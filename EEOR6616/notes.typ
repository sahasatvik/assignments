#import "template.typ": plain, contents
#import "theorems.typ": *
#import "defs.typ": *


#show: plain.with(
  suptitle: [
    *EEOR6616*
  ],
  title: [
    Convex Optimization
  ],
  author: "Satvik Saha",
  author-show: [
    #set footnote(numbering: "*")
    #set strong(delta: 100)
    _Instructed by *Prof.~Tianyi Lin*_~#footnote[
      Department of Industrial Engineering and Operations Research (IEOR), Columbia University
    ]
    #v(-0.4em)
    _Transcribed by *Satvik Saha*_~#footnote[
      Department of Statistics, Columbia University
    ]
  ],
  primary: rgb("#8EACCD").darken(5%),
  secondary: rgb("#8EACCD").darken(30%),
  footer-left: [
    EEOR6616: Convex Optimization
  ],
)

#set heading(numbering: "1.")
#show heading.where(level: 1): h => block(above: 2em, below: 1em, h)
#show heading.where(level: 2): h => block(above: 2em, below: 1em, h)
#show enum: it => pad(left: 1em, it)
#show math.equation: set block(breakable: true)

#show: thm-rules.with(qed-symbol: $square$)


#v(-0.2in)
#contents()
#v(0.3in)


///////////////////////////////////////////////////////////////////////////////


= Basic Definitions

== Convex Sets and Functions


#definition("Convex Set")[
  We say that $KK subset.eq RR^d$ is convex if $
    lambda x + (1 - lambda) y in KK
  $ for all $x, y in KK$ and $lambda in [0, 1]$.
]

#example[
  All linear subspaces of $RR^d$ are convex sets.
]

#example[
  Consider points $x_1, ..., x_n in RR^d$.
  Their _convex hull_, described by $
    "conv"(x_1, ..., x_n) = {lambda_1 x_1 + ... + lambda_n x_n: lambda_1, ..., lambda_n >= 0, #h(0.5em) sum_(i = 1)^n lambda_i = 1},
  $ is a convex set.
  In fact, it is the smallest convex set containing $x_1, ..., x_n$.
]

#definition("Convex Function")[
  We say that $f: KK -> RR$ is convex if $KK$ is convex, and $
    f(lambda x + (1 - lambda) y) <= lambda f(x) + (1 - lambda) f(y)
  $ for all $x, y in KK$ and $lambda in [0, 1]$.
]

#example[
  The map $x mapsto x^2$ is convex.
]

#example[
  Indicator functions of convex sets are convex.
  The indicator function of $XX subset.eq RR^d$ is given by $
    I_XX: RR^d -> overline(RR), quad quad
    x mapsto cases(
      0 quad&"if" x in XX,
      oo &"if" x in.not XX
    ).
  $
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
] <prop-convex-epigraph>
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


From now on, we will always assume that $f:KK -> RR$ is differentiable, unless
stated otherwise.
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



== Projections

#definition[
  We say that $z$ is a projection of a point $y$ onto a set $XX$ if $z in XX$
  and $norm(y - z) <= norm(y - x)$ for all $x in XX$.
]

In other words, $z$ is a projection of $y$ onto $XX$ when $z in argmin_(x in
XX) norm(y - x)$.
In general, such projections of points need not exist!
For instance, one can argue that a projection of $y in.not XX$ onto $XX$ cannot
lie in the interior of $XX$: given $z in B_delta (z) subset.eq interior(XX)$,
set $z_t = z + t(y - z) in XX$ with $t = delta \/ (2norm(y - z))$, whence
$norm(y - z_t) = (1 - t) norm(y - z) < norm(y - z)$.

#example[
  Consider the open unit disk $DD^2 = {x in RR^2 : norm(x) < 1}$ in $RR^2$.
  Projections of points outside $DD^2$ onto $DD^2$ do not exist.
]

In Euclidean spaces $RR^d$, we may observe that closedness of (nonempty) $XX$
guarantees the existence of a projection of $y in RR^d$ onto $XX$.
By picking some $x_0 in XX$, we need only look at the compact set $XX inter
overline(B_r (y))$ where $r = norm(y - x_0)$, on which the continuous map $x
mapsto norm(y - x)$ must attain its minimum.

