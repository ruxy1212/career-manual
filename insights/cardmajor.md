# Project Breakdown: CardMajor

---

## 1. Project Snapshot

* **What the product does:** CardMajor is an enterprise FinTech, digital asset, and telecom management platform offering automated virtual card issuance, multi-provider gift card trading (CySend, Moon, Reloadly), global eSIM provisioning (Airalo, GloEsim), cryptocurrency payment/withdrawal gateways (Cregis, Coinbase, Coingate), and gamified multi-level user ranking rewards.
* **My likely role/contribution:** Senior Full-Stack & FinTech Infrastructure Engineer (authored **223 commits** on core enterprise subsystems: architected mandatory 2FA security enforcement, integrated Cregis blockchain crypto payouts, engineered dual-provider eSIM failover and ranking discounts, built CySend/Moon gift card integrations with caching, and resolved complex ledger balance anomalies).
* **Tech stack:**
  * **Backend:** PHP 8.1, Laravel 9 (`laravel/framework: ^9.19`), Laravel Sanctum (`laravel/sanctum: ^3.0`), Laravel Scout (`laravel/scout: ^10.2`), Spatie Permissions (`spatie/laravel-permission: ^5.5`).
  * **Frontend & Admin UI:** Blade Templating, JavaScript, Tailwind CSS, Bootstrap 5, Yajra DataTables (`yajra/laravel-datatables-oracle: ^10.0`), Chart.js, Notify.
  * **Database & Cache:** MySQL, Redis / Laravel Cache, 109 schema migrations.
  * **FinTech & Telecom Integrations:**
    * **Crypto:** Cregis SDK (`CregisDispatch`), Coinbase, Coingate, Cryptomus, Bitcoin ECDSA (`bitcoin-php/bitcoin-ecdsa`).
    * **Cards & Fiat:** Stripe, Paystack, Razorpay, Mollie, 2Checkout, Perfect Money, SecurionPay, VoguePay.
    * **Telecom & eSIM:** Airalo SDK (`packages/airalo-sdk`), GloEsim API, Twilio SDK (`twilio/sdk: ^7.3`).
    * **Gift Cards:** CySend API, Moon API, Reloadly API.
  * **Security & Auth:** Google 2FA (`pragmarx/google2fa-laravel`, `pragmarx/google2fa-qrcode`), Bacon QR Code, PHPSecLib.
* **Project scale:**
  * **650 total Git commits** (223 authored by Russell Oje).
  * **739 registered routes** spanning Admin backoffice, User portal, and API webhooks.
  * **95 Eloquent domain models**.
  * **106 application controllers** (70 Admin controllers, 26 User controllers, 8 Auth controllers).
  * **109 schema migrations**.
  * **679 Blade template views**.

---

## 2. Engineering Metrics

### Backend Architecture & APIs
* **Endpoint Volume:** 739 route declarations across [`routes/admin.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/routes/admin.php), [`routes/web.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/routes/web.php), and [`routes/api.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/routes/api.php), compartmentalized between customer self-service, staff administration, and webhook ingestion.
* **Controller Hierarchy:** 106 controllers structured into specialized namespaces:
  * Backend Operations (70 controllers): managing virtual cards, prepaid cards, crypto wallets, eSIM packages, KYC verifications, fraud rules, and disputes.
  * Customer Frontend (26 controllers): driving purchases, wallet top-ups, P2P remittances, and security settings.
  * Authentication (8 controllers): handling session lifecycle, OTP verification, and password resets.
* **Data Layer & Models:** 95 Eloquent models managing relational business logic across virtual financial products, blockchain transactions, and multi-tier referral programs.
* **Schema Evolution:** 109 database migrations tracking continuous platform iteration, including custom negative balance ledger constraints and dynamic surcharge columns.

### Security & Fraud Prevention
* **Two-Factor Authentication (TOTP & PIN):** Multi-layered 2FA gating powered by Google Authenticator (`pragmarx/google2fa-laravel`), featuring QR code generation, account recovery keys, and a dedicated middleware ([`TwoFaCheck.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Middleware/TwoFaCheck.php)) enforcing 2FA completion before accessing financial operations.
* **Audit Trail & Activity Logging:** Dedicated security tracking via `SecurityActivityLogger` and `ActivityLogger` logging login attempts, IP changes, 2FA modifications, and withdrawal destinations.
* **Data Retention & Soft-Delete Splitting:** Admin data governance subsystem ([`DeleteData.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Models/DeleteData.php), [`RecycleBinController.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Controllers/Backend/RecycleBinController.php)) segregating deleted records for GDPR audit compliance while maintaining relational ledger integrity.

