#import "@local/plain:0.1.0": plain, contents
#import "@preview/ctheorems:1.1.0": *
#import "@preview/tablex:0.0.8": tablex, cellx, hlinex, vlinex

#show footnote.entry: it => {
  show strong: set text(fill: rgb("#9D75BF").darken(20%))
  it
}

#show: plain.with(
  suptitle: [Notes from a course#footnote(numbering: "*")[*MA4204*, instructed by *Dr.~Swarnendu Datta*.] on],
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
)

#show heading: h => pad(top: 1em, bottom: 0.5em, h)
#show enum: it => pad(left: 1em, it)

#let table-stroke = rgb("#9D75BF").lighten(20%)

#set heading(numbering: "1.")
#show: thmrules

#let thmbox = thmbox.with(
  titlefmt: title => text(10pt, font: "Ubuntu", weight: 500, fill: black, title),
  inset: 0em,
  outset: 1.2em,
  padding: (top: 1.6em, bottom: 1em),
)

#let theorem = thmbox(
  "common",
  "Theorem",
  base_level: 1,
  fill: rgb("#9EC299").lighten(90%),
  stroke: rgb("#9EC299")
)
#let lemma = thmbox(
  "common",
  "Lemma",
  base_level: 1,
  fill: rgb("#E78963").lighten(90%),
  stroke: rgb("#E78963")
)
#let proposition = thmbox(
  "common",
  "Proposition",
  base_level: 1,
  fill: rgb("#C8566B").lighten(95%),
  stroke: rgb("#C8566B").lighten(50%)
)
#let corollary = thmbox(
  "sub",
  "Corollary",
  base: "common",
  fill: rgb("#F2D48F").lighten(85%),
  stroke: rgb("#F2D48F")
)
#let definition = thmbox(
  "common",
  "Definition",
  base_level: 1,
  fill: rgb("#6661AB").lighten(90%),
  stroke: rgb("#6661AB").lighten(30%)
)
#let proof = thmplain(
  "proof",
  "Proof",
  bodyfmt: body => [#body#h(1fr)$square$],
  namefmt: emph,
  inset: 0em,
).with(numbering: none)
#let remark = thmplain(
  "remark",
  "Remark",
  inset: 0em,
).with(numbering: none)
#let example = thmplain(
  "sub",
  "Example",
  base: "common",
  inset: 0em,
)

#let mapsto = $arrow.r.bar$
#let ip(u, v) = $angle.l #u, #v angle.r$


#contents()


///////////////////////////////////////////////////////////////////////////////


= Linear representations of groups

#definition("Linear representation")[
  Let $G$ be a finite group, and let $V$ be a vector space. A linear
  representation $(sigma, V)$ of $G$ is a homomorphism $
    sigma: G -> "GL"(V).
  $
]

#example[
  The _trivial_ representation of $G$ is defined by $g mapsto id_V$.
]
#example[
  Consider a vector space $V$ of dimension $"ord"(G)$, and pick a basis
  ${e_h}_(h in G)$. The _regular_ representation $tau: G -> "GL"(V)$ of $G$ is
  defined as follows: $tau(g)$ sends each of the basis vectors $e_h mapsto
  e_(g h)$.
] <ex_regular>

The following propositions show that it is possible to define group
representations in terms of a special class of group actions of $G$ on the
vector space $V$.

#proposition[
  Let $G$ be a finite group, and let $V$ be a vector space.  Let $rho: G times
  V -> V$ be a group action of $G$ on $V$, such that each for each $G$, the
  map $v mapsto rho(g, v)$ is linear. Then, $(sigma, V)$ is a linear
  representation, where $
    sigma: G -> "GL"(V), wide
    g mapsto (v mapsto rho(g, v)).
  $
]

#proposition[
  Let $(sigma, V)$ be a linear representation. Then, the map $
    rho: G times V -> V, wide
    (g, v) mapsto sigma(g)(v)
  $ is a group action of $G$ on $V$, where for each $g in G$, the map $v
  mapsto rho(g, v)$ is linear.
]

In this discussion, we will always work with finite groups, as well as finite
dimensional vector spaces over a base field $K$. Typically, we will consider
$K = CC$.

We will often abbreviate $(sigma, V)$ with $V$, and $sigma(g)$ with $g$ when
the presence of $sigma$ is clear from context.

#definition[
  The dimension of a representation $(sigma, V)$ is $"dim"(V)$.
]

#example[
  The only one dimensional representation of $S_3$ in $CC^times$ is the sign
  homomorphism. To see this, consider an arbitrary homomorphism $sigma: S_3 ->
  CC^times$. Note that $ker(sigma)$ must be a normal subgroup of $S_3$, hence
  must be one of ${e}, A_3, S_3$. The third option yields the trivial
  representation $sigma = id_(CC^times)$, and the first option gives the
  contradiction $S_3 tilde.equiv im(sigma) subset CC^times$ (the right side is
  abelian while the left is not). This leaves $ker(sigma) = A_3$, i.e.
  $sigma(g) = 1$ for all even permutations $g in S_3$. The remaining elements
  of $S_3$ (the odd permutations) must be sent to $-1$, since for any odd
  permutation $h in S_3$, the permutation $h^2$ is even, so $sigma(h)^2 =
  sigma(h^2) = 1$. The result is precisely the sign homomorphism $
    sigma: S_3 -> CC^times, wide
    g mapsto cases(
      +1 &"if" g in A_3,\
      -1 & "if" g in.not A_3.
    )
  $
] <ex_S3_1D>


#example[
  Construct an equilateral triangle in $CC^2$ centered at the origin, and
  consider the natural action of $S_3$ on it (permuting its vertices $v_1,
  v_2, v_3$). This induces a two dimensional representation $sigma: S_3 ->
  "GL"(CC^2)$. Note that ${v_1, v_2}$ forms a basis of $CC^2$; the third vertex
  can be obtained via $v_3 = -v_1 - v_2$. With this, we can calculate the
  image of $(v_1, v_2)$ under the action of each $g in S_3$, and hence the
  matrices of $sigma(g)$ in the given basis as follows.
  #align(
    center,
    tablex(
      columns: 3,
      inset: (x: 2em, y: 0.8em),
      stroke: table-stroke,
      align: center + horizon,
      auto-hlines: false,
      hlinex(),
      [*$bold(g)$*], [*$bold((sigma(g)(v_1), sigma(g)(v_2)))$*], [*Matrix of $sigma(g)$*],
      hlinex(),
      $e$, $(v_1, v_2)$, $ mat(delim: "[", 1, 0; 0, 1) $,
      $(12)$, $(v_2, v_1)$, $ mat(delim: "[", 0, 1; 1, 0) $,
      $(23)$, $(v_1, v_3) = (v_1, -v_1 - v_2)$, $ mat(delim: "[", 1, -1; 0, -1) $,
      $(31)$, $(v_3, v_2) = (-v_1 - v_2, v_2)$, $ mat(delim: "[", -1, 0; -1, 1) $,
      $(123)$, $(v_2, v_3) = (v_2, -v_1 - v_2)$, $ mat(delim: "[", 0, -1; 1, -1) $,
      $(321)$, $(v_3, v_1) = (-v_1 - v_2, v_1)$, $ mat(delim: "[", -1, 1; -1, 0) $,
      hlinex(),
    )
  )
] <ex_S3_2D>

