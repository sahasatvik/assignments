#import "@local/plain:0.1.0": plain, contents
#import "@preview/ctheorems:1.1.2": *
#import "@preview/tablex:0.0.8": tablex, cellx, hlinex, vlinex

#show footnote.entry: it => {
  show strong: set text(fill: rgb("#9D75BF").darken(20%))
  it
}

#show: plain.with(
  suptitle: [Exercises from a course#footnote(numbering: "*")[*MA4204*, instructed by *Dr.~Swarnendu Datta*.] on],
  title: [
    #set par(justify: false)
    Representation Theory of Finite Groups
  ],
  author: "Satvik Saha",
  affiliation: [
    Department of Mathematics and Statistics,\
    Indian Institute of Science Education and Research, Kolkata.
  ],
  primary: rgb("#9D75BF").darken(5%),
  secondary: rgb("#9D75BF").darken(30%),
  color-strong: rgb("#9D75BF").darken(20%),
  footer-right: "Exercises",
)

#show heading: h => pad(top: 1em, bottom: 0.5em, h)
#show enum: it => pad(left: 1em, it)
#set enum(numbering: "(a)")

#let table-stroke = rgb("#9D75BF").lighten(20%)

// #set heading(numbering: "1.")
#show: thmrules

#let thmbox = thmbox.with(
  titlefmt: title => text(10pt, font: "Ubuntu", weight: 500, fill: black, title),
  inset: 0em,
  outset: 1.2em,
  padding: (top: 1.6em, bottom: 1em),
)

#let solution = thmplain(
  "solution",
  "Solution",
  inset: 0em,
).with(numbering: none)

#let mapsto = $arrow.r.bar$
#let ip(u, v) = $angle.l #u, #v angle.r$


///////////////////////////////////////////////////////////////////////////////

The base field is $CC$.

== Problem 1

Show that every irreducible representation of a finite abelian group is
1-dimensional.

#solution[
  Let $G$ be a finite abelian group, and let $(sigma, V)$ be an irreducible
  representation of $G$. Then for each $g in G$, the map $sigma(g) in "GL"(V)$
  is $G$-invariant; observe that for $g' in G$, $
    sigma(g)(sigma(g')v) = (sigma(g) sigma(g'))(v) = sigma(g g')(v) = sigma(g' g)(v) = sigma(g')(sigma(g)(v)).
  $ Thus, by Schur's Lemma, each $sigma(g)$ must be a scalar map of the form
  $v mapsto lambda_g v$. As a result, every 1-dimensional subspace of $V$ is
  $G$-stable. For $V$ to be irreducible, it must be the case that $dim(V) =
  1$.
]


== Problem 2

Let $V, W$ be vector spaces on which $G$ acts. Let $"Hom"(V, W)$ denote the
vector space of all linear maps from $V$ to $W$. Define an action of $G$ on
$"Hom"(V, W)$ as follows. Let $g in G$ and $f in "Hom"(V, W)$. Then define $g
f in "Hom"(V, W)$ by $
  (g f)(v) = g f (g^(-1) v).
$

+ Show that this indeed defines an action of $G$ on $"Hom"(V, W)$.
+ Suppose now that $W = CC$ (the action of $G$ being trivial). Then $"Hom"(V,
  W)$ is the dual space $V^*$ of $V$. It is called the representation dual to
  $V$. Compute the character of $V^*$ in terms of the character of $V$.