On the other hand, projections of points need not be unique.

#example[
  Consider the unit circle $S^1 = {x in RR^2 : norm(x) = 1}$ in $RR^2$.
  Then, every point in $S^1$ is a projection of $0 in RR^2$ onto $S^1$.
]

The following theorem establishes the existence and uniqueness of projections
onto closed convex sets in any Hilbert space; we focus on Euclidean spaces
$RR^d$ for simplicity.

#theorem("Hilbert Projection")[
  Let $KK subset.eq RR^d$ be closed and convex.
  Then, for each $y in RR^d$, there exists a unique projection of $y$ onto
  $XX$.
] <thm-hilbert-projection>
#proof[
  Set $delta = inf_(x in KK) norm(x - y)$ and pick a sequence $\{z_n\} subset
  KK$ such that $norm(z_n - y) -> delta$.
  Note that $(z_n + z_m)\/2 in KK$; the parallelogram law gives $
    norm(z_n - z_m)^2
      &=  2norm(z_n - y)^2 + 2norm(z_m - y)^2 - 4norm((z_n + z_m)\/2 - y)^2 \
      &<= 2norm(z_n - y)^2 + 2norm(z_m - y)^2 - 4delta^2.
  $ Since this goes to $0$ as $m, n -> oo$, $\{z_n\}$ is Cauchy and hence has a
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
  The projection operator onto $KK$ is defined by $
    Pi_KK: RR^d -> KK, quad quad
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



== Normals

A very useful property of closed convex sets $KK$ is that given a point $w
in.not K$, one can find a hyperplane separating $w$ from $KK$.
In other words, there exists a continuous linear functional $g$ and a constant
$a$ such that $g(x) < a < g(w)$ for all $x in KK$.

#theorem("Strict Separation")[
  Let $w in.not KK$ for closed convex $KK$.
  There exists $v != 0$ such that $
    sup_(x in KK) ip(v, x) < ip(v, w).
  $
] <thm-separation>
#proof[
  Set $v = w - Pi_KK (w)$. Then, @prop-variational gives $
    ip(v, x - (w - v))
      = ip(w - Pi_KK (w), x - Pi_KK (w))
      <= 0,
  $ for all $x in KK$, which rearranges into $
    ip(v, x) + norm(v)^2 <= ip(v, w). #qedhere
  $
]


#definition("Normal")[
  Let $x in KK$ for closed convex $KK$.
  We say that $v$ is normal to $KK$ at $x$ if $ip(v, y) <= ip(v, x)$ for all $y
  in KK$.
]

#definition("Normal Cone")[
  Let $x in KK$ for closed convex $KK$.
  The normal cone $N_KK (x)$ at $x$ is the collection of normals to $KK$ at $x$.
]

Note that if $v$ is normal to $KK$ at $x$, so is $alpha v$ for $alpha >= 0$,
hence $N_KK (x)$ is indeed a cone; it is also convex.
Furthermore, $N_KK (x)$ is nontrivial only when $x in.not interior(X)$; if $x
in B_delta (x) subset.eq KK$, then for any $v$ with $norm(v) = 1$, we have $x
plus.minus delta/2 v in B_delta (x) subset.eq KK$, and $
  ip(v, x - delta/2  v)
    = ip(v, x) - delta/2
    < ip(v, x)
    < ip(v, x) + delta/2
    = ip(v, x + delta/2 v).
$ Thus, we need only look at normal cones at boundary points $x in boundary(KK)$.
At these points, nonzero $v in N_KK (x)$ describe _supporting hyperplanes_ to
$KK$ at $x$.

#proposition[
  Let $x in boundary(KK)$ for closed convex $K subset.eq RR^d$.
  Then, $N_KK (x)$ is nontrivial, i.e. there exists a supporting hyperplane to
  $KK$ at $x$.
] <prop-supporting-plane>
#proof[
  Pick a sequences ${x_n} subset.eq KK^c$ such that $x_n -> x$, and a
  corresponding sequence ${v_n} subset S^(d - 1)$ of directions via
  @thm-separation, such that $sup_(y in KK) ip(v_n, y) < ip(v_n, x_n)$.
  Using the compactness of $S^(d-1)$, descend to a subsequence and relabel so
  that $v_n -> v in S^(d - 1)$.
  Then, for $y in K$, we have $
    ip(v, y)
      = lim_(n -> oo) ip(v_n, y)
      <= lim_(n -> oo) ip(v_n, x_n)
      = ip(v, x). #qedhere
  $
]

