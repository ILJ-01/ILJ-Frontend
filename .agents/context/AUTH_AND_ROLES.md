# Authentication & Authorization System

## 1. Dual-Layer Auth Architecture

ILJ uses a **hybrid authentication model** that bridges a custom `volunteers` table with Supabase Auth:

```
┌──────────────────────────────────────────┐
│          VOLUNTEER LOGIN FLOW            │
│                                          │
│  1. User enters ILJ ID + Password        │
│            │                             │
│  2. RPC: login_volunteer()               │
│     ├─ Validates against volunteers      │
│     │   table (password_hash column)     │
│     └─ Returns user data on success      │
│            │                             │
│  3. supabase.auth.signInWithPassword()   │
│     ├─ Creates JWT session               │
│     └─ Enables RLS-protected queries     │
│            │                             │
│  4. If auth fails, force_sync_auth_      │
│     password() + retry sign-in           │
│            │                             │
│  5. Store user object in localStorage    │
│     ('ilj_user')                         │
└──────────────────────────────────────────┘
```

### Why Dual-Layer?
- **Custom login** via ILJ ID (not email) requires the `volunteers` table
- **Supabase Auth** is needed for JWT tokens to satisfy RLS policies
- Triggers keep both layers in sync:
  - `handle_new_volunteer()` — creates Auth user on volunteer INSERT
  - `sync_volunteer_password_to_auth()` — syncs password changes to Auth

---

## 2. User Roles & Permissions

### Role Hierarchy (highest → lowest)

| Role | How Determined | Access |
|---|---|---|
| **CP/VCP** (Chair Person / Vice Chair Person) | `ilj_id` in `['ILJ-001', 'ILJ-002', 'ILJ-007']` | Full admin + Ideas Hub + Pod Management |
| **Manager** | Has `managed_projects` (projects where `manager_id = user.id` OR `user.id = ANY(sub_head_ids)`) OR is CP/VCP | Manager Hub + Pod Management + Admin write access |
| **Pod Sub-Head** | Volunteer's ID is in `sub_head_ids` UUID array of a project | Pod Management Hub access for assigned projects |
| **Team Leader** | `team_leader_for` field is not empty | Team Leader Hub + elevated timesheet access |
| **Kalyan Mitra** | Other volunteers have user's name in their `kalyan_mitra` field | Kalyan Mitra Hub (mentoring) |
| **IT Admin** | `is_it_admin = true` | IT Verification Hub + Master Sheet |
| **Onboarding Team** | `is_onboarding_team = true` | Onboarding Hub + Master Sheet |
| **Pod Team** | `is_pod_team = true` | Pod-related access |
| **Volunteer** | Default | Dashboard, tasks, timesheet, ideas, STC |

### Composite Flags (computed in AuthContext)
```javascript
isAdmin = isManager || isTeamLeader || isITAdmin
```

### Special Designations
- `secondary_designation = 'Chair Person'` → Ideas Hub access
- `secondary_designation = 'Vice Chair Person'` → Ideas Hub access

---

## 3. Auth Context (`AuthContext.jsx`)

### Provided Values
| Value | Type | Description |
|---|---|---|
| `user` | object | Full volunteer profile + computed flags |
| `loading` | boolean | Initial auth check loading state |
| `login(iljId, password)` | function | Login flow (RPC → Auth → localStorage) |
| `logout()` | function | Clears state + localStorage + Supabase Auth signout |
| `updatePassword(iljId, email, newPassword)` | function | Password reset via RPC |
| `refreshUser()` | function | Re-fetches profile + recomputes roles |
| `isLoggedIn` | boolean | `!!user` |
| `isAdmin` | boolean | Manager OR Team Leader OR IT Admin |
| `isManager` | boolean | Has managed projects (as manager or sub-head) OR is CP/VCP |
| `isTeamLeader` | boolean | Has `team_leader_for` |
| `isKalyanMitra` | boolean | Referenced in other volunteers' `kalyan_mitra` field |
| `isITAdmin` | boolean | `is_it_admin` flag |
| `isOnboardingTeam` | boolean | `is_onboarding_team` flag |
| `isPodTeam` | boolean | `is_pod_team` flag |
| `isCPOrVCP` | boolean | ILJ-001 / ILJ-002 / ILJ-007 |