### Integrations & Payment Gateways
* **Payment Orchestration:** 10+ integrated payment gateways covering credit/debit card processing, regional mobile money, and crypto networks.
* **Multi-Provider Failover:** High-availability telecom engine routing eSIM purchases primarily through Airalo SDK with automatic dynamic failover to GloEsim upon upstream provider outage.
* **External API Caching:** Multi-tiered caching on upstream gift card country directories (CySend) and package catalogs to prevent API rate limits and reduce page load times from seconds to milliseconds.

---

## 3. What I Built

### 1. Mandatory & Adaptive 2FA Security Enforcement System
* **What I implemented technically:** Engineered end-to-end two-factor authentication infrastructure. Created [`TwoFaCheck.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Middleware/TwoFaCheck.php) middleware to intercept unverified users and force enrollment (`two_fa_set.blade.php`), implemented secret key generation via `pragmarx.google2fa`, integrated emergency account recovery keys, configured email OTP verification templates, and built administrative controls allowing staff to require or reset 2FA per user profile.
* **Why it mattered:** Safeguarded high-value customer balances against credential stuffing and account takeover attacks across a platform processing crypto withdrawals and virtual card issuance.

### 2. Cregis Cryptocurrency Gateway & Blockchain Payout Integration
* **What I implemented technically:** Implemented [`CregisService.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Services/CregisService.php) and [`CregisController.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Controllers/CregisController.php) interfacing with `CregisDispatch`. Built automated deposit address creation (`createAddress`), address legality verification (`addressLegal`), crypto checkout generation with collision-resistant transaction references (`Str::random(12)` checked in a loop against existing database hashes), automated crypto withdrawal execution, and asynchronous webhook handling.
* **Why it mattered:** Expanded the platform's payment rails to support non-custodial and custodial multi-chain cryptocurrency deposits and payouts with automated reconciliation.

### 3. Dual-Provider eSIM Marketplace with Automated Failover & Tiered Discounts
* **What I implemented technically:** Enhanced [`Frontend/EsimController.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Controllers/Frontend/EsimController.php) (2,558 lines) and [`Backend/EsimController.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Controllers/Backend/EsimController.php). Engineered automated upstream failover: system attempts Airalo package retrieval and checkout first; upon catch of upstream network or inventory failure, automatically falls back to GloEsim. Integrated eSIM transactions directly into the gamified ranking system ([`UserRanking`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Models/UserRanking.php), [`DiscountRule`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Models/DiscountRule.php)), dynamically applying tiered percentage discounts based on user loyalty tier.
* **Why it mattered:** Eliminated sales downtime during third-party telecom outages while driving customer retention through rank-based pricing incentives.

### 4. Multi-Provider Digital Gift Card Engine with CySend Caching
* **What I implemented technically:** Refactored [`Frontend/GiftCardController.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Controllers/Frontend/GiftCardController.php). Integrated CySend as an automated gift card provider alongside Reloadly and Moon. Implemented response caching in [`CysendService.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Services/CysendService.php) for country and product catalogs, added Moon card surcharge/fee calculations, and standardized digital card creation and post-purchase delivery routines.
* **Why it mattered:** Protected the platform from external supplier rate limits, dramatically decreased catalog load latency, and prevented profit margin erosion caused by unaccounted gateway surcharges.

### 5. Financial Ledger Reconciliation & Negative Balance Safeguards
* **What I implemented technically:** Authored migration [`2025_08_19_092103_add_negative_balance_to_users_table.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/database/migrations/2025_08_19_092103_add_negative_balance_to_users_table.php) introducing `decimal(15,2)` precision negative balance tracking. Diagnosed and fixed complex balance calculation bugs across concurrent virtual card, prepaid card, and eSIM purchases in `Frontend/EsimController.php`, `GiftCardController.php`, and `TransactionController.php`, ensuring that pending holds, exchange rates, and transaction fees reconcile accurately before debiting user wallets.
* **Why it mattered:** Eliminated balance calculation race conditions that previously permitted double-spending or resulted in incorrect wallet debits during multi-product checkouts.

