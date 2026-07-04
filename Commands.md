To generate CV/Resume PDF, run:

```
    node resource/scripts/generate-pdf.mjs \
    manual/cv-{candidate-slug}-{company-slug}.html \
    output/cv-{candidate-slug}-{company-slug}-{YYYY-MM-DD}.pdf \
    --format={a4|letter}
```

Or simply `node resource/scripts/generate-pdf.mjs manual/cv-{candidate-slug}-{company-slug}.html output/cv-{candidate-slug}-{company-slug}-{YYYY-MM-DD}.pdf --format={a4|letter}`

To generate Cover Letter PDF, run:
```
  node resource/scripts/generate-cover-letter.mjs \
    --payload manual/{company-slug}-{role-slug}-cover-payload.json \
    --out output/{company-slug}-{role-slug}-cover.pdf
```

Or simply from the HTML, run `node resource/scripts/generate-pdf.mjs manual/{company-slug}-{role-slug}-cover.html output/{company-slug}-{role-slug}-cover.pdf --format=a4`