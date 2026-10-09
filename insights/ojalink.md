# Project Breakdown: OjaLink

---

## 1. Project Snapshot

* **What the product does:** OjaLink is an on-demand African grocery marketplace and fulfillment platform connecting urban consumers with physical open-air food markets, featuring unit-aware cataloging, AI-assisted recipe-to-cart kit generation, automated volumetric/weight delivery estimation, and real-time personal shopper substitution management.
* **My likely role/contribution:** Sole System Architect & Full-Stack Engineer (authored 468 of 469 total repository commits; designed and implemented complete backend domain logic, AI pipelines, database schemas, frontend architecture, and CI/CD pipelines).
* **Tech stack:**
  * **Backend:** PHP 8.3 / 8.4, Laravel 13 (`laravel/framework: ^13.17`), Inertia.js Laravel 3.0, Laravel Fortify (2FA), Laravel AI (`laravel/ai: ^0.11.0`), Wayfinder (`laravel/wayfinder`).
  * **Frontend:** React 19 (`react: ^19.2.0`), TypeScript 5.7, Inertia.js React 3.0, Tailwind CSS v4 (`tailwindcss: ^4.0.0`), Radix UI Primitives, Motion (Framer Motion), Leaflet / React-Leaflet, Recharts, Sonner.
  * **Database:** MySQL / SQLite, Eloquent ORM, 65 migrations, schema-level foreign key constraints and indexed status columns.
  * **Infrastructure & CI/CD:** GitHub Actions CI/CD with automated PHP 8.4 / Node 20 builds, SSH connection multiplexing (`ControlMaster`), atomic `rsync` deployments, remote index rewriting, storage symlinking.
  * **Integrations:** PayZephyr payment orchestration (Paystack API), Geoapify Routing API & Geocoder Autocomplete, Google Maps Places API, Laravel AI structured LLM agents.
* **Project scale:**
  * **201** registered HTTP routes.
  * **52** Eloquent domain models.
  * **65** database migrations and **14** seeders.
  * **30** application controllers across Storefront, Account, Settings, and Admin namespaces.
  * **353** TypeScript/React frontend files (189 `.tsx` and 164 `.ts` files, including 89 pages/fragments and 116 UI components).
  * **5** domain service classes and **2** structured AI agents.
  * **469** Git commits.

---

## 2. Engineering Metrics

