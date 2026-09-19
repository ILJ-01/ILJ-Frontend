# Frontend ↔ Backend Data Flow Mapping

This document maps every frontend page/component to the exact Supabase tables, queries, and RPC calls it uses.

---

## 1. Authentication & Session

### `LoginModal.jsx` (component)
| Operation | Backend | Details |
|---|---|---|
| Login | RPC `login_volunteer` | Params: `p_ilj_id`, `p_password` |
| Auth Session | `supabase.auth.signInWithPassword()` | Creates JWT for RLS |
| Auth Sync | RPC `force_sync_auth_password` | Fallback if Auth sign-in fails |
| Password Reset | RPC `reset_volunteer_password` | Params: `p_ilj_id`, `p_email`, `p_new_password` |

### `AuthContext.jsx` (context)
| Operation | Backend | Details |
|---|---|---|
| Login | RPC `login_volunteer` → `auth.signInWithPassword` | Dual-layer |
| Refresh User | SELECT `volunteers` WHERE `id` | Re-fetches profile |
| Fetch Projects | SELECT `projects` WHERE `manager_id` | Checks manager status |
| Kalyan Mitra Check | SELECT COUNT `volunteers` WHERE `kalyan_mitra` ILIKE name | Determines KM role |
| Logout | `supabase.auth.signOut()` | Clears JWT |

---

## 2. Public Pages

### `Home.jsx`
| Operation | Backend | Details |
|---|---|---|
| — | — | Static content, no DB queries |

### `Project.jsx` (component — 46KB)
| Operation | Backend | Details |
|---|---|---|
| Fetch Project | SELECT `projects` WHERE `id` or `title` | Single project |
| Fetch Photos | SELECT `project_photos` WHERE `project_id` | Gallery |
| Fetch Events | SELECT `events` WHERE `project_id` | Project events |
| Fetch Feedback | SELECT `project_feedback` WHERE `project_id` AND `is_featured` | Featured testimonials |
| Submit Inquiry | INSERT `project_inquiries` | Contact form |
| Submit Feedback | INSERT `project_feedback` | Rating form |

### `EventRegistrationPage.jsx` (62KB)
| Operation | Backend | Details |
|---|---|---|
| Fetch Project | SELECT `projects` WHERE `id` | Get event details |
| Submit Registration | INSERT `event_registrations` | Full registration form |
| Upload Screenshot | Supabase Storage upload | Payment proof |
| Upload Photo | Supabase Storage upload | Participant photo |
| Send Email | Edge Function `send-event-registration-email` | Confirmation email |

### `VolunteerForm.jsx` (component — 71KB)
| Operation | Backend | Details |
|---|---|---|
| Check Email | SELECT `volunteers` WHERE `email` | Duplicate check |
| Register | RPC `register_volunteer_secure` | Creates volunteer + Auth user |
| Send Email | Edge Function `send-welcome-email` | Welcome email with ILJ ID |

### `LibraryPage.jsx` (63KB)
| Operation | Backend | Details |
|---|---|---|
| Fetch Books | SELECT `library_books` | Full catalog |
| Fetch Pathshalas | SELECT `pathshalas` | Pathshala list |
| Fetch Assignments | SELECT `pathshala_assignments` | Book assignments |
| CRUD Books | INSERT/UPDATE/DELETE `library_books` | Admin operations |
| CRUD Pathshalas | INSERT/UPDATE/DELETE `pathshalas` | Admin operations |
| CRUD Assignments | INSERT/UPDATE/DELETE `pathshala_assignments` | Admin operations |

### `InterestsPage.jsx`
| Operation | Backend | Details |
|---|---|---|
| Fetch Announcements | SELECT `announcements` WHERE type = 'opportunity' | Available opportunities |
| Register Interest | RPC `register_announcement_interest` | Sign up |

### `KivaRegForm.jsx` (component)
| Operation | Backend | Details |
|---|---|---|
| Submit Registration | INSERT `kiva_registrations` | Kiva session signup |

---

## 3. Volunteer Dashboard Pages