// #proposition[
//   The normal cone $N_KK (x)$ is convex.
// ]

#proposition[
  Let $x in KK$ for closed convex $KK$, and let $v in N_KK (x)$.
  Then, $Pi_KK (x + alpha v) = x$ for all $alpha >= 0$.
]
#proof[
  For all $y in KK$, we have $
    ip(x - (x + alpha v), x - y)
      = alpha ip(v, y - x)
      <= 0,
  $ whence $x = Pi_KK (x + alpha v)$ by @prop-variational.
]



= The Convex Optimization Problem

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
$] <op-K>

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

#corollary[
  Local minimizers of convex functions are global minimizers.
]



= Gradient Descent

Gradient descent algorithms for solving @op-unconstrained[] follow the
iterative scheme #eq($(cal("GD"))$)[$
  x_(t + 1) = x_t - eta_t grad(f)(x_t).
$] <al-GD>

It is possible for @al-GD[] to take our iterates $x_t$ outside $KK$; we can
rectify this using projections.
Projected gradient descent algorithms for solving @op-K[] follow the iterative
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
  Further let $\{x_t\}_(t in NN)$ be iterates of @al-GD[] with $eta = 1\/ell$.
  Then, $
    norm(x_(t + 1) - x^*) <= norm(x_t - x^*)
  $ for all $t in NN$.
] <thm-GD-lsmooth-step>
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

// #remark[
//   This remains true with @al-PGD[] as long as $x^* in interior(KK)$, via $
//     norm(x_(t + 1) - x^*)
//       = norm(Pi_KK (y_(t + 1)) - x^*)
//       <= norm(y_(t + 1) - x^*).
//     $
// ]

#theorem[
  Let $f$ be convex and $ell$-smooth, $x^* in RR^d$ be its global minimizer,
  and $norm(x_1 - x^*) <= R$.
  Further let $x_1, ..., x_T$ be $T$ iterates of @al-GD[] with $eta = 1\/ell$.
  Then, $
    f(x_T) - f(x^*) <= (2 ell R^2)/(T - 1).
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
  $ with the last inequality guaranteed by @thm-GD-lsmooth-step.
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


== $alpha$-strong Convexity

#definition([$alpha$-strong Convex Function])[
  We say that convex differentiable $f$ is $alpha$-strongly convex for $alpha
  >= 0$ if $
    f(y) >= f(x) + grad(f)(x)^top (y - x) + alpha/2 norm(y - x)^2
  $ for all $x, y in KK$.
]

#remark[
  This is often presented as $
    f(x) - f(y) <= grad(f)(x)^top (x - y) - alpha/2 norm(x - y)^2.
  $ Thus, $alpha$-strong convexity is a strengthening of the gradient
  inequality (@prop-convex-gradient).
]

#example[
  All convex functions are '$0$-strongly convex'.
]


We can improve upon @thm-PGD-Lipschitz and @thm-GD-lsmooth-step dramatically
with this added assumption.


#theorem[
  Let $f$ be $alpha$-strongly convex and $L$-Lipschitz, and let $x^* in KK$ be
  its global minimizer.
  Further let $x_1, ..., x_T$ be $T$ iterates of @al-PGD[] with $eta_t = 2\/
  (alpha(t + 1))$.
  Then, $
    f(sum_(t = 1)^T t / (T(T + 1)\/2) thin x_t) - f(x^*) <= (2L^2)/(alpha(T + 1)).
  $
] <thm-PGD-Lipschitz-strong>




Note that when $f$ is both $alpha$-strongly convex and $ell$-smooth, we have $
  alpha/2 norm(y - x)^2 <= f(y) - f(x) - grad(f)(x)^top (y - x) <= ell/2 norm(y - x)^2.
$ This also justifies that $alpha <= ell$.

