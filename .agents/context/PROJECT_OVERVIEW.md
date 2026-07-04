# ILJ (I Love Jinshasan) — Project Overview

## 1. Project Identity

| Field | Value |
|---|---|
| **Name** | I Love Jinshasan (ILJ) |
| **Purpose** | Volunteer Management Platform for a Jain community organization |
| **Domain** | Non-profit / Community / Volunteer Coordination |
| **Live URL** | Deployed on **Vercel** (SPA with `vercel.json` catch-all rewrite) |
| **Supabase Project** | `pdcgcqsgzupoyzklvoju` · Region `ap-northeast-1` · Postgres 17 |

## 2. Technology Stack

### Frontend
| Layer | Technology |
|---|---|
| Framework | **React 19** (JSX, no TypeScript) |
| Build Tool | **Vite 7** with `@vitejs/plugin-react-swc` |
| Styling | **Tailwind CSS v4** (via `@tailwindcss/vite` plugin) + custom CSS |
| UI Components | **Radix UI** primitives + **shadcn/ui** pattern (`components/ui/`) |
| Routing | **React Router v7** (`react-router-dom`) |
| Forms | **React Hook Form** + **Zod** validation |
| Animation | **Framer Motion** |
| Icons | **Lucide React** + **React Icons** |
| Carousel | **Embla Carousel** (with autoplay) + **Swiper** |
| PDF Export | **jsPDF** + **jspdf-autotable** |
| Excel Export | **xlsx** |
| Calendar | **React Day Picker** + **date-fns** |
| ICS Export | Custom `src/lib/ics.js` |

### Backend (Supabase — serverless)
| Layer | Technology |
|---|---|
| Database | **PostgreSQL 17** via Supabase |
| Auth | **Supabase Auth** (email/password) synced with custom `volunteers` table |
| API | Supabase **auto-generated REST API** + **RPC functions** |
| Storage | Supabase Storage (project photos, payment screenshots, photographs) |
| Edge Functions | 6 Deno edge functions (email, notifications, migrations) |
| RLS | Row Level Security enabled on **all 25 tables** |

### Hosting & DevOps
| Layer | Technology |
|---|---|
| Hosting | **Vercel** (static SPA) |
| VCS | **Git** (GitHub) |
| Path Aliases | `@` → `./src` (configured in `vite.config.js` + `jsconfig.json`) |

## 3. High-Level Architecture

```
┌─────────────────────────────────────────────────┐
│                  VERCEL (CDN)                   │
│         Static SPA — React + Vite               │
└────────────────────┬────────────────────────────┘
                     │ HTTPS
┌────────────────────▼────────────────────────────┐
│              SUPABASE CLOUD                     │
│                                                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │
│  │ Auth     │  │ PostgREST│  │ Edge         │  │
│  │ (JWT)    │  │ (REST)   │  │ Functions    │  │
│  └────┬─────┘  └────┬─────┘  └──────┬───────┘  │
│       │              │               │          │
│  ┌────▼──────────────▼───────────────▼───────┐  │
│  │            PostgreSQL 17                   │  │
│  │  25 tables · 16 RPC functions · 5 triggers │  │
│  │  RLS on all tables                         │  │
│  └────────────────────────────────────────────┘  │
│                                                 │
│  ┌────────────────────────────────────────────┐  │
│  │          Supabase Storage                  │  │
│  │  (project-photos, payment-screenshots)     │  │
│  └────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

## 4. Application Domains

The app serves **two distinct user groups** with separate route trees:

### Public Website (`/`, `/projects`, `/aboutus`, etc.)
- Marketing site with carousel, projects showcase, blogs
- Volunteer registration form (public)
- Event registration forms (public, per-project)
- Library catalog & registration
- Project inquiry forms

### Volunteer Dashboard (`/dashboard/*`) — Protected
- Personal dashboard (events, tasks, timesheets, profile)
- Role-based hub pages (Manager, Team Leader, Kalyan Mitra, IT Admin, Onboarding, Pod Management)
- Ideas submission & spiritual task tracking (STC)

### Admin Panel (`/admin/*`)
- Separate login with Supabase Auth session check
- Full CRUD on volunteers, projects, events, tasks, timesheets
- Appraisals, inquiries, ideas management, STC management
- Kiva/Reva session management, Kalyan Mitra assignments

## 5. Key Conventions

1. **No backend server** — all backend logic lives in Supabase (RPC, triggers, edge functions)
2. **Auth is dual-layer** — custom `volunteers` table credentials + Supabase Auth session (synced via triggers)
3. **ILJ IDs** — auto-generated sequential IDs like `ILJ-001`, `ILJ-002` via `generate_ilj_id()` trigger
4. **Role hierarchy** — Volunteer → Team Leader → Manager → CP/VCP (ILJ-001, ILJ-002, ILJ-007)
5. **Rank system** — Volunteer → Elite → Premier → Prestige → Legacy (based on hours + STC completions)
6. **Brand color** — `#ae2b2b` (deep red) used throughout
7. **Mobile-first dashboard** — responsive sidebar that collapses on mobile
