#import "template.typ": *

#show: conf.with(
  title: "Final Assignment",
  subject: "MA5102: Partial Differential Equations",
  name: "Satvik Saha",
  affiliation: [
    Department of Mathematics and Statistics,\
    Indian Institute of Science Education and Research, Kolkata
  ]
)


#let dd(..args, d: $diff$) = {
  let x = $x$
  let n = ""
  let y = ""
  if args.pos().len() >= 1 {
     x = args.pos().at(0)
  }
  if args.pos().len() >= 2 {
     n = args.pos().at(1)
  }
  if args.pos().len() >= 3 {
     y = args.pos().at(2)
  }
  $(#d^#n #y) / (#d #x^#n)$
}


== Problem 1

Let $u$ be a solution of
$ a(x, y) u_x + b(x, y) u_y = -u $
and of class $C^1$ in the closed unit disk $Omega$ in the $x y$-plane.
Furthermore, let
$ a(x, y) x + b(x, y) y > 0 $
on the boundary of $Omega$. Prove that $u$ vanishes identically on $Omega$.

=== Solution

Note that by setting $v = u^2 >= 0$, we have $
  a(x, y) v_x + b(x, y) v_y = 2u u_x a + 2u u_y b = -2u^2 = -2v.
$ Since $v$ is of class $C^1$ on $Omega$, it must attain its maximum $M >= 0$
at some point $z_0 = (x_0, y_0) in Omega$. Now, if $z_0$ is in the interior of
$Omega$, then we must have $v_x (z_0) = v_y (z_0) = 0$, hence $M = v(z_0) =
-1/2 (a v_x + b v_y)(z_0) = 0$. This forces $v = 0$, hence $u = 0$ on $Omega$
as desired.

This leaves the case where $z_0 in diff Omega$. Consider an initial curve
along $diff Omega$, and set up the characteristic equations $
  (d x)/(d s) = a, quad
  (d y)/(d s) = b, quad
  (d v)/(d s) = -2v.
$ Thus, $v(theta, s) = phi(theta) e^(-2s)$. Let $theta_0, s_0$ be such that
$(x(theta_0, s_0), y(theta_0, s_0)) = (x_0, y_0) = z_0$. Then, $phi(theta_0) =
v(theta_0, s_0)e^(2s_0) = M e^(2s_0)$. Note that if $M = 0$, we are done.
Otherwise, $M > 0$. Now, at $z_0$, the tangent $(a, b)$ to the characteristic
curve $s |-> (x(theta_0, s), y(theta_0, s))$ points outwards from $Omega$,
since $(a, b) dot (x_0, y_0) > 0$ there. This means that for some $delta > 0$,
the characteristic curve $s |-> (x(theta_0, s), y(theta_0, s))$ must lie in
the interior of $Omega$ for $s in (s_0 - delta, s_0)$.  However, along this
curve, $v(theta_0, s) = M e^(2(s_0 - s))$ is decreasing with $s$! This means
that $v(theta_0, s_0 - delta \/ 2) = M e^delta > M$ in $Omega$, contradicting
the maximality of $M$.

In all cases, $max_(Omega) u^2 = M = 0$, hence $u = 0$ identically on $Omega$.


== Problem 2

+ Let $(r, theta, phi.alt)$ be spherical coordinates in $RR^3$, i.e.#h(1fr) $
    x = r sin theta cos phi.alt, quad
    y = r sin theta sin phi.alt, quad
    z = r cos theta .
  $
  Prove that the Laplace operator $Delta$ can be expressed by $
     Delta = 1/r^2 dd(r) (r^2 dd(r)) +
            1 / (r^2 sin theta) dd(theta) (sin theta dd(theta)) +
            1/(r^2 sin^2 theta) dd(phi.alt, 2).
  $

+ Classify homogeneous harmonic polynomials in $RR^3$ by the following steps.
  Suppose that $u$ is a homogeneous harmonic polynomial of degree $m$ in
  $RR^3$. Set $u = r^m Q_m (theta, phi.alt)$ for some function $Q_m$ defined
  on $S^2$.

  + Prove that $Q_m$ satisfies #h(1fr) $
      m(m + 1) Q_m +
      1 / (sin theta) dd(theta) (sin theta dd(theta, "", Q_m)) +
      1 / (sin^2 theta) dd(phi.alt, 2, Q_m) = 0.
    $
  + Prove that if $Q_m$ is of the form $f(theta) g(phi.alt)$, then $
    Q_m (theta, phi.alt) = (A cos(k phi.alt) + B sin(k phi.alt))
      f_(m, k) (cos theta),
  $ where $
    f_(m, k)(mu) = (1 - mu^2)^(k/2) dd(mu, m + k, d: d) (1 - mu^2)^m
  $ for $mu in [-1, 1]$ and $k = 0, 1, ..., m$.