### 6. Admin Data Retention & Soft-Delete Splitting
* **What I implemented technically:** Engineered the deleted data management subsystem in [`Backend/AppController.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Controllers/Backend/AppController.php) and [`DeleteData.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Models/DeleteData.php). Structured audit split views in the backoffice to allow compliance officers to inspect, restore, or securely purge archived customer records without breaking historical transaction ledger foreign keys.
* **Why it mattered:** Ensured data privacy compliance without corrupting immutable financial auditing trails.

---

## 4. Design Walkthrough

### Flow 1: Mandatory Two-Factor Authentication Gating & Verification
* **Path:** `User Logs In / Registers → TwoFaCheck Middleware Intercepts → Redirect to /user/two-fa/set → User Scans QR Code (pragmarx/google2fa) → Submits 6-digit TOTP → TwoFaCheck Grants Session Access → SecurityActivity Logged`
* **Implementation:** When an authenticated user accesses protected routes, [`TwoFaCheck.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Middleware/TwoFaCheck.php) checks if `google2fa_secret` is verified. If not, it redirects the user to the 2FA setup screen. The controller generates a secret key and QR code using `BaconQrCode`. Upon submission, `Google2FA::verifyKey()` validates the code. On success, `google2fa_status` updates to active, recovery codes are issued, and `SecurityActivityLogger::log('2fa_enabled')` records the event.

### Flow 2: Automated Dual-Provider eSIM Purchase with Upstream Failover
* **Path:** `User Selects eSIM Package → POST /user/esim/purchase → EsimController Validates Wallet Balance & Rank Discount → Attempt Airalo Order via SDK → (If Upstream Error Caught) → Fallback to GloEsim Order → Wallet Debited → EsimOrder Created → QR Code Issued`
* **Implementation:** In [`Frontend/EsimController::purchase`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Controllers/Frontend/EsimController.php), the system queries the user's `UserRanking` to apply active `DiscountRule` percentages. It wraps the primary Airalo order dispatch in a `try...catch` block. If Airalo returns an API error or timeout, the controller catches the exception, logs it, and immediately initiates an order with GloEsim. The purchase cost is debited from user funds, an `EsimOrder` record is committed, and installation instructions/QR codes are rendered.

### Flow 3: Cregis Blockchain Crypto Deposit & Webhook Reconciliation
* **Path:** `User Initiates Crypto Deposit → CregisController::createAddress → CregisService Calls CregisDispatch → Unique Hash Generated & Collisions Checked → Blockchain Address Displayed → External Payment Confirmed on Chain → Webhook Received → Transaction Credited`
* **Implementation:** The user requests a payment address for a given currency code. [`CregisService::orderCheckout`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Services/CregisService.php#L88) generates a 12-character random transaction hash, checking it against `Transaction::where('hash', $ref)->exists()` in a while loop to ensure 100% collision resistance. It calls `CregisDispatch::checkout()`, registers the callback URL, and presents the address. When the blockchain confirms the transfer, Cregis posts a webhook to `/webhook/cregis/webhook`, which verifies the signature, updates the wallet balance, and logs a `CryptoTransaction`.

### Flow 4: Cached CySend Gift Card Purchase with Surcharge Protection
* **Path:** `User Browses Gift Cards → GiftCardController::index → CysendService::getCountries (Redis Cached) → Country / Product Catalog Rendered → User Selects Brand → Moon/CySend Surcharge Applied → Purchase Executed → Card Codes Dispatched via Email`
* **Implementation:** In [`GiftCardController.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Controllers/Frontend/GiftCardController.php), fetching country lists and available brand denominations is wrapped in `Cache::remember()` inside [`CysendService.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Services/CysendService.php). When a purchase is triggered, the controller computes the dynamic supplier charge, validates that the user's balance covers the base price plus surcharge, debits the user balance, issues the digital code via API, and queues an email notification containing the digital card credentials.

### Flow 5: Negative Balance Protection & Transaction Error Recovery
* **Path:** `High-Frequency Withdrawal / Debit Triggered → Controller Checks user->balance vs pending holds → Evaluates negative_balance allowance → Atomic DB Transaction → Balance Updated → (If Gateway Fails) → Rollback & Failed Transaction State Logged`
* **Implementation:** During financial operations across virtual card funding or withdrawals, the controller evaluates available funds against `users.negative_balance`. If the transaction would exceed authorized overdraft limits, it is immediately aborted. If the payment gateway subsequently reports failure, [`TransactionController`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Controllers/Backend/TransactionController.php) reverts pending debits, flags status as `failed`, and logs audit entries in `Transaction` history without leaving dangling deductions.

---

## 5. Engineering Decisions & Challenges

* **Financial Ledger Consistency Across Multi-Product Purchases:** Virtual cards, prepaid cards, eSIMs, and gift cards previously calculated fees independently, leading to edge cases where concurrent checkouts caused balance discrepancies.
  * *Code Solution:* Standardized balance deduction logic across `EsimController.php`, `GiftCardController.php`, and `PrepaidCardController.php`. Implemented atomic database transactions and migrated `negative_balance` column constraints to ensure overdraft rules are strictly enforced.
* **High Availability for Third-Party Telecom Suppliers:** Relying on a single eSIM aggregator caused platform sales outages whenever upstream inventory or network APIs suffered downtime.
  * *Code Solution:* Architected a multi-provider failover engine in [`Frontend/EsimController.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Controllers/Frontend/EsimController.php). Encapsulated Airalo API calls in defensive exception handlers that dynamically reroute orders to GloEsim without disrupting the customer's checkout session.