#lemma[
  Let $f$ be $alpha$-strongly convex and $ell$-smooth, and let $x^+ = x - 1/ell
  grad(f)(x)$.
  Then, $
    f(x^+) - f(y) <= grad(f)(x)^top (x - y) - 1/(2ell) norm(grad(f)(x))^2 - alpha/2 norm(x - y)^2.
  $
] <lem-lsmooth-strong-convex>
#proof[
  Write $
    f(x^+) - f(y)
      &= (f(x^+) - f(x)) + (f(x) - f(y)) \
      &<= grad(f)(x)^top (x^+ - x) + ell/2 norm(x^+ - x)^2 + grad(f)(x)^top (x - y) - alpha / 2 norm(x - y)^2 \
      &= -1/ell norm(grad(f)(x))^2 + 1/(2ell) norm(grad(f)(x))^2 + grad(f)(x)^top (x - y) - alpha/2 norm(x - y)^2 \
      &= - 1/(2ell) norm(grad(f)(x))^2 + grad(f)(x)^top (x - y) - alpha/2 norm(x - y)^2 #qedhere
  $
]

#theorem[
  Let $f$ be $alpha$-strongly convex and $ell$-smooth, and let $x^* in RR^d$ be
  its global minimizer.
  Further let $\{x_t\}_(t in NN)$ be iterates of @al-GD[] with $eta = 1\/ell$.
  Then, $
    norm(x_(t + 1) - x^*)^2 <= e^(-t alpha \/ ell) thin norm(x_1 - x^*)^2
  $ for all $t in NN$.
] <thm-GD-lsmooth-strong-step>
#proof[
  Write $
    norm(x_(t + 1) - x^*)^2
      &= norm(x_(t + 1) - x_t)^2 + norm(x_t - x^*)^2 + 2 (x_(t + 1) - x_t)^top (x_t - x^*) \
      &= 1/(ell^2) norm(grad(f)(x_t))^2 + norm(x_t - x^*)^2 - 2/ell grad(f)(x_t)^top (x_t - x^*) \
      &<= 1/(ell^2) norm(grad(f)(x_t))^2 + norm(x_t - x^*)^2 \
        &#h(2em) - 2/ell [f(x_(t + 1)) - f(x^*) + 1/(2 ell) norm(grad(f)(x_t))^2 + alpha/2 norm(x_t - x^*)^2] #tag[(@lem-lsmooth-strong-convex)]\
      &<= norm(x_t - x^*)^2 - alpha/ell norm(x_t - x^*)^2 #tag[($f(x_(t + 1)) >= f(x^*)$)] \
      &= (1 - alpha/ell) thin norm(x_t - x^*)^2.
  $ Iterating and using $1 - s <= e^(-s)$, we have $
    norm(x_(t + 1) - x^*)^2
      <= (1 - alpha/ell)^t thin norm(x_1 - x^*)^2
      <= e^(-t alpha\/ell) thin norm(x_1 - x^*)^2. #qedhere
  $
]

A version of the above still holds with regards to @al-PGD[].

The quantity $kappa = ell \/ alpha >= 1$, called the _conditional number_,
controls the rate of convergence of @al-GD[].
Convergence is especially slow when $kappa$ is very high.


#example[
  Let $f(x) = 1/2 x^top A x$ for positive definite $A$.
  Then, $ell$ and $alpha$ are the largest and smallest eigenvalues of $A$
  respectively.
]





= Momentum-Based Gradient Descent


== Polyak's Heavy Ball Method

Polyak's heavy ball method follows the iterative scheme
#eq([(HB-$cal("GD")$)])[$
  x_(t + 1) &= x_t - eta_t grad(f)(x_t) + beta_t (x_t - x_(t - 1)).
$] <al-HBGD>


#remark[
  The @al-HBGD[] method can be viewed as a discretized version of the _heavy
  ball flow_ $
    dot.double(x) + gamma dot(x) = -grad(f)(x).
  $
]