=== Solution


+ Note that $
    r^2 = x^2 + y^2 + z^2, quad
    r^2 sin^2 theta = x^2 + y^2, quad
    tan phi.alt = y \/ x.
  $ With this, $
    r_x = x / r = sin theta cos phi.alt, quad
    r_y = y / r = sin theta sin phi.alt, quad
    r_z = z / r = cos theta.
  $ Next, $x sin^2(theta) + r^2 sin(theta) cos(theta) med theta_x = x$, hence $
    theta_x = (x cos theta) / (r^2 sin theta) = 1/r cos theta  cos phi.alt .
  $ Similarly, $
    theta_y = (y cos theta) / (r^2 sin theta) = 1/r cos theta  sin phi.alt, #h(1cm)
    theta_z = - (z sin theta ) / (r^2 cos theta ) = -1/r sin theta .
  $ Finally, $sec^2 (phi.alt) med phi.alt_x = -y\/x^2$, hence $
    phi.alt_x = -(y cos^2 phi.alt) / x^2 = -1/r (sin phi.alt)  / (sin theta).
  $ Similarly, $
    phi.alt_y = - (cos^2 phi.alt)/x = -1/r (cos phi.alt)  / (sin theta), #h(1cm)
    phi.alt_z = 0.
  $ In summary,

  #align(center, box(stroke: (paint: black, dash: "dotted"), inset: 1em)[$
    r_x &= sin theta cos phi.alt, &#h(1cm)
    r_y &= sin theta sin phi.alt, &#h(1cm)
    r_z &= cos theta \
    theta_x &= 1/r cos theta cos phi.alt, &quad
    theta_y &= 1/r cos theta sin phi.alt, &quad
    theta_z &= -1/r sin theta \
    phi.alt_x &= -1/r (sin phi.alt) / (sin theta), &quad
    phi.alt_y &= -1/r (cos phi.alt) / (sin theta), &quad
    phi.alt_z &= 0.
  $])

  Now, recall that $
    dd(x_i) = sum_(j) (diff y_j) / (diff x_i) dd(y_j),
  $ hence $
    diff^2 / (diff x_i^2)
      = sum_j dd(x_i) [(diff y_j) / (diff x_i) dd(y_j)]
      = sum_j (diff^2 y_j) / (diff x_i^2) dd(y_j) +
        sum_(j k) (diff y_j) / (diff x_i) (diff y_k) / (diff x_i) diff^2 / (diff y_j diff y_k).
  $ Thus, $
    Delta
      = sum_i diff^2 / (diff x_i^2)
      &= sum_(i j) (diff^2 y_j) / (diff x_i^2) dd(y_j) +
        sum_(i j k) (diff y_j) / (diff x_i) (diff y_k) / (diff x_i) diff^2 / (diff y_j diff y_k) \
      &= sum_(i j) ((diff^2 y_j) / (diff x_i^2)) dd(y_j) +
        sum_(i j) ((diff y_j) / (diff x_i))^2 diff^2 / (diff y_j^2) +
        2 sum_(i\ j < k) ((diff y_j) / (diff x_i) (diff y_k) / (diff x_i)) diff^2 / (diff y_j diff y_k).
  $ In our case, first note that $
    r_x theta_x + r_y theta_y + r_z theta_z =
    theta_x phi.alt_x + theta_y phi.alt_y + theta_z phi.alt_z =
    phi.alt_x r_x + phi.alt_y r_y + phi.alt_z r_z = 0,
  $ so the $diff^2 \/ diff r med diff theta$, $diff^2 \/ diff theta med diff
  phi.alt$, and $diff^2 \/ diff phi.alt med diff r$ terms vanish. This leaves
  $
    Delta
      = sum_(i j) [((diff^2 y_j) / (diff x_i^2)) dd(y_j) +
        ((diff y_j) / (diff x_i))^2 diff^2 / (diff y_j^2)].
  $ Next, note that $
    r_x^2 + r_y^2 + r_z^2 = 1, quad
    theta_x^2 + theta_y^2 + theta_z^2 = 1/r^2, quad
    phi.alt_x^2 + phi.alt_y^2 + phi.alt_z^2 = 1/(r^2 sin^2 theta),
  $ which are the coefficients of $diff^2 \/ diff r^2$, $diff^2 \/ diff
  theta^2$, and $diff^2 \/ diff phi.alt^2$ respectively. Thus, $
    Delta
      &= [sum_(i j) ((diff^2 y_j) / (diff x_i^2)) dd(y_j)] +
        dd(r, 2) + 1/r^2 dd(theta, 2) + 1/(r^2 sin^2 theta) dd(phi.alt, 2) \
      &= [sum_(j) omega_j dd(y_j)] +
        dd(r, 2) + 1/r^2 dd(theta, 2) + 1/(r^2 sin^2 theta) dd(phi.alt, 2).
  $ To determine the coefficients $omega_j$, first observe that $Delta (x^2 +
  y^2 + z^2) = 6$. This is also precisely $Delta r^2 = 2r omega_r + 2$, hence
  $omega_r = 2\/ r$. Next, observe that $Delta (x^2 + y^2) = 4$, and this is
  also precisely $
    Delta (r^2 sin^2 theta)
      &= 4 sin^2 theta + 2 r^2 omega_theta sin theta cos theta +
        2 sin^2 theta + 4(1 - 2 sin^2 theta) \
      &= -2 sin^2 theta + 2 r^2 omega_theta sin theta cos theta + 4,
  $ hence $omega_theta = cos theta \/ r^2 sin theta$. Finally, observe that $
    Delta (y/ x) = (2y) / x^3 = (2 sec^2 phi.alt tan phi.alt)/ (r^2 sin^2 theta),
  $ which is
  also precisely $
    Delta tan phi.alt = omega_phi.alt sec^2 phi.alt + (2 sec^2 phi.alt tan phi.alt)/(r^2 sin^2 theta),
  $ hence $omega_phi.alt = 0$. Putting everything together, $
    Delta
      &= 2/r dd(r) + 1/r^2 (cos theta) / (sin theta) dd(theta) +
        dd(r, 2) + 1/r^2 dd(theta, 2) + 1/(r^2 sin^2 theta) dd(phi.alt, 2) \
      &= 1/r^2 dd(r) (r^2 dd(r)) +
        1 / (r^2 sin theta) dd(theta) (sin theta dd(theta)) +
        1 / (r^2 sin^2 theta) dd(phi.alt, 2).
  $

  _Remark:_ We have avoided calculating the nine terms $r_(x x), r_(y y), r_(z
  z)$, $theta_(x x), theta_(y y), theta_(z z)$, $phi.alt_(x x), phi.alt_(y y),
  phi.alt_(z z)$!