#v(1em)

Consider the setting $K = CC$. The fact that $G$ is a finite group means that
each element $g in G$ has finite order, hence satisfies $g^m = 1$ for some $m
divides "ord"(G)$. This means that $sigma(g)^m = id_V$, whence $x^m - 1$ is an
annihilating polynomial for $sigma(g)$. A consequence of this is that the
minimal polynomial of $sigma(g)$ is a factor of $x^m - 1$; but the latter
splits into distinct linear factors. Furthermore, all eigenvalues of
$sigma(g)$ are roots of its minimal polynomial. This yields the following
result.

#proposition[
  Suppose that $K = CC$. Let $(sigma, V)$ be a representation of $G$, and let
  $g in G$. Then, $sigma(g)$ is diagonalizable, and its eigenvalues are roots
  of unity.
] <prop_eigenvalues>


= Subrepresentations

#definition("Stable subspace")[
  Let $(sigma, V)$ be a representation of $G$, and let $W subset.eq V$ be a
  subspace of $V$. We say that $W$ is a stable subspace of $V$ if it is
  invariant under the action of $G$, i.e. $g w in W$ for all $g in G$, $w in
  W$.
]

#example[
  Let $S_3$ act on $CC^3$ by permuting the basis vectors ${e_1, e_2, e_3}$.
  Then, the subspace $"span"{e_1 + e_2 + e_3}$ is stable.
] <ex_stable_S3>

#definition("Subrepresentation")[
  Let $W$ be a stable subspace of $V$. We say that $(sigma, W)$ is a
  subrepresentation of $(sigma, V)$.
]


#theorem[
  Suppose that $"char"(K) divides.not "ord"(G)$.
  Let $W$ be a stable subspace of $V$. Then, there exists a stable subspace
  $W'$ of $V$ such that $V = W plus.circle W'$.
] <thm_decomposition>

When working with the field $K = CC$, @thm_decomposition admits a simpler form
by invoking the orthocomplement of $W subset.eq V$, with respect to a suitable
Hermitian form on $V$. We say that a Hermitian form $ip(dot, dot): V times V
-> CC$ is $G$-invariant if for all $g in G$, $v, v' in V$, we have $ip(g v, g
v') = ip(v, v')$.

#theorem[
  Suppose that $K = CC$. If $W$ is a stable subspace of $V$, then $W^perp$ is
  a stable subspace of $V$, with $V = W plus.circle W^perp$.

  #remark[
    The subspace $W^perp$ is defined with respect to a non-degenerate
    $G$-invariant Hermitian form.
  ]
] <thm_decomposition_C>
#proof[
  For all $g in G$, $w in W$, $w' in W^perp$, observe that $g^(-1) w in W$, so
  $
    ip(g w', w) = ip(g w', g g^(-1) w) = ip(w', g^(-1) w) = 0,
  $ whence $g w' in W^perp$.
]

#example[
  Continuing @ex_stable_S3, the subspace $"span"{e_1 - e_2, e_2 - e_3, e_3 -
  e_1}$ is also stable under the action of $S_3$. This gives a two dimensional
  subrepresentation of $S_3$. In fact, it is easy to check that the matrices
  describing this representation in the basis ${2e_1 - e_2 - e_3, 2e_2 - e_3 -
  e_1}$ are precisely the same as those in @ex_S3_2D, making these two
  representations identical in some sense.
] <ex_stable_S3_perp>

#remark[
  Given any Hermitian form $ip(dot, dot): V times V -> C$, we can obtain
  a $G$-invariant Hermitian form on $V$ defined by $
    (u, v) mapsto sum_(g in G) " " ip(g u, g v).
  $
]

Returning to @thm_decomposition, observe that if $pi_W$ is a projection onto
the subspace $W$, then we may write $V = W plus.circle ker(pi_W)$. With this
in mind, we will construct the required subspace $W'$ as the kernel of a
suitable projection map $pi_W$. For this, we demand that $pi_W$ be
$G$-invariant.

#definition[
  A linear map $f: V -> V'$ is called $G$-invariant if it is compatible with
  the $G$-action, i.e. for all $g in G$, $v in V$, we have $f(g v) = g f(v)$.
]

Note that the above definition implicitly deals with _two_ representations
$(sigma, V)$ and $(sigma', V)$ of $G$. The indicated property really looks
like $sigma'(g)(f(v)) = f(sigma(g)(v))$ when written in full.

#lemma[
  Let $f: V -> V'$ be $G$-invariant. Then,
  + $ker(f)$ is a stable subspace of $V$.
  + $im(f)$ is a stable subspace of $V'$.
] <lem_ker_im>

Given any linear map $f: V -> V'$, we can construct a $G$-invariant linear map
via $
  tilde(f): V -> V', wide
  v mapsto sum_(g in G) " " g f(g^(-1) v).
$ With this, we are ready to furnish a proof of our theorem.

#proof([of @thm_decomposition])[
  Let $pi: V -> W$ be any projection onto $W$. Observe that $
    pi_W: V -> W, wide
    v mapsto 1/("ord"(G)) sum_(g in G) " " g pi(g^(-1) v)
  $ is a $G$-invariant projection onto $W$. Setting $W' = ker(pi_W)$
  completes the proof.
]

#remark[
  Note how the assumption that $"char(K)" divides.not "ord"(G)$ is crucial for
  defining the projection $pi_W$.
]


= Irreducible representations

#definition("Irreducible representations")[
  We way that a representation is irreducible if it admits no proper
  non-trivial subrepresentations.
]

In other words, a representation $(sigma, V)$ is irreducible _if and only if_
the only $G$-invariant subspaces of $V$ are ${0}, V$.

#example[
  All one dimensional representations are irreducible.
]

#theorem("Maschke's Theorem")[
  Suppose that $"char"(K) divides.not "ord"(G)$.
  Then, every representation of $G$ over the field $K$ can be written as a
  direct sum of irreducible representations of $G$.
] <thm_maschke>
#proof[
  Follows immediately from @thm_decomposition.
]

#example[
  Combining @ex_stable_S3[Examples] and@ex_stable_S3_perp[], we have the
  decomposition $
    CC^3 = "span"{e_1 + e_2 + e_3} plus.circle "span"{e_1 - e_2, e_2 - e_3, e_3 - e_1}
  $ into irreducible subrepresentations of $S_3$.
]

When we say that two representations $(sigma, V)$ and $(sigma', V')$ are
isomorphic, denoted $V tilde.equiv V'$, we mean that there exists a
$G$-invariant linear bijection $f: V -> V'$. The following result offers a
very powerful characterization of $G$-invariant maps between irreducible
representations.

