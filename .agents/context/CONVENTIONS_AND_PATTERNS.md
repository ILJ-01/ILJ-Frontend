# Coding Conventions & Patterns

## 1. Component Patterns

### File Naming
- **Pages:** PascalCase (`AdminDashboard.jsx`, `VolunteerDashboard.jsx`)
- **Components:** PascalCase (`LoginModal.jsx`, `DashboardLayout.jsx`)
- **UI primitives:** kebab-case (`radio-group.jsx`, `dialog.jsx`) — shadcn/ui convention
- **Utilities:** camelCase (`supabase.js`, `ics.js`, `utils.js`)
- **Data files:** kebab-case (`projects-full.json`)

### Component Structure
```jsx
// 1. Imports (React → Router → Auth → Supabase → UI → Icons)
import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";
import { Button } from "@/components/ui/button";
import { Calendar, CheckSquare } from "lucide-react";

// 2. Constants
const RANKS = [...];

// 3. Component (function declaration or arrow function)
export default function PageName() {
    // State
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const { user } = useAuth();

    // Effects
    useEffect(() => {
        if (user?.id) fetchData();
    }, [user]);

    // Data fetching
    const fetchData = async () => { ... };

    // Event handlers
    const handleSubmit = async () => { ... };

    // Render
    return ( ... );
}
```

### Export Style
- Pages & components: `export default function ComponentName()`
- Context: Named exports (`export function AuthProvider`, `export function useAuth`)
- Lib utilities: Named exports (`export const supabase`, `export async function registerVolunteer`)

---

## 2. Supabase Query Patterns

### Basic SELECT
```javascript
const { data, error } = await supabase
    .from('table_name')
    .select('*')
    .eq('column', value)
    .order('created_at', { ascending: false });
```

### SELECT with JOIN (FK relation)
```javascript
const { data } = await supabase
    .from('tasks')
    .select('*, project:projects(title)')
    .eq('assignee_id', user.id);
```

### Count-only query
```javascript
const { count } = await supabase
    .from('tasks')
    .select('*', { count: 'exact', head: true })
    .eq('assignee_id', user.id)
    .neq('status', 'completed');
```

### RPC calls
```javascript
const { data, error } = await supabase.rpc('function_name', {
    p_param1: value1,
    p_param2: value2
});
```

### Edge Function calls
```javascript
await fetch(`${supabaseUrl}/functions/v1/function-name`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ ... })
});
```

### File uploads (Storage)
```javascript
const { data, error } = await supabase.storage
    .from('bucket-name')
    .upload(`path/${fileName}`, file);

const { data: { publicUrl } } = supabase.storage
    .from('bucket-name')
    .getPublicUrl(`path/${fileName}`);
```

---

## 3. State Management

### Global State
- **Auth only** — via `AuthContext` (React Context)
- No Redux, Zustand, or other state libraries
- Each page manages its own local state

### Data Fetching Pattern
```javascript
const [data, setData] = useState([]);
const [loading, setLoading] = useState(true);

useEffect(() => {
    if (user?.id) fetchData();
}, [user]);

const fetchData = async () => {
    try {
        setLoading(true);
        const { data, error } = await supabase.from('table').select('*');
        if (error) throw error;
        setData(data || []);
    } catch (err) {
        console.error('Error:', err);
    } finally {
        setLoading(false);
    }
};
```

### Form State
- React Hook Form + Zod for complex forms (`VolunteerForm`, `EventRegistrationPage`)
- Simple `useState` objects for simpler forms

---

## 4. Styling Patterns

### Tailwind CSS v4
- Configured via `@tailwindcss/vite` plugin (not PostCSS-based)
- Custom config in `tailwind.config.js`
- Path alias `@` supported via `jsconfig.json`

### Brand Colors
| Token | Value | Usage |
|---|---|---|
| Primary | `#ae2b2b` | Brand red — buttons, accents, headings |
| Primary Hover | `#8f1f1f` | Darker red for hover states |
| Primary Light | `#ae2b2b/5` or `#ae2b2b/10` | Background tints |

### Common Class Patterns
```jsx
// Buttons
className="bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white px-4 py-2 rounded-lg"

// Cards
className="bg-white rounded-xl border border-gray-200 shadow-sm p-6"

// Sidebar active state
className="bg-[#ae2b2b]/5 text-[#ae2b2b]"

// Responsive
className="p-4 md:p-8"
className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4"
```

### shadcn/ui Integration
- Components in `src/components/ui/`
- Uses `cn()` helper from `src/lib/utils.js` (clsx + tailwind-merge)
- Radix UI primitives under the hood
- Component config in `components.json`

---

## 5. Error Handling

### Supabase Error Pattern
```javascript
const { data, error } = await supabase.from('table').select('*');
if (error) {
    console.error('Error:', error);
    // Show user-facing message or set error state
    return;
}
```

### RPC Error Pattern
```javascript
const { data, error } = await supabase.rpc('function_name', params);
if (error || !data || !data.success) {
    return { success: false, error: data?.error || 'Default error message' };
}
return { success: true, ...data };
```

### Error Boundary
- `ErrorBoundary.jsx` wraps critical sections
- Basic fallback UI

---

## 6. Key Conventions & Gotchas

1. **No TypeScript** — pure JSX, no type checking. Use `prop-types` sparingly.
2. **Large monolithic pages** — Several pages exceed 50KB. `PodManagementHub.jsx` is 174KB.
3. **Inline Supabase queries** — No separate API/service layer. Queries are inline in components.
4. **No caching** — Every page fetch is fresh (no SWR/React Query).
5. **Admin auth is separate** — Admin panel uses direct Supabase Auth, not the custom ILJ ID login.
6. **Password stored as plaintext** — `password_hash` column is misleadingly named; it stores plaintext passwords.
7. **Client-side role computation** — Role flags (isAdmin, isManager, etc.) are computed in `AuthContext`, not server-side.
8. **localStorage persistence** — User session survives page refreshes via `localStorage('ilj_user')`.
9. **No i18n** — English/Hindi mixed content, no internationalization framework.
10. **Static project data** — `data/projects-full.json` exists alongside DB `projects` table (legacy).