#lemma[
  Given $M in RR^(d times d)$ and $epsilon > 0$, there exists a norm
  $norm(cdot)_epsilon$ such that $norm(M)_epsilon <= rho(M) + epsilon$, where $
    rho(M) = max{|lambda_1|, .., |lambda_n|}
  $ is the _spectral radius_ of $M$, and $lambda_1, ..., lambda_n$ are the
  eigenvalues of $M$.
] <lem-matrix-norm>
#remark[
  Recall that every norm $norm(cdot)$ on $RR^d$ naturally induces a
  matrix norm $
    norm(M) = sup {norm(M x) : norm(x) = 1}
  $ on $RR^(d times d)$.
  The spectral radius satisfies $rho(A) <= norm(A)$ for every natural matrix
  norm $norm(cdot)$.
  The above lemma shows that $
    rho(M) = inf {norm(M): norm(cdot) " is a matrix norm"}.
  $
]

#theorem[
  Let $f(x) = 1/2 x^top A x$ for positive definite $A in RR^(d times d)$, and
  let $\{x_t\}_(t in NN)$ be iterates of @al-HBGD[] with $
    eta = (2/(sqrt(ell) + sqrt(alpha)))^2, quad
    beta = ((sqrt(kappa) - 1) / (sqrt(kappa) + 1))^2, quad
    kappa = ell / alpha,
  $ where $ell, alpha$ are the largest and smallest eigenvalues of $A$.
  Then, for every $epsilon > 0$, there exists a norm $norm(cdot)_epsilon$ such
  that $
    norm(vec(x_(t + 1), x_t))_epsilon
      <= (sqrt(beta) + epsilon)^t thin norm(vec(x_1, x_0))_epsilon
  $ for all $t in NN$.
] <thm-HBGD>
#proof[
  Note that $grad(f)(x) = A x$, so the @al-HBGD[] updates read $
    x_(t + 1)
      &= x_t - eta A x_t + beta (x_t - x_(t - 1))
      &= ((1 + beta)I_d - eta A)x_t - beta x_(t - 1),
  $ which can be rewritten as $
    vec(x_(t + 1), x_t)
      = mat((1 + beta) I_d - eta A, -beta I_d; I_d, 0) vec(x_t, x_(t - 1)).
  $ Notate this as $
    X_(t + 1) = B X_t = B^t X_1.
  $
  Since $product_j |nu_j| = |det(B)| = beta^d$ for eigenvalues $\{nu_j\}_(j =
  1)^(2d)$ of $B$, we must have $rho(B) = max_j |nu_j| >= sqrt(beta)$.
  The eigenvalue equation for $B$ reads $
    B vec(y, z) = vec((1 + beta)y - eta A y - beta z, y) = nu vec(y, z) quad <==> quad
    cases(eta nu A z = (beta + (1 + beta) nu - nu^2) z, y = nu z).
  $ Thus, the eigenvalues $\{lambda_i\}_(i = 1)^d$ of $A$ and $\{nu_(2i - 1),
  nu_(2i)\}_(i = 1)^d$ of $B$ are related via $eta lambda nu = beta + (1 +
  beta) nu - nu^2$, or $
    nu_(2i - 1, 2i)
      = 1/2 (1 + beta - eta lambda_i plus.minus sqrt((1 + beta - eta lambda_i)^2 - 4 beta)).
  $ Note that when $Delta_i = (1 + beta - eta lambda_i)^2 - 4 beta <= 0$, we
  have $|nu_(2i - 1)| = |nu_(2i)| = sqrt(beta)$.
  Thus, for $rho(B)$ to achieve the lower bound $sqrt(beta)$, we need $(1 -
  sqrt(beta))^2 <= eta lambda_i <= (1 + sqrt(beta))^2$ for all $i$, which holds
  when $
    (1 - sqrt(beta))^2 <= eta alpha <= eta ell <= (1 + sqrt(beta))^2.
  $ Plugging in our choice of $eta, beta$, this is indeed true.

  We now have $rho(B) = sqrt(beta)$.
  Pick a norm $norm(cdot)_epsilon$ such that $norm(B)_epsilon <= sqrt(beta) +
  epsilon$ using @lem-matrix-norm, whence $
    norm(X_(t + 1))_epsilon 
      <= norm(B^t)_epsilon norm(X_1)_epsilon
      <= (sqrt(beta) + epsilon)^t thin norm(X_1)_epsilon. #qedhere
  $
]