#theorem("Schur's Lemma")[
  Let $V, V'$ be two irreducible representations of $G$, and let $f: V -> V'$
  be a $G$-invariant linear map.
  + If $V tilde.equiv.not V'$, then $f = 0$.
  + If $V = V'$ and $K$ is algebraically closed, then $f$ is a scalar
    map, i.e. $f = lambda " " id_V$ for some $lambda in K$.
] <thm_schur>
#proof[
  1. Suppose that $f eq.not 0$. It suffices to show that $f$ is an
     isomorphism; to do so, we make extensive use of @lem_ker_im.

     First, $ker(f) subset.eq V$ is stable, hence must be one of ${0}, V$ by
     the irreducibility of $V$. The assumption $f eq.not 0$ forces $ker(f) =
     {0}$, whence $f$ is injective.

     Next, $im(f) subset.eq V'$ is stable, hence must be one of ${0}, V'$ by
     the irreducibility of $V'$. Again, $f eq.not 0$ forces $im(f) = V'$,
     whence $f$ is surjective.

  2. We have a $G$-invariant linear bijection $f: V -> V$; suppose that $f
     eq.not 0$. Let $lambda$ be an eigenvalue of $f$, and observe that the map
     $(f - lambda" "id_V)$ is also $G$-invariant; indeed, for all $g in G$,
     $v in V$, $
        (f - lambda)(g v) = f(g v) - lambda g v
          = g f(v) - g lambda v
          = g (f - lambda)(v).
     $ Since $lambda$ is an eigenvalue of $f$, we have $ker(f - lambda) eq.not
     {0}$. Since $ker(f - lambda) subset.eq V$ is stable and $V$ is
     irreducible, we must have $ker(f - lambda) = V$, whence $f - lambda"
     "id_V = 0$.
]
#remark[
  Note how the existence of the scalar $lambda in K$ is guaranteed by the fact
  that $K$ is algebraically closed.
]


#corollary[
  All $CC$-linear irreducible representations of finite abelian groups are one
  dimensional.
]
#proof[
  Let $(sigma, V)$ be an irreducible representation of a finite abelian group
  $G$. Check that for each $g in G$, the linear map $sigma(g): V -> V$ is
  $G$-invariant, since it commutes with all $sigma(h)$ for $h in G$. From
  Schur's Lemma (@thm_schur), each $sigma(g)$ is a scalar map. As a result,
  every one dimensional subspace of $V$ is stable. The result now follows from
  the irreducibility of $V$.
]


= Characters

#definition("Character")[
  The character $chi_V$ of a representation $(sigma, V)$ of $G$ is the
  function $
    chi_V: G -> K, wide
    g mapsto tr(sigma(g)).
  $
]

#example[
  $chi_V (1) = dim(V)$.
]

Observe that $chi_V (g)$ is precisely the sum of eigenvalues of $sigma(g)$.
The eigenvalues of $chi_V (g^(-1))$ are simply reciprocals of those of $chi_V
(g)$; in the setting $K = CC$, the following result is immediate from
@prop_eigenvalues.

#proposition[
  Suppose that $K = CC$. Then, $chi_V (g^(-1)) = overline(chi_V (g))$.
] <prop_inverse_character>

The fact that the trace is invariant under conjugation, i.e. $tr(t s t^(-1)) =
tr(s)$, yields the following result.

#lemma[
  $chi_V$ is a class function, i.e. $chi_V$ is constant on conjugacy classes
  of $G$.
]

#lemma[
  Isomorphic representations have the same character.
] <lem_isomorphic_character>
#proof[
  Let $f: V -> V'$ be an isomorphism of representations $(sigma, V)$ and
  $(sigma', V')$ of $G$. Then for each $g in G$, we have $f compose sigma(g) =
  sigma'(g) compose f$, hence $sigma(g) = f^(-1) compose sigma'(g) compose f$.
  Taking the trace of both sides and using the cyclic property gives
  $tr(sigma(g)) = tr(sigma'(g))$ as desired.
]


== Orthogonality

The space $K^G$ of all maps $G -> K$ forms a vector space over $K$, with
dimension $"ord"(G)$. In the setting $K = CC$, we may define the following
inner product. $
  ip(dot, dot): CC^G times CC^G -> CC, wide
  (phi, psi) mapsto 1/"ord"(G) sum_(g in G)" " phi(g) overline(psi(g)).
$

#remark[
  For characters $chi, chi'$, @prop_inverse_character gives $
    ip(chi, chi') = 1/"ord"(G) sum_(g in G)" " chi(g) chi'(g^(-1)).
  $
]


