#import "@preview/ctheorems:2.0.0": *
#import "@preview/xarrow:0.3.1": xarrow   // stretch?
#import "template.typ": plain, contents
#import "defs.typ": *

#import thm-state: *

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
#set math.cancel(stroke: red)

// #show bibliography: place.with(bottom, float: true)

#show: thm-rules.with(qed-symbol: $square$)


#contents()
#pagebreak()


///////////////////////////////////////////////////////////////////////////////



= Location Estimation

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

#definition[M-estimator of Location][
  We say that $T_n$ is an M-estimator of location if $
    T_n in argmin_t sum_(i = 1)^n rho(X_i - t)
  $ for some function $rho$.
  When $rho$ is differentiable, we denote $psi := rho'$, and $T_n$ equivalently
  satisfies $
    sum_(i = 1)^n psi(X_i - T_n) = 0.
  $
]

Note that M-estimators are automatically translation invariant.
We will generally assume that the loss function $rho$ is symmetric and convex
from now on.


#lemma[Asymptotic Normality of M-estimators][
  Let ${T_n}$ be the sequence of M estimators associated with $psi$.
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
  The M-estimator associated with $rho(x) = x^2$ is the sample mean, with
  asymptotic variance $var_F (X)$.
]

#example[
  The M-estimator associated with $rho(x) = |x|$ is the sample median, with
  asymptotic variance $1 \/ 4 (f(F^-(1/2)))^2$.
]

#example[
  The M-estimator associated with $rho(x) = - log f(x)$ is the MLE of $xi$ in
  the location family $F(cdot - xi)$.
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
  $ The sequence of M-estimators associated with $rho_c$ solve the minimax
  asymptotic variance problem when $c$ satisfies $
    2 (nphi(c)/c - Phi(c)) = eps / (1 - eps).
  $
] <thm:minimax-var>

#remark[
  This corresponds to $
    psi_c (x) := rho'_c (x) = cases(
      x & "if" |x| < c\,,
      c sign(x) quad & "if" |x| >= c.
    )
  $
]