#solution[
  + Note that $(1 f)(v) = 1 f(1 v) = f(v)$ so $1f = f$. Next, for $g_1, g_2 in
    G$, we have $
      (g_1 (g_2 f))(v) &= g_1((g_2 f)(g_1^(-1) v)) = g_1(g_2(f(g_2^(-1) (g_1^(-1) v)))) \
        &= (g_1 g_2) (f((g_1 g_2)^(-1) v)) = ((g_1 g_2) f)(v).
    $
  + Let $chi$ be the character of $V$, let $g in G$, and let ${v_i}$ be a
    basis of $V$ with respect to which the action of $g$ is diagonal (this is
    permitted since the base field is $CC$). Then, each $g v_i = lambda_i
    v_i$ for some constants ${lambda_i}$. Observe that ${v_i^*}$ forms a basis
    of $V^*$, where each $v_i^*$ is the map determined by $v_j mapsto delta_(i
    j) v_i$. Then, $
      (g v_i^*)(v_j) = v_i^* (g^(-1) v_j) = v_i^*(lambda_i^(-1) v_j) = lambda_i^(-1) v_i^*(v_j),
    $ so $g v_i^* = lambda_i^(-1) v_i^*$. Thus, the matrix of $g$ in $V^*$ is
    precisely $sigma^*(g) = sigma(g)^(-1)$, where $sigma(g)$ is the matrix of
    $g$ in $V$. Thus, $tr(sigma^*(g)) = tr(sigma(g)^(-1)) =
    tr(sigma(g^(-1)))$. Denoting the character of $V$ as $chi^*$, we have $
      chi^*(g) = chi(g^(-1)) = overline(chi(g)), wide chi^* = overline(chi).
    $
]


== Problem 3

We want to compute the determinant, say $D$, of the character table of a group
$G$. Since its rows (characters) and columns (conjugacy classes) can be
written in any order, $D$ is only well defined upto a sign.

+ Show that $D$ is either real or purely imaginary.
+ Compute $|D|^2$ using the orthogonality relations.
+ Use (a) and (b) to determine $D$ (upto a sign).

#solution[
  Let $A$ be the matrix representing the character table, of order $k times
  k$, and let $n_1, ..., n_k$ be the sizes of the corresponding conjugacy
  classes.

  + Observe that if $chi$ is an irreducible character, so is $overline(chi)$
    via the previous exercise. Thus, for every row in $A$, its complex
    conjugate is also present. This means that the rows of $overline(A)$ are
    just a permutation of the rows of $A$, whence $det(A) = plus.minus
    det(overline(A)) = plus.minus overline(det(A))$. As a result, $D
    minus.plus overline(D) = 0$, from which $D$ is either real ($-$) or purely
    imaginary ($+$).

  + Let $B$ be the diagonal matrix with $n_1, ..., n_k$ along the diagonal,
    i.e. $B_(i j) = delta_(i j) n_i$. for each $1 <= i, j <= k$. Then, compute
    $
      [A B A^dagger]_(i j)
        = sum_(1 <= l, m <= k) A_(i l) B_(l m) A^dagger_(m j)
        = sum_(1 <= l, m <= k) A_(i l) delta_(l m) n_l overline(A_(j m))
        = sum_(1 <= l <= k) n_l A_(i l) overline(A_(j l))
        = delta_(i j) |G|.
    $ The last step follows from the row orthogonality relation $
      1/(|G|) sum_(g in G) chi_i (g) overline(chi_j (g)) = delta_(i j),
    $ and the fact that characters are class functions. Thus, $A B A^dagger$
    is the matrix $|G| II_k$. Taking determinants, $D det(B) overline(D) =
    |G|^k$; but $det(B) = product_i n_i$. Thus, $
      |D|^2 = (|G|^k)/(product_(1 <= i <= k) n_i).
    $

  + We may write $
    D = i^ell sqrt((|G|^k)/(product_(1 <= i <= k) n_i)).
  $ for some $ell in {0, 1, 2, 3}$.
]


== Problem 4

Let $G_1, G_2$ be two finite groups and let $chi_1, chi_2$ be two irreducible
characters of $G_1, G_2$ respectively. Let $V_1$ (resp. $V_2$) be a vector
space on which $G_1$ (resp. $G_2$) acts with character $chi_1$ (resp.
$chi_2$).

+ Let $V = V_1 times.circle V_2$. Define an action of $G_1 times G_2$ on $V$
  by setting #h(1fr)$
    (g_1, g_2) (v_1 times.circle v_2) = g_1(v_1) times.circle g_2(v_2).
  $ Let $chi$ be the character of this representation. Show that $
    chi(g_1, g_2) = chi_1(g_1) chi_2(g_2).
  $
+ Show that $chi$ is irreducible.
+ Show that every irreducible character of $G_1 times G_2$ is obtained in this
  way.

