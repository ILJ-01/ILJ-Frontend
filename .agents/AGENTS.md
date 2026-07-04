# ILJ Project — Agent Rules

## Project Brain

The `.agents/context/` folder is the **project brain**. Before making any changes, read the relevant context files:

| File | When to Read |
|---|---|
| `context/PROJECT_OVERVIEW.md` | Always — start here for project identity, tech stack, architecture |
| `context/FRONTEND_ARCHITECTURE.md` | When working on routes, pages, components, or file structure |
| `context/BACKEND_SCHEMA.md` | When working with Supabase tables, RPC functions, triggers, or edge functions |
| `context/AUTH_AND_ROLES.md` | When touching auth, login, roles, permissions, or RLS policies |
| `context/DATA_FLOW_MAP.md` | When modifying data fetching, API calls, or understanding which page uses which table |
| `context/CONVENTIONS_AND_PATTERNS.md` | When writing new code — follow existing patterns |

## Key Rules

1. **No TypeScript** — this project uses pure JSX. Do not add `.tsx` files.
2. **Supabase is the backend** — there is no separate backend server. All data operations go through Supabase client (`@/lib/supabase`).
3. **Use existing UI components** — shadcn/ui components live in `src/components/ui/`. Use them instead of creating custom primitives.
4. **Brand color is `#ae2b2b`** — use this consistently for primary buttons, active states, and accents.
5. **Path alias `@`** maps to `./src` — always use `@/` for imports.
6. **Auth context** — use `useAuth()` hook for all auth-related state. Never read `localStorage('ilj_user')` directly in components.
7. **Inline queries** — Supabase queries are written inline in components. Follow the existing pattern unless refactoring is explicitly requested.
8. **RLS is active on all tables** — ensure the user has a valid Supabase Auth session before making authenticated queries.
9. **Update context** — if your changes add new tables, routes, components, or significantly alter architecture, update the relevant context files.