#theorem("Orthogonality of characters")[
  Suppose that $K = CC$. Let $(sigma, V)$, $(sigma', V')$ be two irreducible
  representations of $G$.
  + If $V tilde.equiv.not V'$, then $ip(chi_V, chi_V') = 0$.
  + If $V tilde.equiv V'$, then $ip(chi_V, chi_V') = 1$.
] <thm_orthogonality>
#proof[
  Let ${v_1, ..., v_n}$ be a basis of $V$, and let ${v'_1, ..., v'_m}$ be a
  basis of $V'$. Given any linear map $f: V -> V'$, we will denote $tilde(f)
  = sum_(g in G) sigma'(g) compose f compose sigma(g)^(-1)$; recall that
  $tilde(f)$ is $G$-invariant.

  1. Observe that Schur's Lemma (@thm_schur) forces all such $tilde(f) = 0$.
     In particular, consider the maps $e_(i j)$ defined for each $1 <= i <= n$,
     $1 <= j <= m$ as $
        e_(i j): V -> V', wide
          sum_i alpha_i v_i mapsto alpha_i v'_j.
     $ These maps ${e_(i j)}$ form a basis of $cal(L)(V, V')$. Check that the
     matrix entries obey $
        [a compose e_(i j) compose b]_(k ell) = [a]_(k i) [b]_(j ell),
     $ so using $tilde(e)_(i j) = 0$ gives the relations $
        [tilde(e)_(i j)]_(k l)
          = sum_(g in G) [sigma'(g) compose e_(i j) compose sigma(g)^(-1)]_(k l)
          = sum_(g in G) [sigma'(g)]_(k i) [sigma(g)^(-1)]_(j ell)
          = 0
     $ for all $1 <= i, k <= n$, $1 <= j, ell <= m$. These hold in particular
     for $i = k$, $j = ell$; summing over $1 <= i <= n$, $1 <= j <= m$, we
     have $
        0  = sum_(i j) sum_(g in G) [sigma'(g)]_(i i) [sigma(g)^(-1)]_(j j) 
          &= sum_(g in G) ((sum_i [sigma'(g)]_(i i)) (sum_j [sigma(g)^(-1)]_(j j))) \
          &= sum_(g in G) chi_V (g) chi_(V') (g^(-1)) \
          &= "ord"(G) ip(chi_V, chi_V').
     $
  2. Schur's Lemma (@thm_schur) forces all such $tilde(f) = lambda_f id_V$
     for scalars $lambda_f in CC$. To extract $lambda_f$, take the trace of both sides to obtain $
       n lambda_f = dim(V) lambda_f = sum_(g in G) tr(sigma'(g) compose f compose sigma(g)^(-1)) = "ord"(G) tr(f).
     $ With this, each $tilde(e)_(i j) = lambda_(i j) delta_(i j) id_V$,
     where $lambda_(i j) = "ord"(G)\/ n$. Thus, we obtain the relations $
       sum_(g in G) [sigma'(g)]_(k i) [sigma(g)^(-1)]_(j ell) = 1/n
       "ord"(G) delta_(i j) delta_(k l)
     $ for all $1 <= i, j, k, ell <= n$. Following a similar process as before, $
       "ord"(G) ip(chi_V, chi_V')
       &= sum_(g in G) ((sum_i [sigma'(g)]_(i i)) (sum_j [sigma(g)^(-1)]_(j j))) \
       &= sum_(i j) sum_(g in G) [sigma'(g)]_(i i) [sigma(g)^(-1)]_(j j) \
       &= sum_(i j) 1/n "ord"(G) delta_(i j) \
       &= "ord"(G)
     $
  This completes the proof.
]

With this, the characters of irreducible representations form an orthonormal
subset of class functions on $G$. To check whether a representation $V$ is
irreducible or not, it is enough to verify that $ip(chi_V, chi_V) = 1$.

#corollary[
  The number of irreducible representations of $G$ (up to isomorphism) is at
  most the number of conjugacy classes of $G$.
] <cor_number_rep_upper>

Given any representation $V$ of $G$, we can use Maschke's Theorem
(@thm_maschke) to decompose it as a direct sum of (non-isomorphic) irreducible
representations $V_1, ..., V_k$, with multiplicities $m_1, ..., m_k$. By
representing the elements of $G$ as matrices in block diagonal form, we can
derive the following result.

#lemma[
  Let $V_1, ..., V_k$ be irreducible representations of $G$, and let $
    V tilde.equiv m_1 V_1 plus.circle dots.c plus.circle m_k V_k.
  $ Then, $
    chi_V = m_1 chi_V_1 + dots.c + m_k chi_V_k.
  $ The multiplicities can be recovered as $m_i = ip(chi_V, chi_V_i)$.
]

This immediately tells us that $chi_V = chi_V'$ if and only if $V tilde.equiv
V'$. Furthermore, we have the relation $
  ip(chi_V, chi_V) = sum_i m_i^2.
$


== The character table for $S_3$

We have now established that the trivial representation, the one dimensional
representation from @ex_S3_1D, and the two dimensional representation from
@ex_S3_2D are the only irreducible representations of $S_3$. Note that $S_3$
has three conjugacy classes: ${e}$, ${(12), (23), (31)}$, and ${(123),
(321)}$. With this, we can construct the _character table_ for $S_3$, with
each row containing the characters of the group elements with respect to the
given representation.
#align(
  center,
  tablex(
    columns: 7,
    inset: (x: 1em, y: 0.6em),
    stroke: table-stroke,
    align: center + horizon,
    auto-hlines: false,
    auto-vlines: false,
    [*$bold(S_3)$*], vlinex(), $e$, $(12)$, $(23)$, $(31)$, $(123)$, $(321)$,
    hlinex(),
    [Trivial],  1,  1,  1,  1,  1,  1,
    [Sign],     1, -1, -1, -1,  1,  1,
    [Standard], 2,  0,  0,  0, -1, -1,
  )
)
Observe that the rows of this table are orthogonal; indeed, so are the
columns!


== The character table for $S_4$

Let $S_4$ act on $CC^4$ by permuting the basis vectors ${e_1, e_2, e_3, e_4}$,
and let $(sigma, V)$ denote the induced (natural) representation. Note that
each matrix $sigma(g)$ is a permutation, hence its trace $chi_V (g)$ is
precisely the number of elements of ${1, 2, 3, 4}$ fixed by the action of $g$.
With this, we can compute $chi_V$ for each conjugacy class (identified by its
cycle type) as follows.
#align(
  center,
  tablex(
    columns: 6,
    inset: (x: 1em, y: 0.6em),
    stroke: table-stroke,
    align: center + horizon,
    auto-hlines: false,
    auto-vlines: false,
    [*$bold(S_4)$*], vlinex(), $e$, $(a b) times 6$, $(a b)(c d) times 3$, $(a b c) times 8$, $(a b c d) times 6$,
    hlinex(),
    [Trivial],  1,  1,  1,  1,  1,
    [Sign],     1, -1,  1,  1, -1,
    $V$,        4,  2,  0,  1,  0,
  )
)
Compute $
  ip(chi_V, chi_V) = 1/24 (4^2 + 6 dot.c 2^2 + 8 dot.c 1^2) = 2,
$ whence $V$ is not irreducible. Indeed, we know that $W_1 = "span"{e_1 + e_2
+ e_3 + e_4}$ is a trivial subrepresentation of $V$ of dimension $1$.
Furthermore, $2 = 1^2 + 1^2$ is the only way of writing $2$ as a sum of
squares of integers, so $V$ must decompose into precisely two irreducible
subrepresentations with both multiplicities $1$. This means that $V
tilde.equiv W_1 plus.circle W_3$ for some irreducible representation $W_3$ of
dimension 3. Using $chi_V = chi_W_1 + chi_W_3$, we can compute the character
$chi_W_3$ and obtain the following.
#align(
  center,
  tablex(
    columns: 6,
    inset: (x: 1em, y: 0.6em),
    stroke: table-stroke,
    align: center + horizon,
    auto-hlines: false,
    auto-vlines: false,
    [*$bold(S_4)$*], vlinex(), $e$, $(a b) times 6$, $(a b)(c d) times 3$, $(a b c) times 8$, $(a b c d) times 6$,
    hlinex(),
    $W_3$,  3,  1,  -1,  0, -1,
  )
)

Next, we move on to a different representation of $S_4$: consider all subsets
of size 2 of ${1, 2, 3, 4}$ (of which there are 6), and consider the action on
this collection induced by the permutations on the set ${1, 2, 3, 4}$.

#remark[
  If we wish to define a transitive action of $G$ on a set $X$ (and thereby
  examine the vector space $"span"{e_x}_(x in X)$ with the action of $G$
  defined via $g e_x = e_(g x)$), we may invoke the Orbit-Stabilizer Theorem,
  along with the fact that there is only one orbit (all of $X$) to demand that
  $"ord"(X) divides "ord"(G)$.
]

Let $(tau, V')$ denote the induced representation. Again, $chi_V'(g)$ is the
number of 2-subsets fixed by the action of $g$. For instance, an element $(a
b) in S_4$ will only fix 2-subsets ${a, b}, {c, d}$, while an element $(a b c)
in S_4$ fixes no 2-subset. With this, we have the following.
#align(
  center,
  tablex(
    columns: 6,
    inset: (x: 1em, y: 0.6em),
    stroke: table-stroke,
    align: center + horizon,
    auto-hlines: false,
    auto-vlines: false,
    [*$bold(S_4)$*], vlinex(), $e$, $(a b) times 6$, $(a b)(c d) times 3$, $(a b c) times 8$, $(a b c d) times 6$,
    hlinex(),
    $V'$,  6,  2,  2,  0,  0,
  )
) Compute $ip(chi_V', chi_V') = 3 = 1^2 + 1^2 + 1^2$. Again, we may compute
$ip(chi_V', chi_W_1) = 1$ and $ip(chi_V', chi_W_3) = 1$, which tells us that
$V' tilde.equiv W_1 plus.circle W_3 plus.circle W_2$ for some irreducible
representation $W_2$ of dimension $2$. Using $chi_V' = chi_W_1 + chi_W_3 +
chi_W_2$, we can compute the character $chi_W_2$.
#align(
  center,
  tablex(
    columns: 6,
    inset: (x: 1em, y: 0.6em),
    stroke: table-stroke,
    align: center + horizon,
    auto-hlines: false,
    auto-vlines: false,
    [*$bold(S_4)$*], vlinex(), $e$, $(a b) times 6$, $(a b)(c d) times 3$, $(a b c) times 8$, $(a b c d) times 6$,
    hlinex(),
    $W_2$,  2,  0,  2,  -1,  0,
  )
) We now have $4$ irreducible characters of $S_4$; indeed, we may combine
$W_3$ with the sign representation to get another irreducible representation
$W'_3$, completing the character table of $S_4$.
#align(
  center,
  tablex(
    columns: 6,
    inset: (x: 1em, y: 0.6em),
    stroke: table-stroke,
    align: center + horizon,
    auto-hlines: false,
    auto-vlines: false,
    [*$bold(S_4)$*], vlinex(), $e$, $(a b) times 6$, $(a b)(c d) times 3$, $(a b c) times 8$, $(a b c d) times 6$,
    hlinex(),
    [Trivial],  1,  1,  1,  1,  1,
    [Sign],     1, -1,  1,  1, -1,
    $W_2$,      2,  0,  2, -1,  0,
    $W_3$,      3,  1, -1,  0, -1,
    $W'_3$,     3, -1, -1,  0,  1,
  )
) The last trick uses the following proposition.

#proposition[
  Let $(sigma, V)$ and $(tau, CC^times)$ be representations of $G$. Then,
  $(tau sigma, V)$ is also a representation of $G$, where $(tau sigma)(g) =
  tau(g) sigma(g)$. Furthermore, $chi_(tau sigma) = chi_tau chi_sigma$.
] <prop_tensor_1D>

#remark[
  The above proposition is a special case of @prop_tensor.
]


= Regular representations revisited

We focus our attention once again to the regular representation, as defined in
@ex_regular. Note that when $G$ acts on itself by left multiplication, only
the identity element $1$ fixes all $"ord"(G)$ elements of $G$, while the
remaining elements have no fixed points at all. With this, we have the
following proposition.

#proposition[
  Let $(tau, V_G)$ be the regular representation of $G$, and let $chi_tau$
  denote its character. Then, $
    chi_tau (g) = cases(
      "ord"(G) quad&"if" g = 1,\
      0 &"otherwise".
    )
  $ It follows that $
    chi_tau = d_1 chi_1 + ... + d_k chi_k
  $ where $chi_1, ..., chi_k$ are the irreducible characters of $G$, and each
  $d_i = chi_i (1)$ is the dimension of the corresponding irreducible
  representation.
] <prop_regular>

