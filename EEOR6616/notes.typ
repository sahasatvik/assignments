#import "template.typ": plain, contents
#import "theorems.typ": *


#show: plain.with(
  suptitle: [
    *EEOR6616*
  ],
  title: [Convex Optimization],
  // subtitle: [ ],
  author: "Satvik Saha",
  author-show: [
    #set footnote(numbering: "*")
    #set strong(delta: 100)
    _Instructed by *Prof.~Tianyi Lin*_~#footnote[Department of Industrial Engineering and Operations Research (IEOR), Columbia University]
    #v(-0.4em)
    _Transcribed by *Satvik Saha*_~#footnote[Department of Statistics, Columbia University]
  ],
  // affiliation: [Columbia University],
  primary: rgb("#8EACCD").darken(5%),
  secondary: rgb("#8EACCD").darken(30%),
  footer-left: [EEOR6616: Convex Optimization],
)

#show heading.where(level: 1): h => block(above: 2em, below: 1em, h)
#show heading.where(level: 2): h => block(above: 2em, below: 1em, h)
// #show heading.where(level: 2): h => {
//   context {
//     let hh = query(selector(heading).before(here()))
//     if hh.at(-2).level != 1 {
//       v(2em)
//     }
//   }
//   block(above: 1em, below: 1em, h)
// }
#show enum: it => pad(left: 1em, it)

#show math.equation: set block(breakable: true)


#set heading(numbering: "1.")
#show: thm-rules.with(qed-symbol: $square$)

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
#let example = thm-plain(
  "Example",
  counter: "sub",
  base: "common",
  stroke: black.lighten(85%),
)

#let mapsto = $arrow.r.bar$
#let ip(u, v) = $angle.l #u, #v angle.r$

#let argmin = math.op($arg min$, limits: true)
#let argmax = math.op($arg max$, limits: true)

#let grad(f) = $nabla f$

#let KK = $cal(K)$

#let epi = "epi"
#let interior = "int"


#let eq(tag, eq) = math.equation(numbering: num => $#tag$, block: true, eq)


#v(-0.2in)
#contents()
#v(0.3in)

// #pagebreak()


///////////////////////////////////////////////////////////////////////////////


= Basic Definitions

== Convex Sets and Functions


#definition("Convex set")[
  We say that $KK subset.eq RR^d$ is convex if $
    lambda x + (1 - lambda) y in KK
  $ for all $x, y in KK$ and $lambda in [0, 1]$.
]

#definition("Convex function")[
  We say that $f: KK -> RR$ is convex if $KK$ is convex, and $
    f(lambda x + (1 - lambda) y) <= lambda f(x) + (1 - lambda) f(y)
  $ for all $x, y in KK$ and $lambda in [0, 1]$.
]

#proposition("Jensen's Inequality")[
  $f$ is convex if and only if $
    f(lambda_1 x_1 + ... + lambda_n x_n)
      <= lambda_1 f(x_1) + ... + lambda_n f(x_n)
  $ for all $x_1, ..., x_n in KK$ and $lambda_1, ..., lambda_n >= 0$ such that
  $sum_k lambda_k = 1$,
] <prop-jensen>

#definition("Epigraph")[
  The epigraph of $f: KK -> RR$ is defined as $
    epi(f) = {(x, alpha) in KK times RR : f(x) <= alpha}.
  $
]

#remark[
  The epigraph of $f$ is simply the region above the graph of $f$, $
    Gamma(f) = {(x, alpha) in KK times RR : f(x) = alpha}.
  $
]

#proposition[
  $f$ is convex if and only if $epi(f)$ is convex.
]
#proof[
  $(==>)$ For $(x_1, alpha_1), (x_2, alpha_2) in epi(f)$ and $lambda in [0,
  1]$, we have $
    f(lambda x_1 + (1 - lambda)x_2)
      &<= lambda f(x_1) + (1 - lambda) f(x_2) \
      &<= lambda alpha_1 + (1 - lambda) alpha_2.
  $

  $(<==)$ For $x_1, x_2 in KK$ and $lambda in [0, 1]$, since $(x_1, f(x_1)),
  (x_2, f(x_2)) in epi(f)$, we have $
    f(lambda x_1 + (1 - lambda)x_2) <= lambda f(x_1) + (1 - lambda) f(x_2). #qedhere
  $
]


