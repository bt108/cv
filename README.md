# CV

[![built with Typst](https://img.shields.io/badge/built%20with-Typst-blue)](https://typst.app)

A data-driven CV: content lives in YAML, layout in a Typst template, output
is a one-page PDF. For keeping a CV as version-controlled plain text — edit
`details.yml`, run `make`, get `output.pdf`.

## 30-second example

An entry in `details.yml`:

```yaml
timeline:
  heading: Experience & Education
  list:
    - time: Sep 2023 - Oct 2024
      vis: y
      heading: Head of Technical Department
      subtext: Vrindavan Institute for Higher Education, India
```

```sh
make          # typst compile main.typ → output.pdf (git-ignored)
make clean    # rm -f output.pdf
```

## Sample output

`output.pdf`, rendered at 150 dpi:

![CV preview](docs/img/preview.png)

## Prerequisites

- Typst (`typst`) — compiles `main.typ` to PDF.
  Install: `sudo snap install typst --classic`, or `cargo install typst-cli`.
- DejaVu Sans font — title and section headings render in it
  (see `template.typ`); the build fails if it is missing.

## Commands

```sh
make          # default target: typst compile main.typ → output.pdf
make clean    # rm -f output.pdf
```

## Project layout

```
main.typ            # entrypoint: yaml("details.yml") -> cv(data)
template.typ        # layout only: cv() function, section/entry helpers
details.yml         # content only, no formatting (vis: y renders, else hidden)
makefile            # typst compile main.typ output.pdf
docs/img/preview.png  # rendered output.pdf (checked in for this README)
output.pdf          # build output (git-ignored)
```

## Content model

- **details.yml** → contact list, intro paragraph, skills, timeline, strengths,
  plus page settings (`fontsize`, `lang`, `margins`).
- **main.typ** loads the YAML and calls `cv(data)` from `template.typ`.
- **Timeline entries** carry `vis: y` to render; anything else keeps the entry
  in-file but hidden (alternate versions without branches).
- **Layout** is a two-column grid: skills + strengths sidebar, experience main
  column, intro full-width above.
- **Single source of truth**: the PDF is never hand-edited; rebuild via `make`.
