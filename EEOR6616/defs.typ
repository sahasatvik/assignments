#import "theorems.typ": *

#let thm-style = (
  title-fmt: title => text(10pt, font: "Ubuntu", weight: 500, fill: black, title),
  separator: [#text(weight: "bold")[.]#h(0.2em)],
  outset: 1.2em,
  radius: 3pt,
  padding: (top: 1.6em, bottom: 1em),
  breakable: false,
)

#let thm-def = thm-def.with(..thm-style)
#let thm-plain = thm-plain.with(..thm-style)

#let theorem = thm-plain(
  "Theorem",
  counter: "common",
  base-level: 1,
  fill: rgb("#9EC299").lighten(90%),
  stroke: rgb("#9EC299").lighten(30%)
)
#let lemma = thm-plain(
  "Lemma",
  counter: "common",
  base-level: 1,
  fill: rgb("#E78963").lighten(90%),
  stroke: rgb("#E78963").lighten(50%)
)
#let proposition = thm-plain(
  "Proposition",
  counter: "common",
  base-level: 1,
  fill: rgb("#C8566B").lighten(95%),
  stroke: rgb("#C8566B").lighten(50%)
)
#let corollary = thm-plain(
  "Corollary",
  counter: "sub",
  base: "common",
  fill: rgb("#F2D48F").lighten(85%),
  stroke: rgb("#F2D48F").lighten(10%)
)
#let definition = thm-def(
  "Definition",
  counter: "common",
  base-level: 1,
  fill: rgb("#8EACCD").lighten(90%),
  stroke: rgb("#8EACCD").lighten(30%)
)
#let proof = thm-proof(
  "Proof",
)
#let remark = thm-rem(
  "Remark",
).with(numbering: none)
#let example = thm-def(
  "Example",
  counter: "sub",
  base: "common",
  stroke: black.lighten(85%),
)



#let cdot = $thin dot.c thin$
#let mapsto = $arrow.r.bar$
#let ip(u, v) = $angle.l #u, #v angle.r$

#let diag = "diag"

#let argmin = math.op($arg min$, limits: true)
#let argmax = math.op($arg max$, limits: true)

#let grad(f) = $nabla#f$
#let subgrad(f) = $diff#f$

#let KL(p, q) = $"KL"(#p mid(||) #q)$

#let XX = $cal(X)$
#let KK = $cal(K)$

#let epi = "epi"
#let interior = "int"
#let relinterior = "ri"
#let boundary(X) = $diff#X$


#let eq(tag, eq) = math.equation(numbering: num => $#tag$, block: true, eq)