By simply evaluating $chi_tau (1)$, we have the following result.

#corollary[
  Let $chi_1, ..., chi_k$ be the irreducible characters of $G$, and let each
  $d_i = chi_i (1)$. Then, $
    sum_i d_i^2 = "ord"(G).
  $
] <cor_dim_sq>

#proposition[
  Let $f: G -> CC$ be a class function, and let $(sigma, V)$ be a
  representation of $G$. Define $
    f_sigma: V -> V, wide
    v mapsto sum_(g in G) f(g)thin sigma(g)(v).
  $ Then, $f_sigma$ is $G$-invariant. Furthermore, if $(sigma, V)$ is
  irreducible, then Schur's Lemma (@thm_schur) gives $f_sigma = lambda id_V$,
  where $lambda = "ord(G)" ip(f, overline(chi_sigma)) \/ dim(V)$.
] <prop_class_func>

With this construction, we can improve upon @cor_number_rep_upper and
precisely count the number of irreducible representations of a group $G$ (up
to isomorphism).  However, we still do not have any simple way of calculating
these representations explicitly.

#theorem[
  The number of irreducible representations of $G$ (up to isomorphism) is
  precisely the number of conjugacy classes of $G$.
]
#proof[
  Let $cal(C)$ be the space of class functions on $G$, with dimension equal to
  the number of conjugacy classes of $G$. Let $cal(X)$ be the subspace of
  $cal(C)$ spanned by the irreducible characters ${chi_i}$ of $G$. We claim
  that $cal(X) = cal(C)$. It is enough to show that the orthocomplement of
  $cal(X)$ in $cal(C)$ is trivial. For this, pick $f in cal(C)$ such that
  all $ip(f, overline(chi_i)) = 0$. Let $(tau, V_G)$ be the regular
  representation of $G$, and use @prop_regular to write $
    V_G tilde.equiv d_1 V_1 plus.circle ... plus.circle d_k V_k
  $ where ${(sigma_i, V_i)}$ are the irreducible representations corresponding
  to the characters ${chi_i}$. Using @prop_class_func, each $f_sigma_i = 0$,
  hence $f_tau = 0$. Evaluating $f_tau$ at the element $e_1 in V_G$, we have $
    sum_(g in G) f(g)thin sigma(g)(e_1) = sum_(g in G) f(g)thin e_g = 0.
  $ Since ${e_g}_(g in G)$ forms a basis of $V_G$, we must have $f = 0$.
]

#corollary[
  The irreducible characters of $G$ form a basis of the space of all class
  functions on $G$.
] <cor_class_basis>


= Tensor products of representations

The construction used in @prop_tensor_1D generalizes nicely to tensor products
of representations, as follows.

#definition[
  Let $V, V'$ be two representations of $G$. Then, the tensor product $V
  times.circle V'$ is a representation of $G$ induced by the action defined by
  $
    g(v times.circle v') = (g v) times.circle (g v').
  $
]

Recall that if ${v_i}$ is a basis of $V$ and ${v'_j}$ is a basis of $V$', then
${v_i times.circle v'_j}$ forms a basis of $V times.circle V'$. Using this,
the next proposition follows.

#proposition[
  Let $V, V'$ be two representations of $G$. Then, $chi_(V times.circle V') =
  chi_V chi_V'$.
] <prop_tensor>

Let's focus on the tensor product $V times.circle V$ and examine the
involution defined by $
  iota: V times.circle V -> V times.circle V, wide
  v times.circle v' mapsto v' times.circle v.