#remark[
  Given $f(x) = 1/2 (x - x^*)^top A(x - x^*)$ for positive definite, symmetric
  $A$, set $y = P(x - x^*)$ where $A = P^top Lambda P$ is the diagonalization
  of $A$.
  Minimizing $f$ is now equivalent to minimizing $g(y) = y^top Lambda y$.
]


== Nesterov's Accelerated Gradient Descent

Nesterov's accelerated gradient descent follows the iterative scheme
#eq([(N-$cal("AGD"))$])[$
  y_t &= x_t + beta_t (x_t - x_(t - 1)), \
  x_(t + 1) &= y_t - eta_t grad(f)(y_t).
$] <al-NAGD>


#theorem[
  Let $f$ be $alpha$-strongly convex and $ell$-smooth, and let $x^*$ be its
  global minimizer.
  Further let $\{x_t\}_(t in NN)$ be iterates of @al-NAGD[] with $
    eta = 1/ell, quad
    beta = (sqrt(kappa) - 1) / (sqrt(kappa) + 1), quad
    kappa = ell/alpha.
  $ Then, $
    f(x_t) - f(x^*) <= (1 - 1/sqrt(kappa))^t ((l + m) / 2) thin norm(x_0 - x^*)^2
  $ for all $t in NN$.
] <thm-NAGD>


#theorem[
  Let $f$ be convex and $ell$-smooth, $x^*$ be its global minimizer, and
  $norm(x_0 - x^*) <= R$.
  Further let $x_1, ..., x_T$ be $T$ iterates of @al-NAGD[] with $
    eta = 1/ell, quad
    lambda_(t + 1) = (1 + sqrt(1 + 4lambda_t^2))/2, quad
    beta_(t + 1) = (lambda_t - 1) / (lambda_(t + 1)),
  $ where $lambda_0 = beta_0 = 0$.
  Then, $
    f(x_T) - f(x^*) <= (2 ell R^2) / T^2.
  $
] <thm-NAGD-variable-momentum>




= Subdifferentials

#definition("Subdifferential")[
  Let $f: KK -> RR$ be convex.
  The subdifferential of $f$ at $x in KK$ is the collection of all directions
  $v$ such that $
    f(y) >= f(x) + v^top (y - x)
  $ for all $y in KK$, and is denoted $subgrad(f)(x)$.
]

Compare with the gradient inequality (@prop-tangent) for differentiable convex $f$.

#example[
  Consider $f: RR -> RR$, $x mapsto |x|$.
  Then, $
    subgrad(f)(x) = cases(
      {-1} #h(1.5em)& "if "x < 0,
      [-1, 1] & "if "x = 0,
      {+1} & "if "x > 0
    )
  $
]

#example[
  Consider $f: RR^d -> RR$, $x mapsto norm(x)_1 = sum_(i = 1)^d |x_i|$.
  Then, $
    subgrad(f)(x) = {v : v_i in subgrad(|x_i|) "for all" 1 <= i <= d}.
  $
]

#example[
  Let $KK$ be closed and convex.
  The subdifferential of the indicator function $I_KK$ at $x in KK$ is the
  normal cone $N_KK (x)$.
]


It is clear that the subdifferential $subgrad(f)(x)$ is closed and convex.
Showing that it is nontrivial requires more work.

#proposition[
  Let $f: KK -> RR$ be convex.
  Then, $subgrad(f)(x)$ is nonempty for all $x in relinterior(KK)$.
]
#proof[
  Note that $epi(f)$ is convex via @prop-convex-epigraph.
  Use @prop-supporting-plane to find a supporting hyperplane to $epi(f)$ at
  $\(x^top thin f(x)\)^top$, i.e. $\(v^top thin s\)^top != 0$ such that for all
  $\(y^top thin alpha\)^top in epi(f)$, $
    v^top (y - x) + s(alpha - f(x)) <= 0.
  $ By considering $y = x$ and $alpha > f(x)$, we must have $s <= 0$.
  If $s = 0$, we would need $v^top (y - x) <= 0$ for all $y in KK$, which would
  force $v = 0$ since $x in relinterior(KK)$.
  Thus, $s < 0$; putting $alpha = f(y)$, we have $
    f(y) >= f(x) - v^top / s (y - x),
  $ whence $-v^top\/s in subgrad(f)(x)$.
]

