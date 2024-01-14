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
  fill: rgb("#E78963").lighten(90%),
  stroke: rgb("#E78963")
)
#let proposition = thmbox(
  "common",
  "Proposition",
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
]

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
  The only one dimensional representation of $S_3$ in $C^*$ is the sign
  homomorphism. To see this, consider an arbitrary homomorphism $sigma: S_3 ->
  C^*$. Note that $ker(sigma)$ must be a normal subgroup of $S_3$, hence must
  be one of ${e}, A_3, S_3$. The third option yields the trivial
  representation $sigma = id_(C^*)$, and the first option gives the
  contradiction $S_3 tilde.equiv im(sigma) subset C^*$ (the right side is
  abelian while the left is not). This leaves $ker(sigma) = A_3$, i.e.
  $sigma(g) = 1$ for all even permutations $g in S_3$. The remaining elements
  of $S_3$ (the odd permutations) must be sent to $-1$, since for any odd
  permutation $h in S_3$, the permutation $h^2$ is even, so $sigma(h)^2 =
  sigma(h^2) = 1$. The result is precisely the sign homomorphism $
    sigma: S_3 -> C^*, wide
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
          &= sum_(g in G) ((sum_i [sigma(g)]_(i i)) (sum_j [sigma(g)^(-1)]_(j j))) \
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
       &= sum_(g in G) ((sum_i [sigma(g)]_(i i)) (sum_j [sigma(g)^(-1)]_(j j))) \
       &= sum_(i j) sum_(g in G) [sigma'(g)]_(i i) [sigma(g)^(-1)]_(j j) \
       &= sum_(i j) 1/n "ord"(G) delta_(i j) \
       &= "ord"(G)
     $
  This completes the proof.
]

#corollary[
  The number of irreducible representations of $G$ (up to isomorphism) is at
  most the number of conjugacy classes of $G$.
]

#example[
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
] <ex_S3_table>