From now on, we will always assume that $f:KK -> RR$ is differentiable.
Under this setting, we have a simpler characterization of convexity.

#proposition("Gradient Inequality")[
  $f$ is convex if and only if $
    f(y) >= f(x) + grad(f)(x)^top (y - x)
  $ for all $x, y in KK$.
] <prop-tangent>
#proof[
  $(==>)$ Note that for $t in (0, 1)$, we may write $
    f(x) + (f(x + t(y - x)) - f(x))/t
      &= (f((1 - t)x + t y) - (1 - t)f(x))/t \
      &<= f(y).
  $ Taking the limit $t -> 0$ gives the desired result.

  ($<==$) Let $x, y in KK$ and $lambda in [0, 1]$.
  Setting $z = lambda x + (1 - lambda) y$, we have $
    f(x) >= f(z) + grad(f)(z)^top (x - z), quad quad
    f(y) >= f(z) + grad(f)(z)^top (y - z).
  $ Combining these gives $lambda f(x) + (1 - lambda) f(y) >= f(z)$.
]

#remark[
  This is often presented as $
    f(x) - f(y) <= grad(f)(x)^top (x - y).
  $
]


== The Optimization Problem

#definition("Global Minimizer")[
  We say that $x^*$ is a global minimizer of $f: KK -> RR$ if $f(x) >= f(x^*)$
  for all $x in KK$.
]

#definition("Local Minimizer")[
  We say that $x^*$ is a local minimizer of $f: KK -> RR$ if $f(x) >= f(x^*)$
  for all $x in cal(U)$ for some neighborhood $cal(U) subset.eq KK$ of $x^*$.
]

#proposition[
  Let $x^* in interior(KK)$ be a local minimizer of $f$.
  Then, $grad(f)(x^*) = 0$.
] <prop-local-gradient>


The optimization problem for convex $f$ on a convex set $KK$ can be described
as #eq($(cal(M)_KK)$)[$
  min_(x in KK) f(x).
$] <op-X>

In the special case $KK = RR^d$, this is #eq($(cal(M_(RR^d)))$)[$
  min_(x in RR^d) f(x).
$] <op-unconstrained>

The convexity of $f$ allows us to characterize solutions of @op-unconstrained[]
via its critical points.

#proposition[
  Let $f: RR^d -> RR$ be convex.
  Then, $x^* in RR^d$ is a global minimizer of $f$ if and only if $grad(f)(x^*) = 0$.
] <prop-convex-gradient>
#proof[
  Follows directly from @prop-local-gradient and @prop-tangent.
]



= Gradient Descent

Gradient descent algorithms for solving @op-unconstrained[] follow the
iterative scheme #eq($(cal("GD"))$)[$
  x_(t + 1) = x_t - eta_t grad(f)(x_t).
$] <al-GD>

It is possible for @al-GD[] to take our iterates $x_t$ outside $KK$; we can
rectify this using projections.


== Projections