The next result follows immediately from the definition of the subdifferential;
compare this with @prop-convex-gradient.

#proposition[
  Let $f: KK -> RR$ be convex.
  Then, $x^* in KK$ is a global minimizer of $f$ if and only if $0 in subgrad(f)(x^*)$.
] <prop-convex-subgradient>


When $f$ is differentiable at $x in interior(XX)$, the subdifferential reduces
to the usual gradient, with $subgrad(f)(x) = {grad(f)(x)}$.
Indeed, @prop-tangent shows that $grad(f)(x) in subgrad(f)(x)$.
To check that there are no other elements, pick $v in subgrad(f)(x)$, and note
that for $lambda >= 0$, $
  v^top u
    <= (f(x + lambda u) - f(x))/lambda
    -> grad(f)(x)^top u quad "as" lambda -> 0,
$ hence $(grad(f)(x) - v)^top u >= 0$ for all directions $u$.
This forces $v = grad(f)(x)$.

The converse of the above result also holds, in the following form.

#theorem[
  Let $f: KK -> RR$ be convex and $x in interior(KK)$.
  If $f$ is differentiable at $x$, then $subgrad(f)(x) = {grad(f)(x)}$.
  Conversely, if $subgrad(f)(x) = {v}$, then $f$ is differentiable at $x$ with
  $grad(f)(x) = v$.
]
#proof[
  See @rockafellar-1970[Theorem 25.1].
]

#example[
  Let $f_1, f_2$ be convex and differentiable, and let $f = max{f_1, f_2}$.
  At points $x$ where $f_1 (x) != f_2 (x)$, we have $subgrad(f)(x) =
  {grad(f)(x)}$.
  Otherwise, $subgrad(f)(x) = "conv"(grad(f_1)(x), grad(f_2)(x))$.
]


#lemma[
  + $subgrad((alpha f)) = alpha thin (subgrad(f))$ for $alpha > 0$.
  + $subgrad((f_1 + f_2)) = subgrad(f_1) + subgrad(f_2)$.
  + $subgrad(g)(x) = A^top subgrad(f)(A x + b)$ for $g(x) = f(A x + b)$.
]

#lemma[
  Let $f = max{f_1, ..., f_n}$. Then, $
    subgrad(f)(x) = "conv"( union.big_(i : f(x) = f_i (x)) subgrad(f_i)(x))
  $
]


== Subgradient Descent

The subgradient descent algorithm follows the iterative scheme
#eq([($cal("SGD")$)])[$
  x_(t + 1) = x_t - eta_t v_t, quad v_t in subgrad(f)(x_t).
$] <al-SGD>

#theorem[
  Let $f$ be convex and $L$-Lipschitz, $x^*$ be its global minimizer, and
  $norm(x_1 - x^*) <= R$.
  Further let $x_1, ..., x_T$ be $T$ iterates of @al-SGD[].
  Then, $
    min_(1 <= t <= T) f(x_t) - f(x^*)
      <= (R^2 + L^2 sum_(t = 1)^T eta_t^2)/(2 sum_(t = 1)^T eta_t).
  $
]
#proof[
  Write $
    norm(x_(t + 1) - x^*)
      &= norm(x_t - x^*)^2 - 2 eta_t v_t^top (x_t - x^*) + eta_t^2 norm(v_t^2) \
      &<= norm(x_t - x^*)^2 - 2 eta_t (f(x_t) - f(x^*)) + eta_t^2 L^2.
  $ This gives $
    2(sum_(t = 1)^T eta_t) (min_(1 <= t <= T) f(x_t) - f(x^*))
      &<= sum_(t = 1)^T 2 eta_t (f(x_t) - f(x^*)) \
      &<= norm(x_1 - x^*)^2 - norm(x_(T + 1) - x^*)^2 + sum_(t = 1)^T eta_t^2 L^2 \
      &<= R^2 + L^2 sum_(t = 1)^T eta_t^2. #qedhere
  $
]

#remark[
  We would like $sum_t eta_t -> oo$ while $sum_t eta_t^2 < oo$; this is
  achieved by step sizes of the form $eta_t = 1 \/ t$.
]


= Exponential Gradient Descent

