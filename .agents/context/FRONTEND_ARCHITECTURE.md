# Frontend Architecture — File & Directory Map

## Root Directory Structure

```
frontend/
├── .env                          # Environment variables (Supabase URL + anon key)
├── .env.example                  # Template for env vars
├── index.html                    # SPA entry point
├── package.json                  # Dependencies & scripts
├── vite.config.js                # Vite config (React SWC + Tailwind v4 + @ alias)
├── tailwind.config.js            # Tailwind configuration
├── postcss.config.js             # PostCSS config
├── components.json               # shadcn/ui component config
├── vercel.json                   # Vercel SPA rewrite rules
├── jsconfig.json                 # Path alias: @ → ./src
├── eslint.config.js              # ESLint configuration
├── PRD.md                        # Product Requirements Document
├── public/                       # Static assets (images, favicon)
├── dist/                         # Production build output
└── src/                          # Application source code
```

## Source Code Tree (`src/`)

```
src/
├── main.jsx                      # React entry point (renders <App />)
├── App.jsx                       # Root component — routing + layout
├── App.css                       # App-level styles
├── index.css                     # Base CSS imports
│
├── assets/                       # Static images (logos, carousel, project banners)
│
├── context/
│   └── AuthContext.jsx            # Auth state management (login, logout, refresh, roles)
│
├── lib/
│   ├── supabase.js               # Supabase client + registerVolunteer + checkEmailExists
│   ├── ics.js                    # ICS calendar file generation & download
│   └── utils.js                  # Utility (cn helper from shadcn/ui)
│
├── data/
│   ├── projects-full.json        # Static project data (legacy, 5 projects)
│   └── projects-minimal.json     # Minimal project data
│
├── styles/
│   └── global.css                # Global CSS variables & base styles
│
├── components/
│   ├── Navbar.jsx                # Site navigation (responsive with hamburger menu)
│   ├── Footer.jsx                # Site footer with links & social
│   ├── HeroCarousel.jsx          # Home page hero carousel
│   ├── LoginModal.jsx            # Login/Register/Reset password modal (shadcn Dialog)
│   ├── CookieConsent.jsx         # GDPR cookie consent banner
│   ├── ErrorBoundary.jsx         # React error boundary wrapper
│   ├── LoadingSpinner.jsx        # Loading indicator
│   ├── Project.jsx               # Individual project detail page (46KB — very large)
│   ├── Projects.jsx              # Projects listing grid
│   ├── ProjectsPage.jsx          # Projects page wrapper
│   ├── VolunteerForm.jsx         # Volunteer registration form (71KB — largest component)
│   ├── KivaRegForm.jsx           # Kiva session registration form
│   ├── AboutUs.jsx               # About Us section content
│   ├── Contact.jsx               # Contact form component
│   ├── Instagram.jsx             # Instagram feed embed
│   ├── Form.jsx                  # Generic form wrapper
│   ├── BlogList.jsx              # Blog listing
│   ├── BlogDetail.jsx            # Blog detail view
│   │
│   ├── dashboard/
│   │   └── DashboardLayout.jsx   # Sidebar + header layout for volunteer dashboard
│   │
│   └── ui/                       # shadcn/ui primitives (Radix-based)
│       ├── button.jsx
│       ├── calendar.jsx
│       ├── card.jsx
│       ├── carousel.jsx
│       ├── checkbox.jsx
│       ├── dialog.jsx
│       ├── form.jsx
│       ├── input.jsx
│       ├── label.jsx
│       ├── popover.jsx
│       ├── radio-group.jsx
│       ├── select.jsx
│       ├── separator.jsx
│       ├── tabs.jsx
│       └── textarea.jsx
│
├── pages/
│   ├── Home.jsx                  # Landing page (hero carousel + content)
│   ├── AboutUs.jsx               # About page
│   ├── Blogs.jsx                 # Blog listing page
│   ├── Projects.jsx              # Projects page (placeholder)
│   ├── Profile.jsx               # Public profile page
│   ├── AdminLogin.jsx            # Admin login page
│   ├── AdminDashboard.jsx        # Admin dashboard (108KB — mega component)
│   ├── AdminAddProject.jsx       # Admin add project page
│   ├── AdminEditProject.jsx      # Admin edit project page (67KB)
│   ├── EventRegistrationPage.jsx # Event registration (62KB)
│   ├── LibraryPage.jsx           # Sanskar Library catalog (63KB)
│   ├── LibraryRegistrationPage.jsx # Library/Pathshala registration
│   ├── ReflectRegistrationPage.jsx # Reflect session registration
│   ├── InterestsPage.jsx         # Volunteering interests page
│   ├── VolunteerRegistration.jsx # Volunteer registration page wrapper
│   ├── PrivacyPolicy.jsx         # Privacy policy page
│   ├── TermsOfService.jsx        # Terms of service page
│   │
│   ├── admin/                    # Admin sub-pages (tab content)
│   │   ├── AdminEvents.jsx           # Events CRUD
│   │   ├── AdminTasks.jsx            # Tasks management (31KB)
│   │   ├── AdminTimesheets.jsx       # Timesheets approval (22KB)
│   │   ├── AdminAppraisals.jsx       # Volunteer appraisals
│   │   ├── AdminInquiries.jsx        # Project inquiries
│   │   ├── AdminEventRegistrations.jsx # Event registration management (31KB)
│   │   ├── AdminIdeas.jsx            # Ideas review & approval
│   │   ├── AdminSTC.jsx              # Spiritual Task management (50KB)
│   │   ├── AdminKalyanMitras.jsx     # Kalyan Mitra assignments
│   │   ├── AdminOpportunities.jsx    # Volunteer opportunities (23KB)
│   │   ├── AdminRevaSessions.jsx     # Reva session management
│   │   └── AdminKivaSessions.jsx     # Kiva session management
│   │
│   └── dashboard/                # Volunteer dashboard pages (protected routes)
│       ├── VolunteerDashboard.jsx    # Dashboard home (37KB)
│       ├── EventsPage.jsx           # Events listing for volunteers
│       ├── TasksPage.jsx            # My tasks view
│       ├── TimesheetPage.jsx        # Timesheet submission
│       ├── ProfilePage.jsx          # Profile editing (52KB)
│       ├── AssignedProjectsPage.jsx  # Pod / project assignments (20KB)
│       ├── VolunteerIdeas.jsx        # Idea submission
│       ├── VolunteerSTC.jsx          # Spiritual task completion
│       ├── PoliciesPage.jsx          # Org policies viewer (22KB)
│       ├── ManagerHub.jsx            # Manager dashboard (87KB — largest page)
│       ├── TeamLeaderHub.jsx         # Team leader dashboard (64KB)
│       ├── KalyanMitraHub.jsx        # Kalyan Mitra mentoring hub (19KB)
│       ├── IdeasHub.jsx              # Ideas management for CP/VCP
│       ├── ItAdminHub.jsx            # IT Admin verification hub (26KB)
│       ├── OnboardingHub.jsx         # Onboarding team hub (27KB)
│       ├── MasterSheet.jsx           # Master volunteer sheet (30KB)
│       └── PodManagementHub.jsx      # Pod management (174KB — absolute largest)
```