+ 
  + Calculate #h(1fr) $
      1/r^2 diff / (diff r) (r^2 (diff u) / (diff r))
      &= 1/r^2 diff / (diff r) (r^2 diff / (diff r) r^m Q_m (theta, phi.alt))
      = m (m + 1) r^(m - 2) Q_m, \
      1 / (r^2 sin theta) dd(theta) (sin theta dd(theta, "", u))
      &= 1 / (r^2 sin theta) dd(theta) (sin theta dd(theta, "", Q_m) r^m)
      = r^(m - 2) / (sin theta) dd(theta) (sin theta dd(theta, "", Q_m)), \
      1/(r^2 sin^2 theta) dd(phi.alt, 2, u)
      &= 1/(r^2 sin^2 theta) dd(phi.alt, 2, Q_m) r^m
      = r^(m - 2) / (sin^2 theta) dd(phi.alt, 2, Q_m).
    $ Adding everything together, $
      Delta u = r^(m - 2) [
        m(m + 1) Q_m +
        1 / (sin theta) dd(theta) (sin theta dd(theta, "", Q_m)) +
        1 / (sin^2 theta) dd(phi.alt, 2, Q_m) = 0
      ].
    $ Setting this to zero, we must have $
        m(m + 1) Q_m +
        1 / (sin theta) dd(theta) (sin theta dd(theta, "", Q_m)) +
        1 / (sin^2 theta) dd(phi.alt, 2, Q_m) = 0.
    $

  + Putting $Q_m = f(theta) g(phi.alt)$ in the previous equation, we have $
      m(m + 1) f g
        + 1 / (sin theta) (sin theta f')' g
        + 1 / (sin^2 theta) f g'' = 0.
    $ Rearranging, $
      [(m(m + 1) f + (sin theta f')'\/sin theta) / f] sin^2 theta = - g'' / g = k^2.
    $ The last step equating both sides to a constant $k^2$ follows since
    they are independent functions of $theta$ and $phi.alt$ respectively.
    Furthermore, $g$ must be a periodic function of $phi.alt$, which is
    possible only if the constant is positive, yielding periodic solutions $
      g(phi.alt) = A cos(k phi.alt) + B sin(k phi.alt).
    $ Additionally, $k$ must be an integer so that $g$ is $2 pi$ periodic.
    Now, $
      [m(m + 1) - k^2 / (sin^2 theta)] f + 1/(sin theta) (sin theta f')' = 0.
    $ Putting $mu = cos theta$ and $h(mu) = f(theta)$, we have $
      (d f)/(d theta) = (d h)/(d mu) (d mu)/(d theta) = -h'(mu) sin theta = -h'(mu) sqrt(1 - mu^2),
    $ hence $
      d/(d theta) (sin(theta) f'(theta)) = - d/(d theta) ((1 - mu^2) h'(mu)) = -[2mu h'(mu) - (1 - mu^2) h''(mu)] sin(theta).
    $ Thus, our differential equation reduces to $
      [m(m + 1) - k^2 / (1 - mu^2)] h - 2mu h' + (1 - mu^2) h'' = 0.
    $ Rewrite this as the Sturm-Liouville problem $
      m(m + 1) h + ((1 - mu^2) h')' = k^2 / (1 - mu^2) h,
    $ with $h(-1) = h(1)$


== Problem 3

Solve the following Cauchy problem. $
  u_(t t) - u_(x x) &= 0, #h(2cm) &0 < &x < oo, quad t > 0, \
  u(x, 0) &= f(x), &0 <= &x < oo, \
  u_t (x, 0) &= g(x), &0 <= &x < oo,
$ where $f in C^2[0, oo)$ and $g in C^1[0, oo)$ satisfy the compatibility
conditions $f(0) = f''(0) = g(0) = 0$.

=== Solution

Extend $f$ and $g$ as odd functions on $RR$. Then, d'Alembert's formula yields
$
  u(x, t) = 1/2(f(x - t) + f(x + t)) + 1/2 integral_(x - t)^(x + t) g(s) med d s.
$

Note that the compatibility conditions $f(0) = g(0) = 0$ ensure that the
extended versions of $f$ and $g$ are in $C^1(RR)$, and the fact that $f''(0) =
0$ ensures that the extended version of $f$ is in $C^2(RR)$. Thus, $u$ as
obtained above is a classical solution of the given Cauchy problem.



== Problem 4

We say that $v in C^2(macron(U))$ is subharmonic if $-Delta v <= 0$ in $U$.

+ Prove for subharmonic $v$ that for all $B(x, r) subset U$, #h(1fr) $
    v(x) <= 1/(m(B(x, r))) integral_(B(x, r)) v.
  $

+ Prove that therefore, $
    max_(macron(U)) v = max_(diff U) v.
  $

+ Let $phi.alt : RR arrow RR$ be smooth and convex. Assume that $u$ is
  harmonic and $v = phi.alt(u)$. Prove that $v$ is subharmonic.

+ Prove that $v = |D u|^2$ is subharmonic when $u$ is harmonic.


=== Solution

1. Define #h(1fr) $
    phi(r) = 1/sigma(diff B(x, r)) integral_(diff B(x, r)) v
      = 1/sigma(S^(n - 1)) integral_(S^(n - 1)) v(x + r omega) med d sigma(omega).
  $ Then, calculate $
    phi'(r) 
      &= 1/sigma(S^(n - 1)) integral_(S^(n - 1)) D v(x + r omega) dot omega med d sigma(omega) \
      &= 1/(sigma(diff B(x, r))) integral_(diff B(x, r)) D v dot nu med d sigma \
      &= 1/(sigma(diff B(x, r))) integral_(B(x, r)) Delta v med d y
  $ The last step follows from Gauss's Divergence Theorem. Now, $Delta v >=
  0$, hence $phi'(r) >= 0$. Furthermore, $phi(r) -> v(x)$ as $r -> 0$, since $
    min_(diff B(x, r)) v
      <= 1/sigma(diff B(x, r)) integral_(diff B(x, r)) v
      <= max_(diff B(x, r)) v,
  $ and both $min_(diff B(x, r)) v, max_(diff B(x, r)) v -> v(x)$ as $r -> 0$
  by continuity. Thus, $phi(r) >= v(x)$ for all $r > 0$. With this, for $r$
  such that $B(x, r) subset U$, we have $
    1/(m(B(x, r))) integral_(B(x, r)) v
      &= 1/(m(B(x, r))) integral_0^r integral_(S^(n - 1)) v(x + t omega) t^(n - 1) med d sigma(omega) med d t \
      &= sigma(S^(n - 1))/(omega(n) r^n) integral_0^r phi(t) med t^(n - 1) med d t \
      &>= n / r^n integral_0^r v(x) med t^(n - 1) med d t \
      &= v(x).
  $

2. Suppose that $v$ attains its maximum $M$ at a point $x_0$ in the interior
  of $U$. Then, for all $x in U$ such that $v(x) = M$, we have $v(x)
  - v(y) >= 0$ for all $y in macron(U)$, hence $
    0 <= 1 / m(B(x, r)) integral_(B(x, r)) v(x) - v(y) med d y = v(x) - 1 / m(B(x, r)) integral_(B(x, r)) v <= 0.
  $ The last inequality follows from the previous result. This forces $
    1 / m(B(x, r)) integral_(B(x, r)) v(x) - v(y) med d y = 0
  $ where $B(x, r) subset U$, hence $v = v(x) = M$ on $B(x, r)$. Thus, we have
  shown that the set $v^(-1)(M)$ is both open (previous argument) and closed
  (continuity of $v$) in the connected component of $U$ containing $x_0$.
  Since it is non-empty (the point $x_0 in v^(-1)(M)$), $v^(-1)(M)$ must be
  the entirety of that connected component of $U$. Thus, by continuity, $v$
  must attain $M$ at some boundary point of $U$ as well.

3. Calculate #h(1fr) $
    Delta v = sum_(i = 1)^n (diff^2 v) / (diff x_i^2)
      = sum_(i = 1)^n diff / (diff x_i) (phi.alt'(u) (diff u) / (diff x_i))
      = sum_(i = 1)^n [phi.alt''(u) ((diff u) / (diff x_i))^2 +
        phi.alt'(u) (diff^2 u) / (diff x_i^2)].
  $ Using $Delta u = 0$ and $phi.alt'' >= 0$ via convexity, we have $
    Delta v
      = phi.alt''(u) sum_(i = 1)^n ((diff u) / (diff x_i))^2 +
        phi.alt'(u) cancel(Delta u, stroke: #red)
      >= 0,
  $ whence $-Delta v <= 0$. Thus, $v$ is subharmonic.

4. Note that since $u$ is harmonic, so are the functions $u_i := diff u \/
  diff x_i$. Now, $
    v = |D u|^2
      = sum_(i = 1)^n ((diff u) / (diff x_i))^2
      = sum_(i = 1)^n u_i^2,
  $ so $
    Delta v &= sum_(j = 1)^n diff^2/(diff x_j^2)(sum_(i = 1)^n u_i^2) \
      &= sum_(i j) (diff^2 u_i^2) / (diff x_j^2) \
      &= sum_(i j) diff / (diff x_j) ( (diff u_i^2) / (diff x_j) ) \
      &= sum_(i j) diff / (diff x_j) ( 2u_i (diff u_i) / (diff x_j) ) \
      &= 2 sum_(i j) [((diff u_i) / (diff x_j))^2 + u_i (diff^2 u_i) / (diff x_j^2)] \
      &= 2 sum_(i j) ((diff u_i) / (diff x_j))^2 + 2 sum_(i = 1)^n u_i [ sum_(j = 1)^n (diff^2 u_i) / (diff x_j^2)] \
      &= 2 sum_(i j) ((diff u_i) / (diff x_j))^2 + 2 sum_(i = 1)^n u_i cancel(Delta u_i, stroke: #red) \
      &>= 0.
  $ Thus, $-Delta v <= 0$, so $v$ is subharmonic.



== Problem 5

Let $u$ be the solution of $
  Delta u &= 0, #h(1cm) &"in"& RR^n_+,\
  u &= g, &"on"& diff RR^n_+,
$ given by Poisson's formula for the half-space. Assume that $g$ is bounded
and $g(x) = |x|$ for $x in diff RR^n_+$, $|x| <= 1$. Show that $D u$ is not
bounded near $x = 0$.

=== Solution

Using Poisson's formula, write $
  u(x) &= (2 x_n)/ (n omega(n)) integral_(diff RR^n_+) g(y) / norm(x - y)^n med d y \
    &= (2 x_n)/ (n omega(n)) integral_(diff RR^(n - 1)) (tilde(g)(z)) / (norm(tilde(x) - z)^2 + x_n^2)^(n \/ 2) med d z \.
$ Here, we denote $tilde(x) = (x_1, ..., x_(n - 1))$ and $tilde(g)(z) = g(z_1,
..., z_(n - 1), 0)$. Thus, $u(0) = 0$, and $
  u(lambda e_n) = (2 lambda)/ (n omega(n)) integral_(diff RR^(n - 1)) (tilde(g)(z)) / (norm(z)^2 + lambda^2)^(n \/ 2) med d z \.
$ With this, we estimate $
  (u(lambda e_n) - u(0)) / lambda
    &= 2 / (n omega(n)) integral_(diff RR^(n - 1)) (tilde(g)(z)) / (norm(z)^2 + lambda^2)^(n \/ 2) med d z \
    &= 2 / (n omega(n)) integral_(S^(n - 2)) integral_0^oo (tilde(g)(r sigma)) / (r^2 + lambda^2)^(n \/ 2) r^(n - 2) med d r med d sigma \
    &= 2 / (n omega(n)) integral_(S^(n - 2)) (integral_0^1 + integral_1^oo) (tilde(g)(r sigma)) / (r^2 + lambda^2)^(n \/ 2) r^(n - 2) med d r med d sigma \
$ Using the boundedness of $g$, let $|g| < M$. Note that $
  |integral_1^oo (tilde(g)(r sigma))/(r^2 + lambda^2)^(n\/2) med d r| < M integral_1^oo (d r) / r^2 < oo,
$ so $
  2 / (n omega(n)) integral_(S^(n - 2)) integral_1^oo (tilde(g)(r sigma)) / (r^2 + lambda^2)^(n \/ 2) r^(n - 2) med d r med d sigma < oo.
$ For the remaining piece, use $g = r$ when $r <= 1$ to write $
  2 / (n omega(n)) integral_(S^(n - 2)) integral_0^1 (tilde(g)(r sigma)) / (r^2 + lambda^2)^(n \/ 2) r^(n - 2) med d r med d sigma
  &= 2 / (n omega(n)) integral_(S^(n - 2)) integral_0^1 r^(n - 1) / (r^2 + lambda^2)^(n \/ 2) med d r med d sigma \
  &= (2 (n - 1) omega(n - 1)) / (n omega(n)) integral_0^1 r^(n - 1) / (r^2 + lambda^2)^(n \/ 2) med d r.
$ Now, calculate $
  dd(lambda) r^(n - 1) / (r^2 + lambda^2)^(n\/2) = -r^(n - 1)/(r^2 + lambda^2)^n dot n/2 (r^2 + lambda^2)^(n\/2 - 1) dot 2 lambda < 0
$ when $lambda > 0$. Thus, the functions $r |-> r^(n - 1) \/ (r^2 +
lambda^2)^(n\/2)$ are pointwise monotonically increasing on $(0, 1)$ as
$lambda$ decreases to $0$. Therefore, the Monotone Convergence Theorem gives $
  lim_(lambda -> 0) integral_0^1 r^(n - 1) / (r^2 + lambda^2)^(n \/ 2) med d r
  = integral_0^1 lim_(lambda -> 0) r^(n - 1) / (r^2 + lambda^2)^(n \/ 2) med d r
  = integral_0^1 (d r) / r = oo.
$ Thus, we obtain $
  dd(x_n, "", u)(0) = lim_(lambda -> 0) (u(lambda e_n) - u(0))/lambda = oo,
$ from which $D u$ must be unbounded near $0$.