#solution[
  + Fix $g_1 in G_1$, $g_2 in G_2$. Let ${v_i^1}$ be a basis of $V_1$, and let
    ${v_j^2}$ be a basis of $V_2$. Then, ${v_i^1 times.circle v_j^2}$ is a
    basis of $V$. Furthermore, let ${v_i^1}$, ${v_j^2}$ have been chosen so
    that the actions of $g_1$, $g_2$ are diagonal (this is permitted since we
    are working in $"GL"(CC)$). Thus, we may write $g_1 v_i^1 = lambda_i^1
    v_i^1$, $g_2 v_j^2 = lambda_j^2 v_j^2$ for constants ${lambda_i^1}$,
    ${lambda_j^2}$. Thus, each $
      (g_1, g_2) (v_i^1 times.circle v_j^2)
        = (lambda_i^1 v_i^1) times.circle (lambda_j^2 v_j^2)
        = lambda_i^1 lambda_j^2 (v_i^1 times.circle v_j^2).
    $ From this, we immediately have $
      chi(g_1, g_2) = sum_(i, j) lambda_i^1 lambda_j^2
        = (sum_i lambda_i^1) (sum_j lambda_j^2)
        = chi_1(g_1) chi_2(g_2).
    $

  + Note that $
      sum_((g_1, g_2) in G_1 times G_2) |chi(g_1, g_2)|^2
        = sum_(g_1 in G_1\ g_2 in G_2) |chi_1 (g_1)|^2 |chi_2 (g_2)|^2
        = (sum_(g_1 in G_1) |chi_1 (g_1)|^2) (sum_(g_2 in G_2) |chi_2 (g_2)|^2),
    $ so $
      |G_1 times G_2| ip(chi, chi) = |G_1| ip(chi_1, chi_1) dot.c |G_2|
      ip(chi_2, chi_2) = |G_1|dot.c|G_2|
    $ since $chi_1, chi_2$ are irreducible. Thus, $ip(chi, chi) = 1$, whence
    $chi$ is irreducible.

  + Let ${chi_i^1}$ be the $m$ irreducible characters of $G_1$, and let
    ${chi_j^2}$ be the $n$ irreducible characters of $G_2$. Set $chi = chi_i^1
    chi_j^2$, $chi' = chi_(i')^1 chi_(j')^2$ for some $1 <= i, i' <= m$, $1 <=
    j, j' <= n$. Then, $
      ip(chi, chi')
        &= 1/(|G_1 times G_2|) sum_((g_1, g_2) in G_1 times G_2) chi(g_1, g_2) overline(chi'(g_1, g_2)) \
        &= 1/(|G_1| |G_2|) sum_(g_1 in G_1 \ g_2 in G_2) chi_i^1 (g_1) chi_j^2 (g_2) overline(chi_(i')^1 (g_1) chi_(j')^2 (g_2)) \
        &= 1/(|G_1| |G_2|) sum_(g_1 in G_1) chi_i^1 (g_1) overline(chi_(i')^1 (g_1)) sum_(g_2 in G_2) chi_j^1 (g_2) overline(chi_(j')^2 (g_2)) \
        &= ip(chi_i^1, chi_(i')^1) ip(chi_j^2, chi_(j')^2) \
        &= delta_(i i') delta_(j j').
    $ Thus, all $m n$ irreducible characters obtained in this manner are
    orthonormal, hence distinct. However, there are precisely $m n$
    irreducible characters of $G_1 times G_2$, since this is the number of
    conjugacy classes (the conjugacy classes of $G_1 times G_2$ look like $C_1
    times C_2$ where $C_1$ is a conjugacy class of $G_1$, $C_2$ is a conjugacy
    class of $G_2$). Thus, all irreducible characters of $G_1 times G_2$ have
    been found.
]


== Problem 5

+ Let $N$ be a normal subgroup of $G$. Show that every irreducible
  representation of $G\/N$ gives rise to an irreducible representation of $G$.
+ Let $A_4$ be the alternating group on $4$ elements. It contains a normal
  subgroup $K$ of order $4$, the Klein group. Using (a), this gives three
  1-dimensional representations of $A_4$. Show that there exists exactly one
  more irreducible representation. Write down the character table of $A_4$
  (first show that there are exactly $4$ conjugacy classes in $A_4$).

#solution[
  + Let $chi$ be an irreducible character of $G\/N$, and let $G\/N$ act on a
    vector space $V$ such that its character is $chi$. We define an action of
    $G$ on $V$ as follows: for $g in G$ and $v in V$, let $
      g v = (g N)(v).
    $ This is indeed an action of $G$ on $V$; note that $1 v = (N)(v) = v$,
    and for $g_1, g_2 in G$, we must have $
      g_1(g_2(v)) = (g_1 N)((g_2 N)(v)) = ((g_1 N)(g_2 N))(v) = (g_1 g_2 N)(v) = (g_1 g_2)(v).
    $ Thus, the corresponding character $chi'$ of $G$ is given by $
      chi'(g) = chi(g N).
    $ Furthermore, observe that $
      ip(chi', chi')
        &= 1/(|G|) sum_(g in G) |chi'(g)|^2 \
        &= 1/(|G\/N| |N|) sum_(g'N in G\/N) sum_(g in g'N) |chi(g N)|^2 \
        &= 1/(|G\/N| |N|) sum_(g'N in G\/N) sum_(g in g'N) |chi(g' N)|^2 \
        &= 1/(|G\/N| |N|) sum_(g'N in G\/N) |N| dot.c |chi(g'N)|^2 \
        &= ip(chi, chi) \
        &= 1.
    $ Thus, $chi'$ is an irreducible character of $G$.

  + Note that the (non-trivial) cycle types in $A_4$ are $2^2$ and $3$. The
    Klein group may be represented as $
      K = {e, (12)(34), (13)(24), (14)(23)} := {e, a, b, c}.
    $ Note that $K$ is abelian, and $a b = c$, $b c = a$, $c a = b$. Now, $
      A_4\/K = {K, (123)K, (132)K}.
    $ Indeed, $
      K &= {e, (12)(34), (13)(24), (14)(23)}, \
      (123)K &= {(123), (134), (243), (142)}, \
      (132)K &= {(132), (234), (124), (143)}.
    $ Thus, $A_4\/K tilde.equiv C_3 = {e, (123), (132)}$. This is also
    abelian, and admits the following three irreducible representations
    ($omega = e^(2 pi i \/ 3)$). $
      sigma_0: A_4\/K -> CC,& wide K &mapsto 1, quad (123)K &mapsto 1,& quad (132)K &mapsto 1,\
      sigma_1: A_4\/K -> CC,& wide K &mapsto 1, quad (123)K &mapsto omega,& quad (132)K &mapsto omega^2,\
      sigma_2: A_4\/K -> CC,& wide K &mapsto 1, quad (123)K &mapsto omega^2,& quad (132)K &mapsto omega.
    $ Using (a), these give rise to three irreducible representations of
    $A_4$.
]


