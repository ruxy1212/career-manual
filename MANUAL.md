# Manual Application Flow

> **Purpose:** Generate a tailored CV (HTML), cover letter (HTML), and email (Markdown) for a single job application -- without running any scripts, updating the pipeline, or performing any tracking. The user runs `/resource/scripts/generate-pdf.mjs` manually afterwards.

---

## When to use this

Use this flow when you want to:

- Apply directly to a role without going through the full auto-pipeline
- Generate the raw HTML files and review them before converting to PDF
- Keep the application entirely off the tracker (personal outreach, referral, speculative)

**What this flow does NOT do:**

- Run any Node.js scripts
- Update `data/pipeline.md` or `data/applications.md`
- Save evaluation reports to `reports/`
- Write to `batch/tracker-additions/`
- Perform pattern analysis or scoring

---

## Files you (agent) must read before starting

Read all of these. They are the canonical sources of truth.

| File | Purpose |
|------|---------|
| `resource/data/cv.md` | Candidate experience, achievements, skills (source of truth -- never invent) |
| `resource/config/profile.yml` | Name, email, location, LinkedIn, GitHub, portfolio, salary targets |
| `resource/modes/_profile.md` | User archetypes, narrative framing, proof point mapping, writing instructions |
| `resource/CREATING_CV_AND_RESUME.md` | **Mandatory CV writing guidelines** -- read fully before generating CV HTML |
| `resource/CREATING_COVER_LETTER_AND_EMAIL.md` | **Mandatory email writing guidelines** -- read fully before drafting email |
| `resource/templates/cv-template.html` | HTML template for the CV -- replace `{{PLACEHOLDERS}}` |
| `resource/templates/cover-letter-template.html` | HTML template for the cover letter -- filled via JSON payload |

---

## Input

The user provides a job description as either:

- A **URL** -- fetch the page content and extract the JD text
- **Pasted text** -- use directly

If a URL is provided: navigate to it, read the page, extract the job title, company name, location, requirements, and responsibilities. If the page is inaccessible, ask the user to paste the JD text instead.

---

## Step 1 -- Parse the JD

Extract and record:

| Field | Source |
|-------|--------|
| `role_title` | Exact wording from JD |
| `company` | Company name |
| `location` | City / country / remote |
| `paper_format` | `letter` if US/Canada, `a4` otherwise |
| `jd_language` | Language of the JD (EN default) |
| `top_requirements` | Top 3-5 required skills/competencies |
| `ats_keywords` | 15-20 exact keyword phrases for ATS optimization |
| `jd_tone` | Formal / direct / conversational (inferred from JD language) |
| `company_slug` | company name lowercased, spaces to hyphens (e.g. `acme-corp`) |
| `role_slug` | role title lowercased, spaces to hyphens, max 30 chars (e.g. `senior-ai-engineer`) |
| `candidate_slug` | candidate name from `resource/config/profile.yml` lowercased, spaces to hyphens (e.g. `john-doe`) |

---

## Step 2 -- Detect archetype

Classify the role into one of the archetypes defined in `resource/modes/_profile.md` (or `modes/_shared.md` as fallback):

| Archetype | Key signals |
|-----------|-------------|
| AI Platform / LLMOps | observability, evals, pipelines, monitoring, reliability |
| Agentic / Automation | agent, HITL, orchestration, workflow, multi-agent |
| Technical AI PM | PRD, roadmap, discovery, stakeholder, product manager |
| AI Solutions Architect | architecture, enterprise, integration, design, systems |
| AI Forward Deployed | client-facing, deploy, prototype, fast delivery, field |
| AI Transformation | change management, adoption, enablement, transformation |
| General Software / Backend / Fullstack | If none of the above match |

Use the detected archetype to:
- Select which proof points and achievements to lead with (from `resource/data/cv.md`)
- Frame the Professional Summary in the CV
- Choose STAR stories that are most relevant

---

## Step 3 -- Generate the CV HTML

### 3.1 Read CV guidelines

Before writing a single word, read `resource/CREATING_CV_AND_RESUME.md` in full. Every bullet, section heading, and summary sentence must comply with its principles.

### 3.2 Personalize content (do not invent)

Apply these transformations to `resource/data/cv.md` content:

**Professional Summary:**
- 3-4 sentences, keyword-dense
- Inject 3-5 of the highest-relevance ATS keywords naturally
- Include the exit narrative bridge from `resource/modes/_profile.md`
- Reference a portfolio/case study URL if present in `resource/config/profile.yml`

**Core Competencies:**
- 6-8 keyword phrases drawn directly from the JD requirements
- Only include competencies the candidate genuinely has (evidence in cv.md)

**Work Experience:**
- Reorder bullets within each role by relevance to this JD (most relevant first)
- Apply vocabulary from the JD to existing achievement bullets -- never invent new achievements
- Do NOT reorder the roles themselves (keep reverse chronological)

**Projects:**
- Select the top 3-4 most relevant projects to this JD
- Adjust emphasis, not facts

**Skills:**
- Keep truthful; surface JD-relevant technologies first

### 3.3 Fill the template

Use `resource/templates/cv-template.html`. Replace every `{{PLACEHOLDER}}` as follows:

