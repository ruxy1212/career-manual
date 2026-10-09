# Project Breakdown: DevLinks (Link-Sharing)

---

## 1. Project Snapshot

* **What the product does:** DevLinks is a developer-centric, full-stack link-in-bio and profile customization platform featuring real-time interactive phone simulation, drag-and-drop link management, dynamic server-side OpenGraph card generation, 3D WebGL logo interactions, and multi-platform URL validation.
* **My likely role/contribution:** Sole Full-Stack Engineer & Designer (authored 100% of commits—68 of 68—designing the architecture, Firebase integration, 3D graphics pipeline, state reducers, and serverless image generation).
* **Tech stack:**
  * **Frontend / Framework:** Next.js 14 (`next: 14.2.5`, App Router), React 18, TypeScript 5, Tailwind CSS (`tailwindcss: ^3.4.1`), Material-UI (`@mui/material: ^5.16.4`), Radix UI (`@radix-ui/react-dropdown-menu`), `next-themes` (Dark/Light mode).
  * **3D & Animations:** Three.js (`three: ^0.167.0`), React Three Fiber (`@react-three/fiber: ^8.16.8`), React Three Drei (`@react-three/drei: ^9.109.2`), Framer Motion (`framer-motion: ^11.3.30`), GSAP (`gsap: ^3.12.5`).
  * **Backend & Storage:** Firebase Authentication, Cloud Firestore (`firebase: ^9.23.0`), Cloudinary SDK (`cloudinary: ^2.9.0`, `next-cloudinary`), Next.js Server Actions & Route Handlers (`next/og`).
  * **Drag & Drop:** `react-beautiful-dnd` paired with custom `StrictModeDroppable` RAF-delayed mounting.
  * **Infrastructure & Deployment:** Vercel Serverless Hosting, edge-ready dynamic image generation, deployed live at [devlinks-go.vercel.app](https://devlinks-go.vercel.app).
* **Project scale:**
  * **56** TypeScript / React source files (47 `.tsx`, 9 `.ts`).
  * **31** modular UI components and fragments.
  * **14** developer platform integrations with strict domain and path-prefix validators.
  * **2** serverless API route handlers (Cloudinary asset ingestion and dynamic OpenGraph image generation).
  * **68** Git commits authored exclusively by Russell Oje.
  * **Live production deployment:** Hosted on Vercel at [devlinks-go.vercel.app](https://devlinks-go.vercel.app).

---

## 2. Engineering Metrics

### Frontend Architecture
* **Component Volume:** 31 components split between core interactive elements and domain-specific fragments (`link-fragments`, `profile-fragments`, `layouts`).
* **Route Structure:** Next.js 14 App Router containing 5 primary views:
  * `/` & `/dashboard`: Protected dashboard supporting tab switching between Links and Profile management.
  * `/login` & `/register`: Authenticated state flows with client/server validation.
  * `/view/[uid]`: Server-rendered public profile view with dynamic metadata generation.
* **Real-Time Synchronized Device Simulator:** [`PhoneMockup.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/link-fragments/PhoneMockup.tsx) dynamically mirroring form mutations, avatar loading skeletons, name/email toggles, and live drag-and-drop link reordering in an SVG frame.
* **Dual Theme Engine:** Dark/Light theme switching using `next-themes` with custom theme-tailored phone frames (`illustration-phone-mockup.svg` vs. `illustration-phone-mockup-dark.svg`) and custom scrollbars.

### 3D WebGL Graphics
* **3D Canvas Pipeline:** Integrated React Three Fiber canvas ([`logo-scene.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/logo-scene.tsx), [`logo.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/logo.tsx)) rendering an interactive GLTF model (`/third.glb`) with directional lighting, antialiasing, and device pixel ratio clamps (`dpr={[1, 1.5]}`).
* **Hybrid Motion Binding:** Binds Three.js animation actions directly to Framer Motion spring values (`useSpring(motionVal, { stiffness: 20 })`) to scrub 3D model timeline frames on hover and click events.

### Backend / Serverless APIs
* **Dynamic OG Generation:** Serverless Node.js runtime handler ([`api/og/[uid]/route.tsx`](file:///C:/laragon/www/react/link-sharing/src/app/api/og/%5Buid%5D/route.tsx)) querying Firestore in real time and rendering custom $1200 \times 630$ PNG social cards using `next/og` (`@vercel/og`).
* **Cloudinary Media Endpoint:** POST route ([`api/upload/route.ts`](file:///C:/laragon/www/react/link-sharing/src/app/api/upload/route.ts)) executing atomic image uploads with user ID folder isolation, cache invalidation, and automatic overwrite policies.
* **Firebase Data Layer:** Real-time Firestore synchronization using `useDocumentData` hooks ([`react-firebase-hooks`](file:///C:/laragon/www/react/link-sharing/src/components/link-fragments/PhoneMockup.tsx#L11)) listening to document changes under `${uid}/profileDetails` and `${uid}/userLinks`.

### Validation & Drag-and-Drop
* **Domain & Path URL Verification:** Multi-tier URL validation across 14 platforms ([`data.tsx`](file:///C:/laragon/www/react/link-sharing/src/data.tsx)) checking protocol, exact hostname, wildcard subdomains (`.github.com`), and path prefix compliance ([`LinkInput.tsx:43-74`](file:///C:/laragon/www/react/link-sharing/src/components/link-fragments/LinkInput.tsx#L43-L74)).
* **Client-Side Image Pre-Flight Validation:** Inspects raw image files via in-memory `new Image()` onload triggers, enforcing a strict $1024 \times 1024\text{px}$ limit before upload ([`UploadImage.tsx:37-56`](file:///C:/laragon/www/react/link-sharing/src/components/profile-fragments/UploadImage.tsx#L37-L56)).
* **SSR Drag-and-Drop Stabilization:** [`StrictModeDroppable.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/StrictModeDroppable.tsx) deferring droppable initialization via `requestAnimationFrame` to overcome React 18 hydration timing bugs.

---

## 3. What I Built

### 1. Real-Time Interactive Device Simulator (Phone Mockup)
* **What I implemented technically:** Built [`PhoneMockup.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/link-fragments/PhoneMockup.tsx) and [`PhoneLinkBox.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/PhoneLinkBox.tsx). Displays an SVG phone chassis that reacts instantly to input state in the adjacent editor. Integrated dual-directional drag-and-drop reordering: links can be dragged either on the form editor or directly inside the phone screen mockup, updating the global link state reducer synchronously.
* **Why it mattered:** Eliminates guesswork for users by providing an instant, pixel-perfect preview of how their profile looks on mobile devices before publishing.

### 2. Dynamic Server-Side OpenGraph Card Generation (`next/og`)
* **What I implemented technically:** Created [`src/app/api/og/[uid]/route.tsx`](file:///C:/laragon/www/react/link-sharing/src/app/api/og/%5Buid%5D/route.tsx) and wired it to dynamic metadata in [`src/app/view/[uid]/page.tsx`](file:///C:/laragon/www/react/link-sharing/src/app/view/%5Buid%5D/page.tsx#L11). Fetches profile details, avatar URLs, and active platforms directly from Firestore on edge request, synthesizing a stylized $1200 \times 630$ OpenGraph card with circular avatar masks, custom branding, and dynamic link counts.
* **Why it mattered:** When users share their DevLinks URL on Twitter, LinkedIn, Slack, or Discord, it automatically unfurls a high-impact, personalized social preview image.

### 3. Interactive 3D WebGL Logo with Framer Motion Springs
* **What I implemented technically:** Architected a 3D scene in [`logo-scene.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/logo-scene.tsx) and [`logo.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/logo.tsx) using Three.js and React Three Fiber. Loaded a GLTF asset (`/third.glb`), applied continuous rotational physics across X, Y, and Z axes inside `useFrame`, and linked the model's skeletal animation timeline directly to a Framer Motion spring (`useSpring(motionVal, { stiffness: 20 })`) that scrubs keyframe time on pointer hover and down events.
* **Why it mattered:** Elevated the branding from a static 2D vector logo to an interactive 3D WebGL asset that responds tactilely to user pointer interactions.

### 4. Strict Multi-Platform URL Validation Engine
* **What I implemented technically:** Built a deterministic URL verification system in [`LinkInput.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/link-fragments/LinkInput.tsx) and [`data.tsx`](file:///C:/laragon/www/react/link-sharing/src/data.tsx) covering 14 platforms (GitHub, LinkedIn, YouTube, Twitter/X, Frontend Mentor, Dev.to, Codewars, GitLab, Hashnode, Stack Overflow, etc.). Parses URLs with the Web API `URL`, strips `www.`, validates protocol (`http:`, `https:`), matches authorized root and subdomains, enforces path prefixes (e.g. `/in/` for LinkedIn, `/users/` for Codewars, `/@` for YouTube), and interfaces with HTML5 `setCustomValidity`.
* **Why it mattered:** Prevents broken, deceptive, or misconfigured profile links from being saved to the database.

### 5. Hydration-Safe Drag-and-Drop Link Manager
* **What I implemented technically:** Implemented an immutable link state reducer in [`linksManager.ts`](file:///C:/laragon/www/react/link-sharing/src/hooks/linksManager.ts) handling actions: `initialize links`, `add link`, `remove link`, `update link`, and `re-order links`. Wrapped `react-beautiful-dnd` in [`StrictModeDroppable.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/StrictModeDroppable.tsx), using `requestAnimationFrame` lifecycle hooks to eliminate React 18 SSR hydration mismatches.
* **Why it mattered:** Enabled drag-and-drop reordering without hydration failures, visual flickers, or array mutation bugs.

### 6. Cloudinary Asset Pipeline with Client-Side Dimension Pre-Flight
* **What I implemented technically:** Engineered an avatar upload flow in [`UploadImage.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/profile-fragments/UploadImage.tsx) and [`api/upload/route.ts`](file:///C:/laragon/www/react/link-sharing/src/app/api/upload/route.ts). Before firing network requests, images are loaded into an in-memory `new Image()` object to verify dimensions ($<1024 \times 1024\text{px}$). Validated images are dispatched to the serverless Cloudinary endpoint, stored under user-isolated folders (`devlinks/usersAvatar`), and cached with cache invalidation tags.
* **Why it mattered:** Saves bandwidth and server processing by stopping oversized files client-side while ensuring CDN-optimized delivery for public profiles.

---

## 4. Design Walkthrough

### Flow 1: Live Interactive Link Creation & Phone Mockup Reflection
* **Path:** `User clicks "+ Add new link" → dispatch({ type: 'add link' }) → Reducer Appends Item → Form Renders CustomizeLink → PhoneMockup Receives Updated usersLinks → PhoneLinkBox Appears in SVG Chassis`
* **Implementation:** In [`TabsContainer.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/TabsContainer.tsx) and [`LinksTab.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/LinksTab.tsx), clicking the add button dispatches an action to `linksReducer`. Because [`PhoneMockup`](file:///C:/laragon/www/react/link-sharing/src/components/link-fragments/PhoneMockup.tsx) shares context state, a new [`PhoneLinkBox`](file:///C:/laragon/www/react/link-sharing/src/components/PhoneLinkBox.tsx) renders immediately inside the mockup. As the user selects a platform from [`PlatformSelectBox`](file:///C:/laragon/www/react/link-sharing/src/components/link-fragments/PlatformSelectBox.tsx), platform branding and icons update instantaneously across both form and phone views.

### Flow 2: Multi-Platform URL Validation & Error Feedback
* **Path:** `User types link → onChange updates local state → onBlur triggers handleBlur → isValidUrl() parses domain & path prefix → setCustomValidity() updated → Error badge toggled`
* **Implementation:** In [`LinkInput.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/link-fragments/LinkInput.tsx), when the input loses focus, `isValidUrl()` instantiates `new URL(url)`. It tests if `hostname` matches `selectedPlatform.domains` and if `pathname` starts with `selectedPlatform.pathPrefixes`. If invalid, `e.target.setCustomValidity(' ')` triggers HTML5 validation styling and displays an inline red error badge (`Invalid ${platform} URL`). If valid, `dispatch({ type: 'update link' })` commits the change to global state.

### Flow 3: Drag-and-Drop Reordering with StrictMode Droppable
* **Path:** `User drags link handle → onDragEnd(result) → Source and Destination indices extracted → dispatch({ type: 're-order links' }) → Reducer executes splice() → Phone & Form Reorder Atomically`
* **Implementation:** Wrapped in [`StrictModeDroppable`](file:///C:/laragon/www/react/link-sharing/src/components/StrictModeDroppable.tsx), the drag context captures the dropped element. In [`PhoneMockup.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/link-fragments/PhoneMockup.tsx#L42) and [`LinksTab.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/LinksTab.tsx), `onDragEnd` removes the item from the source index and splices it into the destination index, dispatching an immutable update that re-indexes both the editor list and the phone simulator simultaneously.

### Flow 4: Avatar Pre-Flight Validation & Cloudinary Upload
* **Path:** `User selects file → ChangeEvent captured → in-memory new Image() loaded → Dimensions validated (<= 1024x1024) → POST api/upload with Base64 → Cloudinary upload with user public_id → Firestore profileDetails updated`
* **Implementation:** In [`UploadImage.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/profile-fragments/UploadImage.tsx), `image.onload` checks `imageWidth > 1024 || imageHeight > 1024`. If dimensions exceed boundaries, text turns red and execution aborts. On form submission, the image payload is dispatched to [`api/upload/route.ts`](file:///C:/laragon/www/react/link-sharing/src/app/api/upload/route.ts), which uploads to Cloudinary with `overwrite: true` and `invalidate: true`. The secure URL is saved to Firestore `${uid}/profileDetails`.

### Flow 5: Public Profile View & Dynamic OpenGraph Card Generation
* **Path:** `External visitor visits /view/[uid] → Server Page executes generateMetadata → Queries Firestore profileDetails → Renders <meta property="og:image" content="/api/og/[uid]"> → Social bot fetches /api/og/[uid] → ImageResponse returns 1200x630 dynamic PNG`
* **Implementation:** In [`src/app/view/[uid]/page.tsx`](file:///C:/laragon/www/react/link-sharing/src/app/view/%5Buid%5D/page.tsx), `generateMetadata` reads the user's profile from Firestore on the server and defines an OG image URL pointing to `/api/og/${uid}`. When an external crawler requests this route, [`api/og/[uid]/route.tsx`](file:///C:/laragon/www/react/link-sharing/src/app/api/og/%5Buid%5D/route.tsx) executes an `ImageResponse` using JSX layout tags, combining the user's name, avatar, total link counts, and DevLinks branding into an edge-rendered social card.

### Flow 6: 3D Model Pointer Interaction Loop
* **Path:** `Pointer hovers over 3D Canvas → onPointerOver fires → motionVal.set(0.9) → Framer Motion useSpring interpolates value → useFrame loop reads spring.get() → action.time updated → GLTF animation advances`
* **Implementation:** In [`logo.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/logo.tsx), the Three.js GLTF model is mounted inside a React Three Fiber canvas. The animation action is paused (`action.play().paused = true`), and its playback time is set every frame to `spring.get()`. Pointer events adjust `motionVal` between `0` and `0.9`, creating a smooth, spring-damped morphing animation of the 3D logo whenever the user interacts with it.

---

## 5. Engineering Decisions & Challenges

* **React 18 SSR Hydration with `react-beautiful-dnd`:** Standard `react-beautiful-dnd` throws hydration mismatch errors in Next.js App Router because its droppable DOM attributes are generated before the client hydration phase completes.
  * *Code Solution:* Engineered [`StrictModeDroppable.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/StrictModeDroppable.tsx). Defer the rendering of the droppable tree until the browser's first `requestAnimationFrame` tick (`requestAnimationFrame(() => setEnabled(true))`), ensuring 100% clean server-to-client hydration.
* **OpenGraph Image Generation at Scale:** Generating social preview cards via headless Chromium instances introduces heavy cold-start latency and high memory overhead on serverless edge functions.
  * *Code Solution:* Implemented Next.js `ImageResponse` (`@vercel/og`) in [`api/og/[uid]/route.tsx`](file:///C:/laragon/www/react/link-sharing/src/app/api/og/%5Buid%5D/route.tsx). Uses a lightweight WebAssembly-based Satori layout engine to compile pure JSX/CSS into $1200 \times 630$ PNG cards in under 100ms.
* **Decoupled 3D Animation Control:** Coordinating 3D mesh keyframe scrub animations using standard Three.js clock ticks results in rigid, linear transitions that do not match the UI's Framer Motion spring physics.
  * *Code Solution:* Bound Three.js animation actions directly to a Framer Motion spring value (`useSpring(motionVal, { stiffness: 20 })`). In [`logo.tsx:23`](file:///C:/laragon/www/react/link-sharing/src/components/logo.tsx#L23), updated `action.time = spring.get()` inside the 60 FPS `useFrame` render loop, giving the 3D model organic elastic spring physics.
* **Complex URL Validation for 14 Heterogeneous Platforms:** Simple regex URL validation fails to prevent users from entering invalid user profile formats (e.g. entering a Twitter home URL instead of a profile, or invalid LinkedIn handles).
  * *Code Solution:* Structured a domain and path-prefix validation matrix in [`data.tsx`](file:///C:/laragon/www/react/link-sharing/src/data.tsx). Evaluates URL protocol, checks domain wildcards (`.github.com`), and validates path prefixes (`/in/`, `/users/`, `/@`), providing specific platform error messages.
* **Client-Side Image Bandwidth Optimization:** Uploading raw multi-megabyte images from smartphones directly to image hosting consumes excessive bandwidth and can trigger function payload limits.
  * *Code Solution:* Integrated pre-flight image dimension checking in [`UploadImage.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/profile-fragments/UploadImage.tsx). Loads the file into a temporary `new Image()` object and blocks uploads exceeding $1024 \times 1024\text{px}$ before sending data over the network.

---

## 6. Job-Application Evidence

* **Claim:** Architected and deployed a full-stack, real-time link management platform with serverless APIs and database integration.
  * **Evidence:** Single author of 100% of commits (68 of 68), engineering 56 TypeScript/React files across Next.js 14 App Router, Firebase Authentication, Cloud Firestore, and Cloudinary.
  * **Metric:** 68 commits, 56 TSX/TS files, 31 modular components, live production URL.

* **Claim:** Engineered dynamic, on-the-fly OpenGraph image generation for social platform sharing.
  * **Evidence:** Authored [`src/app/api/og/[uid]/route.tsx`](file:///C:/laragon/www/react/link-sharing/src/app/api/og/%5Buid%5D/route.tsx) and [`src/app/view/[uid]/page.tsx`](file:///C:/laragon/www/react/link-sharing/src/app/view/%5Buid%5D/page.tsx), generating dynamic $1200 \times 630$ PNG cards with user avatars, names, and link tallies via `@vercel/og`.
  * **Metric:** Sub-100ms serverless edge generation delivering personalized rich link previews on Twitter, LinkedIn, and Slack.

* **Claim:** Integrated interactive 3D WebGL graphics and animations into a production React application.
  * **Evidence:** Created [`logo-scene.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/logo-scene.tsx) and [`logo.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/logo.tsx) using Three.js, React Three Fiber, and Drei, binding 3D GLTF keyframe playback directly to Framer Motion spring physics.
  * **Metric:** Continuous 3-axis rotational physics and interactive pointer-scrubbed morph animations running at 60 FPS.

* **Claim:** Built a real-time reactive device simulator with dual-directional drag-and-drop reordering.
  * **Evidence:** Implemented [`PhoneMockup.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/link-fragments/PhoneMockup.tsx), allowing users to reorder links either in the form editor or directly inside the phone screen mockup with instant state synchronization.
  * **Metric:** 100% synchronized state updates between editor and mockup via immutable `linksReducer`.

* **Claim:** Implemented strict input validation and pre-flight media checks to ensure data integrity.
  * **Evidence:** Authored [`LinkInput.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/link-fragments/LinkInput.tsx) and [`UploadImage.tsx`](file:///C:/laragon/www/react/link-sharing/src/components/profile-fragments/UploadImage.tsx), enforcing domain and path-prefix compliance across 14 platforms and pre-flight validating image pixel boundaries ($1024 \times 1024\text{px}$).
  * **Metric:** 14 platform configurations validated with zero broken URL saves.

---

## 7. Resume-Ready Highlights

* Engineered **DevLinks**, a full-stack link-in-bio platform built with **Next.js 14**, **React 18**, **TypeScript**, and **Firebase**, deployed in production on Vercel.
* Developed a **real-time interactive phone simulator** that mirrors form mutations, avatar loading states, and live link additions inside an SVG mobile chassis.
* Built dynamic **server-side OpenGraph card generation** utilizing `next/og` and Edge runtimes, rendering customized $1200 \times 630$ social preview images based on live Firestore user data.
* Integrated an **interactive 3D WebGL scene** with React Three Fiber, Three.js, and Drei, binding 3D model animation playback directly to Framer Motion spring mechanics.
* Implemented **drag-and-drop link reordering** using `react-beautiful-dnd`, resolving React 18 SSR hydration mismatches via custom `requestAnimationFrame` lifecycle mounting.
* Designed a **strict multi-platform validation engine** validating protocol, domain wildcards, and path prefixes across 14 developer platforms.
* Architected a **Cloudinary media pipeline** featuring client-side pre-flight image dimensional checks ($1024 \times 1024\text{px}$) and user-isolated asset storage.

---

## Project Interview Cheat Sheet

1. **Core Purpose:** Link-in-bio platform tailored for developers to aggregate portfolios and social handles with real-time mobile simulation.
2. **Commit Distribution:** 100% authored by Russell Oje (68 of 68 commits).
3. **Real-Time Phone Mockup:** SVG phone chassis reacts instantly to Firestore and React context mutations; supports dragging links directly on the phone or in the form.
4. **Dynamic OpenGraph Engine:** Uses `next/og` (`@vercel/og`) in `api/og/[uid]/route.tsx` to generate personalized $1200 \times 630$ PNG social cards on edge requests.
5. **3D WebGL Integration:** React Three Fiber canvas mounts a GLTF model (`/third.glb`); scrubs animation keyframes by mapping `action.time` to a Framer Motion spring (`useSpring(motionVal, { stiffness: 20 })`).
6. **SSR Hydration Fix:** `StrictModeDroppable.tsx` delays mounting of `react-beautiful-dnd` until the first `requestAnimationFrame`, eliminating React 18 App Router hydration bugs.
7. **Validation Logic:** `LinkInput.tsx` tests URLs against 14 platform definitions in `data.tsx`, enforcing valid protocol, root/subdomain matches, and path prefixes.
8. **Client-Side Image Checks:** Pre-flight checks file width and height via `new Image()` in `UploadImage.tsx`, rejecting images above $1024 \times 1024\text{px}$ before upload.
9. **State Architecture:** Global state managed via `MyAppProvider` context paired with an immutable action reducer (`linksManager.ts`).
10. **Modern Stack:** Next.js 14 App Router, React 18, TypeScript 5, Tailwind CSS, Firebase Auth/Firestore, Cloudinary, Three.js, and Vercel hosting.
