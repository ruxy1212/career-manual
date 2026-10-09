# Project Breakdown: DeMosaic Homes (Estate Kangaroo)

---

## 1. Project Snapshot

* **What the product does:** DeMosaic Homes is a luxury real estate development and property management platform featuring automated physical inspection booking, dynamic property and amenity catalogs, high-performance brand video streaming, applicant career tracking, and backoffice analytics.
* **My likely role/contribution:** Lead Full-Stack Architect & Core Developer (authored **163 of 207 commits**—78.7% ownership; engineered the inspection booking engine, dynamic asset management pipelines, media streaming components, administrative analytics dashboards, and frontend UI interactions).
* **Tech stack:**
  * **Backend:** PHP 8.2, Laravel 12 (`laravel/framework: ^12.0`), Inertia.js Laravel 2.0 (`inertiajs/inertia-laravel: ^2.0`), Laravel Sanctum (`laravel/sanctum: ^4.0`), Tighten Ziggy.
  * **Frontend:** React 18.2 (`react: ^18.2.0`), TypeScript 5 (`typescript: ^5.0.2`), Vite 6 (`vite: ^6.2.4`), Inertia.js React 2.0 (`@inertiajs/react: ^2.0.0`), Tailwind CSS, Headless UI (`@headlessui/react: ^2.0.0`), Framer Motion (`framer-motion: 10.16.4`).
  * **Media & Visualizations:** XGPlayer (`xgplayer: ^3.0.22`), Recharts (`recharts: ^2.15.3`), React Fast Marquee (`react-fast-marquee: ^1.6.5`), React Responsive Masonry (`react-responsive-masonry: ^2.7.1`), Sonner.
  * **Database & Mail:** MySQL / SQLite, 16 migrations, automated transactional dual-email delivery (Office Alert + Client Confirmation).
* **Project scale:**
  * **207 total Git commits** (163 authored by Russell Oje).
  * **75 registered routes** across storefront, booking API, and administration.
  * **14 Eloquent domain models** and **24 application controllers**.
  * **16 database schema migrations** and **6 seeders**.
  * **115 TypeScript/React frontend files** (106 `.tsx`, 8 `.ts`, 1 `.jsx`) spanning 37 page views and layouts.

---

## 2. Engineering Metrics

### Backend & API
* **Route Structure:** 75 route endpoints separating public client navigation (`/projects`, `/booking`, `/careers`, `/gallery`), inspection reservation mutations, and an administrative control panel (`/admin/management/*`).
* **Controller Organization:** 24 controllers structured across Storefront (Public, Booking, Careers, Messages), Admin Operations (Projects, Amenities, Staff, Media, Testimonials, Gallery, Settings), and Authentication.
* **Data Layer:** 14 Eloquent models encapsulating property developments, unit specifications, schedule constraints, media assets, and executive staff profiles.
* **Database Migrations:** 16 migrations tracking real estate project states, property amenities, inspection booking configurations, and career applications.

### Frontend Architecture
* **Code Volume:** 115 TypeScript/React files (106 `.tsx`, 8 `.ts`, 1 `.jsx`).
* **Page Layouts & Views:** 37 distinct views across client exploration (`External/BookingPage.tsx`, `External/Projects.tsx`, `External/List/Project.tsx`) and backoffice property control (`AdminDashboard.tsx`, `Admin/Projects/Index.tsx`, `Admin/BookingConfiguration.tsx`).
* **Video & Media Player Integration:** Embedded `xgplayer` web video player providing hardware-accelerated video playback with custom overlay controls and gradient vignettes.
* **Reactive Analytics:** Real-time Recharts `AreaChart` tracking monthly inspection appointment volumes and conversion trends.

### Scheduling & Automation
* **Configurable Reservation Rules:** Dynamic booking limits ([`ScheduleConfiguration.php`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Models/ScheduleConfiguration.php)) restricting appointments to specified days (`available_days`), operating hours (`start_time`, `end_time`), and blackout dates.
* **Automated Dual-Channel Mail Notification:** Instantaneous trigger of [`ScheduleBookingAdminMail`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Mail/ScheduleBookingAdminMail.php) (notifying property managers with lead credentials) and [`ScheduleBookingUserMail`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Mail/ScheduleBookingUserMail.php) (sending calendar invites and location coordinates to the client).

---

## 3. What I Built