== Problem 6

You are only given the character table of a group. Can you decide whether it
is simple or not?

#solution[
  A group is not simple if and only if there exists non-trivial $g in G$ and a
  non-trivial irreducible character $chi$ of $G$ such that $chi(g) = chi(1)$.
  The latter condition is satisfied if and only if there is a (non-trivial)
  row in the character table of $G$ where the first value (corresponding to
  $chi(1)$) is equal to some other value in that row.

  To prove this, first let $g in G$, $g eq.not 1$ such that $chi(g) = chi(1)$
  for some non-trivial irreducible character $chi$. Now, $chi(g)$ is the sum
  of $d = chi(1)$ roots of unity (the eigenvalues of $sigma(g)$). By the
  triangle inequality, this can be equal to $d = chi(1)$ only when all these
  eigenvalues are $1$, hence $sigma(g) = id$. With this, consider $N = {g in
  G: chi(g) = chi(1)}$. Then, $N$ is a normal subgroup of $G$; note that $N =
  ker(sigma)$, where $sigma: G -> "GL"(V)$ is a group homomorphism.
  Furthermore, $N eq.not {1}$ by the existence of $g eq.not 1$ such that
  $chi(g) = chi(1)$, and $N eq.not G$ since $sigma$ is a non-trivial
  representation ($chi$ is a non-trivial character). Thus, $G$ is not simple.

  Conversely, suppose that $G$ is not simple. Find a normal subgroup $N$ of
  $G$ where $N eq.not {1}, G$. Then, $G\/N$ admits some non-trivial
  irreducible character $chi$ (if not, that would imply that $G\/N$ has only
  one conjugacy class, forcing $G\/N = {1}$). Use the previous exercise to
  define an irreducible, non-trivial character $chi'$ of $G$ where $chi'(g) =
  chi(g N)$.  Then, we can pick $g in N$, $g eq.not 1$ and have $chi'(g) =
  chi(g N) = chi(N) = chi'(1)$.
]