Consider the standard $d$-simplex $
  Delta^d = {x in RR^d : sum_(i = 1)^d x_i = 1, x_i >= 0 "for all" 1 <= i <= d}.
$ Members of $Delta^d$ can be naturally identified with discrete probability
distributions on ${1, ..., k}$.
Given convex $f$, we examine the optimization problem #eq($(cal(M)_(Delta^d))$)[$
  min_(x in Delta^d) f(x).
$] <op-simplex>

The exponential gradient descent algorithm follows the iterative scheme
#eq([($cal("EGD")$)])[$
  z^((t)) &= sum_(i = 1)^d x^((t))_i thin e^(- eta grad(f)\(x^((t))\)_i), \
  x^((t + 1))_i &= 1/(z^((t))) thick x^((t))_i thin e^(- eta grad(f)\(x^((t))\)_i)
$] <al-EGD>


Since we are effectively dealing with probability distributions, we will use
the Kullback-Leibler divergence instead of a Euclidean norm to describe
convergence in $Delta^d$.


#definition("Kullback-Leibler Divergence")[
  The Kullback-Leibler (KL) divergence of $p in Delta^d$ with respect to $q in
  Delta^d$ is defined by $
    KL(p, q)
      = EE_p [log(p/q)]
      = sum_(i = 1)^d p_i log(p_i / q_i).
  $
]

Note that for any $x^* in Delta^d$, the concavity of the logarithm gives $
  KL(x^*, 1/d bold(1))
    = sum_(i = 1)^d x^*_i log(x^*_i cdot d)
    <= log(sum_(i = 1)^d (x^*_i)^2 d)
    <= log(d).
$ This is often useful in bounding the 'diameter' of $Delta^d$.


#lemma[
  For iterates of @al-EGD[], $
    KL(x^*, x^((t))) - KL(x^*, x^((t + 1)))
      = -eta grad(f)(x^((t)))^top x^* - log(z^((t))).
  $
] <lem-EGD-KL>


#theorem[
  Let $f$ be convex such that $norm(grad(f))_oo <= ell$ on $Delta^d$, and let
  $x^* in KK$ be its global minimizer.
  Further let $x^((1)), ..., x^((T))$ be $T$ iterates of @al-EGD[] with $
    eta = 1/ell sqrt(log(d) / T), quad
    x^((1)) = 1/d bold(1).
  $ Then, $
    f(1/T sum_(t = 1)^T x^((t))) - f(x^*)
      <= 2 ell sqrt(log(d) / T).
  $
]
#proof[
  It will suffice to show that $
    sum_(t = 1)^T grad(f)(x^((t)))^top (x^((t)) - x^*)
      <= KL(x^*, x^((1))) / eta + eta^2 ell T,
  $ from which the result will follow using @prop-jensen and @prop-tangent,
  much like in the proof of @thm-PGD-Lipschitz.
  Indeed, checking that $e^(-x) <= 1 + x + x^2$ for $x <= 1$ and noting that
  $eta norm(grad(f))_oo <= 1$ for sufficiently large $T$, $
    log(z^((t)))
      &= log(sum_(i = 1)^d x_i^((t)) e^(-eta (grad(f)(x^((t))))_i)) \
      &<= log(sum_(i = 1)^d x_i^((t)) (1 - eta grad(f)(x^((t)))_i + eta^2 grad(f)(x^((t)))_i^2 )) \
      &= log(1 - eta grad(f)(x^((t)))^top x^((t)) + sum_(i = 1)^d eta^2 grad(f)(x^((t)))_i^2 x_i^((t)) ) \
      &<= log(1 - eta grad(f)(x^((t)))^top x^((t)) + eta^2 ell^2 ) \
      &<= - eta grad(f)(x^((t)))^top x^((t)) + eta^2 ell^2.
  $ Thus, by @lem-EGD-KL, $
    eta grad(f)(x^((t)))^top (x^((t)) - x^*) - eta^2 ell^2
      &<= KL(x^*, x^((t))) - KL(x^*, x^((t + 1))).
  $ Summing over $t$ and rearranging gives the desired result.
]





// = Mirror Descent



#pagebreak()
#bibliography(
  "references.bib",
  style: "ieee",
  full: true,
)