### Session Persistence
- User object stored in `localStorage` as `'ilj_user'`
- On mount, checks localStorage → validates Supabase Auth session
- If Auth session missing (but localStorage exists), logs user out to resync

---

## 4. Admin Panel Auth (Separate)

The admin panel (`/admin/*`) uses a **separate auth flow**:
- `AdminLogin.jsx` → `supabase.auth.signInWithPassword()` directly
- `AdminDashboard.jsx` → checks `supabase.auth.getSession()` on mount
- If no session → redirects to `/admin`
- Uses admin email: `admin@ilovejinshasan.org`

---

## 5. Route Protection

### `ProtectedRoute` Component (in `App.jsx`)
```jsx
const ProtectedRoute = ({ children }) => {
  const { user, loading } = useAuth();
  if (loading) return <div>Loading...</div>;
  if (!user) return <Navigate to="/" replace />;
  return children;
};
```
- Wraps all `/dashboard/*` routes
- Redirects to home if not logged in
- Does **not** check specific roles — role-based access is handled by conditional sidebar rendering

### Dashboard Sidebar (Role-Based Menu)
Menu items are conditionally added based on user roles:
- `isITAdmin` → IT Verification + Master Sheet
- `isOnboardingTeam` → Onboarding + Master Sheet
- `managed_projects.length > 0 || isCPOrVCP` → Pod Management Hub
- `isKalyanMitra` → Kalyan Mitra Hub
- `team_leader_for` → Team Leader Hub
- `secondary_designation` → Ideas Hub

---

## 6. RLS (Row Level Security) Policies

### Key Policy Patterns

| Table | SELECT | INSERT | UPDATE | DELETE |
|---|---|---|---|---|
| `volunteers` | Public SELECT + Auth SELECT | — (via RPC) | Self (`auth.uid()=id`) + Admin + Privileged | Admin only |
| `projects` | Public SELECT | Admin + Privileged | Admin + Privileged | Admin + Privileged |
| `tasks` | Own (`auth.uid()=assignee_id`) + Admin | Admin | Own + Admin | Admin |
| `timesheets` | Own (`auth.uid()=volunteer_id`) + Privileged | Own + Privileged | Own + Privileged | Own + Privileged |
| `notifications` | Own (`auth.uid()=user_id`) | Authenticated | Own | Own |
| `events` | Public SELECT | Admin | Admin | Admin |
| `announcements` | Public SELECT | Admin | Admin | Admin |
| `ideas` | Public ALL | — | — | — |
| `event_registrations` | Public ALL | Public INSERT | — | Public DELETE |
| `spiritual_tasks` | Public ALL | — | — | — |
| `spiritual_task_assignments` | Public ALL | — | — | — |

### Helper Functions Used in RLS
- `is_admin()` — checks if user has admin role in `app_roles`
- `get_user_privilege_level()` — returns `'admin'`, `'manager'`, `'team_leader'`, or `'volunteer'`
- `auth.uid()` — Supabase Auth built-in, returns current user's UUID
- `auth.role()` — returns `'authenticated'` or `'anon'`

---

## 7. Volunteer Rank System

Ranks are calculated client-side based on approved hours + spiritual task completions:

| Rank | Min Hours | Min STC |
|---|---|---|
| Volunteer | 0 | 0 |
| ILJ Elite Volunteer | 100 | 25 |
| ILJ Premier Volunteer | 750 | 100 |
| ILJ Prestige Volunteer | 1750 | 150 |
| ILJ Legacy Volunteer | 3000 | 250 |

The `rank` column in `volunteers` table is updated by admin/system.