== Problem 7

Let $chi$ be an irreducible character of a group $G$. Show that its complex
conjugate $overline(chi)$ is also an irreducible character.

#solution[
  $overline(chi)$ is the dual character of $chi$, via Problem 2(b).
]


== Problem 8

Let $g$ be an element of order $2$. Show that $chi(g)$ is always an integer
for any character $chi$.

#solution[
  Note that $sigma(g)^2 = sigma(g^2) = sigma(1) = id_V$, so the minimal
  polynomial of $sigma(g)$ is a factor of $x^2 - 1$. As a result, the
  eigenvalues of $sigma(g)$ are in ${plus.minus 1}$. Thus, $chi(g)$ being the
  sum of eigenvalues of $sigma(g)$ must be an integer.
]


== Problem 9

+ Let $C$ be a conjugacy class and let $C^(-1) = {g^(-1): g in C}$. Show that
  $C^(-1)$ is also a conjugacy class.
+ Show that if $C = C^(-1)$, then $chi(C)$ is real for any character $chi$.

#solution[
  + Note that any two elements from $C^(-1)$ can be written as $g_1^(-1),
    g_2^(-1)$ for conjugates $g_1, g_2 in C$. Thus, we can find $h in G$ such
    that $g_1 = h g_2 h^(-1)$, hence $g_1^(-1) = h g_2^(-1) h^(-1)$. This
    shows that $g_1^(-1), g_2^(-1)$ are conjugate. Furthermore, fixing $g in
    G$, we have $
      C = {h g h^(-1): h in G},
    $ so $
      C^(-1) = {(h g h^(-1))^(-1): h in G} = {h g h^(-1): h in G}
    $ is the set of all conjugates of $g^(-1)$.

  + Pick $g in C$, whence $g^(-1) in C^(-1) = C$, so $g^(-1) = h g h^(-1)$ for
    some $h in G$. Thus, $overline(chi(g)) = chi(g^(-1)) = chi(h g h^(-1)) =
    chi(g)$. This means that $chi(g)$ must be real.
]


== Problem 10

We want to construct the character table of $A_5$.


== Problem 11

Consider the action of $S_n$ on $CC^n$, where $S_n$ acts by permuting the
coordinates. We want to show that this representation is the direct sum of the
trivial representation and another irreducible representation (here $n >= 2$).

+ For $sigma in S_n$, let $chi(sigma)$ denote the number of fixed points of
  $sigma$. Show that $chi$ is the character of the permutation representation.
+ Let $X = {1, ..., n}$. Consider the action of $S_n$ on $X times X$. Observe
  that the number of fixed points of $sigma$ in $X times X$ is $chi(sigma)^2$.
  Evaluate $
    sum_(sigma in S_n) chi(sigma)^2
  $ using Burnside's Lemma.
+ Deduce that $ip(chi, chi) = 2$. Conclude.