### Backend / API
* **Total Routes:** 201 routes (`php artisan route:list`), separating customer storefront (`routes/web.php`), authenticated user settings (`routes/user.php`), administrative backoffice (`routes/admin.php`), and system console tasks (`routes/console.php`).
* **Controllers:** 30 controllers structured across Storefront (14), Admin Operations (13), and Profile/Security Settings (3).
* **Domain Services & AI Agents:** 5 dedicated service engines ([`RecommendationService.php`](file:///C:/laragon/www/laravel/oja-link/app/Services/RecommendationService.php), [`DeliveryEstimatorService.php`](file:///C:/laragon/www/laravel/oja-link/app/Services/DeliveryEstimatorService.php), [`DeliverySlotService.php`](file:///C:/laragon/www/laravel/oja-link/app/Services/DeliverySlotService.php), [`EstimateDistanceService.php`](file:///C:/laragon/www/laravel/oja-link/app/Services/EstimateDistanceService.php), [`WeightEstimationService.php`](file:///C:/laragon/www/laravel/oja-link/app/Services/WeightEstimationService.php)) and 2 structured output AI agents ([`RecipeExtractorAgent.php`](file:///C:/laragon/www/laravel/oja-link/app/AI/RecipeExtractorAgent.php), [`WeightEstimatorAgent.php`](file:///C:/laragon/www/laravel/oja-link/app/AI/WeightEstimatorAgent.php)).
* **Monetary Precision:** 100% integer-based currency arithmetic (storing values as `*_kobo` in database columns) to avoid IEEE 754 floating-point inaccuracies.

### Frontend
* **Codebase Volume:** 353 frontend files (189 `.tsx`, 164 `.ts`).
* **Page Views & Fragments:** 89 page views and modal fragments spanning Storefront, Customer Account Hub, Admin Backoffice, and Shopper In-Market Terminal.
* **Reusable UI Components:** 116 custom components built on Radix UI headless primitives and styled with Tailwind CSS v4.
* **Routing & Type Safety:** Type-safe Laravel routes exposed directly to React via `@laravel/vite-plugin-wayfinder`.

### Database
* **Total Models:** 52 Eloquent models encapsulating multi-tier relationships (e.g. `Product` → `ProductVariant` → `ProductVariantPrepExtra`).
* **Migrations:** 65 schema migration files establishing relational integrity, indexes, soft deletes, and polymorphic relationships.
* **Database Seeders:** 14 seeders provisioning realistic market data, delivery slots, categories, and business parameters.

### Authentication & Security
* **Multi-Guard Authentication:** Separate guards for standard customers (`web`) and administrative operators (`admin` via [`AdminAuthenticate.php`](file:///C:/laragon/www/laravel/oja-link/app/Http/Middleware/AdminAuthenticate.php)).
* **Two-Factor Authentication & Passkeys:** Fortify 2FA (TOTP authenticator app and recovery codes) paired with WebAuthn/Passkey integration (`@laravel/passkeys`).
* **Delivery PIN Verification:** Cryptographic Bcrypt verification with brute-force throttling: locks account after failed attempts with automatic time lockouts ([`OrderController.php:1240-1255`](file:///C:/laragon/www/laravel/oja-link/app/Http/Controllers/OrderController.php#L1240-L1255)).
* **Pessimistic Locking:** Database-level `lockForUpdate()` applied on payment webhook processing and point redemption transactions to eliminate race conditions.

### Integrations
* **Payments:** Multi-provider gateway routing via PayZephyr (`kendenigerian/payzephyr: ^3.0`) with automated webhook verification and signature checking.
* **Routing & Geo-Intelligence:** Geoapify Routing API with custom Haversine fallback; Geoapify Geocoder Autocomplete; Google Maps SDK.
* **AI / LLM Integration:** `laravel/ai` SDK with strict JSON schema constraints for unstructured text parsing.

### Background Jobs & Queues
* **Queued Matrix Engine:** [`BuildProductCooccurrencesJob.php`](file:///C:/laragon/www/laravel/oja-link/app/Jobs/BuildProductCooccurrencesJob.php) calculating pairwise Jaccard similarity across order histories, processed in batched chunks of 500 rows.
* **Webhook Event Listener:** [`HandlePaymentWebhook.php`](file:///C:/laragon/www/laravel/oja-link/app/Listeners/HandlePaymentWebhook.php) listening to `WebhookReceived` events.
* **Model Observers:** [`ProductReviewObserver.php`](file:///C:/laragon/www/laravel/oja-link/app/Observers/ProductReviewObserver.php) auto-recalculating rolling aggregate product ratings.

### Testing
* **Test Suite:** Pest PHP v4 (`pestphp/pest: ^4.7`) with 16 test suites covering authentication, password resets, mail rendering, admin playground endpoints, and recommendation matrix calculations ([`RecommendationEngineTest.php`](file:///C:/laragon/www/laravel/oja-link/tests/Feature/RecommendationEngineTest.php)).

### Infrastructure & Deployment
* **CI/CD Pipeline:** Dual GitHub Actions workflows (`deploy.yml`, `deploy_prod.yml`).
* **Production Deployment:** Automated SSH connection multiplexing with persistent control sockets (`ControlMaster=yes`, `ControlPersist=10m`), selective file exclusions, atomic rsync, and remote path adjustments.

---

## 3. What I Built

### 1. Recommendation Engine with Jaccard Co-Occurrence Matrix
* **What I implemented technically:** Engineered an asynchronous recommendation pipeline in [`BuildProductCooccurrencesJob.php`](file:///C:/laragon/www/laravel/oja-link/app/Jobs/BuildProductCooccurrencesJob.php) that computes bidirectional product pairs and calculates statistical Jaccard similarity indices:
  $$\text{Score} = \frac{\text{CoCount}}{\text{Count}(A) + \text{Count}(B) - \text{CoCount}}$$
  Paired this with [`RecommendationService.php`](file:///C:/laragon/www/laravel/oja-link/app/Services/RecommendationService.php), providing 4 distinct recommendation algorithms: Personalized User Recommendations (category affinity + 7-day replenishment interval candidates), Frequently Bought Together, Cart Complements (multi-product aggregation), and 30-day Sales Velocity Trending ($0.7 \times \text{SalesQty} + 0.3 \times [\text{RatingAvg} \times \log_{10}(\text{RatingCount} + 1)]$).
* **Why it mattered:** Replaced static merchandising with automated algorithmic cross-sells and replenishment reminders, increasing average order value (AOV) while caching expensive calculations in Redis/file cache for 15–60 minutes.

### 2. Volumetric Weight & Multi-Tier Delivery Fee Calculation Engine
* **What I implemented technically:** Architected [`DeliveryEstimatorService.php`](file:///C:/laragon/www/laravel/oja-link/app/Services/DeliveryEstimatorService.php) and [`WeightEstimationService.php`](file:///C:/laragon/www/laravel/oja-link/app/Services/WeightEstimationService.php). Calculates freight fees using integer kobo arithmetic: base fee + weight surcharge for kilograms exceeding an exemption threshold + zone/market surcharges + delivery tier multipliers (standard vs. express).
* **Why it mattered:** Grocery items in open markets lack barcode weights; the engine accurately prices delivery logistics for non-standard goods (e.g. bags of tubers, baskets of vegetables) before rider dispatch.

### 3. Structured LLM Agents for Local Catalog & Weight Normalization
* **What I implemented technically:** Created two specialized AI agents implementing `Laravel\Ai\Contracts\Agent` and `HasStructuredOutput`:
  1. [`RecipeExtractorAgent.php`](file:///C:/laragon/www/laravel/oja-link/app/AI/RecipeExtractorAgent.php): Ingests unstructured recipe text from blogs/notes, maps ingredients to existing database catalog IDs, identifies variants (Paint, mudu, derica, kg), and maps preparation techniques (e.g., "blended", "peeled") to `default_prep_extra_ids`.
  2. [`WeightEstimatorAgent.php`](file:///C:/laragon/www/laravel/oja-link/app/AI/WeightEstimatorAgent.php): Translates traditional African volumetric market measures (mudu, paint rubber, derica, tuber, bunch) into estimated kilogram equivalents and generates a short cargo manifest summary for delivery dispatchers.
* **Why it mattered:** Solved the unstructured data entry bottleneck, enabling 1-click recipe kit generation in the admin panel and instant logistics weight estimation for items without static catalog specs.

### 4. Resilient Hybrid Distance Estimation with Fallback Architecture
* **What I implemented technically:** Implemented [`EstimateDistanceService.php`](file:///C:/laragon/www/laravel/oja-link/app/Services/EstimateDistanceService.php), which prioritizes live turn-by-turn driving distance and ETA via Geoapify API, but automatically detects failure states (such as "unconnected regions" or network timeouts) and falls back to a mathematical Haversine spherical distance calculation scaled by an empirical $1.3\times$ urban road circuity factor and $20\text{ km/h}$ average urban driving speed.
* **Why it mattered:** Prevented checkout abandonment caused by external mapping API outages or geocoding anomalies.

### 5. In-Market Personal Shopper Terminal & Substitution Lifecycle
* **What I implemented technically:** Developed an operations terminal ([`OrderController.php:1452-1510`](file:///C:/laragon/www/laravel/oja-link/app/Http/Controllers/OrderController.php#L1452-L1510) and [`resources/js/pages/admin/shopper/`](file:///C:/laragon/www/laravel/oja-link/resources/js/pages/admin/shopper)) allowing field shoppers to flag items as in-stock, out-of-stock, or substituted. For substitutions, shoppers capture live market photos, propose replacement variants or raw market items, record price differentials, and trigger customer notification workflows.
* **Why it mattered:** Real open-air markets experience constant intra-day inventory fluctuation; this workflow provides end-to-end transparency, auditability, and financial reconciliation for items substituted in real time.

### 6. FinTech Wallet & Double-Spend Proof Loyalty Points Redemption
* **What I implemented technically:** Built an integrated ledger system in [`WalletController.php`](file:///C:/laragon/www/laravel/oja-link/app/Http/Controllers/WalletController.php) managing wallet deposits, checkout debits, and loyalty points. Handled point redemption via database transactions with `lockForUpdate()` pessimistic row locking on unused points, preventing concurrency exploits and snapshotting point-to-currency conversion rates on the redemption record for immutable financial auditing.
* **Why it mattered:** Safeguarded platform liability against race conditions during high-volume checkouts and ensured clean regulatory reconciliation.

---

## 4. Design Walkthrough

### Flow 1: Automated Recipe-to-Cart Extraction Flow
* **Path:** `User Input (Admin) → React Recipe Editor → POST admin/recipes/ai-draft → Laravel AI Agent → OpenAI / Anthropic → Structured JSON → React Form State`
* **Implementation:** The administrator pastes unformatted recipe text into the UI. [`AdminRecipeController::aiDraft`](file:///C:/laragon/www/laravel/oja-link/app/Http/Controllers/Admin/AdminRecipeController.php#L179) injects the active grocery catalog into the context of [`RecipeExtractorAgent`](file:///C:/laragon/www/laravel/oja-link/app/AI/RecipeExtractorAgent.php). The agent executes structured extraction against a strict JSON schema, resolving product IDs, variant IDs, and preparation add-on IDs. The resulting payload populates an interactive ingredient builder in React, allowing one-click publishing of recipe kits.

### Flow 2: Intelligent Weight & Delivery Fee Calculation at Checkout
* **Path:** `Cart Update → React Checkout → POST checkout/estimate-distance & fee calculation → WeightEstimationService & DeliveryEstimatorService → Geoapify Routing API / Cache → Inertia Props Update`
* **Implementation:** When customer addresses or cart items change, [`WeightEstimationService`](file:///C:/laragon/www/laravel/oja-link/app/Services/WeightEstimationService.php) calculates a unique MD5 hash of list items and quantities. If not cached, known catalog variant weights are summed and remaining items are passed to [`WeightEstimatorAgent`](file:///C:/laragon/www/laravel/oja-link/app/AI/WeightEstimatorAgent.php). The resulting weight feeds into [`DeliveryEstimatorService`](file:///C:/laragon/www/laravel/oja-link/app/Services/DeliveryEstimatorService.php), which applies base kobo rates, excess weight surcharges ($(\text{weight} - \text{exemption}) \times \text{surcharge\_per\_kg}$), market zone surcharges, and tier multipliers to render an itemized delivery breakdown.

### Flow 3: Idempotent Payment Webhook & Order State Machine
* **Path:** `Payment Provider Webhook → POST webhook/payzephyr → WebhookReceived Event → HandlePaymentWebhook Listener → DB Transaction with Lock → Order & Wallet State Update → Queued Confirmation Email`
* **Implementation:** Upon receiving a payment webhook, [`HandlePaymentWebhook`](file:///C:/laragon/www/laravel/oja-link/app/Listeners/HandlePaymentWebhook.php) queries the payment record by `gateway_reference`. It checks for existing success status (idempotency guard), re-verifies the transaction server-to-server with PayZephyr, and verifies that the reported amount matches `amount_kobo / 100`. Inside a pessimistic database lock (`lockForUpdate()`), it marks the payment successful, transitions the order from `draft_checkout` to `new`, awards loyalty cashback, deletes the temporary draft shopping list, and enqueues [`OrderConfirmedMail`](file:///C:/laragon/www/laravel/oja-link/app/Mail/OrderConfirmedMail.php).

### Flow 4: In-Market Shopper Item Substitution Flow
* **Path:** `Shopper in Market → Shopper Order Detail UI → POST shopper/orders/{order}/items/{item}/substitute → DB Transaction → OrderItem Updated & OrderItemSubstitution Created → Audit Log Recorded`
* **Implementation:** When a product is unavailable in the physical stall, the shopper submits [`shopperItemSubstitute`](file:///C:/laragon/www/laravel/oja-link/app/Http/Controllers/OrderController.php#L1452). The controller validates proposed variant IDs, item descriptions, replacement prices in kobo, and an optional image upload (saved to public storage). Within a database transaction, the `OrderItem` is updated to status `substituted`, price deltas are computed, and a permanent `OrderItemSubstitution` record is linked.

### Flow 5: Cryptographic Order Delivery Handover (Bcrypt PIN Verification)
* **Path:** `Delivery Rider at Doorstep → Shopper PIN UI → POST shopper/{order_code}/verify-pin → Hash::check vs delivery_pin_hash → Rate Limiter / Attempt Counter → Order Marked Delivered`
* **Implementation:** During checkout, a 4-digit PIN is displayed to the customer and stored only as a Bcrypt hash (`delivery_pin_hash`). At handover, the rider enters the PIN via [`verifyDeliveryPin`](file:///C:/laragon/www/laravel/oja-link/app/Http/Controllers/OrderController.php#L1232). The system checks if the order is temporarily locked (`pin_locked_until`). If invalid, it increments `pin_attempts`; upon hitting the limit, it locks verification for a designated cooldown period. If valid, the order status transitions to `delivered` and completion timestamps are logged.

### Flow 6: Concurrency-Safe Loyalty Points Redemption
* **Path:** `User Click Redeem → React Wallet View → POST account/wallet/redeem-points → WalletController::redeemPoints → DB Transaction with lockForUpdate() → WalletTransaction & PointsRedemption Created`
* **Implementation:** In [`WalletController::redeemPoints`](file:///C:/laragon/www/laravel/oja-link/app/Http/Controllers/WalletController.php#L203), all unused earned points for the user are queried and locked with `lockForUpdate()`. The controller calculates total kobo value using a system configuration rate, snapshots the valuation rate directly onto a new `PointsRedemption` row, creates a credited `WalletTransaction`, and atomically marks the source points transactions as used (`is_used = true`).

---

## 5. Engineering Decisions & Challenges

* **Financial Data Consistency:** Floating point rounding errors in JavaScript and PHP can create discrepancy bugs across multi-item grocery orders with variable tax and surcharges.
  * *Code Solution:* All monetary values across database schemas, models, and controllers are strictly represented as integers in minor currency units (`*_kobo`), converting to major units only at display boundaries.
* **External API Resilience & Latency:** Dependency on third-party routing APIs (Geoapify) risked slowing down checkout flows or blocking orders entirely when routing points were in remote or unconnected regions.
  * *Code Solution:* [`EstimateDistanceService`](file:///C:/laragon/www/laravel/oja-link/app/Services/EstimateDistanceService.php) wraps API calls in strict 8-second HTTP timeouts and provides an automatic mathematical fallback using the Haversine great-circle formula multiplied by a $1.3\times$ urban circuity factor.
* **Concurrency in Financial Operations & Webhook Re-delivery:** Payment providers frequently dispatch duplicate webhook notifications; concurrent redemption clicks could result in double-spending points.
  * *Code Solution:* Implemented early idempotency return checks combined with database row locking (`lockForUpdate()`) inside atomic database transactions across [`HandlePaymentWebhook.php`](file:///C:/laragon/www/laravel/oja-link/app/Listeners/HandlePaymentWebhook.php) and [`WalletController.php`](file:///C:/laragon/www/laravel/oja-link/app/Http/Controllers/WalletController.php).
* **LLM Output Predictability:** Standard LLM outputs can fail parsing if they return freeform conversational text instead of strict relational data.
  * *Code Solution:* Leveraged `Laravel\Ai` with JSON Schema definitions ([`RecipeExtractorAgent`](file:///C:/laragon/www/laravel/oja-link/app/AI/RecipeExtractorAgent.php), [`WeightEstimatorAgent`](file:///C:/laragon/www/laravel/oja-link/app/AI/WeightEstimatorAgent.php)) to enforce typed arrays and validate numeric fields directly at the framework level.
* **Performance of Pairwise Recommendations:** Calculating product co-occurrences across large order histories on page requests causes severe database latency.
  * *Code Solution:* Offloaded co-occurrence matrix generation to a background queue ([`BuildProductCooccurrencesJob`](file:///C:/laragon/www/laravel/oja-link/app/Jobs/BuildProductCooccurrencesJob.php)), persisted precalculated Jaccard scores to a dedicated table (`product_cooccurrences`), and cached query results in Redis/file cache with staggered TTLs (15 to 60 minutes).
* **Zero-Downtime Deployment on Constrained Shared/cPanel Hosting:** Remote hosting lacked full containerization and experienced SSH timeout drops when running heavy build scripts.
  * *Code Solution:* Configured a multi-stage GitHub Actions workflow ([`deploy_prod.yml`](file:///C:/laragon/www/laravel/oja-link/.github/workflows/deploy_prod.yml)) that compiles all assets and dependencies on Ubuntu runners, initiates a single persistent SSH master socket with multiplexing (`ControlMaster=yes`), syncs assets via atomic `rsync`, and performs remote symlinking and path rewrites.

---

## 6. Job-Application Evidence

* **Claim:** Architected and delivered an end-to-end full-stack marketplace platform from scratch, managing full lifecycle design and deployment.
  * **Evidence:** Single author of 468 of 469 repository git commits, establishing all 52 Eloquent models, 65 migrations, 201 routes, and 353 frontend TypeScript/React files.
  * **Metric:** 468 commits, 201 routes, 52 models, 65 migrations.

* **Claim:** Engineered an algorithmic recommendation engine capable of personalized suggestions, co-occurrence associations, and trending calculations.
  * **Evidence:** Implemented [`BuildProductCooccurrencesJob.php`](file:///C:/laragon/www/laravel/oja-link/app/Jobs/BuildProductCooccurrencesJob.php) and [`RecommendationService.php`](file:///C:/laragon/www/laravel/oja-link/app/Services/RecommendationService.php), computing Jaccard similarity indices, 7-day replenishment affinities, and weighted velocity scores.
  * **Metric:** 4 distinct recommendation algorithms verified by automated Pest feature tests in [`RecommendationEngineTest.php`](file:///C:/laragon/www/laravel/oja-link/tests/Feature/RecommendationEngineTest.php).

* **Claim:** Implemented AI-driven structured data extraction pipelines to solve real-world e-commerce domain challenges.
  * **Evidence:** Created [`RecipeExtractorAgent.php`](file:///C:/laragon/www/laravel/oja-link/app/AI/RecipeExtractorAgent.php) and [`WeightEstimatorAgent.php`](file:///C:/laragon/www/laravel/oja-link/app/AI/WeightEstimatorAgent.php) with structured JSON schemas, mapping non-standard informal market measurements to exact catalog variants and kilogram estimates.
  * **Metric:** 2 production LLM agents with 100% schema-enforced output validation.

* **Claim:** Designed a secure, fault-tolerant financial ledger and payment processing architecture.
  * **Evidence:** Authored [`HandlePaymentWebhook.php`](file:///C:/laragon/www/laravel/oja-link/app/Listeners/HandlePaymentWebhook.php) and [`WalletController.php`](file:///C:/laragon/www/laravel/oja-link/app/Http/Controllers/WalletController.php) with integer kobo accounting, idempotent webhook handling, and `lockForUpdate()` pessimistic locking on wallet transactions and point redemptions.
  * **Metric:** Zero floating-point monetary storage across 100% of payment and wallet database tables.

* **Claim:** Built real-time logistics and physical fulfillment tools for on-the-ground operational staff.
  * **Evidence:** Designed the personal shopper management suite in [`OrderController.php`](file:///C:/laragon/www/laravel/oja-link/app/Http/Controllers/OrderController.php) and [`resources/js/pages/admin/shopper/`](file:///C:/laragon/www/laravel/oja-link/resources/js/pages/admin/shopper), handling real-time item substitution with photo uploads, price reconciliation, and Bcrypt-verified delivery PIN handoffs with lockout limits.
  * **Metric:** Complete 4-stage fulfillment lifecycle (Picking → Substitution → Pack Verification → PIN Confirmation).

* **Claim:** Automated deployment pipelines with resilient remote synchronization.
  * **Evidence:** Configured GitHub Actions CI/CD workflows utilizing SSH connection multiplexing (`ControlMaster=yes`, `ControlPersist=10m`) to deploy compiled assets and backend code via rsync with automatic storage symlinking and path rewriting.
  * **Metric:** 2 automated deployment workflows running on every main branch push.

---

## 7. Resume-Ready Highlights

* Architected and engineered **OjaLink**, a full-stack grocery e-commerce and logistics marketplace powered by **Laravel 13**, **React 19**, **Inertia.js**, and **TypeScript**, delivering 201 API routes and 52 relational models.
* Developed an asynchronous **recommendation engine** leveraging queued Jaccard similarity co-occurrence algorithms, sales velocity calculations, and category affinity models with multi-tiered cache optimization.
* Integrated **structured AI agents** via `laravel/ai` to parse unformatted recipe text into shoppable catalog bundles and estimate kilogram weights for non-standard local market produce.
* Engineered a robust **fintech wallet and rewards subsystem** enforcing strict integer kobo accounting, idempotent payment webhook reconciliation, and pessimistic database locking (`lockForUpdate()`) to prevent race conditions.
* Implemented a specialized **in-market personal shopper suite** supporting live item substitution, photo verification, price difference calculations, and rate-limited Bcrypt-hashed delivery PIN handovers.
* Built resilient **geospatial and logistics services** utilizing Geoapify routing with automated fallback to Haversine formula calculation scaled by urban road circuity factors.
* Designed an automated **GitHub Actions CI/CD pipeline** featuring SSH socket multiplexing, optimized asset compilation, and atomic rsync deployments.

---

## Project Interview Cheat Sheet

1. **Core Problem:** Formalizes e-commerce for fragmented, open-air African grocery markets where products lack barcodes, standard packaging, and fixed weights.
2. **Commit Distribution:** Sole author of 468 out of 469 commits—architected every layer from database design to UI interaction.
3. **Monetary Architecture:** Stored exclusively in integer `*_kobo` across all models and tables to eliminate float rounding errors.
4. **Recommendation Formula:** Combines pairwise Jaccard co-occurrence scores ($\frac{\text{CoCount}}{\text{Union}}$) with a velocity score ($0.7 \times \text{SalesQty} + 0.3 \times [\text{RatingAvg} \times \log_{10}(\text{RatingCount} + 1)]$).
5. **AI Integration:** Implements `Laravel\Ai` structured agents ([`RecipeExtractorAgent`](file:///C:/laragon/www/laravel/oja-link/app/AI/RecipeExtractorAgent.php) and [`WeightEstimatorAgent`](file:///C:/laragon/www/laravel/oja-link/app/AI/WeightEstimatorAgent.php)) using explicit JSON schema output constraints.
6. **Geospatial Fallback:** Prioritizes Geoapify turn-by-turn driving API; falls back smoothly to Haversine great-circle distance $\times 1.3$ urban circuity factor on API timeout or error.
7. **Webhook Security:** Triple-checked: gateway reference verification, expected vs. received amount comparison, and pessimistic database row locking (`lockForUpdate()`).
8. **Handover Security:** 4-digit customer delivery PIN stored as a Bcrypt hash; verification endpoint tracks failed attempts and enforces timed lockouts against brute-force attacks.
9. **In-Market Substitution:** Shoppers capture photos, propose alternative catalog variants, track price adjustments, and execute database transactions directly from market stalls.
10. **Modern Tech Stack:** Laravel 13, React 19, Inertia.js 3.0, Tailwind CSS v4, TypeScript 5.7, Pest PHP 4.7, and GitHub Actions with SSH connection multiplexing.
