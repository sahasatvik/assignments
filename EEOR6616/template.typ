#let primary-color = state("primary-color", black)
#let secondary-color = state("secondary-color", black)


#let footer(title, footer-left, footer-right) = {
  let f-left = footer-left
  if footer-left == auto {
    f-left = title
  }
  context {
    let f-right = footer-right
    if footer-right == auto {
      let elems = query(selector(heading.where(level: 1)).before(here()))
      let section = if elems == () {} else { elems.last().body }
      f-right = section
    }
    set text(font: "Ubuntu")
    grid(
      columns: (1fr, 20pt, 1fr),
      align(
        left,
        text(size: 10pt, fill: black.lighten(70%), f-left)
      ),
      align(
        center,
        text(weight: 700, counter(page).display())
      ),
      align(
        right,
        text(size: 10pt, fill: black.lighten(70%), f-right)
      )
    )
  }
}

#let plain(
  title: "",
  author: "",
  author-show: auto,
  affiliation: "",
  suptitle: none,
  subtitle: none,
  links: (),
  footer-left: auto,
  footer-right: auto,
  primary: rgb("#DA1212"),
  secondary: rgb("#11468F"),
  color-strong: auto,
  paper: "a4",
  doc
) = {

  set document(title: title, author: author)
  set page(
    paper: paper,
    margin: (bottom: 1in),
    footer-descent: 0.5in,
    footer: footer(title, footer-left, footer-right),
  )

  set par(justify: true)

  primary-color.update(primary)
  secondary-color.update(primary)

  if color-strong == auto {
    color-strong = primary
  }
  if color-strong == false {
    color-strong = black
  }
  show strong: set text(fill: color-strong)
  show cite: set text(fill: secondary)
  show ref: set text(fill: secondary)
  show link: set text(fill: secondary)

  show heading: h => {
    set text(font: "Ubuntu", weight: 500)
    if h.numbering != none {
      text(fill: primary, counter(heading).display() + "  ")
    }
    h.body
    v(0.2em)
  }

  if suptitle != none {
    text(16pt, font: "Ubuntu", fill: black.lighten(20%), suptitle)
    v(-0.35in)
  }
  text(36pt, font: "Ubuntu", fill: primary, weight: 500, title)
  v(-0.3in)
  if subtitle != none {
    v(0.05in)
    text(16pt, font: "Ubuntu", fill: black.lighten(20%), subtitle)
    v(-0.05in)
  }
  if author-show == auto {
    author-show = author
  }
  text(16pt, font: "Ubuntu", fill: black.lighten(20%), author-show)
  v(-0.15in)
  text(12pt, font: "Ubuntu", fill: black.lighten(40%), affiliation)
  if links.len() > 0 {
    let link_format(key) = {
      text(12pt, font: "Ubuntu", weight: 500, link(links.at(key), key))
    }
    let links = links.keys().map(link_format)
    let links = links.join(h(4pt) + sym.circle.filled.small + h(4pt))
    v(-0.05in)
    text(12pt, font: "Ubuntu", fill: black.lighten(40%), links)
  }
  v(0.2in)

  show outline.entry: it => {
    set text(font: "Ubuntu")
    it
  }

  doc
}


#let contents(
  title: "Table of Contents",
  indent: 1.5em,
  depth: auto,
) = {
  heading(level: 1, numbering: none, outlined: false)[#title]
  context {
    let headings = query(selector(heading.where(outlined: true)))
    if depth != auto {
      headings = headings.filter(h => (h.level <= depth))
    }

    set text(font: "Ubuntu")
    grid(
      columns: (1fr, 20pt),
      gutter: 0.8em,
      ..headings.map((section) => (
        h((section.level - 1) * indent) +
        link(section.location())[
          #if section.numbering != none {
            let num = counter(heading).at(section.location())
            text(weight: 500, fill: primary-color.at(here()), numbering(section.numbering, ..num))
          }
          #text(fill: black, section.body)
        ],
        link(section.location())[#align(right)[
          #text(fill: primary-color.at(here()))[#section.location().page()]
        ]],
      )).flatten(),
    )
  }
}
