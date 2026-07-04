# Career Manual

A lightweight, manual-first version of the ideas behind [santifer/career-ops](https://github.com/santifer/career-ops).

This project exists for people who want to create tailored application materials for a specific job, but do not want to rely on the full CLI workflow. It keeps the process simple and direct: fill in your data, describe the job, generate the files, and ship a custom CV, cover letter, and email when needed.

## What this repo is for

Use this repository when you want to:

- create a CV or resume tailored to one job description
- generate a cover letter and email using your own data manually
- package the project as a zip file and send it to someone else to complete the application materials
- keep a local, reusable set of prompts, templates, and generation commands

This is intentionally a lighter workflow than the full `career-ops` project. It focuses on manual generation and local control rather than tracking, automation, or a larger pipeline.

## What is included

- `resource/` - templates, scripts, config, and source data
- `manual/` - example HTML files and sample cover letter payloads
- `output/` - generated PDFs
- `PROMPT.md` - the prompt used when handing the zip to an AI tool or assistant
- `COMMANDS.md` - the commands used to turn HTML into PDFs
- `zip-project.bat` - Windows helper that packages the files into `manual.zip`

## Local setup

1. Clone or open the project in your local workspace.
2. Install dependencies with your package manager of choice if needed - `pnpm install`.
3. Copy `resource/config/profile.example.yml` to `resource/config/profile.yml` and fill in your own details.
4. Copy `resource/data/cv.example.md` to `resource/data/cv.md` and fill it so it reflects your real experience.
5. Read `MANUAL.md` to understand the manual application flow and what files are expected.

## How the manual workflow works

1. Identify a job description you want to apply to.
2. Decide whether you need a CV, cover letter, email, or all three.
3. Run `zip-project.bat` from the project root.
4. Attach the generated `manual.zip` to the chat or tool you want to use.
5. Include the contents or guidance from `PROMPT.md` so the assistant knows how to tailor the files.
6. After the HTML files are ready, use the commands in `COMMANDS.md` to generate PDFs.

## Windows packaging

The packaging script is designed for Windows and uses PowerShell under the hood.

From the project root, run:

```bat
zip-project.bat
```

This creates `manual.zip` in the root of the repository. The archive includes the `resource` folder and `MANUAL.md`, which are the core inputs needed for the manual generation flow.

## Generating PDFs locally

Use the commands in `COMMANDS.md` after the HTML files have been created.

CV / resume PDF:

```bash
node resource/scripts/generate-pdf.mjs manual/cv-{candidate-slug}-{company-slug}.html output/cv-{candidate-slug}-{company-slug}-{YYYY-MM-DD}.pdf --format={a4|letter}
```

Cover letter PDF from payload:

```bash
node resource/scripts/generate-cover-letter.mjs --payload manual/{company-slug}-{role-slug}-cover-payload.json --out output/{company-slug}-{role-slug}-cover.pdf
```

Cover letter PDF from HTML:

```bash
node resource/scripts/generate-pdf.mjs manual/{company-slug}-{role-slug}-cover.html output/{company-slug}-{role-slug}-cover.pdf --format=a4
```

## Typical file flow

- `resource/config/profile.yml` stores your personal details
- `resource/data/cv.md` stores your factual career history
- `manual/` stores job-specific HTML and payload files
- `output/` stores the exported PDFs

## Notes

- Do not invent experience, metrics, or credentials.
- Keep the prompt and commands alongside the project so the workflow stays repeatable.
- If you are using this for a new job, tailor only the files needed for that role.

## License

This repository is provided under the MIT license, with inspiration and workflow ideas acknowledged from `career-ops`.