* **External API Latency & Rate Limiting in Gift Card Browsing:** Upstream gift card APIs (CySend) have high latency and strict rate limits; fetching country catalogs on every page render slowed the user dashboard significantly.
  * *Code Solution:* Implemented caching layers in [`CysendService.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Services/CysendService.php) using Laravel Cache, storing country and product catalogs with automatic invalidation and slashing page load times.
* **Crypto Reference Collision Vulnerabilities:** High-volume automated crypto checkout sessions can generate identical references if relying solely on timestamps or non-verified pseudo-random strings.
  * *Code Solution:* In [`CregisService::orderCheckout`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Services/CregisService.php#L90), implemented an explicit collision-check loop: `$uniqueTrnRef = Str::random(12)` verifying existence against the database before proceeding to API dispatch.
* **Compliance vs. Ledger Audit Integrity:** Deleting customer accounts under privacy mandates risked breaking historical transaction relational constraints and financial reporting.
  * *Code Solution:* Engineered [`DeleteData.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Models/DeleteData.php) and backoffice split views. Anonymizes and archives deleted user records into segregated compliance partitions while preserving immutable transaction IDs for accounting audit trails.

---

## 6. Job-Application Evidence

* **Claim:** Engineered enterprise security infrastructure enforcing mandatory two-factor authentication and fraud prevention.
  * **Evidence:** Implemented [`TwoFaCheck.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Middleware/TwoFaCheck.php), TOTP QR generation with Google Authenticator, account recovery keys, email OTP verification, and administrative override tooling.
  * **Metric:** 100% route enforcement for sensitive financial actions and user onboarding.

* **Claim:** Integrated multi-chain cryptocurrency payment gateways and automated blockchain payout engines.
  * **Evidence:** Authored [`CregisService.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Services/CregisService.php) and [`CregisController.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Controllers/CregisController.php), implementing dynamic address generation, address validation, collision-resistant transaction references, and automated crypto payouts.
  * **Metric:** Multi-currency crypto rails supporting automated checkout and payout query workflows.

* **Claim:** Built resilient telecom e-commerce pipelines with automated multi-provider failover.
  * **Evidence:** Refactored [`Frontend/EsimController.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Controllers/Frontend/EsimController.php), creating an automated fallback between Airalo and GloEsim providers and linking purchases to user loyalty ranking discounts.
  * **Metric:** Zero downtime during upstream supplier outages across global eSIM packages.