#lemma[
  Suppose that $F_* in cP_eps^"sym" (Phi)$ has density $f_*$ such that $
    F_* in argmax_(F in cP_eps^"sym" (Phi)) V(psi_*, F)
  $ where $psi_* = -f'_* \/ f_*$.
  Then $psi_*$ solves the minimax asymptotic variance solution, and $
    min_psi max_(F in cP_eps^"sym" (Phi)) V(psi, F)
      = V(psi_*, F_*).
  $
] <lem:minimax-var>
#proof[
  We already have $
    min_psi max_(F in cP_eps^"sym" (Phi)) V(psi, F)
      <= max_(F in cP_eps^"sym" (Phi)) V(psi_*, F)
      = V(psi_*, F_*).
  $ To establish the other direction, we will show that $psi_* in argmin_(psi)
  V(psi, F_*)$, whence $
    min_psi max_(F in cP_eps^"sym" (Phi)) V(psi, F)
      >= min_psi V(psi, F_*)
      = V(psi_*, F_*).
  $ To this end, compute $
    EE_(F_*) [psi']
      = integral psi' f_*
      = -integral psi f'_*
      = integral psi psi_* f_*
      = EE_(F_*) [psi psi_*]
      <= sqrt(EE_(F_*) [psi^2] EE_(F_*)[psi_*^2]).
  $ In particular, $EE_(F_*) [psi'_*] = EE_(F_*) [psi_*^2]$.
  Thus, $
    V(psi, F_*)
      = (EE_(F_*) [psi^2])/(EE_(F_*) [psi'])^2
      >= cancel(EE_(F_*) [psi^2])/(cancel(EE_(F_*) [psi^2]) EE_(F_*)[psi_*^2])
      = 1/(EE_(F_*) [psi_*^2])
      = V(psi_*, F_*).  #qedhere
  $
]


~
#proof[of @thm:minimax-var][
  Set $
    f_c (x) := (1 - eps)/(sqrt(2 pi)) exp(-rho_c (x))
      = cases(
        (1 - eps) nphi(x) &"if" |x| < c\,,
        (1 - eps)/sqrt(2pi) exp(-c|x| + 1/2 c^2) quad&"if" |x| >= c\,
      )
  $ and check that our choice of $c$ ensures that $f_c$ is a probability
  density function.
  The corresponding distribution $F_c$ can be shown to belong to $cP^"sym"_eps
  (Phi)$, by isolating $
    h_c (x) := (f_c (x) - (1 - eps)nphi)/eps >= 0
  $ and checking that this is also a probability density function.
  Now, for any $F := (1 - eps) Phi + eps H in cP_eps^"sym" (Phi)$, we have $
    V(psi_c, F)
      = (EE_F [psi_c^2]) / (EE_F [psi'_c])^2
      = ((1 - eps) EE_Phi [psi_c^2] + eps EE_H [psi_c^2]) /((1 - eps) EE_Phi [psi'_c] + eps EE_H [psi'_c])^2.
  $ which attains its maximum precisely when $EE_H [psi_c^2] = c^2$ and $EE_H
  [psi'_c] = 0$.
  However, these are satisfied by $H_c$ (supported on ${|x| >= c}$, where
  $psi_c (x) = c sign(x)$), whence $V(psi_c, F) <= V(psi_c, F_c)$.
  We have shown that $F_c$ satisfies the conditions of @lem:minimax-var, which
  directly gives the result.
]



// ~
#pagebreak()
= Quantification of Robustness

== Influence Functions

#definition[Influence Function][
  The influence function of a functional $T$ at $x$ with respect to a
  distribution $F$ is defined by $
    IF(x; T, F)
      = lim_(eps -> 0^+) (T((1-eps)F + eps delta_x) - T(F))/eps
      = lr(dif/(dif eps) thin T((1-eps)F + eps delta_x) |)_(eps = 0).
  $
]

#remark[
  The influence function $IF(x; T, F)$ is the Gateaux derivative of $T$ at $F$
  in the direction $delta_x - F$.
]

The influence function $IF(x; T, F)$ quantifies infinitesimal effect on $T(F)$
of adding a new point $x$ to $F$.
We will call functionals with bounded influence functions _infinitesimally
robust_.

#example[
  Let $T$ be a linear functional.
  Denoting $F_t := (1 - t)F + t delta_x$, we have $
    T(F_t) = (1 - t)T(F) + t T(delta_x)
      implies IF(x; T, F) = T(delta_x) - T(F).
  $ For instance, the influence function of the  mean functional $mu(F) := EE_F
  [X]$ is described by $
    IF(mu(F) + x; mu, F) = x.
  $ Note that this is unbounded!
]

#example[
  Let $m(G) := G^(-1) (1/2)$ be the median functional.
  Denoting $F_t := (1 - t)F + t delta_x$, note that we must have $F_t (m(F_t)) =
  1/2$, which expands to $
    (1 - t)F(m(F_t)) + t bold(1)(m(F_t) >= x).
  $
  Differentiating this implicit equation and setting $t = 0$ gives $
      -1/2 + f(m(F)) IF(x; m, F) + bold(1)(m(F_t) >= z) = 0
      implies
      IF(z; m, F) = (sign(z - m(F))) / (2 f(m(F))).
  $
]

#example[
  Let $T$ be an M-estimator associated with $psi$, obeying $EE_F [psi(X, T(F))]
  = 0$.
  Plugging in $F_t := (1 - t)F + t delta_x$ gives $
    (1 - t)EE_F [psi(X, T(F_t))] + t psi(x, T(F_t)) = 0.
  $ Differentiating at $t = 0$ gives $
    -cancel(EE_F [psi(X, T(F))]) &+ (1 - t) EE_F [psi'(X, T(F))] IF(x; T, F) \
      &+ psi(x, T(F)) + t psi'(x, T(F)) IF(x; T, F) = 0,
  $ hence $
    IF(x; T, F) = M^(-1) EE_F [psi(x, T(F))], #h(2em)
      M := - EE_F [psi'(x, T(F))].
  $
]

The influence function can be interpreted as a certain limit of the
_sensitivity curve_.
For $X_i iid F$, with estimators $T_n ->^p T(F)$, and under under suitable
regularity conditions, we have $
  "SC"(x, T)
    := n(T_(n + 1) (X_1, ..., X_n, x) - T_n (X_1, ..., X_n))
    --> IF(x; T, F).
$


~
== Breakdown Points


#definition[Breakdown Point, Asymptotic][
  The asymptotic breakdown point of $T$ is $
    eps^* (T, F)
      := sup {eps : sup_H thin norm(T((1 - eps) F + eps H) - T(F)) < oo}.
  $
]

#example[
  Consider the mean functional $mu(F) := EE_F [X]$.
  Then, $
    mu((1 - eps)F + eps H) - mu(F) = eps (mu(H) - mu(F))
  $ is unbounded over all distributions $H$ whenever $eps > 0$.
  This means that $eps^* (mu, F) = 0$.
]


#theorem[
  Let $T$ be an M-estimator of location associated with $psi$, with $psi$
  nondecreasing, $k_1 := -psi(-oo)$, $k_2 := psi(oo)$ both finite.
  Then, $
    eps^* (T, F) = min(k_1, k_2) / (k_1 + k_2).
  $ In particular, $eps^* (T, F) = 1/2$ when $psi(-oo) + psi(oo) = 0$.
]