$ This map has two eigenspaces, corresponding to the eigenvalues $1$ and $-1$,
which we define as $"Sym"^2(V)$ and $"Alt"^2(V)$ respectively. Furthermore, it
is clear that these eigenspaces are stable under the action of $G$, since the
action of $G$ commutes with $iota$. This gives us the following decomposition
of $V times.circle V$.

#proposition[
  Let $V$ be a representation of $G$. Then, $
    V times.circle V tilde.equiv "Sym"^2(V) plus.circle "Alt"^2(V).
  $
]

Observe that $"Sym"^2(V)$ is spanned by elements of the form $v times.circle
v' + v' times.circle v$, while $"Alt"^2(V)$ is spanned by elements of the form
$v times.circle v' - v' times.circle v$. This, together with $dim(V
times.circle V) = n^2$, tells us that $
  dim("Sym"^2(V)) = binom(n, 2) + n, wide
  dim("Alt"^2(V)) = binom(n, 2).
$ To compute the characters of these representations, first note that $
  chi_V^2 = chi_("Sym"^2(V)) + chi_("Alt"^2(V)).
$ Fix $g in G$ and choose a basis ${v_i}$ of $V$ such that the action of $g$
is diagonalized, i.e. $g v_i = lambda_i v_i$; recall that this is always
possible via @prop_eigenvalues when we are working over the field $K = CC$. We
need only check the action of $g$ on the basis elements of $"Sym"^2(V)$ and
$"Alt"^2(V)$. To this end, compute $
  g(v_i times.circle v_j + v_j times.circle v_i) = lambda_i lambda_j (v_i
  times.circle v_j + v_j times.circle v_i),
$ whence $
  chi_("Sym"^2(V))(g)
    = sum_(i <= j) lambda_i lambda_j
    = sum_(i < j) lambda_i lambda_j + sum_i lambda_i^2
    = 1/2 (sum_i lambda_i)^2 + 1/2 sum_i lambda_i^2.
$ However, $sum_i lambda_i$ and $sum_i lambda_i^2$ are precisely $chi_V (g)$
and $chi_V (g^2)$. Thus, we have the following result.

#proposition[
  $
    chi_("Sym"^2(V)) (g) = 1/2(chi_V (g)^2 + chi_V (g^2)), wide
    chi_("Alt"^2(V)) (g) = 1/2(chi_V (g)^2 - chi_V (g^2)).
  $
] <prop_sym_alt_character>


== The character table for $S_5$

We proceed much in the same manner as in the computation for $S_4$; the
character of the natural representation $V$ of $S_5$ (induced by the action of
$S_5$ on $5$ objects) can be computed by counting the number of fixed points
of the corresponding conjugacy class.
#align(
  center,
  tablex(
    columns: 8,
    inset: (x: 1em, y: 0.6em),
    stroke: table-stroke,
    align: center + horizon,
    auto-hlines: false,
    auto-vlines: false,
    [*$bold(S_5)$*], vlinex(), $e$, $(a b)$, $(a b)(c d)$, $(a b c)$, $(a b) (c d f)$, $(a b c d)$, $(a b c d f)$,
    [], $times 1$, $times 10$, $times 15$, $times 20$, $times 20$, $times 30$, $times 24$,
    hlinex(),
    [Trivial],  1,  1,  1,  1,  1,  1,  1,
    [Sign],     1, -1,  1,  1, -1, -1,  1,
    $V$,        5,  3,  1,  2,  0,  1,  0,
  )
)
Since the inner product of the first and last rows is non-zero, $V$ contains a
copy of the trivial representation, which we subtract from its character to
obtain the representation $W_4$. This happens to be irreducible (verified by
checking $ip(chi_W, chi_W) = 1$), and we obtain another irreducible
representation $W'_4$ by taking the tensor product with the sign
representation.
#align(
  center,
  tablex(
    columns: 8,
    inset: (x: 1em, y: 0.6em),
    stroke: table-stroke,
    align: center + horizon,
    auto-hlines: false,
    auto-vlines: false,
    [*$bold(S_5)$*], vlinex(), $e$, $(a b)$, $(a b)(c d)$, $(a b c)$, $(a b) (c d f)$, $(a b c d)$, $(a b c d f)$,
    hlinex(),
    $W_4$,        4,  2,  0,  1,  -1,  0,  -1,
    $W'_4$,       4, -2,  0,  1,   1,  0,  -1,
  )
)
We now compute the characters of $"Sym"^2(W_4)$ and $"Alt"^2(W_4)$ using
@prop_sym_alt_character. To do so, we compute $chi_(W_4) (g)^2$ and $chi_(W_4)
(g^2)$ for each conjugacy class; the latter can be computed by examining what
happens to each cycle type after squaring.
#align(
  center,
  tablex(
    columns: 8,
    inset: (x: 1em, y: 0.6em),
    stroke: table-stroke,
    align: center + horizon,
    auto-hlines: false,
    auto-vlines: false,
    [*$bold(S_5)$*], vlinex(), $e$, $(a b)$, $(a b)(c d)$, $(a b c)$, $(a b) (c d f)$, $(a b c d)$, $(a b c d f)$,
    hlinex(),
    $chi_(W_4)^2$,     16,  4,  0,  1,  1,  0,   1,
    $chi_(W_4) (g^2)$,  4,  4,  4,  1,  1,  0,  -1,
    $"Alt"^2(W_4)$,     6,  0, -2,  0,  0,  0,   1,
    $"Sym"^2(W_4)$,    10,  4,  2,  1,  1,  0,   0,
  )
)
Note that $"Alt"^2(W_4)$ is irreducible, but $"Sym"^2(W_4)$ is not. Indeed,
the latter clearly has a positive inner product with the trivial
representation, hence contains a copy of it which we take away giving us
$W_9$.
#align(
  center,
  tablex(
    columns: 8,
    inset: (x: 1em, y: 0.6em),
    stroke: table-stroke,
    align: center + horizon,
    auto-hlines: false,
    auto-vlines: false,
    [*$bold(S_5)$*], vlinex(), $e$, $(a b)$, $(a b)(c d)$, $(a b c)$, $(a b) (c d f)$, $(a b c d)$, $(a b c d f)$,
    hlinex(),
    $W_9$,    9,  3,  1,  0,  0,  -1,   -1,
  )
)
Looking back, we have found five irreducible representations of $S_5$, and
hence are left to discover two more. The sum of squares of their dimensions is
$70$; @cor_dim_sq tells us that the sum of squares of the dimensions of the
remaining two must be $"ord"(S_5) - 70 = 50$. Now, $50 = 1^2 + 7^2 = 5^2 +
5^2$, but the first decomposition is not possible since the trivial and sign
representations are the only ones of dimension 1. Thus, both remaining
representations are of dimension 5.

