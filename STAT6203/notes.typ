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
    Nonparametric Statistics
  ],
)

#set heading(numbering: "1.")
#show enum: it => pad(left: 1em, it)
#show math.equation: set block(breakable: true)

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
]


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
    b({T_n}, F) := |lim_(n -> oo) EE_F [T_n] - T(F_0)|.
  $
]

We can now choose our 'best' estimator on the basis of asymptotic bias; fix
$eps > 0$ and consider the minimax problem $
  min_({T_n} subset cT) max_(F in cP_eps (F_0)) b({T_n}, F).
$




#v(1fr)
#bibliography(
  "references.bib",
  style: "apa",
  full: true
)
#v(2em)