#theorem("Hilbert Projection")[
  Let $KK subset.eq RR^d$ be closed and convex.
  Then, for each $y in RR^d$, there exists unique $z in KK$ such that $norm(z -
  y) <= norm(x - y)$ for all $x in KK$.
] <thm-hilbert-projection>
#proof[
  Set $delta = inf_(x in KK) norm(x - y)$ and pick a sequence
  ${z_n} subset KK$ such that $norm(z_n - y) -> delta$.
  Note that $(z_n + z_m)\/2 in KK$; the parallelogram law gives $
    norm(z_n - z_m)^2
      &=  2norm(z_n - y)^2 + 2norm(z_m - y)^2 - 4norm((z_n + z_m)\/2 - y)^2 \
      &<= 2norm(z_n - y)^2 + 2norm(z_m - y)^2 - 4delta^2.
  $ Since this goes to $0$ as $m, n -> oo$, ${z_n}$ is Cauchy and hence has a
  limit $z in KK$.
  Furthermore, if $delta = norm(z' - y)$ for some other $z' in KK$,
  then $
    norm(z - z')^2
      = 4(delta^2 - norm((z + z')\/2 - y))^2
      <= 0,
  $ forcing $z = z'$.
]

#definition[
  Let $KK subset.eq RR^d$ be closed and convex.
  The projection onto $KK$ is defined by $
    Pi_KK: RR^d -> KK, quad
    y mapsto argmin_(x in KK) thick norm(x - y).
  $
]
#remark[
  @thm-hilbert-projection guarantees that $Pi_KK$ is well defined; the
  minimizer of $x mapsto norm(x - y)$ on $KK$ exists and is unique.
]


#proposition("Variational Inequality")[
  Let $y in RR^d$ and $z in KK$ for closed convex $KK$.
  Then, $z = Pi_KK (y)$ if and only if $ip(z - y, z - x) <= 0$ for all $x in
  KK$.
] <prop-variational>
#proof[
  $(==>)$ Let $t in (0, 1)$, and $z_t = (1 - t)Pi_KK (y) + t x in KK$.
  Then, $
    norm(z - y)^2
      &<= norm(z_t - y)^2
      &=  norm(z - y - t (z - x))^2,
  $ which simplifies to $
    -2 ip(z - y, z - x) + t norm(z - x)^2 >= 0.
  $ Taking the limit $t -> 0$ gives the desired inequality.

  $(<==)$ For $x in KK$, $
    norm(y - x)^2
      = norm(y - z)^2 + norm(z - x)^2 - 2 ip(z - y, z - x)
      >= norm(y - z)^2. #qedhere
  $
]

#lemma("Pythagoras")[
  For all $x in KK$ and $y in RR^d$, $
    norm(Pi_KK (y) - x)^2 <= norm(y - x)^2 - norm(y - Pi_KK (y))^2.
  $
] <lem-pythagoras>
#proof[
  It suffices to show that $ip(Pi_KK (y) - y, Pi_KK (y) - x) <= 0$ for all $x
  in KK$, which holds via @prop-variational.
]

#corollary[
  For all $x, y in RR^d$, $
    norm(Pi_KK (x) - Pi_KK (y)) <= norm(x - y).
  $
]


Projected gradient descent algorithms for solving @op-X[] follow the iterative
scheme #eq($(cal("PGD"))$)[$
  y_(t + 1) &= x_t - eta_t grad(f)(x_t), \
  x_(t + 1) &= Pi_KK (y_(t + 1)).
$] <al-PGD>

We can establish rates of convergence of @al-GD[] and  @al-PGD[] under certain
regularity conditions on $f$.


== $L$-Lipschitz Functions

#definition([$L$-Lipschitz])[
  We say that $f: KK -> RR$ is $L$-Lipschitz for some $L >= 0$ if $
    |f(x) - f(y)| <= L norm(x - y)
  $ for all $x, y in KK$.
]

#remark[
  When $f$ is differentiable, $f$ is $L$-Lipschitz if and only if $norm(grad(f))
  <= L$.
]