| Placeholder | Content source |
|-------------|---------------|
| `{{LANG}}` | `en` or `es` (from JD language) |
| `{{PAGE_WIDTH}}` | `8.5in` (letter) or `210mm` (a4) |
| `{{NAME}}` | `resource/config/profile.yml` -- candidate.name |
| `{{PHONE}}` | `resource/config/profile.yml` -- candidate.phone (omit span and separator if empty) |
| `{{EMAIL}}` | `resource/config/profile.yml` -- candidate.email |
| `{{LINKEDIN_URL}}` | `resource/config/profile.yml` -- candidate.linkedin |
| `{{LINKEDIN_DISPLAY}}` | `resource/config/profile.yml` -- candidate.linkedin (display text) |
| `{{PORTFOLIO_URL}}` | `resource/config/profile.yml` -- candidate.portfolio |
| `{{PORTFOLIO_DISPLAY}}` | `resource/config/profile.yml` -- candidate.portfolio (display text) |
| `{{LOCATION}}` | `resource/config/profile.yml` -- candidate.location |
| `{{SECTION_SUMMARY}}` | Professional Summary |
| `{{SUMMARY_TEXT}}` | Personalized summary from Step 3.2 |
| `{{SECTION_COMPETENCIES}}` | Core Competencies |
| `{{COMPETENCIES}}` | `<span class="competency-tag">keyword</span>` x 6-8 |
| `{{SECTION_EXPERIENCE}}` | Work Experience |
| `{{EXPERIENCE}}` | Full HTML for all roles with reordered bullets |
| `{{SECTION_PROJECTS}}` | Projects |
| `{{PROJECTS}}` | HTML for top 3-4 projects |
| `{{SECTION_EDUCATION}}` | Education |
| `{{EDUCATION}}` | Education HTML from cv.md |
| `{{SECTION_CERTIFICATIONS}}` | Certifications |
| `{{CERTIFICATIONS}}` | Certifications HTML from cv.md |
| `{{SECTION_SKILLS}}` | Skills |
| `{{SKILLS}}` | Skills HTML -- JD-relevant technologies first |

### 3.4 Write the CV HTML file

Save the completed HTML to:

```
manual/cv-{candidate-slug}-{company-slug}.html
```

Example: `manual/cv-john-doe-acme-corp.html`

---

## Step 4 -- Generate the cover letter HTML

### 4.1 Read cover letter guidelines

Before drafting, read `resource/CREATING_COVER_LETTER_AND_EMAIL.md` in full. The letter must comply with every principle in that file.

### 4.2 Select achievements

From `resource/data/cv.md` only:

1. Read all achievement bullets across all roles
2. Score each against the JD's top 3-5 requirements
3. Select 4-5 highest-scoring bullets that each have at least one metric or concrete outcome
4. Use exact wording and metrics from cv.md -- never paraphrase, never invent

### 4.3 Draft the letter body

Structure (350-420 words total -- header and credentials not counted):

```
[Opening -- 2 sentences]
Why applying + functional summary. Uses JD mirror vocabulary from Step 1.
Derived from the role archetype framing in modes/_profile.md.

[Profile introduction -- 1 paragraph]
Years of experience, current/most recent role, domain expertise.
Read directly from cv.md Professional Summary, adapted to JD domain.
Tone: match the JD tone detected in Step 1.

[Achievements -- 4-5 bullets]
- **Bold lead phrase,** impact sentence with metric.
- **Bold lead phrase,** impact sentence with metric.
- **Bold lead phrase,** impact sentence with metric.
- **Bold lead phrase,** impact sentence with metric.

[Problems I will solve -- 2-3 sentences]
What specific problem does this company likely have that I will address?
Ground in the JD language. Be specific -- not generic.
If company research context is available (from the user), incorporate it.

[Closing -- 1-2 sentences]
Availability + forward signal. No "Thank you for your time."
End with value: what does hiring me give the team?
```

**Hard language rules (no exceptions):**
- Active voice only
- No em dashes (use comma, full stop, or rewrite)
- No buzzwords: leverage, synergy, seamless, robust, cutting-edge, spearheaded, passionate, excited, stakeholder alignment, data-driven
- No filler openers: "I am pleased to", "I am writing to", "I am excited to"
- Every claim needs a number, system name, or specific outcome -- no abstractions
- Mirror JD vocabulary, but never sacrifice clarity for keyword density
- No sentence that could appear unchanged in a letter for a different company

### 4.4 Assemble the JSON payload

Build the cover letter payload and save to `manual/{company-slug}-{role-slug}-cover-payload.json`:

