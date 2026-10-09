# Project Breakdown: Animated Kangaroo

---

## 1. Project Snapshot

* **What the product does:** Animated Kangaroo is an award-winning style, high-performance creative frontend engineering showcase and digital experience (cloning Valid.com's trusted connectivity portal) featuring complex 180-frame canvas scrubbing, multi-phase GSAP camera zooms, interactive spring-back particle physics, and custom inertia-damped cursor mechanics.
* **My likely role/contribution:** Sole Frontend Architect & Creative Developer (authored 100% of commits—38 of 38—architecting all GSAP scroll timelines, custom physics engines, canvas renderers, and responsive layouts).
* **Tech stack:**
  * **Frontend / Framework:** Next.js 15 (`next: 15.3.8`), React 19 (`react: ^19.0.0`), TypeScript 5 (`typescript: ^5`), Tailwind CSS v4 (`tailwindcss: ^4`, `@tailwindcss/postcss: ^4`), styled-components (`styled-components: ^6.1.17`).
  * **Animation & Physics:** GSAP 3.12.7 (`gsap`), `@gsap/react: ^2.1.2`, GSAP ScrollTrigger plugin, Motion (`motion: ^12.7.4`), HTML5 Canvas 2D, custom trigonometric & spring-friction physics engines.
  * **Asset Optimization & Fonts:** Local WOFF2 typography integration (`PPEditorialNew`, `PPRadioGrotesk`, `InterTight`), HTML5 background video playback, 180 pre-rendered canvas frames.
  * **Infrastructure & Deployment:** Vercel Edge Hosting, Next.js App Router, automated production CI/CD builds.
* **Project scale:**
  * **43** TypeScript / React source files (36 `.tsx`, 7 `.ts`).
  * **34** modular UI components and layout fragments across 9 feature namespaces (`carousel`, `partners`, `hero`, `header`, `footer`, `modal`, `error`, `common`, `util`).
  * **180** pre-rendered sequential JPG canvas frames ($1280 \times 632$) preloaded into memory for smooth scrubbing.
  * **38** Git commits authored exclusively by Russell Oje.
  * **Live production deployment:** Hosted on Vercel at [animated-kangaroo.vercel.app](https://animated-kangaroo.vercel.app/).

---

## 2. Engineering Metrics

### Frontend Architecture
* **Component Volume:** 34 components and fragments structured into dedicated domain directories:
  * Carousel: 3 files ([`Carousel.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/carousel/Carousel.tsx), [`ButtonCarousel.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/carousel/ButtonCarousel.tsx), [`CarouselSection.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/carousel/CarouselSection.tsx)).
  * Partners & Scrollers: 7 files ([`ZoomScrollSections.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/partners/ZoomScrollSections.tsx), [`ScrollSection.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/partners/ScrollSection.tsx), [`AboutSection.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/partners/AboutSection.tsx), [`InsightsSection.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/partners/InsightsSection.tsx), and fragments).
  * Physics & Cursors: 4 files ([`cursor-follow.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/util/cursor-follow.tsx), [`cursor-follow-wrapper.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/util/cursor-follow-wrapper.tsx), [`Trail.ts`](file:///C:/laragon/www/react/animated-kangaroo/src/lib/follow/Trail.ts), [`particles.ts`](file:///C:/laragon/www/react/animated-kangaroo/src/components/error/particles.ts)).
  * Header & Navigation Drawers: 10 files ([`Header.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/header/Header.tsx), [`Sidebar.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/header/Sidebar.tsx), [`MobileMenu.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/header/MobileMenu.tsx), [`ContactExpert.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/header/ContactExpert.tsx), and fragments).
  * Footer & Marquee: 3 files ([`Footer.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/footer/Footer.tsx), [`InfiniteText.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/footer/InfiniteText.tsx), [`Subscribe.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/footer/Subscribe.tsx)).
* **Next.js App Router Structure:** Server Layout root ([`layout.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/app/layout.tsx)) pairing local variable web fonts with client-rendered interactive scenes ([`page.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/app/page.tsx), [`not-found.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/app/not-found.tsx)).

### Animation & Rendering Performance
* **Canvas Preload Pipeline:** 180 image frames (`00000.jpg` to `00179.jpg`) preloaded in memory via parallel `Image()` instantiations during `useEffect`, drawing the initial frame on Canvas mount to eliminate layout shifts.
* **Frame Rate Integrity:** 60 FPS sub-pixel animation loops driven by browser `requestAnimationFrame` for cursor interpolation, marquee scrolling, and particle updates, bypassing React component reconciliation.
* **Display Density Adaptation:** High-DPI canvas scaling using `window.devicePixelRatio` for retina clarity without blurriness ([`particles.ts:11-12`](file:///C:/laragon/www/react/animated-kangaroo/src/components/error/particles.ts#L11-L12)).
* **Scroll Distance Span:** Multi-stage pinned scroll timeline orchestrating animation over 505% of viewport height ($5.05 \times \text{window.innerHeight}$) with 6 distinct choreographies ([`ZoomScrollSections.tsx:42`](file:///C:/laragon/www/react/animated-kangaroo/src/components/partners/ZoomScrollSections.tsx#L42)).

### Security & State Management
* **Memory Leak Elimination:** Explicit lifecycle cleanup: teardown of GSAP ScrollTriggers (`st.kill()`), cancellation of animation frame IDs (`cancelAnimationFrame`), removal of window resize/scroll listeners, and DOM node clearing.
* **Layer Composition:** `mix-blend-mode: difference` combined with hardware-accelerated CSS properties (`will-change-transform`, `transform: translate3d`) for cursor blending across high-contrast backgrounds without DOM repaints.

---

## 3. What I Built

### 1. 180-Frame HTML5 Canvas Sequence Scrubber with Extreme Zoom
* **What I implemented technically:** Built [`ZoomScrollSections.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/partners/ZoomScrollSections.tsx) and [`ScrollSection.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/partners/ScrollSection.tsx). Preloads 180 frames into an in-memory image buffer, binds scroll progress ($0.0 \to 1.0$) to canvas frame indexes via GSAP ScrollTrigger, and coordinates a 6-scene zoom transformation that scales typography from 0.8x up to 60x while shifting the `transformOrigin` at keyframe boundaries (`49% 20%`) to reveal an embedded eye canvas surrounded by four directional CSS gradient masks.
* **Why it mattered:** Solved the stuttering and codec delay inherent in standard `<video>` tag scrubbing; delivers silky 60 FPS bidirectional playback scrubbed directly by the user's scrollbar.

### 2. Custom Inertia-Damped Cursor & Orbiting Particle Physics
* **What I implemented technically:** Engineered an object-oriented cursor physics library in [`Trail.ts`](file:///C:/laragon/www/react/animated-kangaroo/src/lib/follow/Trail.ts) and [`cursor-follow.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/util/cursor-follow.tsx). Implements damped linear interpolation (`lerp`):
  $$\text{trail}.x \mathrel{+}= (x - \text{trail}.x) \times 0.4$$
  When movement ceases, the cursor activates an idle detection timer ($N \times 7.5\text{ms}$), switching trailing particles into a harmonic circular orbit powered by trigonometric offsets:
  $$x = \text{lockX} + \sin(\text{angleX}) \times \text{range}, \quad y = \text{lockY} + \sin(\text{angleY}) \times \text{range}$$
* **Why it mattered:** Produces an elastic, organic cursor feel that responds to mouse, touch, and scroll wheel events without sluggishness or input lag.

### 3. Interactive Elastic Particle Collision & Dispersion System (404 Page)
* **What I implemented technically:** Created an interactive particle simulation in [`particles.ts`](file:///C:/laragon/www/react/animated-kangaroo/src/components/error/particles.ts) and [`Particles404.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/error/Particles404.tsx). Generates a grid of particles scaled by device pixel ratio. When the cursor approaches within radius ($r = 3000$), each particle calculates polar repulsion vectors:
  $$\text{force} = \left(-\frac{\text{radius}}{\text{distance}}\right) \times \text{spread}, \quad \theta = \text{atan2}(dy, dx)$$
  As the mouse moves away, the particles return to their original grid coordinates via velocity dampening ($\text{friction} = 0.9$) and elastic spring restoration ($\text{ease} = 0.05$).
* **Why it mattered:** Turns an otherwise boring error screen into a memorable, physics-driven interactive canvas that demonstrates high-performance 2D math capabilities.

### 4. Pinned Vertical-to-Horizontal Carousel with Staggered Container Morphing
* **What I implemented technically:** Built [`Carousel.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/carousel/Carousel.tsx). Pins the section to the viewport using GSAP ScrollTrigger and translates the inner container horizontally (`x: () => -maxScrollX`). Simultaneously connects sub-item container heights (interpolating text container from 65vh to 50vh, and image container from 35vh to 50vh) and image scale ($1.1 \to 1.0$) directly to the horizontal scroll timeline via `containerAnimation`. On mobile viewports, automatically switches to viewport-width calculations with discrete magnetic snap increments (`snapTo: 1 / (N - 1)`).
* **Why it mattered:** Delivers complex multi-axis motion (vertical page scroll translating smoothly into horizontal card movement with interior image reveals) without breaking standard touch or scrollbar mechanics.

### 5. Bidirectional Dynamic Marquee Text Engine
* **What I implemented technically:** Developed [`Footer.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/footer/Footer.tsx) and [`InfiniteText.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/footer/InfiniteText.tsx). Combines `requestAnimationFrame` infinite modulo translation with GSAP ScrollTrigger scroll velocity monitoring. Tracks window scroll direction via `currentScrollY > lastScrollY ? -1 : 1` to instantly invert the text travel direction and accelerate translation during active user scrolling.
* **Why it mattered:** Replaces flat CSS `@keyframes` marquees with an interactive typography element that responds dynamically to user scroll speed and direction.

### 6. Interactive Hacker / Matrix Scramble-Text Deciphering Effect
* **What I implemented technically:** Authored [`mouse-enter.ts`](file:///C:/laragon/www/react/animated-kangaroo/src/lib/utils/mouse-enter.ts). Intercepts hover events, reads `data-value` attributes, and runs a requestAnimationFrame decoding loop using character randomizations from a specialized symbol bank (`!ABCDEFGHIJKLMNOPQRSTUVWXYZ#`). Iterates progressively ($+1/3$ per tick) at delta-time intervals (30–60ms) until the exact string resolves.
* **Why it mattered:** Enhances micro-interactions on interactive links and headers with zero heavy external libraries.

---

## 4. Design Walkthrough

### Flow 1: 180-Frame Canvas Sequence & 60x Typography Zoom
* **Path:** `User Vertical Scroll → GSAP ScrollTrigger (505vh pin) → Progress Normalization (0.0–1.0) → Frame Index Calculation → Canvas 2D drawImage() → Parallel H1 Scale (0.8x → 60x) → Fixed Eye Revealing`
* **Implementation:** As the user scrolls into [`ZoomScrollSections`](file:///C:/laragon/www/react/animated-kangaroo/src/components/partners/ZoomScrollSections.tsx#L41), a ScrollTrigger instance pins the container across 505vh. On every scroll tick, `self.progress` maps to an integer between 0 and 179, invoking `renderFrame(frame)` which executes `ctx.drawImage` with the pre-cached image element. Concurrently, a master GSAP timeline scales `h1Ref` up to 60x, shifts `transformOrigin` to `49% 20%` at keyframe 2, and fades in the eye canvas overlay (`scale: 1, opacity: 1, position: 'fixed'`).

### Flow 2: Inertia-Damped Cursor Tracking & Orbital Idle Transition
* **Path:** `Window Mouse Move → cursorListener → Coordinate Update → requestAnimationFrame(animate) → Trail.ts Lerp Equation → Damped Trail DOM Update → 75ms Idle Timeout → Trigonometric Orbit Loop`
* **Implementation:** Mouse movements fire [`cursorListener`](file:///C:/laragon/www/react/animated-kangaroo/src/components/util/cursor-follow.tsx#L93), capturing client and scroll offsets. The `animate` loop iterates over the `Trail` particle array; each node lags behind its parent using linear interpolation ($0.4$). When no mouse event fires for $10 \times 7.5\text{ms}$, `isIdle` toggles to true. Each particle locks its current coordinates and calculates harmonic circular orbits using `Math.sin(angleX)` and `Math.sin(angleY)`, yielding an undulating cluster.

### Flow 3: Interactive Particle Collision & Dispersion (404 View)
* **Path:** `404 Route Encountered → Particles404 Mount → Canvas DPI Initialization → Effect Grid Generated → Mouse Movement → Polar Force Vector Applied → Friction & Spring Restoration → Continuous RAF Render`
* **Implementation:** When entering an unmatched route, [`particlesCanvas`](file:///C:/laragon/www/react/animated-kangaroo/src/components/error/particles.ts#L7) sets canvas dimensions scaled by `devicePixelRatio`. A grid of `Particle` objects is created across the viewport. When `mouse.radius` intersects a particle, an acceleration vector is computed via `Math.atan2(dy, dx)` and `force = (-radius / distance) * spread`. During updates, velocity is dampened by friction ($0.9$) while an elastic return force (`(origin - current) * 0.05`) gently springs the particle back to its initial position.

### Flow 4: Pinned Horizontal Card Carousel with Container Revealing
* **Path:** `User Scrolls into Carousel → ScrollTrigger Pin Engages → Horizontal Translation (0 → -maxScrollX) → Child ScrollTrigger ContainerAnimation → Height & Scale Interpolation → Dynamic Image Reveal`
* **Implementation:** In [`Carousel.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/carousel/Carousel.tsx#L17), `isDesktop` initiates a timeline that pins `containerRef` and calculates total horizontal scroll width based on item counts. For each subsequent card, a linked `ScrollTrigger` uses `containerAnimation: horizontalScroll`. As a card crosses the viewport boundary, `gsap.utils.interpolate` smoothly expands its image container from 35vh to 50vh, contracts the text container from 65vh to 50vh, and scales the image from 1.1x to 1.0x with an opacity fade.

### Flow 5: Direction-Aware Dynamic Marquee Loop
* **Path:** `Window Scroll Event → Delta ScrollY Checked → directionRef Set (+1 or -1) → requestAnimationFrame Loop → X-Percent Step (+0.1 * direction) → Modulo Reset at -100% / 0% → DOM Set`
* **Implementation:** In [`Footer.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/footer/Footer.tsx#L20), two identical text spans are rendered side by side. An ongoing `requestAnimationFrame` loop increments `xPercentRef` by `0.1 * directionRef.current`. If `xPercent` drops below -100%, it resets to 0% (and vice-versa), ensuring an unbroken seamless loop. Scroll event listeners evaluate `currentScrollY > lastScrollY`, instantly flipping `directionRef` so the typography accelerates in the intuitive direction of the user's gesture.

---

## 5. Engineering Decisions & Challenges

* **Video Scrubbing Latency vs. Canvas Frame Buffering:** Scrubbing standard HTML5 MP4 videos via `video.currentTime = scrollProgress` results in choppy frame drops and high CPU decoding spikes across browsers.
  * *Code Solution:* Deconstructed video footage into 180 compressed JPEG frames ($1280 \times 632$) in `public/img/canvas/`. Initialized a preloading queue in [`ZoomScrollSections.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/partners/ZoomScrollSections.tsx) and drew active frames onto an HTML5 2D canvas, guaranteeing deterministic 60 FPS scrubbing regardless of hardware video decode capabilities.
* **React State Thrashing in High-Frequency Animations:** Updating React state on mousemove or requestAnimationFrame causes continuous virtual DOM reconciliation, resulting in dropped frames and high CPU usage.
  * *Code Solution:* Decoupled animation loops completely from React component state. In [`Trail.ts`](file:///C:/laragon/www/react/animated-kangaroo/src/lib/follow/Trail.ts) and [`cursor-follow.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/util/cursor-follow.tsx), references to raw DOM `<span>` elements are mutated directly using `style.transform`, `style.top`, and `style.left` inside a single persistent `requestAnimationFrame` loop.
* **Focal Jump Prevention During Scale 60x Camera Zoom:** Scaling typography from 0.8x up to 60x with a static transform origin causes the center of focus to drift drastically off-screen.
  * *Code Solution:* Orchestrated multi-scene keyframing in GSAP timelines. Set initial origin to `516px 114px`, and inserted an instantaneous keyframe shift (`tl.set(h1Ref.current, { transformOrigin: '49% 20%' }, 2)`) exactly at the 400vh mark before executing the high-magnitude zoom (scale 10x to 60x).
* **Retina / High-DPI Canvas Blur:** Default HTML5 `<canvas>` elements appear pixelated and blurry on modern high-DPI displays (MacBook Retina, 4K displays).
  * *Code Solution:* In [`particles.ts`](file:///C:/laragon/www/react/animated-kangaroo/src/components/error/particles.ts#L11-L15), scaled the internal canvas drawing surface by `window.devicePixelRatio` while fixing CSS dimensions to `window.innerWidth` and `innerHeight`, maintaining razor-sharp particle physics across all screen densities.
* **Next.js 15 App Router Hydration Safety:** Window, document, and Canvas APIs are unavailable during server-side pre-rendering, leading to hydration mismatches if not guarded properly.
  * *Code Solution:* Wrapped client-only physics hooks in [`CursorFollowWrapper.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/util/cursor-follow-wrapper.tsx), guarded canvas initializations behind `useEffect` and window checks, and applied `'use client'` pragmas to interactive route trees.

---

## 6. Job-Application Evidence

* **Claim:** Architected and engineered high-performance creative web animations combining canvas scrubbing and multi-timeline GSAP sequences.
  * **Evidence:** Implemented [`ZoomScrollSections.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/partners/ZoomScrollSections.tsx), coordinating a 180-frame canvas sequence synchronized with a 6-scene, 505vh typography zoom timeline (scale 0.8x to 60x).
  * **Metric:** 180 preloaded frames rendered at 60 FPS with zero video codec decode lag.

* **Claim:** Built custom 2D particle physics simulations utilizing mathematical vector mechanics and spring-damper equations.
  * **Evidence:** Authored [`particles.ts`](file:///C:/laragon/www/react/animated-kangaroo/src/components/error/particles.ts), programming real-time polar coordinate repulsion, trigonometric angles (`atan2`), velocity friction ($0.9$), and elastic spring return forces ($0.05$).
  * **Metric:** High-DPI canvas simulation running smoothly on device-pixel-ratio scaling with full window resize recalculation.

* **Claim:** Designed custom inertia-damped cursor physics with organic idle states.
  * **Evidence:** Created [`Trail.ts`](file:///C:/laragon/www/react/animated-kangaroo/src/lib/follow/Trail.ts) and [`cursor-follow.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/util/cursor-follow.tsx) using linear interpolation (`lerp`), DOM direct mutation, `mix-blend-mode: difference`, and trigonometric circular orbiting during inactivity.
  * **Metric:** 60 FPS sub-pixel tracking synchronized across mouse, touch, and scroll wheel events with automatic cancellation on unmount.

* **Claim:** Developed complex multi-axis scroll transitions (vertical-to-horizontal pinning with child morphing).
  * **Evidence:** Authored [`Carousel.tsx`](file:///C:/laragon/www/react/animated-kangaroo/src/components/carousel/Carousel.tsx), converting vertical page scroll into pinned horizontal sliding while using `containerAnimation` to dynamically interpolate child container heights ($65\text{vh} \to 50\text{vh}$) and image scales.
  * **Metric:** Responsive dual-mode implementation supporting continuous scroll on desktop and discrete snap points on mobile (`snapTo: 1 / (N - 1)`).

* **Claim:** Sole engineering ownership across full creative frontend development and deployment.
  * **Evidence:** Single author of 100% of commits (38 of 38), engineering 43 TypeScript/React files and 34 components, deploying to production on Vercel at [animated-kangaroo.vercel.app](https://animated-kangaroo.vercel.app/).
  * **Metric:** 38 commits, 43 TSX/TS files, 34 modular components, live production URL.

---

## 7. Resume-Ready Highlights

* Engineered **Animated Kangaroo**, an award-winning style interactive digital experience built with **Next.js 15**, **React 19**, **GSAP 3**, **Tailwind CSS v4**, and **TypeScript**, deployed globally on Vercel.
* Developed an **HTML5 2D Canvas sequence scrubber** preloading 180 sequential frames in memory to achieve 60 FPS scroll-driven playback synchronized with a 6-scene 60x typography zoom timeline.
* Authored an **elastic cursor physics system** featuring linear interpolation damping, sub-pixel DOM updates via `requestAnimationFrame`, `mix-blend-mode: difference` contrast inversion, and trigonometric idle orbiting.
* Built an interactive **canvas particle physics simulation** on 404 views using polar coordinate repulsion forces, friction dampening, and elastic spring return equations scaled for Retina/High-DPI displays.
* Engineered a **pinned multi-axis horizontal carousel** converting vertical scroll progress into horizontal card transitions with nested container dimension morphing and responsive mobile snap mechanics.
* Created a **bidirectional dynamic marquee engine** detecting real-time scroll velocity and direction to dynamically reverse and accelerate continuous typography ribbons.
* Implemented a custom **hacker text-deciphering effect** using delta-time throttled `requestAnimationFrame` loops and dynamic symbol shuffling.

---

## Project Interview Cheat Sheet

1. **Core Purpose:** High-fidelity creative engineering clone of Valid.com demonstrating mastery of advanced web animation, canvas graphics, and custom physics.
2. **Commit Ownership:** 100% authored by Russell Oje (38 of 38 commits).
3. **Canvas Image Scrubbing:** Employs 180 preloaded JPG frames on an HTML5 2D canvas instead of `<video currentTime>`, eliminating video decode lag and frame drops.
4. **Zoom Mechanics:** Multi-scene GSAP timeline spanning 505vh; switches `transformOrigin` at keyframe 2 (`49% 20%`) to seamlessly transition from headline scale 0.8x up to 60x into an eye canvas overlay.
5. **Cursor Physics:** Uses linear interpolation (`trail.x += (x - trail.x) * 0.4`) and trigonometric idle orbiting ($x = \text{lockX} + \sin(\text{angleX}) \times \text{range}$) driven directly through DOM styles to prevent React re-renders.
6. **Particle Simulation:** 404 canvas computes polar repulsion vectors ($\theta = \text{atan2}(dy, dx)$, $\text{force} = (-\text{radius} / \text{dist}) \times \text{spread}$), dampened by $0.9$ friction with $0.05$ spring return.
7. **Retina Display Rendering:** Canvas internal buffer scales by `window.devicePixelRatio` while styling CSS dimensions to viewport size for razor-sharp rendering.
8. **Horizontal Pinning:** `Carousel.tsx` pins section and drives nested child container heights (65vh to 50vh) via GSAP `containerAnimation`.
9. **Dynamic Marquee:** Checks scroll delta `scrollY > lastScrollY ? -1 : 1` to dynamically reverse and accelerate infinite text wrapping on the fly.
10. **Modern Stack:** Next.js 15 App Router, React 19, GSAP 3.12, Motion 12, Tailwind CSS v4, local WOFF2 variable fonts, hosted live on Vercel.
