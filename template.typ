// CV template — Typst port of template.tex (pandoc + xelatex).
//
// Usage (see main.typ):
//   #import "template.typ": cv
//   #let data = yaml("details.yml")
//   #cv(data)

#let link-blue = rgb("#1eaedb")

#let cv-section(heading) = {
  v(0.6em)
  line(length: 100%, stroke: 0.5pt)
  v(0.15em)
  text(size: 10pt, weight: "bold", font: "DejaVu Sans", upper(heading))
  v(0.25em)
}

#let cv-timeline-entry(entry) = {
  // Heading row: title left, time right (replaces LaTeX \hfill).
  // Single paragraph with 1fr glue keeps linear text order (ATS-friendly).
  text(size: 14.4pt)[#entry.heading #h(1fr) #entry.time]
  parbreak()
  text(size: 10pt, style: "italic")[#entry.subtext]
  v(0.2em)

  // Paragraph variant (was `\small{...}` + `\vspace{1em}`).
  let par-text = entry.at("par", default: none)
  if par-text != none {
    text(size: 10pt)[
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

#let cv-characteristics-entry(entry) = {
  text(size: 14.4pt)[#entry.heading]
  v(-0.2em)

  let sub = entry.at("subtext", default: none)
  if sub != none {
    text(size: 10pt, style: "italic")[#sub]
    v(0.2em)
  }

  let par-text = entry.at("par", default: none)
  if par-text != none {
    text(size: 10pt)[#par-text]
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
    #text(font: "DejaVu Sans")[
      #data.at("contact", default: ()).map(c => [#link(c.url)[#c.text]]).join([, ])
    ]
  ]
  v(-0.4em)

  // --- Optional intro paragraph ---
  let intro = data.at("intro", default: none)
  if intro != none {
    v(0.4em)
    par[#intro]
  }

  // --- Skills section (same card layout as characteristics) ---
  let skills = data.at("skills", default: none)
  if skills != none {
    cv-section(skills.heading)
    for entry in skills.at("list", default: ()) {
      cv-characteristics-entry(entry)
    }
  }

  // --- Timeline section ---
  let timeline = data.at("timeline", default: none)
  if timeline != none {
    cv-section(timeline.heading)
    for entry in timeline.at("list", default: ()) {
      // `vis: y` renders; anything else is skipped (matches template.tex `$if(vis)$`).
      if entry.at("vis", default: "y") == "y" {
        cv-timeline-entry(entry)
      }
    }
  }

  // --- Characteristics section ---
  let chars = data.at("characteristics", default: none)
  if chars != none {
    cv-section(chars.heading)
    for entry in chars.at("list", default: ()) {
      cv-characteristics-entry(entry)
    }
  }
}