### `VolunteerDashboard.jsx` (37KB)
| Operation | Backend | Details |
|---|---|---|
| Total Hours | SELECT `timesheets.hours` WHERE `volunteer_id` AND `status = 'approved'` | Sum client-side |
| Pending Tasks | COUNT `tasks` WHERE `assignee_id` AND `status != 'completed'` | Head-only count |
| Upcoming Events | SELECT `events` WHERE `date >= now()` LIMIT 3 | Ordered ascending |
| My Tasks | SELECT `tasks` + JOIN `projects(title)` WHERE `assignee_id` LIMIT 4 | With project name |
| Announcements | SELECT `announcements` WHERE `type = 'general'` LIMIT 3 | Recent |
| Opportunities | SELECT `announcements` WHERE `type = 'opportunity'` | Open opportunities |
| Projects | SELECT `projects` | For idea form |
| My Ideas | SELECT `ideas` WHERE `submitted_by` | User's ideas |
| Assigned Projects | SELECT `project_volunteers` + JOIN `projects(*)` WHERE `volunteer_id` | Pod assignments |
| Submit Idea | INSERT `ideas` | New idea |

### `EventsPage.jsx`
| Operation | Backend | Details |
|---|---|---|
| Fetch Events | SELECT `events` + JOIN `projects(title)` | All events |
| Check Interest | SELECT `event_interests` WHERE `volunteer_id` | User's interests |
| Register Interest | RPC `register_event_interest` | Toggle interest |
| Revoke Interest | RPC `revoke_event_interest` | Toggle interest |

### `TasksPage.jsx`
| Operation | Backend | Details |
|---|---|---|
| Fetch Tasks | SELECT `tasks` + JOIN `projects(title)` WHERE `assignee_id` | Volunteer's tasks |
| Update Status | UPDATE `tasks.status` WHERE `id` | Status change |

### `TimesheetPage.jsx`
| Operation | Backend | Details |
|---|---|---|
| Fetch Timesheets | SELECT `timesheets` + JOIN `projects(title)` WHERE `volunteer_id` | User's timesheets |
| Fetch Projects | SELECT `projects` | For dropdown |
| Submit Timesheet | INSERT `timesheets` | New entry |

### `ProfilePage.jsx` (52KB)
| Operation | Backend | Details |
|---|---|---|
| Fetch Profile | SELECT `volunteers` WHERE `id` | Current user |
| Update Profile | UPDATE `volunteers` WHERE `id` | Self-edit |
| Fetch Timesheets | SELECT `timesheets` WHERE `volunteer_id` AND `status = 'approved'` | Hours for stats |
| Fetch STC | SELECT `spiritual_task_assignments` + JOIN `spiritual_tasks` WHERE `volunteer_id` | STC progress |

### `AssignedProjectsPage.jsx` (20KB)
| Operation | Backend | Details |
|---|---|---|
| Fetch Assignments | SELECT `project_volunteers` + JOIN `projects(*)` WHERE `volunteer_id` | Pod assignments |
| Engagement Update | UPDATE `project_volunteers.engagement_status` | Accept/decline |

### `VolunteerIdeas.jsx`
| Operation | Backend | Details |
|---|---|---|
| Fetch Ideas | SELECT `ideas` WHERE `submitted_by` | User's ideas |
| Fetch Projects | SELECT `projects` | For dropdown |
| Submit Idea | INSERT `ideas` | New idea |

### `VolunteerSTC.jsx`
| Operation | Backend | Details |
|---|---|---|
| Fetch Assignments | SELECT `spiritual_task_assignments` + JOIN `spiritual_tasks(*)` WHERE `volunteer_id` | STC list |
| Complete Task | UPDATE `spiritual_task_assignments` SET `status='completed'` | Mark complete |

---

## 4. Role-Based Hub Pages

