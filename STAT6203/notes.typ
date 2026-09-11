#import "template.typ": plain, contents
#import "@local/ctheorems:2.0.0": *
#import "defs.typ": *
#import "@preview/xarrow:0.3.1": xarrow   // stretch?


#show: plain.with(
  suptitle: [
    STAT6203: Theoretical Statistics III
  ],
  title: [
    Robust Statistics
  ],
  author: "Satvik Saha",
  author-show: [
    Instructed by _Prof.~Marco Avella Medina_ \
    Transcribed by _Satvik Saha_
    #v(0.5em)
  ],
  affiliation: [
    Department of Statistics, Columbia University
  ],
  primary: rgb("#8EACCD").darken(20%),
  secondary: rgb("#8EACCD").darken(30%),
  footer-left: [
    Robust Statistics
  ],
)

#set heading(numbering: "1.")
#show enum: it => pad(left: 1em, it)
#show math.equation: set block(breakable: true)

// #show bibliography: place.with(bottom, float: true)

#show: thm-rules.with(qed-symbol: $square$)


#contents()
#pagebreak()


///////////////////////////////////////////////////////////////////////////////



= Location estimation

Consider the problem of estimating an unknown location parameter $xi$ from a
sample $
  X_1, ..., X_n iid F(cdot - xi).
$ In general, we search for suitably _efficient_ estimators.
#pc[@huber-1964] seeks to obtain _robust_ (in a certain sense) estimators which
perform well when $F$ is only being approximately known; in particular, suppose
that $F$ is a slightly 'contaminated' version of a known distribution $F_0$.


#definition[Tukey-Huber Contamination][
  Given $eps in [0, 1]$ and a distribution $F_0$, define $
    cP_eps (F_0) := {(1 - eps) F_0 + eps H : "arbitrary distribution" H}.
  $
] <def:TH-contamination>


#remark[
  $cP_eps (F_0)$ is contained within the $eps$-Kolmogorov-Smirnov neighborhood
  of $F_0$: for any $F = (1 - eps) F_0 + eps H$, $
    norm(F - F_0)_oo
      = norm((1 - eps) F_0 + eps H - F_0)_oo
      = eps norm(H - F_0)_oo
      <= eps.
  $
]

With this, we may examine how an estimator based for a parameter of$F_0$
suffers under the contaminated sample from $F in cP_eps (F_0)$.
As a first step, we may look at some simple population-level functionals.

#example[
  Consider the mean functional $mu(G) := EE_G [X]$.
  The 'bias' of $mu$ on $F := (1 - eps) F_0 + eps H$ against $F_0$ is $
    mu(F) - mu(F_0) = eps mu(H) - eps mu(F_0).
  $ Note that this is completely unrestricted over $F in cP_eps (F_0)$ even if
  we fix $epsilon$, owing to the arbitrary nature of $H$ (which in principle
  may not even have a mean!).
]

#example[
  Consider the (left) median functional $m(G) := G^- (1/2) = inf{x : G(x) >=
  1/2}$, and let $eps < 1/2$.
  For $F := (1 - eps) F_0 + eps H$, note that $
      m(F) &= inf{x : (1 - eps) F_0(x) + eps H(x) >= 1/2}.
  $ Since $0 <= H(x) <= 1$, we can bound $
      F_0^- ((1/2 - eps) / (1 - eps))
        &= inf{x : (1 - eps) F_0(x) + eps >= 1/2} \
        &<= m(F) \
        &<= inf{x : (1 - eps) F_0(x) >= 1/2}
        = F_0^- ((1/2)/(1 - eps)).
  $ Unlike the previous example, the median $m(F)$ cannot deviate arbitrarily
  over $F in cP_eps (F_0)$.
] <ex:median-bias>


~
== Minimax Asymptotic Bias

For the purposes of location estimation, it is natural to restrict ourselves to
_translation invariant_ estimators.

