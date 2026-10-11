// CV template — Typst port of template.tex (pandoc + xelatex).
//
// Usage (see main.typ):
//   #import "template.typ": cv
//   #let data = yaml("details.yml")
//   #cv(data)

#let link-blue = rgb("#0e4d6e")

#let cv-section(heading, size: 10pt) = {
  v(0.6em)
  line(length: 100%, stroke: 0.5pt)
  v(0.15em)
  text(size: size, weight: "bold", font: "DejaVu Sans", upper(heading))
  v(0.25em)
}

#let cv-timeline-entry(entry, heading-size: 12.5pt, body-size: 10pt) = {
  // Heading row: title left, time right (replaces LaTeX \hfill).
  // Single paragraph with 1fr glue keeps linear text order (ATS-friendly).
  text(size: heading-size)[#entry.heading #h(1fr) #entry.time]
  parbreak()
  text(size: body-size, style: "italic")[#entry.subtext]
  v(0.2em)

  // Paragraph variant (was `\small{...}` + `\vspace{1em}`).
  let par-text = entry.at("par", default: none)
  if par-text != none {
    text(size: body-size)[
      #par-text.split("\n").join(linebreak())
    ]
    v(1em)
  }

  let items = entry.at("list", default: none)
  if items != none {
    list(tight: true, indent: 1em, body-indent: 0.5em, ..items.map(i => [#i]))
  }
  v(0.4em)
}

#let cv-characteristics-entry(entry, heading-size: 14.4pt, body-size: 10pt) = {
  text(size: heading-size)[#entry.heading]
  v(-0.2em)

  let sub = entry.at("subtext", default: none)
  if sub != none {
    text(size: body-size, style: "italic")[#sub]
    v(0.2em)
  }

  let par-text = entry.at("par", default: none)
  if par-text != none {
    text(size: body-size)[#par-text]
    v(0.3em)
  }

  let items = entry.at("list", default: none)
  if items != none {
    list(tight: true, indent: 1em, body-indent: 0.5em, ..items.map(i => [#i]))
  }
  v(0.4em)
}

#let cv(data) = {
  // --- Page setup (replaces geometry + fontsize + pagenumbering{gobble}) ---
  let margins = data.at("margins", default: (left: 25mm, right: 25mm, top: 20mm, bottom: 20mm))
  set page(
    paper: "a4",
    margin: (
      left: eval(margins.left),
      right: eval(margins.right),
      top: eval(margins.top),
      bottom: eval(margins.bottom),
    ),
    numbering: none,
  )
  set text(lang: data.at("lang", default: "en"), size: eval(data.at("fontsize", default: "12pt")))
  set par(spacing: 0.65em, leading: 0.65em)
  set list(tight: true)
  set par(justify: false)

  // Links (replaces hyperref urlcolor/linkcolor).
  show link: set text(fill: link-blue)

  // --- Title block (replaces \maketitle) ---
  align(center)[
    #text(size: 25pt, weight: "bold", font: "DejaVu Sans", upper(data.name)) \
    #{
      let contact = data.at("contact", default: ())
      let online = contact.filter(c => not c.url.starts-with("tel:"))
      let phones = contact.filter(c => c.url.starts-with("tel:"))
      text(size: 9.5pt, font: "DejaVu Sans")[
        #online.map(c => box(link(c.url)[#c.text])).join([ #h(0.4em) · #h(0.4em) ])
        #if online.len() > 0 and phones.len() > 0 [ \ ]
        #phones.map(c => box(link(c.url)[#c.text])).join([ #h(0.4em) · #h(0.4em) ])
      ]
    }
  ]
  v(-0.4em)

  // --- Optional intro paragraph ---
  let intro = data.at("intro", default: none)
  if intro != none {
    v(0.4em)
    par[#intro]
  }

  // --- Two-column body: narrow sidebar | wide main (intro stays full-width above) ---
  let skills = data.at("skills", default: none)
  let timeline = data.at("timeline", default: none)
  let chars = data.at("characteristics", default: none)
  grid(
    columns: (1fr, 1.85fr),
    gutter: 1.6em,
    align: top,
    [
      #show list: set text(size: 9pt)
      #if skills != none {
        cv-section(skills.heading, size: 9pt)
        for entry in skills.at("list", default: ()) {
          cv-characteristics-entry(entry, heading-size: 11pt, body-size: 9pt)
        }
      }
      #if chars != none {
        cv-section(chars.heading, size: 9pt)
        for entry in chars.at("list", default: ()) {
          cv-characteristics-entry(entry, heading-size: 11pt, body-size: 9pt)
        }
      }
    ],
    [
      #if timeline != none {
        cv-section(timeline.heading)
        for entry in timeline.at("list", default: ()) {
          // `vis: y` renders; anything else is skipped (matches template.tex `$if(vis)$`).
          if entry.at("vis", default: "y") == "y" {
            cv-timeline-entry(entry)
          }
        }
      }
    ],
  )
}