#theorem[
  Let $f$ be convex and $L$-Lipschitz, $x^* in KK$ be its global minimizer, and
  $norm(x_1 - x^*) <= R$.
  Further let $x_1, ..., x_T$ be $T$ iterates of @al-PGD[] with $eta = R\/ L
  sqrt(T)$.
  Then, $
    f(1/T sum_(t = 1)^T x_t) - f(x^*) <= (R L)/sqrt(T).
  $
] <thm-PGD-Lipschitz>
#proof[
  Compute $
    f(1/T sum_(t = 1)^T x_t) - f(x^*)
      &<= 1/T sum_(t = 1)^T f(x_t) - f(x^*) #tag[(@prop-jensen)] \
      &<= 1/T sum_(t = 1)^T grad(f)(x_t)^top (x_t - x^*) #tag[(@prop-tangent)]\
      &=  1/(T eta) sum_(t = 1)^T (x_t - y_(t + 1))^top (x_t - x^*) \
      &=  1/(2T eta) sum_(t = 1)^T [norm(x_t - y_(t + 1))^2 + norm(x_t - x^*)^2 - norm(y_(t + 1) - x^*)^2] \
      &=  eta/(2) norm(grad(f)(x_t))^2 + 1/(2T eta) sum_(t = 1)^T [norm(x_t - x^*)^2 - norm(y_(t + 1) - x^*)^2] \
      &<= (eta L^2)/2 + 1/(2T eta) sum_(t = 1)^T lr(size: #50%, [norm(x_t - x^*)^2 - norm(size: #30%, underbrace(Pi_KK (y_(t + 1)), x_(t + 1)) - x^*)^2]) #tag[(@lem-pythagoras)]\
      &=  (eta L^2)/2 + 1/(2T eta) [norm(x_1 - x^*)^2 - norm(x_(T + 1) - x^*)^2] \
      &<= (eta L^2)/2 + (R^2) / (2T eta) \
      &=  (R L) / sqrt(T). #qedhere
  $
]


== $ell$-smoothness

#definition([$ell$-smoothness])[
  We say that $f: KK -> RR$ is $ell$-smooth for some $ell >= 0$ if $
    norm(grad(f)(x) - grad(f)(y)) <= ell norm(x - y)
  $ for all $x, y in KK$.
]

#lemma[
  Let $f: KK -> RR$ for convex $KK$ be $ell$-smooth.
  Then, $
    |f(y) - f(x) - grad(f)(x)^top (y - x)| <= ell/2 norm(y - x)^2.
  $
] <lem-lsmooth>
#proof[
  Using the Fundamental Theorem of Calculus, $
    |f(y) - f(x) - grad(f)(x)^top (y - x)|
      &= lr(|integral_0^1 (grad(f)(x + t(y - x)) - grad(f)(x))^top (y - x) thick d t|) \
      &<= integral_0^1 norm(grad(f)(x + t(y - x)) - grad(f)(x)) dot.c norm(y - x) thick d t \
      &<= integral_0^1 ell t norm(y - x) dot.c norm(y - x) thick d t \
      &= ell/2 norm(y - x)^2. #qedhere
  $
]

When $f$ is convex, the norm on the left hand side is redundant, giving the
estimate $
    0 <= f(y) - f(x) - grad(f)(x)^top (y - x) <= ell/2 norm(y - x)^2.
$
In fact, we can use $ell$-smoothness to improve upon the estimate in @prop-tangent.

#lemma[
  Let $f$ be convex and $ell$-smooth.
  Then, $
    f(x) - f(y) <= grad(f)(x)^top (x - y) - 1/(2ell) norm(grad(f)(x) - grad(f)(y))^2.
  $
] <lem-lsmooth-convex>
#proof[
  Set $z = y + (grad(f)(x) - grad(f)(y))\/ell$.
  Using @prop-tangent, @lem-lsmooth, $
    f(x) - f(y)
      &=  (f(x) - f(z)) + (f(z) - f(y)) \
      &<= grad(f)(x)^top (x - z) + grad(f)(y)^top (z - y) + ell/2 norm(z - y)^2 \
      &=  grad(f)(x)^top (x - y) + (grad(f)(y) - grad(f)(x))^top (z - y) + ell/2 norm(z - y)^2 \
      &=  grad(f)(x)^top (x - y) - 1/ell norm(grad(f)(x) - grad(f)(y))^2 + 1/(2ell) norm(grad(f)(x) - grad(f)(y))^2 \
      &=  grad(f)(x)^top (x - y) - 1/(2ell) norm(grad(f)(x) - grad(f)(y))^2. #qedhere
  $
]

