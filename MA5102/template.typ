#let conf(title: "", subject: "", name: "", affiliation: "", doc) = {

  set document(title: title, author: name)
  set page(paper: "a4", numbering: "1")
  set text(12pt)
  set par(justify: true)

  set enum(numbering: "1.i.")

  show heading: it => {
    block(
      below: 14pt,
      text(font: "Ubuntu", weight: 500, it)
    )
  }

  show heading.where(level: 2): it => {
    block(
      outset: (left: 0.2in, y: 4pt),
      stroke: (left: blue + 5pt),
      above: 32pt,
      below: 14pt,
      breakable: false,
      text(16pt, font: "Ubuntu", weight: 500, it.body)
    )
  }

  show heading.where(level: 3): it => {
    block(
      outset: (left: 0.2in, y: 4pt),
      stroke: (left: green + 5pt),
      above: 22pt,
      below: 14pt,
      breakable: false,
      text(14pt, font: "Ubuntu", weight: 500, it.body)
    )
  }


  text(18pt, font: "Ubuntu", fill: black.lighten(20%), subject)
  v(-0.35in)
  text(36pt, font: "Ubuntu", fill: red.darken(15%), weight: 500, title)
  v(-0.3in)
  text(22pt, font: "Ubuntu", fill: black.lighten(20%), name)
  v(-0.15in)
  text(12pt, font: "Ubuntu", fill: black.lighten(40%), affiliation)
  v(0.2in)

  show outline.entry.where(level: 2): it => {
    link(
      it.element.location(),
      text(font: "Ubuntu")[#it.element.body#it.fill#strong(it.page)]
    )
  }

  outline(
    fill: box(width: 1fr, repeat(text(fill: black.lighten(60%), " ."))),
    depth: 2,
    indent: 0.2in
  )

  doc
}