#definition[Translation Invariant Estimators][
  We say that an estimator $T$ is translation invariant if $T(X + a bold(1)) =
  T(X) + a$ for all samples $X$ and $a in RR$.
  We denote the class of all translation invariant estimators by $cT$.
]

#definition[Asymptotic Bias][
  Let ${T_n}$ be a sequence of estimators for $T(F_0)$.
  Its asymptotic bias is defined as $
    b({T_n}, F) := limsup_(n -> oo) thin lr(|EE_F [T_n] - T(F_0)|).
  $
]

We can now choose our 'best' estimator on the basis of asymptotic bias; fix
$eps > 0$ and consider the minimax problem $
  b_* := min_({T_n} subset cT) max_(F in cP_eps (F_0)) b({T_n}, F).
$

#theorem[
  Let $F_0$ have a density that is symmetric about zero and decreasing on
  $RR_+$, and let $T(F_0) = 0$.
  The sample medians ${M_n}$ solve the minimax asymptotic bias problem, with $
    min_({T_n} subset cT) max_(F in cP_eps (F_0)) b({T_n}, F)
      = F_0^(-1)((1\/2) / (1 - eps)).
  $
]
#proof[
  First note that the sample median estimator is consistent, and $lim_(n -> oo)
  EE_F [M_n] = F^- (1/2)$ under some mild conditions on $F$.
  We have already demonstrated in @ex:median-bias that $|F^- (1/2)| <=
  F_0^(-1)((1\/2)/(1 - eps)) =: m_*$ for all $F in cP_eps (F_0)$, which gives
  us the upper bound $b_* <= m_*$.

  Next, we will construct two distributions $F_+, F_- in cP_eps (F_0)$, and
  use $
    b_* >= min_({T_n} subset cT) max(b({T_n}, F_+),thick b({T_n}, F_-))
      #tag[($star$)]
  $ to obtain the matching lower bound $b_* >= m_*$.
  Define $
    F_+(x) := cases(
      (1 - eps) F_0(x)  & "if" x < m_*\,,
      1 - (1 - eps) F_0(2m_* - x) & "if" x >= m_*.
    )
  $ This describes a distribution which has the same shape as $F_0$ on $(-oo,
  m_*)$, and is symmetric about $m_*$.
  Further set $F_-(x) = F_+(x + 2m_*)$, which is symmetric about $-m_*$.
  We can verify that $F_+, F_-$ are indeed members of $cP_eps (F_0)$; solving
  for $F_+ = (1 - eps)F_0 + eps H_+$ reveals that $
    H_+(x)
      = (F_+(x) - (1 - eps) F_0(x))/eps
      = (1 - (1 - eps)(F_0(x) + F_0(2m_* - x)))/eps bold(1)(x >= m_*).
  $ This is continuous with $H(-oo) = 0$, $H(oo) = 1$, and is nondecreasing
  since $
    F_0(x) + F_0(2m_* - x)
      = F_0(x) - F_0(x - 2m_*) + 1
  $ is decreasing on $x >= m_*$, which makes it a valid _cdf_.
  The argument for $F_-$, which is a reflection of $F_+$ about zero, is
  similar.

  Now, if $b_* < m_*$, then $m_*$ must be strictly greater than the right hand
  side of $(star)$, hence there exists a sequence ${T_n} subset cT$ such that $
    max(
      limsup_(n -> oo)thin |EE_(F_+) [T_n]|,quad
      limsup_(n -> oo)thin |EE_(F_-) [T_n]|
    ) < m_*.
  $ However, translation invariance of $T_n$ forces $EE_(F_+) [T_n] = EE_(F_-)
  [T_n] + 2m_*$, hence $
      2m_*
        = limsup_(n -> oo)thin |EE_(F_+) [T_n] - EE_(F_-) [T_n]|
        <= limsup_(n -> oo)thin |EE_(F_+) [T_n]| + limsup_(n -> oo)thin |EE_(F_-) [T_n]|
        < 2m_*,
  $ a contradiction!
]