### `ManagerHub.jsx` (87KB)
| Operation | Backend | Details |
|---|---|---|
| Fetch Managed Projects | SELECT `projects` WHERE `manager_id` | Manager's projects |
| Fetch All Volunteers | SELECT `volunteers` | For assignment |
| Fetch Project Volunteers | SELECT `project_volunteers` + JOIN `volunteers(*)` | Pod members |
| Fetch Tasks | SELECT `tasks` + JOIN `volunteers(first_name, last_name)` | Project tasks |
| Fetch Timesheets | SELECT `timesheets` + JOIN `volunteers(*)` + `projects(title)` | For approval |
| CRUD Tasks | INSERT/UPDATE/DELETE `tasks` | Task management |
| Approve Timesheets | UPDATE `timesheets.status` | Approval workflow |
| Send Task Email | Edge Function `send-task-email` | Email notification |

### `TeamLeaderHub.jsx` (64KB)
| Operation | Backend | Details |
|---|---|---|
| Fetch Team Members | SELECT `volunteers` WHERE `team_leader_for` matches | Team listing |
| Fetch Tasks | SELECT `tasks` WHERE `assignee_id` IN team_members | Team tasks |
| Fetch Timesheets | SELECT `timesheets` WHERE `volunteer_id` IN team_members | Team timesheets |
| Schedule Meeting | INSERT `team_meetings` | New meeting |
| Fetch Meetings | SELECT `team_meetings` WHERE `team_leader_id` | Meeting history |

### `KalyanMitraHub.jsx` (19KB)
| Operation | Backend | Details |
|---|---|---|
| Fetch Mentees | SELECT `volunteers` WHERE `kalyan_mitra` ILIKE user's name | Assigned mentees |
| Fetch Mentee Stats | SELECT `timesheets`, `spiritual_task_assignments` per mentee | Progress tracking |

### `PodManagementHub.jsx` (174KB — largest file)
| Operation | Backend | Details |
|---|---|---|
| Fetch All Projects | SELECT `projects` | All pods |
| Fetch All Volunteers | SELECT `volunteers` | For assignment |
| Fetch Assignments | SELECT `project_volunteers` + JOIN | All assignments |
| Assign Volunteer | INSERT `project_volunteers` | New assignment |
| Remove Volunteer | DELETE `project_volunteers` | Remove from pod |
| Update Volunteer Fields | UPDATE `volunteers` (assigned_pod, kalyan_mitra, team_leader_for, etc.) | Bulk operations |
| Notify Assignment | Edge Function `notify-pod-assignment` | Email on assignment |
| Assign Kalyan Mitra | Edge Function `assign-kalyan-mitra` | KM assignment |

### `IdeasHub.jsx`
| Operation | Backend | Details |
|---|---|---|
| Fetch All Ideas | SELECT `ideas` + JOIN `volunteers(first_name, last_name)` + `projects(title)` | All ideas |
| Update Status | UPDATE `ideas` SET `status`, `admin_notes` | Approve/reject |

### `ItAdminHub.jsx` (26KB)
| Operation | Backend | Details |
|---|---|---|
| Fetch Volunteers | SELECT `volunteers` WHERE `onboarding_status` | Verification queue |
| Update Status | UPDATE `volunteers` SET `onboarding_status`, `is_it_admin` etc. | Admin operations |

### `OnboardingHub.jsx` (27KB)
| Operation | Backend | Details |
|---|---|---|
| Fetch New Volunteers | SELECT `volunteers` WHERE `onboarding_status = 'pending'` | Onboarding queue |
| Update Onboarding | UPDATE `volunteers` SET `onboarding_status` | Progress tracking |

### `MasterSheet.jsx` (30KB)
| Operation | Backend | Details |
|---|---|---|
| Fetch All Volunteers | SELECT `volunteers` | Full list |
| Export to Excel | Client-side `xlsx` | Excel download |
| Export to PDF | Client-side `jsPDF` | PDF download |

---

## 5. Admin Panel Pages

### `AdminDashboard.jsx` (108KB — tabbed mega-component)
| Tab | Backend | Details |
|---|---|---|
| Volunteers | SELECT `volunteers` | Full CRUD + search/filter |
| Projects | SELECT `projects` | View/navigate to edit |