#corollary[
  Let $f$ be convex and $ell$-smooth.
  Then, $
    (grad(f)(x) - grad(f)(y))^top (x - y) >= 1/ell norm(grad(f)(x) - grad(f)(y))^2.
  $
] <cor-lsmooth-convex>


#theorem[
  Let $f$ be convex and $ell$-smooth, $x^* in RR^d$ be its global minimizer.
  Further let ${x_t}_(t in NN)$ be iterates of @al-GD[] with $eta = 1\/ell$.
  Then, $
    norm(x_(t + 1) - x^*) <= norm(x_t - x^*)
  $ for all $t in NN$.
] <thm-GD-step>
#proof[
  Using $grad(f)(x^*) = 0$ and @cor-lsmooth-convex, $
    norm(x_(t + 1) - x^*)^2
      &=  norm(x_(t + 1) - x_t)^2 + 2(x_(t + 1) - x_t)^top (x_t - x^*) + norm(x_t - x^*)^2 \
      &=  1/ell^2 norm(grad(f)(x_t))^2 - 2/ell grad(f)(x_t)^top (x_t - x^*) + norm(x_t - x^*)^2 \
      &<= 1/ell^2 norm(grad(f)(x_t))^2 - 2/ell^2 norm(grad(f)(x_t))^2 + norm(x_t - x^*)^2 \
      &=  -1/ell^2 norm(grad(f)(x_t))^2 + norm(x_t - x^*)^2 \
      &<= norm(x_t - x^*)^2. #qedhere
  $
]

#remark[
  This remains true with @al-PGD[] as long as $x^* in interior(KK)$, via $
    norm(x_(t + 1) - x^*)
      = norm(Pi_KK (y_(t + 1)) - x^*)
      <= norm(y_(t + 1) - x^*).
    $
]

#theorem[
  Let $f$ be convex and $ell$-smooth, $x^* in RR^d$ be its global minimizer,
  and $norm(x_1 - x^*) <= R$.
  Further let $x_1, ..., x_T$ be $T$ iterates of @al-GD[] with $eta = 1\/ell$.
  Then, $
    f(x_T) - f(x^*) <= (2 R^2 ell)/(T - 1).
  $
] <thm-GD-lsmooth>
#proof[
  Using @lem-lsmooth, note that $
    f(x_(t + 1)) - f(x_t)
      &<= grad(f)(x_t)^top (x_(t + 1) - x_t) + ell/2 norm(x_(t + 1) - x_t)^2 \
      &=  -1/(2ell) norm(grad(f)(x_t))^2.
  $ Setting $delta_t = f(x_t) - f(x^*)$, this reads $
    delta_(t + 1) <= delta_t - 1/(2ell) norm(grad(f)(x))^2. 
  $ Now, $
    delta_t
      &<= grad(f)(x_t)^top (x_t - x^*)
      &<= norm(grad(f)(x_t)) norm(x_t - x^*)
      &<= norm(grad(f)(x_t)) norm(x_1 - x^*),
  $ with the last inequality guaranteed by @thm-GD-step.
  Setting $w = 1\/ 2ell norm(x_1 - x^*)^2$, this is $norm(grad(f)(x_t))^2 \/
  2ell >= w delta_t^2$.
  Thus, $delta_(t + 1) <= delta_t - w delta_t^2$, which rearranges to $
    1/delta_(t + 1) - 1/delta_t >= w delta_t / delta_(t + 1) >= w.
  $ Summing over $t$ gives $1 \/ delta_T >= w(T - 1)$, which is the desired estimate.
]
#remark[
  We have shown that $
    1/ell norm(grad(f)(x_t))^2
      <=f(x_t) - f(x_(t + 1))
      <=  1/(2ell) norm(grad(f)(x_t))^2.
  $
]