#example[
  For the median functional $m(F) := F^(-1)(1/2)$, $eps^* (m, F) = 1/2$.
]


#definition[Breakdown Point, Finite Sample][
  The finite sample breakdown point of a statistic $T_n$ at $X := (X_1, ...,
  X_n)$ is $
    hat(eps) (T_n, X)
      := sup {m/n : sup_(d_H (X, X') <= m) thin norm(T_n (X') - T_n (X)) < oo}.
  $
]

#remark[
  Here, $d_H$ denotes the _Hamming distance_, with $
    d_H (X, X') := sum_(i = 1)^n bold(1)(X_i eq.not X'_i).
  $ We may call $X'$ an _$m$-replacement of $X$_ when $d_H (X, X') = m$.
]

#remark[
  The sample median $M_n$ achieves the largest possible finite sample breakdown
  point $
      hat(eps)(M_n, X) = 1/n floor(n/2 - 1)
  $ among all translation invariant estimators.
]



#pagebreak()
= Location and Scale Estimation

== The Univariate Setting

Pure scale estimation involves considering iid $X_1, ..., X_n$ from the the
scale family $
  f(x; sigma) = 1/sigma f(x/sigma).
$ An MLE of $sigma$ would satisfy the score equation $
  sum_(i = 1)^n partial/(partial x) log f(x; sigma)
    = sum_(i = 1)^n -x/(sigma^2) (f'(x\/sigma))/(f(x\/sigma)) - 1/sigma
    = 0.
$

#definition[M-estimator of Scale][
  We say that $S_n$ is an M-estimator of scale if it satisfies $
    sum_(i = 1)^n chi(X_i / S_n) = 0
  $ for some function $chi$.
]

This corresponds to the population functional $S$ satisfying $
  EE_F [chi(X/S(F))] = 0.
$

#remark[
  We can compute $
    IF(x; S, F)
      = (chi(x\/S(F)))/(EE_F [chi'(X\/S(F)) (X\/S(F))]).
  $ An infinitesimally robust M-estimator of scale requires bounded $chi$.
]

#example[
  Let $X_i iid N(0, sigma^2)$, and consider the M-estimator described by $
    chi_c (x)
      := cases(
        x^2 + kappa_c quad&"if" |x| <= c\,,
        c^2 + kappa_c &"if" |x| > c\,
      )
  $ where $kappa_c$ is a _Fisher consistency constant_ chosen such that
  $EE_(N(0, 1)) [chi_c (Z)]$.
  Note that the symmetry of the location problem saved us from this
  complication earlier!
]


More generally, for iid $X_1, ..., X_n$ from a location-scale family of
the form $
  f(x; sigma) = 1/sigma f((x - mu)/sigma),
$ we may consider estimators $(T_n, S_n)$ which satisfy equations $
  sum_(i = 1)^n psi((X_i - T_n) / S_n) = 0, #h(2em)
  sum_(i = 1)^n chi((X_i - T_n) / S_n) = 0
$ as joint M-estimators of location and scale.


#example[
  Picking $rho = rho_c$, $chi = chi_c$ amounts to solving $
    (T_n, S_n) in argmin_(mu, sigma) {
      sum_(i = 1)^n sigma rho_c ((X_i - mu) / sigma) + sigma beta n
    }
  $ with an appropriate Fisher consistency constant $beta$.
]

#example[
  It is also possible to perform estimation in two stages, by first estimating
  the scale, then plugging that into a location estimation problem.
  The _Mean Absolute Deviation (MAD)_ estimator is a common choice for this
  initial scale estimate.
]



~
== The Multivariate Setting


Here, we will consider multivariate distributions on $RR^p$.

#definition[
  An elliptical family of distributions has densities of the form $
    f(x; mu, Sigma)
      = 1/(|Sigma|^(1/2)) f((x - mu)^top Sigma^(-1) (x - mu)).
  $ The quantity $d(cdot; mu, Sigma) := sqrt(norm(x - mu)_(Sigma^(-1))^2)$ is
  the _Mahalanobis distance_.
]

We may consider estimators $(T_n, S_n)$ satisfying equations of the form $
  sum_(i = 1)^n w_1 (d_i^2) (X_i - T_n) &= 0, \
  1/n sum_(i = 1)^n w_2 (d_i^2) (X_i - T_n)(X_i - T_n)^top &= S_n,
$ where $d_i^2 := d^2 (X_i; T_n, S_n)$.
Note that these produce _affine invariant estimators_.
As usual, we may construct the corresponding population-level functionals $
  EE_F [w_1 (d^2 (X)) (X - T(F))] &= 0, \
  EE_F [w_2 (d^2 (X)) (X - T(F))(X - T(F))^top] &= S(F).
$