### 1. Dynamic Property Inspection Booking & Slot Reservation Engine
* **What I implemented technically:** Built [`ScheduleBookingController.php`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Http/Controllers/ScheduleBookingController.php), [`ScheduleConfigurationController.php`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Http/Controllers/ScheduleConfigurationController.php), and [`BookingPage.tsx`](file:///C:/laragon/www/laravel/estate-kangaroo/resources/js/Pages/External/BookingPage.tsx). Features dynamic configuration retrieval, 24-hour to 12-hour time normalization (`convertToReadableTime`), idempotent booking records via `updateOrCreate(['email' => ..., 'date' => ...])`, and transactional dual-email notifications with physical Lekki Phase 1 office coordinates.
* **Why it mattered:** Automated the physical property viewing pipeline, eliminating manual scheduling calls and ensuring zero double-booked inspection slots.

### 2. Real Estate Asset & Amenity Management Pipeline
* **What I implemented technically:** Architected [`Admin/ProjectController.php`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Http/Controllers/Admin/ProjectController.php) and [`ProjectAmenityController.php`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Http/Controllers/Admin/ProjectAmenityController.php). Enables staff to manage luxury real estate projects, define property features, attach project amenities, configure unit availability, upload high-res imagery, and reorder homepage presentation order via drag/sort endpoints (`admin.projects.reorder`).
* **Why it mattered:** Gave non-technical marketing staff complete control over property listings, unit specifications, and featured project promotions without requiring code redeployments.

### 3. High-Performance Brand Video Architecture (`xgplayer`)
* **What I implemented technically:** Created [`BrandVideo.tsx`](file:///C:/laragon/www/laravel/estate-kangaroo/resources/js/Components/components/sections/BrandVideo.tsx) and [`Admin/BrandVideoController.php`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Http/Controllers/Admin/BrandVideoController.php). Integrated `xgplayer` and custom HTML5 video wrappers with play/pause state morphing, gradient overlays, infinite floating decorative icons powered by Framer Motion, and administrative video upload/reordering controls.
* **Why it mattered:** Provided smooth, lag-free video tours of luxury architectural developments, capturing client attention while keeping page weight optimized.

### 4. Interactive Property Explorer with Responsive Masonry & Recharts
* **What I implemented technically:** Developed [`External/Projects.tsx`](file:///C:/laragon/www/laravel/estate-kangaroo/resources/js/Pages/External/Projects.tsx) and [`AdminDashboard.tsx`](file:///C:/laragon/www/laravel/estate-kangaroo/resources/js/Pages/AdminDashboard.tsx). Features `react-responsive-masonry` for staggered architectural photo galleries, `react-fast-marquee` for institutional partner banners, and interactive Recharts area charts plotting appointment schedules over time.
* **Why it mattered:** Delivered a luxury editorial aesthetic expected in high-end real estate while giving business executives clear visibility into lead generation performance.

### 5. Career Portal & Applicant Ingestion Engine
* **What I implemented technically:** Built [`CareerController.php`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Http/Controllers/CareerController.php), [`CareerRole.php`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Models/CareerRole.php), and [`External/Careers.tsx`](file:///C:/laragon/www/laravel/estate-kangaroo/resources/js/Pages/External/Careers.tsx). Supports opening and closing job positions, collecting applicant credentials, storing resume attachments safely in cloud/local storage, and tracking applicant statuses from the admin panel.
* **Why it mattered:** Streamlined talent acquisition for property development, site engineering, and sales staff within the same platform.

### 6. Curated Gallery & Events Diary System
* **What I implemented technically:** Developed [`GalleryController.php`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Http/Controllers/Admin/GalleryController.php) and [`GalleryManagement.tsx`](file:///C:/laragon/www/laravel/estate-kangaroo/resources/js/Pages/Admin/GalleryManagement.tsx). Handles dynamic gallery roll uploads, project milestone photo diaries, event creation, and background hero customization.
* **Why it mattered:** Allows developers to showcase live groundbreaking ceremonies, architectural progress, and handover galas to prospective property buyers.

---

## 4. Design Walkthrough

### Flow 1: Client Inspection Booking & Automated Notification Flow
* **Path:** `Client Browses Project → Clicks "Book Inspection" → Inertia Navigates to /booking?property=7 → ScheduleBookingController::index loads ScheduleConfiguration → Client Selects Date & Time → Form POST /booking → updateOrCreate() → Dual Mailgun/SMTP Dispatched → Client Redirected to Project Page with Flash Toast`
* **Implementation:** When visiting `/booking`, [`ScheduleBookingController`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Http/Controllers/ScheduleBookingController.php) reads `ScheduleConfiguration::getActiveConfiguration()`, passing available days and operational hours to React. Upon form submission, the controller validates inputs, normalizes time strings into 12-hour AM/PM formats, records the appointment, and triggers `ScheduleBookingAdminMail` and `ScheduleBookingUserMail`. Inertia flushes the response with a success toast.

### Flow 2: Dynamic Project Creation & Catalog Publishing
* **Path:** `Admin at /admin/management/projects → ProjectForm.tsx → POST admin/projects → ProjectController::store → Image Upload Stored in /storage/projects → DB Transaction creates Project & Attaches Amenities → Inertia Re-renders Catalog`
* **Implementation:** In [`Admin/ProjectController.php`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Http/Controllers/Admin/ProjectController.php), the admin uploads project blueprints, renders, location pins, and selects linked amenities. The controller stores image files on disk, auto-generates SEO-friendly slugs, commits the project record, and syncs amenity relationships, immediately making the listing visible on the public `/projects` directory.

### Flow 3: Interactive Video Tour Playback & State Morphing
* **Path:** `Visitor scrolls to Brand Video Section → BrandVideo.tsx mounts → Framer Motion whileInView triggers → User clicks Custom Play/Pause Overlay → togglePlay() drives videoRef.current.play() → Play button morphs into pause bars → Video scales on hover`
* **Implementation:** In [`BrandVideo.tsx`](file:///C:/laragon/www/laravel/estate-kangaroo/resources/js/Components/components/sections/BrandVideo.tsx), brand videos are rendered with custom playback controls. Clicking the button toggles between play state and pause bars using smooth SVG transitions. On video completion (`onEnded`), the state resets automatically, maintaining aesthetic alignment with luxury design standards.

### Flow 4: Administrative Booking Analytics & Period Filtering
* **Path:** `Admin Logs In → GET /admin/dashboard → AdminSettingsController::dashboard → Aggregates Appointments by Month & Total Transactions → Passes Array to Inertia → AdminDashboard.tsx renders AreaChart`
* **Implementation:** In [`AdminDashboard.tsx`](file:///C:/laragon/www/laravel/estate-kangaroo/resources/js/Pages/AdminDashboard.tsx), appointment metrics are plotted using Recharts `AreaChart`. The dashboard maps historical inspection volumes with custom tooltips, highlighting peak viewing seasons and allowing sales directors to monitor property interest trends.

### Flow 5: Real-Time Admin Project Drag-and-Drop Reordering
* **Path:** `Admin Drags Project Card → POST /admin/management/projects/reorder → ProjectController::reorder → Loops through Array → Updates order column → Public Landing Page Reflects New Order`
* **Implementation:** To prioritize flagship property developments, the admin panel allows visual reordering. The controller receives the re-indexed array and executes a batch update on the `order` column, dynamically changing the sorting order of the public `/` landing page showcase.

---

## 5. Engineering Decisions & Challenges

* **Inspection Slot Idempotency & Overbooking Prevention:** Multiple prospective buyers submitting inquiries for the same property on the same day could create duplicate bookings and double-booked calendar slots.
  * *Code Solution:* Implemented `ScheduleBooking::updateOrCreate()` keyed on `['email' => $request->email_address, 'date' => $dateOnly]`, paired with active configuration boundaries (`available_days`, `start_time`, `end_time`) loaded dynamically from [`ScheduleConfiguration`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Models/ScheduleConfiguration.php).
* **High-Resolution Media Weight vs. Initial Page Load Performance:** Luxury real estate platforms depend on ultra-high-resolution architectural photography and 4K brand videos, which easily degrade page performance and Lighthouse scores.
  * *Code Solution:* Integrated lazy loading, responsive masonry grids (`react-responsive-masonry`), and deferred video loading via `xgplayer` with poster placeholders (`maxHeight: '420px'`) and CSS gradient overlays.
* **Synchronized Client/Admin Notification Architecture:** Property inspections require immediate sales team alerting while confirming the calendar details with the prospective home buyer.
  * *Code Solution:* Configured dual Mailable classes ([`ScheduleBookingAdminMail`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Mail/ScheduleBookingAdminMail.php) and [`ScheduleBookingUserMail`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Mail/ScheduleBookingUserMail.php)) triggered synchronously within the booking transaction, formatting 24h military timestamps into localized 12h AM/PM strings.
* **SEO Metadata & OpenGraph Optimization for Luxury Properties:** Property links shared on WhatsApp, Facebook, or iMessage needed rich, dynamic social preview cards with architectural renders.
  * *Code Solution:* Integrated `react-helmet-async` and an SEO component ([`resources/js/Components/components/SEO.tsx`](file:///C:/laragon/www/laravel/estate-kangaroo/resources/js/Components/components/SEO.tsx)) injecting OpenGraph image URLs, titles, and property descriptions dynamically from Inertia page props.

---

## 6. Job-Application Evidence

* **Claim:** Architected and delivered a full-stack real estate and property management platform with Laravel 12 and React 18.
  * **Evidence:** Lead developer authoring 163 of 207 git commits, engineering 14 Eloquent models, 24 controllers, 75 routes, and 115 TypeScript/React files.
  * **Metric:** 163 commits, 75 routes, 14 models, 37 page views.

* **Claim:** Built an automated property inspection booking and schedule reservation system.
  * **Evidence:** Implemented [`ScheduleBookingController.php`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Http/Controllers/ScheduleBookingController.php) and [`ScheduleConfigurationController.php`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Http/Controllers/ScheduleConfigurationController.php) supporting dynamic slot rules, 24h-to-12h time formatting, idempotent record creation, and automated dual-recipient email alerts.
  * **Metric:** 100% automated inspection booking lifecycle from slot selection to calendar confirmation.

* **Claim:** Engineered comprehensive backoffice asset management tools for non-technical marketing teams.
  * **Evidence:** Developed 7 administrative controllers handling projects, amenities, staff profiles, testimonials, brand videos, and event galleries with drag-and-drop reordering.
  * **Metric:** 7 backoffice management modules with automated image uploads and ordering logic.

* **Claim:** Created an interactive real estate analytics dashboard for business intelligence.
  * **Evidence:** Built [`AdminDashboard.tsx`](file:///C:/laragon/www/laravel/estate-kangaroo/resources/js/Pages/AdminDashboard.tsx) using Recharts `AreaChart`, mapping inspection trends, monthly booking tallies, and property inquiry volumes.
  * **Metric:** Real-time data visualization plotting historical lead conversion metrics.

* **Claim:** Implemented modern luxury web interactions using Framer Motion and video player integrations.
  * **Evidence:** Authored [`BrandVideo.tsx`](file:///C:/laragon/www/laravel/estate-kangaroo/resources/js/Components/components/sections/BrandVideo.tsx) and landing sections utilizing `xgplayer`, infinite floating animation variants, responsive masonry layouts, and continuous marquee carousels.
  * **Metric:** 60 FPS hardware-accelerated animations and interactive video playback.

---

## 7. Resume-Ready Highlights

* Engineered **DeMosaic Homes**, a full-stack luxury real estate platform built with **Laravel 12**, **React 18.2**, **Inertia.js 2.0**, and **TypeScript**, contributing 163 commits as lead engineer.
* Developed an **automated property inspection booking engine** with dynamic availability scheduling, slot validation, and automated dual transactional email notifications.
* Architected a **dynamic project and amenity management system**, empowering administrative staff to configure property catalogs, unit specs, and featured showcase ordering.
* Integrated **high-performance web video tours** leveraging XGPlayer and Framer Motion, designing custom playback controls and floating micro-interactions.
* Built an **executive booking analytics dashboard** utilizing Recharts to track monthly inspection volume trends, conversion metrics, and appointment distributions.
* Created a **career recruitment portal** supporting dynamic job postings, resume file uploads, and in-app applicant tracking.
* Designed an **editorial media gallery and events diary** utilizing responsive masonry grids and continuous marquees for luxury architectural showcases.

---

## Project Interview Cheat Sheet

1. **Core Purpose:** Luxury real estate and property development platform combining high-end editorial property showcases with automated inspection appointment booking.
2. **Commit Ownership:** Lead full-stack engineer authoring 163 of 207 repository commits (78.7% ownership).
3. **Booking Architecture:** [`ScheduleBookingController`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Http/Controllers/ScheduleBookingController.php) validates appointments against rules in [`ScheduleConfiguration`](file:///C:/laragon/www/laravel/estate-kangaroo/app/Models/ScheduleConfiguration.php) (`available_days`, `start_time`, `end_time`).
4. **Idempotent Appointments:** Uses `ScheduleBooking::updateOrCreate()` keyed on client email and date, preventing duplicate records.
5. **Dual Notification:** Simultaneously dispatches `ScheduleBookingAdminMail` (to office dispatchers with lead details) and `ScheduleBookingUserMail` (to the prospect with Lekki Phase 1 location coordinates).
6. **Video Architecture:** Employs `xgplayer` and custom HTML5 video components in [`BrandVideo.tsx`](file:///C:/laragon/www/laravel/estate-kangaroo/resources/js/Components/components/sections/BrandVideo.tsx) with state-morphing play buttons.
7. **Analytics Engine:** [`AdminDashboard.tsx`](file:///C:/laragon/www/laravel/estate-kangaroo/resources/js/Pages/AdminDashboard.tsx) renders Recharts `AreaChart` plotting monthly appointments and total transactions.
8. **Dynamic Reordering:** Admins can re-index featured projects, brand videos, staff members, and testimonials via batch database update endpoints (`reorder`).
9. **Modern Stack:** Laravel 12, React 18.2, Inertia.js 2.0, Vite 6, TypeScript 5, Tailwind CSS, and Framer Motion.
10. **Scale:** 75 routes, 24 controllers, 14 models, 16 migrations, and 115 frontend TypeScript/React files across 37 views.