```json
{
  "candidate": {
    "name": "{from resource/config/profile.yml}",
    "email": "{from resource/config/profile.yml}",
    "phone": "{from resource/config/profile.yml -- omit key if empty}",
    "location": "{from resource/config/profile.yml}",
    "linkedin": "{from resource/config/profile.yml -- omit key if empty}",
    "github": "{from resource/config/profile.yml -- omit key if empty}",
    "credentials": ["{degree}", "{cert}"]
  },
  "letter": {
    "role_title": "{exact from JD}",
    "company": "{company name}",
    "city": "{JD city or Remote}",
    "date": "{YYYY-MM-DD -- today's date}",
    "opening": "{opening paragraph}",
    "profile_intro": "{profile intro paragraph}",
    "achievements": [
      {"lead": "...", "impact": "..."},
      {"lead": "...", "impact": "..."},
      {"lead": "...", "impact": "..."},
      {"lead": "...", "impact": "..."}
    ],
    "problems_section": "{problems paragraph}",
    "closing": "{closing sentence}",
    "language_closing": null
  },
  "output_path": "manual/{company-slug}-{role-slug}-cover.pdf"
}
```

### 4.5 Write the cover letter HTML

Render `templates/cover-letter-template.html` by substituting the payload values into the template tokens (same substitution logic as `generate-cover-letter.mjs`). Save to:

```
manual/{company-slug}-{role-slug}-cover.html
```

Example: `manual/acme-corp-senior-ai-engineer-cover.html`

---

## Step 5 -- Generate the application email (Markdown)

### 5.1 Read email guidelines

Before writing, confirm you have read `resource/CREATING_COVER_LETTER_AND_EMAIL.md`. Every sentence must comply.

### 5.2 Draft the email

Follow the structure from `resource/CREATING_COVER_LETTER_AND_EMAIL.md`:

1. **Subject line** -- role-specific, hints at solving a real problem (not "Application for...")
2. **Opening** -- state an invisible problem companies with this role commonly face, explain why it matters, pivot to yourself
3. **Introduction** -- role, years of experience, core specialization (2-3 sentences max)
4. **Company pain point** -- one realistic challenge this company likely has (ground in JD; do not invent company facts)
5. **Evidence** -- 1-2 concrete achievements with outcomes (draw from the same bullets selected in Step 4.2)
6. **How I think** -- one short paragraph on engineering/AI philosophy relevant to this role
7. **Technologies** -- mentioned naturally, only those relevant to this role
8. **Attachments mention** -- explicitly reference CV and cover letter
9. **Closing** -- end with value, not gratitude

### 5.3 Write the email file

Save to `manual/{company-slug}-{role-slug}-email.md` with this format:

```markdown
# Application Email: {Role Title} -- {Company}

**To:** {recruiter email if known, otherwise leave blank}
**Subject:** {subject line}

---

{full email body}

---

**Attachments:**
- CV: manual/cv-{candidate-slug}-{company-slug}.html
- Cover letter: manual/{company-slug}-{role-slug}-cover.html
```

---

## Step 6 -- Summary output to the user

After all three files are written, display this summary:

```
Manual Application Files -- {company} | {role_title}
======================================================

CV HTML:
  manual/cv-{candidate-slug}-{company-slug}.html

Cover Letter HTML:
  manual/{company-slug}-{role-slug}-cover.html

Cover Letter Payload:
  manual/{company-slug}-{role-slug}-cover-payload.json

Email:
  manual/{company-slug}-{role-slug}-email.md

------------------------------------------------------

To generate PDFs, run:

  node resource/scripts/generate-pdf.mjs \
    manual/cv-{candidate-slug}-{company-slug}.html \
    output/cv-{candidate-slug}-{company-slug}-{YYYY-MM-DD}.pdf \
    --format={a4|letter}

  node resource/scripts/generate-cover-letter.mjs \
    --payload manual/{company-slug}-{role-slug}-cover-payload.json \
    --out output/{company-slug}-{role-slug}-cover.pdf

------------------------------------------------------

ATS keywords injected: {N} of {total extracted}
Keywords NOT injected (review manually):
  - {keyword if any could not be woven in naturally}

Archetype detected: {archetype}
Paper format: {a4 | letter}
```

---

## Quality rules (applied throughout)

- **Never invent experience, metrics, or skills.** Read `cv.md` and `article-digest.md`. Use exact wording.
- **Never modify `cv.md`** or any source file.
- **Active voice only.** Passive constructions must be rewritten.
- **No em dashes, smart quotes, or special Unicode.** Use plain ASCII equivalents.
- **No buzzwords.** The banned list is in `resource/CREATING_CV_AND_RESUME.md` and `resource/CREATING_COVER_LETTER_AND_EMAIL.md`.
- **ATS normalization.** `generate-pdf.mjs` handles this at render time, but avoid generating these characters in the first place.
- **Mirror JD vocabulary** around real cv.md achievements -- never use JD language to fabricate new claims.
- **Self-check:** Before finalizing each file, re-read every sentence. If it could appear in any application for any company, rewrite it.

---

## Output directory

All output goes inside `/manual/`. Never write to `resource/`, `output/`, or any other project directory.

```
manual/
+-- cv-{candidate-slug}-{company-slug}.html
+-- {company-slug}-{role-slug}-cover.html
+-- {company-slug}-{role-slug}-cover-payload.json
+-- {company-slug}-{role-slug}-email.md
```

---

## Triggering this flow

Read this file and execute each step in order, providing the JD as input. No slash commands, no scripts, no pipeline updates required.

Example prompt:

> Read MANUAL.md and perform the manual application flow for this JD: {url or pasted text}
