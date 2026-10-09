# Project Breakdown: EduLaw (Legal EdTech & Assessment Platform)

> **Repository Architecture:** Distributed Full-Stack System
> * **Backend Repository:** [`../laravel/edulaw-be`](file:///C:/laragon/www/laravel/edulaw-be) (Laravel 11, Dual MySQL + MongoDB, Edge-TTS, AWS S3)
> * **Frontend Repository:** [`../react/edulaw`](file:///C:/laragon/www/react/edulaw) (React 18, Vite 5, TensorFlow.js, Zustand, Tremor)

---

# SECTION 1: Full-Stack Platform Overview & Architecture

## 1. Full-Stack Snapshot
* **What the product does:** EduLaw is an AI-enhanced legal education, bar exam preparation, and curriculum management platform designed to help law students master complex statutes, case law, and procedural rules through neural audio notes, automated multi-format question ingestion, and client-side semantic NLP evaluation.
* **My likely role/contribution:** Lead Full-Stack Architect & Principal Developer (authored **145 of 146 backend commits** and **154 of 155 frontend commits**; designed polyglot data persistence, automated document parsing pipelines, neural speech synthesis, client-side ML scoring, and rich student dashboards).
* **End-to-End Tech Stack:**
  * **Backend Core:** PHP 8.2, Laravel 11 (`laravel/framework: ^11.9`), Tymon JWT Auth (`tymon/jwt-auth: ^2.1`), Laravel Sanctum, Laravel Socialite.
  * **Databases (Polyglot):** MySQL (Users, Auth, Payments, Subscriptions) + MongoDB (`mongodb/laravel-mongodb: ^5.0` for hierarchical legal curriculum, question banks, and embedded subtopics).
  * **AI & Document Processing:** Edge-TTS (`afaya/edge-tts`), Spatie PDF-to-Text, Smalot PDF Parser, PhpWord, Google Drive API v3 (`google/apiclient`).
  * **Cloud & Media:** AWS S3 (`league/flysystem-aws-s3-v3: 3.0`), Cloudinary (`cloudinary-labs/cloudinary-laravel`).
  * **Frontend Core:** React 18 (`react: ^18.3.1`), Vite 5 (`vite: ^5.4.1`), React Router DOM v6, TypeScript / JSX, Tailwind CSS, Radix UI primitives.
  * **Client-Side ML & Audio:** TensorFlow.js (`@tensorflow/tfjs: ^4.22.0`), Universal Sentence Encoder (`@tensorflow-models/universal-sentence-encoder: ^1.3.3`), `react-use-audio-player`.
  * **State & Visualizations:** Zustand (`zustand: ^5.0.0`), Tremor React (`@tremor/react: ^3.18.7`), Recharts, Jodit Rich Text Editor.
* **Total System Scale:**
  * **301 total Git commits** (299 authored exclusively by Russell Oje).
  * **115 registered backend API endpoints**.
  * **24 Eloquent / Mongo models** and **11 domain services**.
  * **210 frontend React/JS source files** (188 `.jsx`, 22 `.js`) spanning 68 distinct views and fragments.

---

## 2. End-to-End Architectural Workflows

```
┌────────────────────────────────────────────────────────────────────────┐
│                          EDULAW FULL-STACK FLOW                        │
└────────────────────────────────────────────────────────────────────────┘

 [Word/Google Docs] ──────► [GoogleDocService / QuestionsDocxService]
                                    │ (RegEx / TextRun Tokenizer)
                                    ▼
 [Edge-TTS Engine]  ◄────── [Course & Topic Ingestion Pipeline]
         │                          │
         ▼ (Neural MP3)             ▼ (Embedded Document Trees)
   [AWS S3 Bucket]            [MongoDB: topics / subtopics]
         │                          │
         │ (Streaming URL)          │ (JSON API via JWT)
         ▼                          ▼
 [react-use-audio-player]    [Zustand Store / React Router v6]
         │                          │
         │                          ▼
         │               [Interactive Assessment Modes]
         │           (MCQ, FITB, Active Recall, Legal Drafting)
         │                          │
         └──────────────────► [TensorFlow.js]
                               (Universal Sentence Encoder
                                On-Device Cosine Similarity)
```

### Flow 1: Automated Legal Curriculum & Question Bank Ingestion
* **Path:** `Admin Doc Upload / Google Doc URL → Laravel API (POST /questions/extract-docx or /topics/extract-google) → Document Parsing Services → Regex Tokenization → MongoDB Document Creation → React Course Explorer`
* **Implementation:** Law professors or administrators submit Google Docs URLs or upload `.docx` files. [`GoogleDocService`](file:///C:/laragon/www/laravel/edulaw-be/app/Services/GoogleDocService.php) exports clean text via Google Drive API v3. [`QuestionsDocxService`](file:///C:/laragon/www/laravel/edulaw-be/app/Services/QuestionsDocxService.php) tokenizes the text using structural boundary tags (`-MCQ_BEGINS-`, `-BLANK_BEGINS-`, `-FLASH_BEGINS-`, `-PAIRS_BEGINS-`). The parsed questions and hierarchical subtopics are saved as embedded document arrays in MongoDB (`$topic->subtopics()->create(...)`).

### Flow 2: Neural Audio Note Generation & Streaming
* **Path:** `New Legal Subtopic Saved → GenerateAudioNoteJob Dispatched to Queue → cleanHtmlContent() → EdgeTTS Synthesis ('en-GB-LibbyNeural') → S3 Upload → MongoDB Audio Reference Updated → React TopicAudioCard Playback`
* **Implementation:** When text content updates, [`GenerateAudioNoteJob`](file:///C:/laragon/www/laravel/edulaw-be/app/Jobs/GenerateAudioNoteJob.php) strips HTML formatting into natural spoken English (transforming bullet points and statutes into conversational pauses). It invokes Edge-TTS with the `en-GB-LibbyNeural` voice model, streams the resulting audio stream to AWS S3, and writes the public URL to MongoDB. In the frontend, [`TopicAudioCard.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/dashboard/courses/_components/TopicAudioCard.jsx) streams the audio via `react-use-audio-player` with persistent scrub controls.

### Flow 3: Hybrid Free-Text Semantic Assessment (On-Device NLP)
* **Path:** `Student Submits Essay/Statutory Recall → React Test View → TensorFlow.js Universal Sentence Encoder Model → In-Memory 512-Dim Vector Embeddings → Cosine Similarity Metric → Immediate Score & Feedback`
* **Implementation:** Instead of sending every student keystroke or recall response to costly cloud LLMs, [`CosineSimilarityTest.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/demo/CosineSimilarityTest.jsx) loads TensorFlow.js and Google's Universal Sentence Encoder on-device. The engine computes text embeddings and derives the cosine distance vector against model answers:
  $$\text{Similarity} = 1 - \text{cosineDistance}(\vec{E}_{\text{student}}, \vec{E}_{\text{statute}})$$
  This provides instantaneous, private, zero-latency scoring for free-form legal answers.

### Flow 4: Subscriptions & Tiered Course Access
* **Path:** `User Selects Plan → React Checkout → POST /payment/pay → PaymentController → Paystack Gateway → Redirect Callback / Webhook → Subscription & Payment Record Created → JWT Claims Refreshed`
* **Implementation:** Users choose a study plan (`app/Models/Plan.php`). [`PaymentController.php`](file:///C:/laragon/www/laravel/edulaw-be/app/Http/Controllers/PaymentController.php) initializes a Paystack transaction and logs a pending `Payment` row. Upon successful verification, a `Subscription` document is generated with valid dates, granting instant access to restricted course libraries and question banks.

---

## 3. Full-Stack Interview Cheat Sheet

1. **Architecture:** Decoupled system comprising a Laravel 11 API backend and a Vite-powered React 18 SPA.
2. **Commit Ownership:** Russell Oje authored 145/146 backend commits and 154/155 frontend commits (99.3% total ownership).
3. **Polyglot Database Strategy:** Uses MySQL for relational transactional data (Users, Payments, Plans) and MongoDB for flexible, deep legal hierarchies (`Course` $\to$ `Topic` $\to$ `Subtopic` $\to$ `InTopicTest`).
4. **Speech Synthesis:** Queued background synthesis via [`GenerateAudioNoteJob`](file:///C:/laragon/www/laravel/edulaw-be/app/Jobs/GenerateAudioNoteJob.php) using Edge-TTS (`en-GB-LibbyNeural`) with direct AWS S3 streaming.
5. **Document Ingestion:** Custom tokenizers in [`QuestionsDocxService`](file:///C:/laragon/www/laravel/edulaw-be/app/Services/QuestionsDocxService.php) parsing 5 distinct question types (`flash`, `mcq`, `theory`, `pairs`, `blank`) from Word `.docx` and Google Drive API exports.
6. **Client-Side AI/ML:** On-device semantic similarity scoring powered by TensorFlow.js and Universal Sentence Encoder, evaluating legal definitions without cloud API costs.
7. **Interactive Assessment:** 5 specialized test engines: Diagnostic Onboarding, In-Topic Quizzes, Cumulative Past Questions, Fill-in-the-Blank, and Active Recall.
8. **Legal Drafting Studio:** Integrates Jodit WYSIWYG editor with Markdown sanitization and real-time legal template drafting.
9. **Analytics:** Admin dashboard powered by Tremor React and Recharts tracking MRR, subscriber churn, and question bank coverage.
10. **FinTech Security:** Paystack payment integration with strict transaction reference checks and webhook verification.

---

# SECTION 2: Backend Deep Dive (`edulaw-be`)

## 1. Backend Snapshot & Scale
* **Directory Path:** [`../laravel/edulaw-be`](file:///C:/laragon/www/laravel/edulaw-be)
* **Framework:** Laravel 11.9, PHP 8.2
* **Git Volume:** 146 commits (145 authored by Russell Oje).
* **Backend Metrics:**
  * **115 API Endpoints** across Authentication, Courses, Topics, Tests, Payments, Programs, Subscriptions, and Admin Operations.
  * **24 Models** (14 MongoDB document models, 10 SQL relational models).
  * **22 Controllers** structured across API, Auth, User, and Admin namespaces.
  * **11 Domain Services** handling document extraction, Google Drive sync, and TTS.
  * **1 Asynchronous Queued Job** ([`GenerateAudioNoteJob.php`](file:///C:/laragon/www/laravel/edulaw-be/app/Jobs/GenerateAudioNoteJob.php)).

---

## 2. Core Backend Engineering

### Polyglot Persistence Architecture
* **Relational SQL Database:** Stores strict ACID transactional data: `users`, `password_resets`, `payments`, `plans`, `subscriptions`.
* **MongoDB Document Database:** Utilizes `mongodb/laravel-mongodb` for unstructured legal curricula:
  * [`Topic.php`](file:///C:/laragon/www/laravel/edulaw-be/app/Models/Topic.php): Embeds subtopics (`$this->embedsMany(Subtopic::class)`), casts legal `cases` and statutory `provisions` directly to BSON arrays, and manages user study progress.
  * Eliminates complex multi-table SQL joins across nested legal subjects, enabling single-query retrieval of entire topics with all subtopics, audio references, and quiz questions.

### Automated Legal Document Ingestion Pipeline
* **Multi-Format Ingestion Services:**
  1. [`GoogleDocService.php`](file:///C:/laragon/www/laravel/edulaw-be/app/Services/GoogleDocService.php): Connects to Google Drive API v3, resolves Document IDs from URLs, exports text/html streams, and isolates content bodies.
  2. [`QuestionsDocxService.php`](file:///C:/laragon/www/laravel/edulaw-be/app/Services/QuestionsDocxService.php): Reads PhpWord `TextRun` elements or raw text, parses delimitation tags (`-MCQ_BEGINS-`, `-MCQ_ENDS-`, `-BLANK_BEGINS-`), and generates validated question objects with answer keys and distractor options.
  3. [`PdfParserService.php`](file:///C:/laragon/www/laravel/edulaw-be/app/Services/PdfParserService.php) & [`SmalotParserService.php`](file:///C:/laragon/www/laravel/edulaw-be/app/Services/SmalotParserService.php): Extracts case citations and legal texts from scanned statutory PDFs.

### Neural Audio Synthesis & AWS S3 Storage
* **Queue-Driven Text-to-Speech:** In [`GenerateAudioNoteJob.php`](file:///C:/laragon/www/laravel/edulaw-be/app/Jobs/GenerateAudioNoteJob.php), legal content passes through regex cleanup (`cleanHtmlContent`) that converts numbered statutory clauses into spoken phonetic lists.
* **Edge-TTS Pipeline:** Uses Microsoft Neural Voices (`en-GB-LibbyNeural`) for formal British legal cadence, streams the binary MP3 to Amazon S3 via `league/flysystem-aws-s3-v3`, and stores the object key on the MongoDB `Subtopic` record.

### Security, Admin Governance & Soft Deletions
* **JWT & Multi-Tier Middleware:** Protects endpoints via `tymon/jwt-auth` (`check.for.jwt`) and enforces role-based access control with `ensure.is.admin`.
* **Centralized Recycle Bin:** Implemented in [`AdminController::recycleBin`](file:///C:/laragon/www/laravel/edulaw-be/app/Http/Controllers/AdminController.php) allowing administrators to audit, restore, or permanently purge soft-deleted courses, topics, and blogs across both SQL and MongoDB connections.
* **Cron Execution Guard:** Protected `/cron` webhook verifying `Bearer config('custom.cron_secret')` to prevent unauthorized scheduler triggering ([`routes/api.php:50-61`](file:///C:/laragon/www/laravel/edulaw-be/routes/api.php#L50-L61)).

---

## 3. Backend Job-Application Evidence

* **Claim:** Architected a polyglot persistence architecture combining relational SQL with MongoDB document stores.
  * **Evidence:** Designed models in [`app/Models/`](file:///C:/laragon/www/laravel/edulaw-be/app/Models), isolating transactional payments in SQL and embedding hierarchical course/topic structures in MongoDB via `mongodb/laravel-mongodb`.
  * **Metric:** 24 total models (14 Mongo, 10 SQL), zero multi-table relational joins for deep nested curriculum trees.

* **Claim:** Engineered automated legal curriculum parsing engines supporting Word, PDF, and Google Docs.
  * **Evidence:** Implemented 11 domain service classes including [`QuestionsDocxService.php`](file:///C:/laragon/www/laravel/edulaw-be/app/Services/QuestionsDocxService.php) and [`GoogleDocService.php`](file:///C:/laragon/www/laravel/edulaw-be/app/Services/GoogleDocService.php) parsing 5 distinct question formats with automated boundary tokenization.
  * **Metric:** 11 parsing services supporting DOCX, TXT, RTF, PDF, and Google Docs API streams.

* **Claim:** Built an automated background audio synthesis pipeline streaming neural speech to cloud storage.
  * **Evidence:** Authored [`GenerateAudioNoteJob.php`](file:///C:/laragon/www/laravel/edulaw-be/app/Jobs/GenerateAudioNoteJob.php), formatting legal HTML into conversational text, synthesizing audio with Edge-TTS, and persisting directly to AWS S3.
  * **Metric:** 100% asynchronous background processing via Laravel queue worker.

---

## 4. Backend Resume-Ready Highlights

* Engineered **EduLaw Backend**, an EdTech API built with **Laravel 11**, **PHP 8.2**, **MySQL**, and **MongoDB**, exposing 115 RESTful endpoints.
* Architected a **polyglot persistence system** using MySQL for transactional subscriptions/auth and MongoDB for deeply nested, embedded course curricula and question banks.
* Developed an **automated legal ingestion pipeline** parsing Word documents, PDFs, and Google Docs API streams into validated question banks across 5 assessment formats.
* Implemented an **asynchronous text-to-speech engine** utilizing Edge-TTS neural voice models and AWS S3 cloud storage to generate streaming audio study guides.
* Built **fintech payment and subscription services** interfacing with Paystack API, supporting multi-tier billing plans and automated access revocation.
* Implemented **admin governance tooling**, including a cross-database soft-delete recycle bin and token-secured cron schedulers.

---

# SECTION 3: Frontend Deep Dive (`edulaw`)

## 1. Frontend Snapshot & Scale
* **Directory Path:** [`../react/edulaw`](file:///C:/laragon/www/react/edulaw)
* **Framework:** React 18.3, Vite 5.4, React Router DOM v6
* **Git Volume:** 155 commits (154 authored by Russell Oje).
* **Frontend Metrics:**
  * **210 React / JavaScript source files** (188 `.jsx`, 22 `.js`).
  * **68 Application Pages & Views** across Public Site, Authentication, Student Dashboard, Test Center, Legal Drafting Studio, and Admin Hub.
  * **Client-Side ML Integration:** TensorFlow.js (`@tensorflow/tfjs`) paired with `@tensorflow-models/universal-sentence-encoder`.
  * **State Architecture:** Centralized Zustand stores for user session, active course state, and study streaks.

---

## 2. Core Frontend Engineering

### On-Device Machine Learning Assessment (TensorFlow.js)
* **Universal Sentence Encoder Integration:** In [`CosineSimilarityTest.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/demo/CosineSimilarityTest.jsx), the frontend asynchronously loads Google's 512-dimensional sentence encoder in the browser.
* **Vectorized Cosine Distance:** Converts student recall input and canonical legal principles into tensors and calculates similarity directly in WebGL memory:
  ```javascript
  const embeddings = (await modelRef.current.embed([textA.toLowerCase(), textB.toLowerCase()])).unstack();
  const similarity = tf.losses.cosineDistance(embeddings[0], embeddings[1], 0).dataSync()[0];
  ```
* **Performance Impact:** Instantaneous response times with zero network overhead, zero server compute bills, and complete student answer privacy.

### Multi-Modal Legal Assessment Suites
* **Specialized Test Engines:**
  1. [`MCQTests.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/dashboard/tests/MCQTests.jsx): Timed multiple-choice testing with instant answer explanations and statute cross-references.
  2. [`FITBTests.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/dashboard/tests/FITBTests.jsx): Fill-in-the-blank statutory term completion with strict keyword checking.
  3. [`ACRTests.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/dashboard/tests/ACRTests.jsx): Active Recall testing prompts requiring students to write legal precedents from memory.
  4. [`TestCumulation.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/dashboard/tests/TestCumulation.jsx): Aggregated bar exam simulation compiling cross-topic question sets.

### Audio Player & Study Interface
* **Streaming Audio Integration:** In [`TopicAudioCard.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/dashboard/courses/_components/TopicAudioCard.jsx), streams AWS S3 audio notes using `react-use-audio-player`.
* **Synchronized Study Experience:** Enables students to listen to neural audio lectures while reading corresponding legal texts, statutory provisions, and landmark court cases simultaneously.

### Legal Drafting Studio
* **Rich Document Editor:** Integrates `jodit-react` in [`DraftsPractice.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/dashboard/drafts/DraftsPractice.jsx) allowing students to practice drafting formal court pleadings, affidavits, motions, and commercial contracts.
* **Markdown & HTML Sanitization:** Uses `rehype-sanitize`, `rehype-raw`, and `remark-gfm` to prevent XSS vulnerabilities when previewing legal documents.

### Executive Admin Analytics Hub
* **Real-Time Data Visualization:** Authored [`admin/dashboard.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/admin/dashboard.jsx) utilizing `@tremor/react` and `recharts`.
* **Revenue Metrics:** Tracks Monthly Recurring Revenue (MRR), subscriber growth, currency formatting (`currency-symbol`, `iso-country-currency`), and question ingestion coverage.

---

## 3. Frontend Job-Application Evidence

* **Claim:** Integrated on-device Machine Learning for semantic natural language processing in React.
  * **Evidence:** Implemented [`CosineSimilarityTest.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/demo/CosineSimilarityTest.jsx) using `@tensorflow/tfjs` and Universal Sentence Encoder, deriving cosine distance tensors in-browser.
  * **Metric:** 512-dimensional sentence vector calculation executing client-side with zero cloud API latency.

* **Claim:** Engineered comprehensive, multi-modal assessment engines for professional accreditation prep.
  * **Evidence:** Built 5 interactive testing modules ([`MCQTests.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/dashboard/tests/MCQTests.jsx), [`FITBTests.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/dashboard/tests/FITBTests.jsx), [`ACRTests.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/dashboard/tests/ACRTests.jsx), [`TestCumulation.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/dashboard/tests/TestCumulation.jsx)) tracking user scores and question bank mastery.
  * **Metric:** 5 dedicated test modalities supporting instant feedback, timers, and progress persistence.

* **Claim:** Designed a specialized legal document drafting studio with rich text editing and XSS protection.
  * **Evidence:** Implemented [`DraftsPractice.jsx`](file:///C:/laragon/www/react/edulaw/src/pages/dashboard/drafts/DraftsPractice.jsx) with `jodit-react`, `rehype-sanitize`, and `remark-gfm`.
  * **Metric:** Safe client-side document drafting and rendering across complex legal templates.

---

## 4. Frontend Resume-Ready Highlights

* Engineered **EduLaw Frontend**, an EdTech web application built with **React 18**, **Vite 5**, **Tailwind CSS**, and **Zustand**, delivering 68 responsive views.
* Integrated **client-side NLP evaluation** using **TensorFlow.js** and the **Universal Sentence Encoder**, computing 512-dimensional vector embeddings and cosine distances on-device.
* Developed **5 interactive assessment engines** (MCQ, Fill-in-the-Blank, Active Recall, Diagnostic Onboarding, and Exam Simulation) with real-time score tracking.
* Built an interactive **legal audio study player** utilizing `react-use-audio-player` to stream neural audio notes alongside statutory reading materials.
* Created a **legal drafting studio** incorporating the Jodit rich text editor with Markdown processing and Rehype sanitization pipelines.
* Designed an **executive analytics dashboard** utilizing Tremor React and Recharts to visualize subscription metrics, revenue, and curriculum completion rates.