#theorem[#pc[@maronna-1976]][
  Suppose that $w_2 (d^2) d^2$ is nondecreasing with a finite supremum $k$, and
  $w_1 (d^2) d < oo$.
  Then, the corresponding location-scale functionals $(T, S)$ have breakdown
  point $
    eps^* ((T, S); F)
      <= min {1/k,thin 1 - p/k}
      <= 1/(p + 1).
  $
] <thm:mv_ls_bp>

In this setting, the right notion of breakdown involves $T$ escaping to $oo$ as
well as the minimum/maximum eigenvalues of $S$ escaping to $0$/$oo$:
$
  eps^* (T, S; F)
    := sup{ eps:
      sup_(G in cP_eps (F))& norm(T(G) - T(F)) < oo, \
      &sup_(G in cP_eps (F)) lambda_"max" (S(G)) < oo, #h(1em)
      sup_(G in cP_eps (F)) lambda_"min" (S(G)) > 0
    }.
$


The Mahalanobis distance in the previous construction can be swapped out for
other notions of outlyingness.
The Stahel-Donoho estimator uses a projection-based outlyingness of the form $
  o(x; F)
    := sup_(u in S^(d-1))thick lr(| (u^top x - T_n^1(u^top x; F_u)) / (S_n^1(u^top x; F_u)) |)
$ where $F_u$ is the distribution of $u^top X$ with $X ~ F$, and $T_n^1, S_n^1$
are (robust) univariate location and scale estimators.
This leads to weighted mean and covariance estimators $
  T_n (X)
    &:= (sum_(i = 1)^n w_1 (o(X_i)) X_i) / (sum_(i = 1)^n w_1 (o(X_i))), \
  S_n (X)
    &:= (sum_(i = 1)^n w_2 (o(X_i)) (X_i - T_n (X))(X_i - T_n (X))^top)
      / (sum_(i = 1)^n w_2 (o(X_i))).
$ Under conditions analogous to @thm:mv_ls_bp, these estimators can be shown to
achieve a breakdown point of $1/2$, avoiding the dimensional penalty.




// TODO: S-estimators




#pagebreak()
= Robust Regression

Consider $
  y_i = x_i^top beta + eps_i
$ where ${eps_i}$ are iid random variables such that $eps_i perp x_i$,
$EE[eps_i] = 0$, and $var[eps_i] = sigma^2$.
Recall that ordinary least-squares linear regression solves $
  hat(beta)_"OLS"
    in argmin_(beta in RR^p) sum_(i = 1)^n norm(y_i - x_i^top beta)_2^2.
$ One obvious extension is to instead optimize $
  hat(beta)
    in argmin_(beta in RR^p) sum_(i = 1)^n rho(y_i - x_i^top beta).
  iff sum_(i = 1)^n psi(x_i - x_i^top hat(beta)) thin x_i = 0.
$ Under suitable conditions on the loss $rho$ and the noise $eps$, we recover
asymptotic normality $
  sqrt(n) (hat(beta) - beta)
    -->^d normal(
      0, thick
      (EE_F [psi^2 (eps_1)])/(EE_F [psi' (eps_1)])^2 EE_F [x_1 x_1^top]^(-1)
    ).
$ The general theory of M-estimators shows that using the Huber loss gives the
minimax variance optimal estimator for symmetric contaminated noise $eps_i$.
The influence function for (the population version of) these estimators take
the form $
  IF((x, y); T, F)
    = - (EE_F [psi'(eps_1)] EE_F [x_1 x_1^top])^(-1)
      psi(y - x^top T(F))thin x.
$ This shows that this setup is infinitesimally robust in the space of
residuals, but _not_ in the space of covariates $x$!

#lemma[
  Let $psi$ be nondecreasing.
  The breakdown point of the regression estimator solving $sum_(i = 1)^n
  psi(y_i - x_i^top T_n)x_i = 0$ is zero.
]

~
== Mean-Shift Model

Consider an extension of the previous model of the form $
  y_i = x_i^top beta + gamma_i + eps_i,
$ introducing a sparse parameter $gamma$; we intend for $gamma_i != 0$ when the
linear model does not hold (for instance, because of the presence of outliers).
One choice is a LASSO-type estimator $
  (hat(beta)_lambda, hat(gamma)_lambda)
    in argmin_(beta, gamma) {
      1/2 norm(y - X beta - gamma)_2^2
        + lambda norm(gamma)_1
      }
$ for some $lambda >= 0$.

#theorem[
  The solution $hat(beta)_lambda$ coincides with the Huber estimator obtained from $
    hat(beta)
      in argmin_(beta in RR^p) sum_(i = 1)^n rho_lambda (y_i - x_i^top beta).
  $
]







#pagebreak()
#bibliography(
  "references.bib",
  style: "apa",
  full: true
)
#v(2em)