Observe that $ip(chi_W_9, chi_W_9) = 2 = 1^2 + 1^2$, hence $W_9$ must be
composed of two irreducible representations. The only way to write 9 as the
sum of two dimensions of irreducible representations (which we know are $1, 1,
4, 4, 5, 5, 6$) is $4 + 5$. Indeed, $ip(chi_W_9, chi_W_4) = 1$, so we take
$W_4$ away leaving us with an irreducible representation $W_5$. Taking the
tensor product with the sign representation yields our final irreducible
representation $W_5'$. Thus, the complete character table of $S_5$ is as
follows.
#align(
  center,
  tablex(
    columns: 8,
    inset: (x: 1em, y: 0.6em),
    stroke: table-stroke,
    align: center + horizon,
    auto-hlines: false,
    auto-vlines: false,
    [*$bold(S_5)$*], vlinex(), $e$, $(a b)$, $(a b)(c d)$, $(a b c)$, $(a b) (c d f)$, $(a b c d)$, $(a b c d f)$,
    [], $times 1$, $times 10$, $times 15$, $times 20$, $times 20$, $times 30$, $times 24$,
    hlinex(),
    [Trivial],        1,  1,  1,  1,  1,  1,  1,
    [Sign],           1, -1,  1,  1, -1, -1,  1,
    $W_4$,            4,  2,  0,  1, -1,  0, -1,
    $W'_4$,           4, -2,  0,  1,  1,  0, -1,
    $W_5$,            5,  1,  1, -1,  1, -1,  0,
    $W'_5$,           5, -1,  1, -1, -1,  1,  0,
    $"Alt"^2(W_4)$,   6,  0, -2,  0,  0,  0,  1,
  )
)

#remark[
  Observe that the columns of this character table are pairwise orthogonal!
  Indeed, we already know from @prop_regular that the first column of any
  character table must be orthogonal to the rest. Furthermore, this character
  table strongly suggests a relation of the form $
    sum_i |chi_i (g)|^2 = "ord"(G) / "ord"("Cl"(g)),
  $ where $chi_i, ..., chi_k$ are the irreducible characters of $G$, and
  $"Cl"(g)$ denotes the conjugacy class of $g in G$.
]


= Orthogonality of characters revisited

Let $cal(O)_1, ..., cal(O)_k$ be the conjugacy classes of $G$, let $n_1, ...,
n_k$ be their sizes, and let $chi_1, ..., chi_k$ be the irreducible characters
of $G$. Furthermore, let's work with the field $K = CC$. Set $n = "ord"(G)$.
We know from @thm_orthogonality that (with a little abuse of notation) $
  sum_ell n_ell thin chi_i (cal(O)_ell) overline(chi_j (cal(O)_ell)) = delta_(i j) n.
$ We construct the matrix $A in M_k (CC)$ via $A_(i ell) = sqrt(n_ell\/n) thin
chi_i (cal(O)_ell)$ and note that $A A^dagger = II_n$. Thus, $A$ is a unitary
matrix with orthonormal rows. As a result, the columns of $A$ must also be
orthonormal, giving $
  delta_(i j) = sum_ell A_(ell i) overline(A_(ell j)) = sqrt(n_i n_j) / n sum_ell chi_ell (cal(O)_i) overline(chi_ell (cal(O)_j)).
$ In other words, $
  sum_ell chi_ell (cal(O)_i) overline(chi_ell (cal(O)_j)) = cases(
    n \/ n_i quad&"if" i = j,\
    0 &"otherwise".
  )
$ Thus, the columns of the character table of $G$ also obey an orthonormality
relation. We supply a different proof below.

#theorem("Column orthogonality of characters")[
  Suppose that $K = CC$. Let $chi_1, ..., chi_k$ be the irreducible characters
  of $G$, and let $g, g' in G$. Denote $g tilde g'$ if $g$ and $g'$ are
  conjugates.  Then, $
    sum_i chi_i (g) overline(chi_i (g')) = cases(
      "ord"(G) \/ "ord"("Cl"(g)) quad&"if" g tilde g',\
      0 &"otherwise".
    )
  $
] <thm_orthogonality_col>

#proof[
  Define the class function $
    f_g: G -> CC, wide
    h mapsto cases(
      1 quad&"if" g tilde h,\
      0 &"otherwise".
    )
  $ Using @cor_class_basis, we can expand $f_g$ in terms of the irreducible
  characters as $
    f_g = a_1 chi_1 + ... + a_k chi_k,
  $ and compute each $a_i = ip(f_g, chi_i) = "ord"("Cl"(g)) thin
  overline(chi_i (g)) \/ "ord"(G)$. Thus, $
    "ord"("Cl"(g)) / "ord"(G) sum_i chi_i (g) overline(chi_i (h))
      = overline(f_g (h)) = cases(
        1 quad&"if" g tilde h,\
        0 &"otherwise",
      )
  $ as desired.
]


== The character table for $A_5$

Note that $A_5$ has five conjugacy classes; the 5-cycles split into two
conjugacy classes in $A_5$. As usual, we start with the natural representation
$V$ of $A_5$, then take away the copy of the trivial representation yielding
an irreducible representation $W_4$.
#align(
  center,
  tablex(
    columns: 6,
    inset: (x: 1em, y: 0.6em),
    stroke: table-stroke,
    align: center + horizon,
    auto-hlines: false,
    auto-vlines: false,
    [*$bold(A_5)$*], vlinex(), $e$, $(1 2)(3 4)$, $(1 2 3)$, $(1 2 3 4 5)$, $(1 3 5 2 4)$,
    [], $times 1$, $times 15$, $times 20$, $times 12$, $times 12$,
    hlinex(),
    [Trivial],  1,  1,  1,  1,  1,
    $V$,        5,  1,  2,  0,  0,
    $W_4$,      4,  0,  1, -1, -1,
  )
)
We compute $"Sym"^2(W_4)$ and $"Alt"^2(W_4)$ as usual.
#align(
  center,
  tablex(
    columns: 6,
    inset: (x: 1em, y: 0.6em),
    stroke: table-stroke,
    align: center + horizon,
    auto-hlines: false,
    auto-vlines: false,
    [*$bold(A_5)$*], vlinex(), $e$, $(1 2)(3 4)$, $(1 2 3)$, $(1 2 3 4 5)$, $(1 3 5 2 4)$,
    hlinex(),
    $chi_(W_4)^2$,     16,  0,  1,  1,  1,
    $chi_(W_4) (g^2)$,  4,  4,  1, -1, -1,
    $"Alt"^2(W_4)$,     6, -2,  0,  1,  1,
    $"Sym"^2(W_4)$,    10,  2,  1,  0,  0,
  )
)
Now, $"Sym"^2(W_4)$ contains copies of both the trivial representation and
$W_4$; taking them away yields the irreducible representation $W_5$.
#align(
  center,
  tablex(
    columns: 6,
    inset: (x: 1em, y: 0.6em),
    stroke: table-stroke,
    align: center + horizon,
    auto-hlines: false,
    auto-vlines: false,
    [*$bold(A_5)$*], vlinex(), $e$, $(1 2)(3 4)$, $(1 2 3)$, $(1 2 3 4 5)$, $(1 3 5 2 4)$,
    hlinex(),
    $W_5$,     5,  1, -1,  0,  0,
  )
)
Looking back, we have found three out of five irreducible representations. The
sum of squares of their dimensions is $42$, hence the sum of squares
dimensions of the remaining two representations must be $"ord"(A_5) - 42 = 18$
by @cor_dim_sq. The only way to write this as a sum of two squares is $18 =
3^2 + 3^2$, hence the remaining two irreducible representations must both have
dimension $3$.

