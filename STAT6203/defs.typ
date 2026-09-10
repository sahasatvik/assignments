#import "@local/ctheorems:2.0.0": *


// Math definitions

#let cdot = $thin dot.c thin$
#let mapsto = $arrow.r.bar$

#let diag = "diag"

#let argmin = math.op($arg min$, limits: true)
#let argmax = math.op($arg max$, limits: true)

#let grad(f) = $nabla#f$

#let ip(u, v) = $lr(chevron.l #u comma #v chevron.r)$
#let KL(p, q) = $"KL"(#p mid(||) #q)$

#let eps = $epsilon$

#let XX = $cal(X)$
#let KK = $cal(K)$

#let cP = $cal(P)$
#let cT = $cal(T)$

#let iid = $~^"iid"$
#let var = "var"

#let eq(tag, eq) = math.equation(numbering: num => $#tag$, block: true, eq)


// Citation

#let pc = (citation) => {
  set cite(form: "prose")
  citation
}


// Theorem environments

#let thm-plain = thm.with(
  fmt: thm-fmt-block.with(
    name-fmt: x => [(#x)],
    title-fmt: strong,
    body-fmt: emph,
    separator: [*.* ]
  )
)

#let thm-def = thm.with(
  fmt: thm-fmt-block.with(
    name-fmt: x => [(#x)],
    title-fmt: strong,
    body-fmt: x => x,
    separator: [*.* ]
  )
)

#let thm-rem = thm.with(
  numbering: none,
  fmt: thm-fmt-block.with(
    name-fmt: name => emph([(#name)]),
    title-fmt: emph,
    body-fmt: x => x,
    separator: [. ]
  )
)

#let thm-style = (
  title-fmt: title => text(10pt, font: "Ubuntu", weight: 500, fill: black, title),
  separator: [#text(weight: "bold")[.]#h(0.2em)],
  outset: 1.2em,
  radius: 3pt,
  above: 3.2em,
  below: 2.2em,
  breakable: false,
)

#let thm-def = thm-def.with(..thm-style)
#let thm-plain = thm-plain.with(..thm-style)

#let proof = thm.with(
  supplement: "Proof",
  numbering: none,
  fmt: thm-fmt-block.with(
    name-fmt: emph,
    title-fmt: emph,
    body-fmt: proof-body-fmt,
    separator: [.#h(0.2em)]
  )
)

#let theorem = thm-plain.with(
  supplement: "Theorem",
  counter: "Theorem",
  base-level: 1,
  fill: rgb("#9EC299").lighten(90%),
  stroke: rgb("#9EC299").lighten(30%)
)
#let lemma = thm-plain.with(
  supplement: "Lemma",
  counter: "Theorem",
  base-level: 1,
  fill: rgb("#E78963").lighten(90%),
  stroke: rgb("#E78963").lighten(50%)
)
#let proposition = thm-plain.with(
  supplement: "Proposition",
  counter: "Theorem",
  base-level: 1,
  fill: rgb("#C8566B").lighten(95%),
  stroke: rgb("#C8566B").lighten(50%)
)
#let corollary = thm-plain.with(
  supplement: "Corollary",
  counter: "Sub-Theorem",
  base: "Theorem",
  fill: rgb("#F2D48F").lighten(85%),
  stroke: rgb("#F2D48F").lighten(10%)
)
#let definition = thm-def.with(
  supplement: "Definition",
  counter: "Theorem",
  base-level: 1,
  fill: rgb("#8EACCD").lighten(90%),
  stroke: rgb("#8EACCD").lighten(30%)
)
// #let proof = thm-proof(
//   "Proof",
// )
#let remark = thm-rem.with(
  supplement: "Remark",
)
#let example = thm-def.with(
  supplement: "Example",
  // counter: "Sub-Theorem",
  counter: "Theorem",
  // base: "Theorem",
  stroke: black.lighten(85%),
)



