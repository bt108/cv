# CV — Typst + YAML

Data-driven CV. Content lives in `details.yml`, layout in `template.typ`,
built to PDF with [Typst](https://typst.app/).

## Build

```sh
# install typst (pick one)
sudo snap install typst --classic
# or: cargo install typst-cli

make          # builds output.pdf (git-ignored)
```

## Edit

- `details.yml` — all content: contact, intro, skills, experience, strengths.
  - `vis: y` renders the entry, anything else hides it (keeps alternate
    versions in-file without separate branches).
  - Newest-first order in `timeline.list`.
- `template.typ` — layout only (`cv()` function, section/entry helpers).
- `main.typ` — entrypoint, wires YAML data into the template.

## Structure

```
main.typ      entrypoint: yaml("details.yml") -> cv(data)
template.typ  layout: header, skills, timeline, strengths sections
details.yml   content only, no formatting
makefile      typst compile main.typ output.pdf
```

## Notes

- `output.pdf` is build output and intentionally git-ignored.
- Single source of truth: no hand-editing the PDF.