#solution[
  + Let ${e_i}$ be the standard basis of $CC^n$. Then, $sigma$ acts on $CC^n$
    via $sigma e_i = e_(sigma(i))$; this is equal to $e_i$ precisely when
    $sigma(i) = i$, i.e. $i$ is a fixed point of $sigma$. Thus, the trace of
    the representation of $sigma$ is precisely the number of such fixed points
    of $sigma$, which is $chi(sigma)$.

  + Note that $sigma(i, j) = (sigma(i), sigma(j))$; this is equal to $(i, j)$
    precisely when $sigma(i) = i$ and $sigma(j) = j$, i.e. $i, j$ are both
    fixed points of $sigma$. The number of such tuples $(i, j)$ is precisely
    $chi(sigma)^2$.

    Now, Burnside's Lemma tells us that $
      |(X times X)\/S_n| = 1/(|S_n|) sum_(sigma in S_n) |(X times X)^sigma|
        = 1/(|S_n|) sum_(sigma in S_n) chi(sigma)^2.
    $ We claim that the number of orbits $|(X times X)\/S_n| = 2$, the orbits
    being the diagonal $Delta = {(i, i): i in X}$ and the complement $Delta' =
    (X times X)without Delta$. Indeed, $sigma(1, 1) = (sigma(1), sigma(1)) in
    Delta$ for all $sigma$, and $(1 i)(1, 1) = (i, i)$ for any $i in X$, so
    $Delta$ is indeed the orbit of $(1, 1)$. Next, given any $i, j in X$ with
    $i eq.not j$, it is always possible to find a permutation $sigma$ such
    that $sigma(1, 2) = (i, j)$.

    With this, $
      sum_(sigma in S_n) chi(sigma)^2 = 2 |S_n| = 2n!.
    $

  + The previous equation immediately gives $ip(chi, chi) = 2 = 1^2 + 1^2$.
    But $"span"_CC {e_1 + ... + e_n}$ is a trivial sub-representation of
    $CC^n$; subtracting it from $chi$ leaves us with an irreducible
    representation of $S_n$.
]


== Problem 12

Let $X$ be a finite set on which a finite group $G$ acts. Let $V$ be the
vector space which has the elements of $X$ as a basis. Note that $G$ acts on
$V$ by permuting its basis. Let $chi$ (rep. $bold(1)_G$) denote that character
of $V$ (resp. the trivial character). Show that $
  sum_(g in G) chi(g) = |G| dot.c m,
$ where $m$ is the number of orbits of $G$ in $X$. Using this, show that the
number of times $bold(1)_G$ occurs in $V$ is the same as the number of orbits
of $G$ in $X$. In particular, if $G$ acts transitively on $X$, then
$bold(1)_G$ occurs exactly once in $chi$.

#solution[
  By the same argument as before, $chi(g)$ is precisely the number of fixed
  points of $g in G$ when acting on $X$. Thus, Burnside's Lemma immediately
  gives $
    1/(|G|) sum_(g in G) chi(g) = |X\/G| = m.
  $ However, this is also precisely $ip(chi, bold(1)_G)$, hence the number of
  times $bold(1)_G$ occurs in $chi$ is the number of orbits of $G$ in $X$,
  namely $m$.
]


== Problem 13

Suppose now that $G$ acts doubly transitively on $X$, i.e. given elements $x,
y$ and $z, w$ in $X$ such that $x eq.not y$ and $z eq.not w$, there exists $g
in G$ such that $
  g(x) = z, wide g(y) = w.
$ Note that the action of $G$ is transitive (why?). Thus, we can write $
  chi = bold(1)_G + theta
$ where $theta$ is a character in which $bold(1)_G$ does not appear. Show that
$theta$ is irreducible.

#solution[
  The fact that $G$ acts transitively on $X$ can be checked by setting $z =
  y$, $w = x$ for $x, y in X$, $x eq.not y$. With this, the previous exercise
  gives us the representation $theta$ which does not contain $bold(1)_G$.
  Consider the action of $G$ on $X times X$; like before, the number of fixed
  points of $g in G$ is $chi(g)^2$, and the two orbits of $G$ in $X times X$
  are the diagonal $Delta = {(x, x): x in X}$ and $Delta' = (X times X)without
  Delta$ (via the doubly transitive property). Thus, Burnside's Lemma gives $
    ip(chi, chi) = 1/(|G|) sum_(g in G) chi(g)^2 = 1/(|G|) sum_(g in G) |(X
    times X)^g| = 2 = 1^2 + 1^2.
  $ Thus, $chi$ is the sum of two irreducible characters each of degree $1$;
  since $bold(1)_G$ is one of them, $theta$ must be the other.
]