/* Computing $ip(chi_("Alt"^2(W_4)), chi_("Alt"^2(W_4))) = 2 = 1^2 + 1^2$, we see */
/* that $"Alt"^2(W_4)$ must be composed of two irreducible representations both */
/* of dimension $3$ (we already know that the dimensions of the irreducible */
/* representations are $1, 3, 3, 4, 5$, and the inner product with the trivial */
/* representation is zero). */

We can now fill in most of the character table for $A_5$ as follows.
#align(
  center,
  tablex(
    columns: 6,
    inset: (x: 1em, y: 0.6em),
    stroke: table-stroke,
    align: center + horizon,
    auto-hlines: false,
    auto-vlines: false,
    [*$bold(A_5)$*], vlinex(), $e$, $(1 2)(3 4)$, $(1 2 3)$, $(1 2 3 4 5)$, $(1 3 5 2 4)$,
    [], $times 1$, $times 15$, $times 20$, $times 12$, $times 12$,
    hlinex(),
    [Trivial],  1,    1,    1,    1,    1,
    $W_4$,      4,    0,    1,   -1,   -1,
    $W_3$,      3,  $a$,  $b$,  $c$,  $d$,
    $W'_3$,     3, $a'$, $b'$, $c'$, $d'$,
    $W_5$,      5,    1,   -1,    0,    0,
  )
)

We can be sure that the unknown quantities are real because of the following
observation.

#lemma[
  Let $G$ be such that for every $g in G$, the elements $g$ and $g^(-1)$
  belong to the same conjugacy class. Then, the characters of $G$ (with $K =
  CC$) are real valued.
] <lem_real_char>
#proof[
  Use $chi(g) = chi(g^(-1)) = overline(chi(g))$, with the first equality
  following from the fact that $chi$ is a class function and $g tilde g^(-1)$.
]

Column orthogonality (@thm_orthogonality_col) gives the relations $1 + 3a +
3a' + 5 = 0$ and $1^2 + a^2 + a'^2 + 1^2 = 60\/15 = 4$, which simplifies to
$a + a' = -2$ and $a^2 + a'^2 = 2$. This is only possible if $a = a' = -1$.
Again, we have the relations $1 + 4 + 3b + 3b' - 5 = 0$ and $1^2 + 1^2 +
b^2 + b'^2 + 1^2 = 60\/20 = 3$, which simplify to $b + b' = 0$ and $b^2 + b'^2
= 0$. This is only possible if $b = b' = 0$.

Similar computations give $c + c' = d + d' = 1$, and $c^2 + c'^2 = d^2 + d'^2
= 3$. This gives $c c' = d d' = -1$. Thus, $c, c'$ and $d, d'$ are the roots
of $x^2 - x - 1$, which we denote as $phi = (1 + sqrt(5))\/2$ and $psi = (1 -
sqrt(5)) \/ 2$. Without loss of generality, set $c = phi$, $c' = psi$. Using
the column orthogonality $1 + 1 + c d + c' d' = 0$, we discard the case $d =
phi$, $d' = psi$, leaving $d = psi$, $d' = phi$. This completes our
computation of the character table of $A_5$.
#align(
  center,
  box(
    tablex(
      columns: 6,
      inset: (x: 1em, y: 0.6em),
      stroke: table-stroke,
      align: center + horizon,
      auto-hlines: false,
      auto-vlines: false,
      breakable: false,
      [*$bold(A_5)$*], vlinex(), $e$, $(1 2)(3 4)$, $(1 2 3)$, $(1 2 3 4 5)$, $(1 3 5 2 4)$,
      [], $times 1$, $times 15$, $times 20$, $times 12$, $times 12$,
      hlinex(),
      [Trivial],  1,    1,    1,     1,     1,
      $W_4$,      4,    0,    1,    -1,    -1,
      $W_3$,      3,   -1,    0, $phi$, $psi$,
      $W'_3$,     3,   -1,    0, $psi$, $phi$,
      $W_5$,      5,    1,   -1,     0,     0,
    )
  )
)


= Induced representations

Consider a representation $W$ of a subgroup $H subset.eq G$. We want to obtain
a representation $V$ of $G$, by extending the action of $H$ on $W$ to the
action of $G$ on a larger space. To do so, we first let $cal(R) = {r_1, ...,
r_m}$ be representative elements from each of the cosets of $H$ in $G$, and
consider the vector spaces $r_i W$. These are just 'copies' of $W$, containing
elements of the form $r_i w$ for $w in W$. We have the isomorphisms $
  phi_i: W -> r_i W_i, wide
  w mapsto r_i w.
$ With this, define the vector space $
  V = r_1 W plus.circle ... plus.circle r_m W.
$ We will define the action of $G$ on $V$ via the components $r_i W$. Given $g
in G$, write $g r_i = r h$ for $r in cal(R)$, $h in H$ (this is always
possible since $g$ belongs to precisely one coset of $H$ in $G$). With this,
for $r_i w in r_i W$, define $g (r_i w) = r (h w)$. It can be shown that this
does indeed define a group action of $G$ on $V$. We call the associated
representation $V$ of $G$ the induced representation $"Ind"_H^G (W)$.

For some fixed $g in G$, observe that the action of $g$ permutes the cosets
$r_i W$ among each other. In particular, if $g r_i = r h$, we have $g (r_i W)
= r W$. Thus, if we represent $g$ as a block matrix using the natural basis
${r_i w_j}$ (where ${w_j}$ forms a basis of $W$), the result contains blocks
of size $dim(W)$, with exactly one block per 'row' and 'column'. This means
that when computing the trace of $g$, the only blocks that contribute
correspond to those $i$ where $g (r_i W) = r_i W$, i.e. $g r_i = r_i h$ for
some $h in H$.  In this setting, we have each $g (r_i w) = r_i (h w)$; thus,
the trace of $g$ acting on $r_i W$ is precisely the same as the trace of $h$
acting on $W$ (use the isomorphism $phi_i$ to note that $g = phi_i compose h
compose phi_i^(-1)$ on $r_i W$). Since $h = r_i^(-1) g r_i$, we have $
  chi_V (g) = sum_(r in cal(R)\ r^(-1) g r in H) chi_W (r^(-1) g r)
    = 1/"ord"(H) sum_(s in G\ s^(-1) g s in H) chi_W (s^(-1) g s).
$ The last equivalence follows from the fact that if $s in r H$, then we may
write $s = r h$ for some $h in H$, hence $s^(-1) g s = h^(-1) (r^(-1) g r) h
in H$ if and only if $r^(-1) g r in H$; furthermore, $chi_W$ will be the same
for both of them since they are conjugates in $H$. The factor of $"ord"(H) =
"ord"(r H)$ accounts for the number of these repeated terms.