Delegates to child components for each admin tab:

### `AdminEvents.jsx`
| Operation | Backend |
|---|---|
| CRUD Events | INSERT/UPDATE/DELETE `events` |
| Create Notifications | INSERT `notifications` for all volunteers |

### `AdminTasks.jsx` (31KB)
| Operation | Backend |
|---|---|
| CRUD Tasks | INSERT/UPDATE/DELETE `tasks` |
| Fetch Volunteers | SELECT `volunteers` (for assignment dropdown) |
| Fetch Projects | SELECT `projects` (for project dropdown) |
| Send Task Email | Edge Function `send-task-email` |

### `AdminTimesheets.jsx` (22KB)
| Operation | Backend |
|---|---|
| Fetch Timesheets | SELECT `timesheets` + JOIN `volunteers(*)` + `projects(title)` |
| Approve/Reject | UPDATE `timesheets.status` |
| Create Notification | INSERT `notifications` |

### `AdminSTC.jsx` (50KB)
| Operation | Backend |
|---|---|
| CRUD Spiritual Tasks | INSERT/UPDATE/DELETE `spiritual_tasks` |
| Assign Tasks | INSERT `spiritual_task_assignments` (bulk for all volunteers) |
| View Completions | SELECT `spiritual_task_assignments` + JOIN |

### `AdminEventRegistrations.jsx` (31KB)
| Operation | Backend |
|---|---|
| Fetch Registrations | SELECT `event_registrations` + JOIN `projects(title)` |
| Delete Registration | DELETE `event_registrations` |
| Export | Client-side Excel/PDF |

### `AdminIdeas.jsx`
| Operation | Backend |
|---|---|
| Fetch Ideas | SELECT `ideas` + JOIN `volunteers` + `projects` |
| Update Status | UPDATE `ideas` SET `status`, `admin_notes` |

### `AdminKalyanMitras.jsx`
| Operation | Backend |
|---|---|
| Fetch KM Pairs | SELECT `volunteers` WHERE `kalyan_mitra IS NOT NULL` |
| Assign KM | UPDATE `volunteers.kalyan_mitra` |
| Notify | Edge Function `assign-kalyan-mitra` |

### `AdminRevaSessions.jsx` / `AdminKivaSessions.jsx`
| Operation | Backend |
|---|---|
| CRUD Sessions | INSERT/UPDATE/DELETE `reva_sessions` / `kiva_sessions` |
| Fetch Registrations | SELECT `kiva_registrations` (for Kiva) |
| Update Attendance | UPDATE `kiva_registrations.attendance_status` |

### `AdminOpportunities.jsx` (23KB)
| Operation | Backend |
|---|---|
| CRUD Announcements | INSERT/UPDATE/DELETE `announcements` WHERE `type = 'opportunity'` |
| Fetch Interests | SELECT `announcement_interests` + JOIN `volunteers` |

### `AdminAppraisals.jsx`
| Operation | Backend |
|---|---|
| Fetch Volunteer Stats | SELECT `timesheets`, `tasks`, `spiritual_task_assignments` per volunteer |
| Update Rank | UPDATE `volunteers.rank` |

---

## 6. Edge Function Invocation Map

| Edge Function | Called From | Trigger |
|---|---|---|
| `send-birthday-email` | Postgres `pg_cron` via `pg_net` | Daily at 08:00 AM IST (`30 2 * * *`) |
| `send-welcome-email` | `VolunteerForm.jsx` / `supabase.js` | After `register_volunteer_secure` RPC |
| `send-task-email` | `AdminTasks.jsx` / `ManagerHub.jsx` | After task creation |
| `send-event-registration-email` | `EventRegistrationPage.jsx` | After event registration |
| `assign-kalyan-mitra` | `AdminKalyanMitras.jsx` / `PodManagementHub.jsx` | After KM assignment |
| `notify-pod-assignment` | `PodManagementHub.jsx` | After pod assignment |
| `system-migration` | Manual / Admin | DB migration utility |