== Problem 14

Let $N$ be a normal subgroup of $G$ and let $chi$ be a character of $N$. If
$tilde(chi)$ is the character of $G$ induced from $N$, show that
$tilde(chi)(g) = 0$ if $g eq.not N$.

#solution[
  Recall that $
    tilde(chi)(g) = 1/(|N|) sum_(h in G\ h g h^(-1) in N) chi(h g h^(-1)).
  $ It is enough to show that $h g h^(-1) in.not N$ for $g in.not N$, $h in
  G$. Indeed, if $h g h^(-1) = g' in N$, then $g = h^(-1) g' h in.not N$,
  contradicting the normality of $N$ in $G$.
]


== Problem 15

For each irreducible representation of $S_3$, find the character of the
representation obtained by inducing it to $S_4$. Decompose the induced
characters into irreducibles.


== Problem 16

Induce the sign representation of $S_4$ to $S_5$ and decompose it into
irreducibles using the character table of $S_5$.


== Problem 17

Let $D_n$ be the group of symmetries of a regular $n$-gon. Note that $|D_n| =
2n$ and $D_n$ contains a cyclic subgroup $C_n$ of order $n$, consisting of
rotations in $D_n$.

+ Let $chi$ be a character of $C_n$. Note that since $C_n$ is abelian, $chi$
  is necessarily $1$-dimensional. Suppose that $chi^2 eq.not 1$. Show that
  $chi' := "Ind"_(C_n)^(D_n) chi$ is irreducible.
+ Using (a), compute the character table of $D_n$.

#solution[
  Use the presentation $D_n = angle.l sigma, tau | sigma^n = tau^2 = (tau
  sigma)^2 = 1 angle.r$, with $C_n = {1, sigma, ..., sigma^(n - 1)}$. Observe
  that $tau sigma = sigma^(n - 1) tau$, hence every element of $D_n$ is either
  of the form $sigma^k$ or $sigma^k tau$.
  + Representing $D_n\/C_n
    = {C_n, tau C_n}$, we have $
      chi'(g) = sum_(r in {1, tau}\ r g r^(-1) in C_n) chi(r g r^(-1)).
    $ Since $[D_n : C_n] = 2$, $C_n$ is a normal subgroup of $D_n$. Thus,
    $chi'(g) = 0$ for all $g in.not C_n$ by Problem 14. Now for $g in C_n$,
    write $g = sigma^k$ for some $0 <= k < n$, so $tau g tau^(-1) = tau
    sigma^k tau = sigma^(k(n - 1)) = sigma^(-k) in C_n$. Thus, $
      chi'(sigma^k) = chi(sigma^k) + chi(sigma^(-k)) = chi(sigma^k) + overline(chi(sigma^k)).
    $ Thus, $
      ip(chi', chi')
        = 1/(2n) sum_(g in D_n) |chi'(g)|^2
        = 1/(2n) sum_(g in C_n) (chi(g) + overline(chi(g)))^2
    $ Now, observe that since $chi$ is $1$-dimensional, $chi(g)$ must be a
    root of unity. Specifically, $chi$ is completely determined by the value
    of $chi(sigma) = xi$, where $xi = e^(2 pi i ell \/ n)$; every other
    $chi(sigma^k) = xi^k$. Thus, $
      ip(chi', chi')
        = 1/(2n) sum_(k = 0)^(n - 1) (xi^k + xi^(-k))^2 = 1/(2n) sum_(k = 0)^(n - 1) [xi^(2k) + xi^(-2k) + 2] = 1/n (sum_(k = 0)^(n - 1) xi^(2k)) + 1.
    $ But $xi^2 = chi(sigma)^2 eq.not 1$, hence $
      sum_(k = 0)^(n - 1) xi^(2k) = (xi^(2n) - 1)/(xi^2 - 1) = 0,
    $ so $ip(chi', chi') = 1$ whence $chi'$ is irreducible.

]