#remark[
  Some further technical conditions are required to ensure that $EE_F [M_n] ->
  F^-(1/2)$, which we omit here.
]


~
== Minimax Asymptotic Variance

Instead of relying on asymptotic bias, we will now examine the asymptotic
variance of a special class of estimators.

#definition[$M$-estimator][
  We say that $T_n$ is an $M$-estimator of location if $
    T_n in argmin_t sum_(i = 1)^n rho(X_i - t)
  $ for some function $rho$.
  When $rho$ is differentiable, we denote $psi := rho'$, and $T_n$ equivalently
  satisfies $
    sum_(i = 1)^n psi(X_i - T_n) = 0.
  $
]

Note that $M$-estimators are automatically translation invariant.
We will generally assume that the loss function $rho$ is symmetric and convex
from now on.


#lemma[Asymptotic Normality of $M$-estimators][
  Let ${T_n}$ be the sequence of $M$ estimators associated with $psi$.
  Define the maps $lambda(t) := EE_F [psi(X - t)]$, $sigma^2 (t) := var_F
  [psi(X - t)]$, and suppose that there exists $t_0 in RR$ such that the
  following are satisfied.
  // + $psi$ is nondecreasing and sufficiently regular,
  // + $EE_F [psi(X - t)] > 0$ for all $t < t_0$,
  // + $EE_F [psi(X - t)] < 0$ for all $t > t_0$.
  + $lambda$ is continuous in a neighborhood of $t_0$, with $lambda(t_0) = 0$.
  + $lambda$ is differentiable at $t_0$, with $lambda'(t_0) < 0$.
  + $sigma^2$ is continuous, finite, non-zero in a neighborhood of $t_0$.
  Then $sqrt(n)(T_n - t_0) -->^d normal(0,thick V(psi, F))$, where $
    V(psi, F)
      := (sigma^2 (t_0))/(lambda'(t_0))^2
  $ is the asymptotic variance of ${T_n}$.
] <lem:M-normal>

#example[
  The $M$-estimator associated with $rho(x) = x^2$ is the sample mean, with
  asymptotic variance $var_F (X)$.
]

#example[
  The $M$-estimator associated with $rho(x) = |x|$ is the sample median, with
  asymptotic variance $1 \/ 4 (f(F^-(1/2)))^2$.
]

From now on, we will restrict ourselves to the contamination neighborhood $
  cP_eps^"sym" (F_0)
    := {(1 - eps) F_0 + eps H : "symmetric" H}
$ to ensure that $F in cP_eps^"sym" (F_0)$ is symmetric (about zero), and
further select $F_0 = Phi$.

Consider the problem $
  V_* := min_psi max_(F in cP_eps^"sym" (Phi)) V(psi, F),
$ where $psi$ ranges over functions satisfying the requirements of
@lem:M-normal, along with symmetry and convexity so that $t_0 = 0$.


#theorem[
  Define the Huber loss $
    rho_c (x) = cases(
      1/2 x^2 & "if" |x| < c\,,
      c|x| - 1/2 c^2 quad& "if" |x| >= c.
    )
  $ The sequence of $M$-estimators associated with $rho_c$ solve the minimax
  asymptotic variance problem when $c$ satisfies $
    2 (nphi(c)/c - Phi(c)) = eps / (1 - eps).
  $
] <thm:minimax-var>

#lemma[
  Suppose that $F_* in cP_eps^"sym" (Phi)$ has density $f_*$ such that $
    F_* in argmax_(F in cP_eps^"sym" (Phi)) V(psi_*, F_*)
  $ where $psi_* = -f'_* \/ f_*$.
  Then $psi_*$ solves the minimax asymptotic variance solution, and $
    min_psi max_(F in cP_eps^"sym" (Phi)) V(psi, F)
      = V(psi_*, F_*).
  $
]



#pagebreak()
#bibliography(
  "references.bib",
  style: "apa",
  full: true
)
#v(2em)