## Route Map

### Public Routes (with `MainLayout` — Navbar + Footer)
| Route | Component | Purpose |
|---|---|---|
| `/` | `Home` | Landing page with carousel |
| `/blogs` | `Blogs` | Blog listing |
| `/aboutus` | `AboutUs` | About the organization |
| `/projects` | `Projects` | Projects catalog |
| `/project/:title` | `Project` | Individual project detail |
| `/projects/:id/event-registration` | `EventRegistrationPage` | Event registration form |
| `/profile` | `Profile` | Public profile |
| `/form` | `Form` | Generic form |
| `/volunteer-registration` | `VolunteerRegistration` | Volunteer signup |
| `/interests` | `InterestsPage` | Volunteering interests |
| `/privacy-policy` | `PrivacyPolicy` | Privacy policy |
| `/terms` | `TermsOfService` | Terms of service |
| `/policies` | `PoliciesPage` | Organization policies |
| `/library` | `LibraryPage` | Sanskar Library catalog |
| `/library-registration` | `LibraryRegistrationPage` | Library registration |

### Admin Routes (standalone layout)
| Route | Component | Purpose |
|---|---|---|
| `/admin` | `AdminLogin` | Admin login page |
| `/admin/dashboard` | `AdminDashboard` | Admin panel (tabbed) |
| `/admin/add-project` | `AdminAddProject` | Create new project |
| `/admin/edit-project/:id` | `AdminEditProject` | Edit existing project |
| `/admin/inquiries` | `AdminInquiries` | View project inquiries |

### Dashboard Routes (protected — `DashboardLayout`)
| Route | Component | Access |
|---|---|---|
| `/dashboard` | → redirects to `/dashboard/events` | All volunteers |
| `/dashboard/events` | `EventsPage` | All volunteers |
| `/dashboard/tasks` | `TasksPage` | All volunteers |
| `/dashboard/timesheet` | `TimesheetPage` | All volunteers |
| `/dashboard/profile` | `ProfilePage` | All volunteers |
| `/dashboard/share-idea` | `VolunteerIdeas` | All volunteers |
| `/dashboard/stc` | `VolunteerSTC` | All volunteers |
| `/dashboard/assigned-projects` | `AssignedProjectsPage` | All volunteers |
| `/dashboard/policies` | `PoliciesPage` | All volunteers |
| `/dashboard/manager` | `ManagerHub` | Managers only |
| `/dashboard/team-leader` | `TeamLeaderHub` | Team leaders only |
| `/dashboard/kalyan-mitra` | `KalyanMitraHub` | Kalyan Mitras only |
| `/dashboard/ideas` | `IdeasHub` | CP/VCP only |
| `/dashboard/it-admin` | `ItAdminHub` | IT Admins only |
| `/dashboard/onboarding` | `OnboardingHub` | Onboarding team only |
| `/dashboard/master-sheet` | `MasterSheet` | IT Admin / Onboarding |
| `/dashboard/pod-management` | `PodManagementHub` | Managers / CP/VCP |

## Layout Architecture

```
<AuthProvider>                    ← Global auth context
  <Router>
    <CookieConsent />             ← Always rendered
    <Routes>
      {/* Public */}
      <MainLayout>                ← Navbar + Footer wrapper
        <Page />
      </MainLayout>

      {/* Admin */}
      <AdminPage />               ← Standalone (own auth check)

      {/* Dashboard */}
      <ProtectedRoute>            ← Redirects to / if not logged in
        <DashboardLayout>         ← Sidebar + Header
          <DashboardPage />
        </DashboardLayout>
      </ProtectedRoute>
    </Routes>
  </Router>
</AuthProvider>
```