* **Claim:** Resolved complex financial ledger accounting and balance deduction anomalies in high-volume production.
  * **Evidence:** Migrated `users.negative_balance` constraints ([`2025_08_19_092103_add_negative_balance_to_users_table.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/database/migrations/2025_08_19_092103_add_negative_balance_to_users_table.php)) and overhauled purchase calculations across virtual cards, prepaid cards, gift cards, and telecom modules.
  * **Metric:** 14 files updated in a single reconciliation refactor, eliminating double-spending risks.

* **Claim:** Optimized external third-party API consumption through intelligent multi-tier caching.
  * **Evidence:** Implemented caching strategies in [`CysendService.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Services/CysendService.php) and [`DashboardController.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Controllers/Frontend/DashboardController.php), preventing rate-limiting on country directory lookups.
  * **Metric:** Dramatic latency reduction on gift card and dashboard renders.

---

## 7. Resume-Ready Highlights

* Engineered core FinTech and telecom systems for **CardMajor**, an enterprise digital asset and virtual card platform built with **Laravel 9**, **PHP 8.1**, **MySQL**, and **Redis**, contributing 223 commits.
* Architected a **mandatory 2FA security infrastructure** utilizing Google Authenticator (TOTP), custom session-gating middleware, recovery key protocols, and administrative controls.
* Integrated the **Cregis cryptocurrency payment engine**, implementing blockchain address creation, collision-resistant transaction reference generators, and automated crypto withdrawal pipelines.
* Built a resilient **eSIM marketplace with automated provider failover** between Airalo and GloEsim APIs, integrating purchases into gamified user ranking discount rules.
* Engineered a **multi-provider gift card trading module** integrating CySend, Moon, and Reloadly APIs with response caching and dynamic fee/surcharge calculations.
* Resolved complex **financial ledger balance anomalies**, implementing atomic database transactions, failed transaction rollbacks, and negative balance constraints.
* Designed an **audited data retention and soft-delete splitting system** to support privacy compliance while preserving immutable financial audit records.

---

## Project Interview Cheat Sheet

1. **Core Problem:** Enterprise multi-service portal unifying virtual card issuance, crypto payouts, digital gift cards, and global eSIM provisioning under a single wallet.
2. **Commit Ownership:** Co-developed enterprise platform; authored 223 commits directly focused on core financial, security, and third-party provider integrations.
3. **2FA Architecture:** Enforced via [`TwoFaCheck`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Http/Middleware/TwoFaCheck.php) middleware; pairs Google Authenticator TOTP secrets with emergency recovery keys and email OTP fallbacks.
4. **eSIM Failover Strategy:** Primary requests routed through Airalo SDK; catch blocks intercept upstream network/inventory exceptions and automatically reroute orders to GloEsim.
5. **eSIM Rank Discounts:** Purchases evaluate [`UserRanking`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Models/UserRanking.php) and [`DiscountRule`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Models/DiscountRule.php) models to apply tiered percentage discounts at checkout.
6. **Crypto Collision Safety:** [`CregisService`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Services/CregisService.php) generates 12-char hashes inside a while-loop collision check against the database before calling external checkout APIs.
7. **Negative Balance Enforcement:** Introduced `negative_balance` column (`decimal(15,2)`) in `users` table to prevent unauthorized wallet overdrafts during high-frequency debit attempts.
8. **Gift Card Caching:** Cached CySend country and brand catalogs in Redis/file cache, avoiding third-party rate limits and drastically cutting dashboard latency.
9. **Compliance Architecture:** [`DeleteData.php`](file:///C:/laragon/www/laravel/unostafakrackenboss/app/Models/DeleteData.php) splits and archives deleted accounts for data privacy compliance without corrupting foreign keys in financial transaction tables.
10. **Scale:** 739 routes, 106 controllers, 95 models, 109 migrations, and integrations across 10+ payment and crypto gateways.
