---
layout: post
title: "Jacobi's Triple Product"
sources:
  - title: Introduction to Bosonization (S&eacute;n&eacute;chal)
    link: https://arxiv.org/pdf/cond-mat/9908262.pdf
    type: paper
  - title: Partial Fractions and Four Classical Theorems of Number Theory (Hirschhorn)
    link: https://www.jstor.org/stable/2589321
    type: paper
  - title: Introduction to Conformal Field Theory (Blumenhagen and Plauschinn)
    link: https://www.springer.com/gp/book/9783642004490
    type: book
tags: mathematica
mma: true
tikzjax: true
---

There are some surprising connections between bosonization in quantum field theory, classical theorems in number theory, and characters of the affine algebra $$A_1^{(1)} = \widehat{\mathfrak{su}}(2)_1$$. All of them connect to the Jacobi triple product identity:

$$\prod_{n=1}^\infty \left(1-q^n\right)\left(1+zq^{n-1/2}\right)\left(1+z^{-1}q^{n-1/2}\right) = \sum_{n=-\infty}^\infty z^n q^{n^2/2}$$

This identity can be understood in many different ways, and has several consequences. As one simple example, we can substitute $$z = -x^{-1/2}$$ and $$q = x^3$$. Then we have

$$\prod_{n=1}^\infty \left(1-x^{3n}\right)\left(1-x^{3n-2}\right)\left(1-x^{3n-1}\right) = \prod_{n=1}^\infty \left(1-x^n\right) = \sum_{n=-\infty}^\infty (-1)^n x^{(3n^2-n)/2}$$

On the right hand side, we clearly have a power series with coefficients $$0,\pm 1$$. The exponents with nonzero coefficients are called (generalized) pentagonal numbers. Indeed, we can look at the first few terms:
```mma
Sum[(-1)^n x^((3n^2-n)/2), {n,-5, 5}]
```
Now try drawing some pentagons using collections of points. For instance, here are the first few patterns:
{% tikz %}
\tikzset{point/.style={fill,circle,minimum size=5,inner sep=0}}
\begin{scope}
  \node[point] at (0,0) {};
  \node[scale=2] at (0,-3) {1};
\end{scope}
\begin{scope}[xshift=3cm]
  \draw[thick] (90:0.5) 
  \foreach \t in {162,234,...,378} {
    -- (\t:0.5)
  } -- cycle;
  \node[point] at (90:0.5) {};
  \foreach \t in {162,234,...,378} {
    \node[point,red] at (\t:0.5) {};
  };
  \node[scale=2] at (0,-3) {5};
\end{scope}
\begin{scope}[xshift=6cm]
  \draw[thick,yshift=-0.3cm] (90:1) 
  \foreach \t in {162,234,...,378} {
    -- (\t:1)
  } -- cycle;
  \foreach \t in {90,162,...,378} {
    \node[point,yshift=0.2cm] at (\t:0.5) {};
  };
  \path[scale={sin(36)},yshift=1.2cm] (-144:2) node[point,red] {}
  -- ++(-72:1) node[point,red] {}
  -- ++(-72:1) node[point,red] {}
  -- ++(0:1) node[point,red] {}
  -- ++(0:1) node[point,red] {}
  -- ++(72:1) node[point,red] {}
  -- ++(72:1) node[point,red] {};
  \node[scale=2] at (0,-3) {12};
\end{scope}
{% endtikz %}
To get to the $$n$$th pentagon, we have to add the bottom three sides of length $$n$$, but these share two vertices. We thus have the recurrence

$$a_n = a_{n-1} + (3n-2),$$

which is solved by

$$a_n = \frac{3n^2-n}{2}.$$

Continuing to negative $$n$$ yields the generalized pentagonal numbers which appear in the expansion of $$\prod \left(1-x^n\right)$$.

This special case of the Jacobi triple product, called Euler's pentagonal number theorem, has a surprising combinatorial interpretation. The infinite product is the generating function for the number of signed partitions of $$n$$ into distinct parts; that is, the number of partitions into an even number of distinct parts minus the number of partitions into an odd number of distinct parts. Euler's identity tells us that this number is very often 0, meaning there are equal numbers of partitions into even and odd numbers of parts, and only for generalized pentagonal numbers does the count differ by 1.

As an example, let's look at 14 and 15. Since 14 is not a generalized pentagonal number (which you can see from the series expansion above), the numbers of even and odd distinct partitions should be equal. And indeed:
```mma
DistinctPartitions[n_] := 
  Select[IntegerPartitions[n], Length[#] == Length[Union[#]] &];

EvenOdd[n_] := 
 With[{dp = DistinctPartitions[n]}, 
  Grid[{Column[Select[dp, #]] & /@ {EvenQ@*Length, OddQ@*Length}}, 
   Alignment -> Top]]; 

EvenOdd[14]
```
However, 15 has one additional odd distinct partition, corresponding to the negative coefficient in the series expansion:
```mma
EvenOdd[15]
```

We'll now look at several different ways to come at the Jacobi triple product, starting with a proof due to G. E. Andrews based on two identities of Euler.

## The Andrews Proof

[Andrews (1964)](https://www.ams.org/journals/proc/1965-016-02/S0002-9939-1965-0171725-X/home.html) notes that the Jacobi triple product follows from the following two identities due to Euler:
$$
\begin{align}
  \prod_{n=0}^\infty \left(1+z q^n\right) &= \sum_{n=0}^\infty z^n\frac{q^{n(n-1)/2}}{(1-q)\cdots(1-q^n)} \\
  \prod_{n=0}^\infty \left(1+z q^n\right)^{-1} &= \sum_{n=0}^\infty z^n\frac{(-1)^n}{(1-q)\cdots(1-q^n)}
\end{align}
$$

Proving these is simple. Both expand an infinite product as a power series in $$z$$. For instance, to prove the first one, we can set

$$ \prod_{n=0}^\infty (1+z q^n) = \sum_{n=0}^\infty a_n(q) z^n$$

and try to find $$a_n(q)$$. If we set $$z\mapsto qz$$, then all the factors on the left shift $$n\mapsto n+1$$, so we are effectively dividing by $$(1+z)$$. Thus,

$$ \sum_{n=0}^\infty a_n(q) z^n = (1+z) \sum_{n=0}^\infty a_n(q) q^n z^n = \sum_{n=0}^\infty \left(a_n(q)q^n + a_{n-1}(q)q^{n-1}\right) z^n $$

Equating this series term by term yields

$$ a_n(q) = \frac{a_{n-1}(q)q^{n-1}}{1-q^n},$$

which after noting that $$a_0(q) = 1$$ immediately implies the first Euler identity.

Much the same method works for the second Euler identity. We set

$$ \prod_{n=0}^\infty (1+z q^n)^{-1} = \sum_{n=0}^\infty b_n(q) z^n$$

Setting $$z = zq^{-1}$$, we obtain

$$ \sum_{n=0}^\infty b_n(q) z^n = \left(1+zq^{-1}\right)\sum_{n=0}^\infty \frac{b_n(q)}{q^n}z^n = \sum_{n=0}^\infty \frac{b_n(q)+b_{n-1}(q)}{q^n}z^n$$

The recurrence is

$$b_n(q) = -\frac{b_{n-1}(q)}{1-q^n}$$

and the result follows.

Now we use these identities to prove the triple product, following Andrews. In the first identity, we can set $$z\mapsto q^{1/2} z$$ to find

$$
  \prod_{n=0}^\infty \left(1+z q^{n+1/2}\right) = \sum_{n=0}^\infty z^n \frac{q^{n^2/2}}{(1-q)\cdots(1-q^n)}
$$

We can multiply through and clear the denominator on the right (note the change in indexing on the left):

$$
  \prod_{n=1}^\infty \left(1-q^n\right)\left(1+z q^{n-1/2}\right) = \sum_{n=-\infty}^\infty z^n q^{n^2/2} \prod_{j=0}^\infty \left(1-q^{n+j+1}\right)
$$

Note that we have extended the sum on the right to all integer $$n$$, since the product will vanish anyway for negative $$n$$. The product on the right hand side looks like the one from the first Euler identity, with $$z = -q^{n+1}$$. Substituting we find

$$
  \prod_{n=1}^\infty \left(1-q^n\right)\left(1+z q^{n-1/2}\right) = \sum_{n=0}^\infty z^n q^{n^2/2} \sum_{m=0}^\infty \frac{(-1)^m q^{m(m-1)/2+m(n+1)}}{(1-q)\cdots(1-q^m)}
$$

Collecting powers in the sum, we have $$z^n$$ and $$q^{n^2/2 + nm + m^2/2 + m/2} = q^{(n+m)^2/2 + m/2}$$. We can thus formally switch the sums and obtain

$$
  \prod_{n=1}^\infty \left(1-q^n\right)\left(1+z q^{n-1/2}\right) = \sum_{m=0}^\infty \frac{(-1)^m q^{m/2}}{(1-q)\cdots(1-q^m)}\sum_{n=-\infty}^\infty z^n q^{(n+m)^2/2}
$$

We can eliminate $$m$$ in the inner sum on the right by shifting $$n \mapsto n-m$$ and absorbing $$z^{-m}$$ into the outer part:

$$
  \prod_{n=1}^\infty \left(1-q^n\right)\left(1+z q^{n-1/2}\right) = \left(\sum_{m=0}^\infty \frac{(-1)^m q^{m/2}z^{-m}}{(1-q)\cdots(1-q^m)}\right)\left(\sum_{n=-\infty}^\infty z^n q^{n^2/2}\right)
$$

Finally we can use the second Euler identity. Setting $$z\mapsto \sqrt{q}/z$$ yields

$$
  \sum_{m=0}^\infty \frac{(-1)^m q^{m/2}z^{-m}}{(1-q)\cdots(1-q^m)} = \prod_{n=0}^\infty \left(1+z^{-1}q^{n+1/2}\right)^{-1}
$$

Moving this over to the left and changing the indexing, we finally have

$$
  \prod_{n=1}^\infty \left(1-q^n\right)\left(1+z q^{n-1/2}\right)\left(1+z^{-1} q^{n-1/2}\right) = \sum_{n=-\infty}^\infty z^n q^{n^2/2}
$$

## Young Diagrams

The pentagonal number theorem,

$$\prod_{n=1}^\infty (1-x^n) = \sum_{n=-\infty}^\infty (-1)^n x^{n(3n-1)/2},$$

is made much clearer when we think of what it means for partitions, as above. In turn, we can use the interpretation as a generating function to prove the identity combinatorially. Let's go through this as a warmup, and then we'll move on to a combinatorial proof of the full triple product.

We can represent partitions using Young diagrams. These are pretty self-explanatory: each entry in the partition is a row in the diagram, so we get a top-heavy arrangement of dots (usually drawn as boxes, but this way is prettier).

```mma
YoungDiagram[xs_] := Grid[Table[Graphics[Disk[], ImageSize -> 10], #] & /@ ReverseSort[xs]];

Grid[Table[{StringRiffle[ToString /@ p, "+"], YoungDiagram[p]}, {p, DistinctPartitions[9]}], Dividers -> {True, All}, Alignment -> Left]
```

We want some way of pairing up diagrams with even and odd numbers of rows, such that we almost have a one-to-one mapping, except in isolated cases for the generalized pentagonal numbers. The trick is to exchange the bottom row with the rightmost 45 degree line. For instance, look at the following two Young diagrams from the table above:
```mma
Grid[{YoungDiagram /@ {{4, 3, 2}, {5, 4}}}, Alignment -> Top, ColumnSpacings -> 5]
```
If we take the bottom row of the first diagram, and attach it on the right at a 45 degree angle, we get the second diagram. It's clear that for any diagram, we can only make this exchange in one direction. If we tried to move the rightmost diagonal to the bottom row in the $$4+3+2$$ diagram, the bottom row would be too long. If we tried to move the bottom row to the rightmost diagonal in the second diagram, there wouldn't be enough rows to add the dots onto.

Let's take a look at how this exchange pairs up all the distinct partitions of 9:
```mma
DiagonalLength[xs_] := With[{fp = FirstPosition[First[xs] + 1 - Range@Length[xs] - xs, x_ /; x > 0]}, 
    If[MissingQ[fp], Length[xs], fp[[1]] - 1]
  ];
PartitionPair[xs_] := 
  Sort[{xs, 
    If[DiagonalLength[xs] < Last[xs], 
     Append[xs - PadRight[Table[1, DiagonalLength[xs]], Length[xs]], DiagonalLength[xs]], 
     Most[xs] + PadRight[Table[1, Last[xs]], Length[xs] - 1]
    ]
  }];
Pairing[n_] := Grid[Map[YoungDiagram, Values[GroupBy[DistinctPartitions[n], PartitionPair]], {2}], Alignment -> Left, Dividers -> {All, All}]

Pairing[9]
```
This explains why the coefficient of $$x^9$$ in $$\prod (1-x^n)$$ is 0. What about $$x^7$$, for which the coefficient is 1? There's one even partition which doesn't have a pair:
```mma
Pairing[7]
```
With this unpaired diagram, corresponding to $$4+3$$, we can't make the exchange in either direction. With a bit of work, one can show that the only time we're in trouble is when the diagonal and the bottom row share a dot, and when they have either the same length or the bottom row is longer by one dot. In the former case, we have Young diagrams of the following form:
```mma
Grid[Transpose[
  Table[{YoungDiagram[Range[2 n - 1, n, -1]], 
    Style[Total@Range[2 n - 1, n, -1], 24]}, {n, 1, 4}]], 
 Alignment -> Top, Dividers -> {All, True}]
```
These are just the pentagonal numbers! In the other case, we get the pentagonal numbers with negative index:
```mma
Grid[Transpose[
  Table[{YoungDiagram[Range[2 n - 2, n, -1]], 
    Style[Total@Range[2 n - 2, n, -1], 24]}, {n, 2, 4}]], 
 Alignment -> Top, Dividers -> {All, True}]
```
It's easy to prove this in general, and to check that the offending Young diagrams alternate in the parity of the number of rows, corresponding to the alternating signs in the series.

## Excitations of the Dirac Sea

Now for something totally different. Suppose we have a system of fermions with energy levels $$\pm \frac{1}{2}$$, $$\pm\frac{3}{2}$$, and so on (this could be arranged by putting the fermions on a cylinder with antiperiodic boundary conditions). To make things stable, we'll fill in all the negative energy levels with particles. To modify this system, we can either create a particle at some positive energy level or delete a particle, which we call creating a hole, from some negative energy level.

We can use the language of second quantization to describe these excitations. Let $$a(n)$$ be the annihilation operator for the fermion at energy $$n-\frac{1}{2}$$, for integer $$n$$. The vacuum $$\vert 0\rangle{}$$ consists of the full Dirac sea, so we can define $$b^\dagger(n) = a(-n)$$ as the creation operator for holes. Then an arbitrary state is obtained by acting with a string of $$a^\dagger$$'s and $$b^\dagger$$'s on the vacuum, such as below:
{% tikz %}
\tikzset{particle/.style={fill,circle,minimum size=8,inner sep=0},hole/.style={draw,dashed,circle,minimum size=8,inner sep=0}}
\node[scale=2,left] at (0, 0) {$$a^\dagger(2)b^\dagger(1)b^\dagger(3)\vert 0\rangle = $$};
\draw[ultra thick] (0,0) -- (6,0);
\fill[gray!50] (0,0) rectangle (6, -4);
\foreach \i in {1,3,...,13} {
  \draw (2,{\i/4}) -- (4,{\i/4});
  \draw (2,{-\i/4}) -- (4,{-\i/4});
};
\node at (1,-2) {Dirac Sea};
\node[particle] at (3,0.75) {};
\node[particle] at (3,-0.75) {};
\node[particle] at (3,-1.75) {};
\node[particle] at (3,-2.25) {};
\node[particle] at (3,-2.75) {};
\node[particle] at (3,-3.25) {};
\node[hole] at (3,-0.25) {};
\node[hole] at (3,-1.25) {};
{% endtikz %}

Now let's think about the combinatorics of this system. We define two operators, which count the energy and the particle number:
$$\begin{align}
  E &= \sum_{n>0} \left(n-\frac{1}{2}\right)\left(a^\dagger(n)a(n) + b^\dagger(n)b(n)\right) \\
  N &= \sum_{n>0} \left(a^\dagger(n)a(n)-b^\dagger(n)b(n)\right)
\end{align}$$

We can then ask for the total number of excitations with some fixed values of $$E$$ and $$N$$. For instance, the excitation above has energy $$\frac{3}{2}+\frac{1}{2}+\frac{5}{2} = \frac{9}{2}$$ and particle number $$1-2 = -1$$.

It's easy to write a generating function for these counts. There are two kinds of things we can do: create a particle at level $$n$$ or create a hole at level $$-n$$. The first has $$\Delta E = n-\frac{1}{2}$$ and $$\Delta N = 1$$; the second also has $$\Delta E = n-\frac{1}{2}$$, but $$\Delta N = -1$$. If we label excitations of energy $$E$$ and particle number $$N$$ by $$q^Ez^N$$, then the generating function is

$$ \prod_{n=1}^\infty \left(1+zq^{n-1/2}\right)\left(1+z^{-1}q^{n-1/2}\right)$$

So maybe this isn't something totally different after all!

If we could find another way to count these excitations, we might be able to give a combinatorial proof of the Jacobi triple product. We would need to obtain

$$ \left(\sum_{n=0}^\infty z^n q^{n^2/2}\right)\prod_{m=1}^\infty \frac{1}{1-q^m}$$

A big hint is that the infinite product appearing here is the generating function for integer partitions. So we should find a way to count excitations in terms of integer chunks of energy.

Well, one thing we can do that costs an integer amount of energy is move a particle up one rung of the latter. Let's define

$$ c^\dagger(n) = a^\dagger(n)a(n-1),$$

an operator which destroys a particle at level $$n-1$$ and creates it again at level $$n$$. Note that

$$ c^\dagger(-n) = a^\dagger(-n)a(-n-1) = -b^\dagger(n+1)b(n), $$

so we can also think of $$c^\dagger$$ as pushing a hole downwards. Since $$c^\dagger$$ doesn't create any net particles, we're still stuck in the $$N = 0$$ sector for now.

This is the sole limitation, though: using just $$c^\dagger(n)$$, we can build any excitation with zero particle number in a unique way. For example:
{% tikz %}
\tikzset{particle/.style={fill,circle,minimum size=8,inner sep=0},hole/.style={draw,dashed,circle,minimum size=8,inner sep=0}}
\node[scale=2,left] at (0,0) {$$c^\dagger(1)c^\dagger(0)c^\dagger(3)c^\dagger(2)c^\dagger(1)\vert 0\rangle = $$};
\draw[ultra thick] (0,0) -- (6,0);
\fill[gray!50] (0,0) rectangle (6, -4);
\foreach \i in {1,3,...,13} {
  \draw (2,{\i/4}) -- (4,{\i/4});
  \draw (2,{-\i/4}) -- (4,{-\i/4});
};
\node[particle] at (3,1.25) {};
\node[particle] at (3,0.25) {};
\node[particle] at (3,-1.25) {};
\node[particle] at (3,-1.75) {};
\node[particle] at (3,-2.25) {};
\node[particle] at (3,-2.75) {};
\node[particle] at (3,-3.25) {};
\node[hole] at (3,-0.25) {};
\node[hole] at (3,-0.75) {};

\foreach \i in {1,3,5} {
  \draw[-latex] (4.2,{\i/4-0.5}) ..controls (4.4,{\i/4-0.3}) and (4.4,{\i/4-0.2}).. (4.2,{\i/4});
};
\foreach \i in {-1,1} {
  \draw[-latex] (1.8,{\i/4-0.5}) ..controls (1.6,{\i/4-0.3}) and (1.6,{\i/4-0.2}).. (1.8,{\i/4});
};
{% endtikz %}
Stepping through the operators, we see that we lifted the particle at $$-\frac{1}{2}$$ three steps up to $$\frac{5}{2}$$, and then lifted the particle at $$-\frac{3}{2}$$ two steps up to $$\frac{1}{2}$$, for a total of $$E = 5$$. Note that we could not have done this in the other order; we would end up having to move particles past each other, which doesn't work, since they can only step one at a time and they can't both occupy the same level.

When we think of it this way, it's clear that any string of $$c^\dagger$$'s which doesn't produce a null state has to have a particular form: lift the highest state from the Dirac sea up to some level, then lift the next highest state up to some lower level, and so on. When we think of it this way, it's clear what's going on: every excitation of energy $$E$$ corresponds to a partition of $$E$$.

What about excitations of nonzero particle number? For these we can just start from a different vacuum, $$\vert n\rangle{}$$, for which the level of the Dirac sea is shifted. We can define $$\vert n\rangle{}$$ for in terms of $$\vert 0\rangle{}$$ by

$$ \vert n\rangle = \left(\prod_{i=1}^n a^\dagger(i)\right)\vert 0\rangle{}$$

The energy of $$\vert n\rangle{}$$ is 

$$E_N = \frac{1}{2} + \frac{3}{2} + \ldots + \frac{n-1}{2} = \frac{n^2}{2}.$$

These formulas are for $$n>0$$; analogous relations hold for $$n<0$$.

Now we can count the excitations using this new scheme. First we sum over the vacua; since $$\vert n\rangle{}$$ has particle number $$n$$ and energy $$\frac{n^2}{2}$$, we should multiply by $$z^n q^{n^2/2}$$. Then, for each vacuum, we have to multiply by the generating function for the number of partitions of each energy level. This gives exactly what we're looking for:

$$ \sum_{n=0}^\infty z^n q^{n^2/2}\prod_{m=1}^\infty \frac{1}{1-q^m}$$

Equating this with the other expression above, we immediately recover the Jacobi triple product formula.

## Anomalies and Bosonization

The combinatorial argument we have just given is an instance of a more general construction in two-dimensional quantum field theory called *bosonization*. Bosonization is an equivalence between a theory of Dirac fermions and a theory of bosons, both in 1+1 dimensions.

Before delving into the details, why does this only work in $$1+1$$ dimensions? We will be following the same line of thought as above: represent a particle-hole excitation in the fermion theory as a single bosonic excitation. There is a simple reason why this analogy works particularly well in one spatial dimension. Imagine we have 1D and 2D lattices, each with lattice spacing $$a$$. We then have respective 1D and 2D Brillouin zones, with $$-\frac{\pi}{a}\le k_x\le \frac{\pi}{a}$$ and the same bounds for $$k_y$$ in the 2D case. The Hamiltonian will be of the form

$$ \mathcal{H} = \int dk\,\epsilon(k) c^\dagger(k) c(k) $$

for some dispersion relation $$\epsilon(k)$$. For concreteness, we can work in the tight-binding model with tunneling amplitude $$t$$, giving

$$\begin{aligned}
  \epsilon(k) &= E_0 - 2t\cos(ka) & &\text{(1D)} \\
  \epsilon(k_x, k_y) &= E_0 - 2t\cos(k_x a) - 2t \cos(k_y a)& &\text{(2D)}
\end{aligned}$$

In one dimension, the Fermi surface is $$S^0$$, that is, just the two points $$k = \pm \frac{\pi}{2a}$$:
```mma-hide
ResourceFunction["MaTeXInstall"][];
<< MaTeX`
SetOptions[MaTeX, "Preamble" -> {"\\usepackage{amsfonts}"}];
texStyle = 
  Sequence @@ {BaseStyle -> {FontFamily -> "CMU Serif", 
      FontSize -> 16}, TicksStyle -> Directive[30], 
    FrameTicksStyle -> Directive[30], LabelStyle -> Black, 
    AxesStyle -> Black, FrameStyle -> Black, PlotStyle -> Black};
```
```mma-nocode
Plot[-Cos[ka], {ka, -Pi, Pi}, Axes -> False, Frame -> True, 
 FrameTicks -> {{None, 
    None}, {{{-Pi/2, MaTeX["-\\frac{\\pi}{2a}"]}, {Pi/2, 
      MaTeX["\\frac{\\pi}{2a}"]}}, None}}, 
 FrameLabel -> {MaTeX["k", Magnification -> 2], 
   MaTeX["\\epsilon(k)", Magnification -> 2]}, 
 Prolog -> {LightGray, Opacity[0.5], 
   Rectangle[Scaled[{0, 0}], Scaled[{1, 0.5}]]}, 
 GridLines -> {{-Pi/2, Pi/2}, None}, 
 GridLinesStyle -> Directive[Dashed], Evaluate@texStyle]
```

However, in two dimensions, the Fermi surface is topologically $$S^1$$ (though geometrically a square in the tight-binding case):
```mma-nocode
GraphicsRow[{Show[
   SliceContourPlot3D[z, 
    z == -Cos[kxa] - Cos[kya], {kxa, -Pi, Pi}, {kya, -Pi, Pi}, {z, -2,
      2}, BoxRatios -> Automatic, 
    ContourShading -> Join[Table[Gray, 8], Table[White, 7]], 
    Contours -> Subdivide[-2, 2, 14], LabelStyle -> Black, 
    BoxStyle -> Black, Ticks -> None], 
   AxesLabel -> {MaTeX["k_x", Magnification -> 2], 
     MaTeX["k_y", Magnification -> 2], 
     MaTeX["\\epsilon(k)", Magnification -> 2]}], 
  ContourPlot[-Cos[kxa] - Cos[kya], {kxa, -Pi, Pi}, {kya, -Pi, Pi}, 
   Axes -> False, Frame -> True, FrameTicks -> None, 
   FrameLabel -> {MaTeX["k_x", Magnification -> 2], 
     MaTeX["k_y", Magnification -> 2]}, 
   ContourShading -> Join[Table[LightGray, 8], Table[White, 7]], 
   Contours -> Subdivide[-2, 2, 14], Evaluate@texStyle]}]
```
To create a particle-hole excitation at the Fermi surface, we move a particle out of the Fermi sea. In one dimension, there's clearly only one independent way to do this: take a particle near one of the points of the $$S^0$$ and nudge it over by some $$\Delta k$$. So long as $$t k \ll a^{-1}$$, the change in energy $$\Delta \epsilon$$ has to be very close to $$2t\vert \Delta k\vert $$, since there's only one place for the particle to go.

In two dimensions, we can move the particle in a variety of directions across the $$S^1$$ Fermi surface. Depending on the direction, we could have $$\Delta \epsilon$$ near zero or close to a multiple of $$\Delta k$$, so there is no fixed dispersion relation for the particle-hole excitations.

Now let's shift gears and talk about another reason why bosonization works in $$1+1$$ dimensions -- a more mysterious reason, but one which will lead us to the explicit formulas for bosonization. Generally speaking, we are looking for a map between a fermion field and a scalar field which respects the algebras of each. We will start with a free Dirac fermion $$\Psi = \displaystyle\begin{pmatrix} \psi_R \\ \psi_L \end{pmatrix}$$, and a free scalar boson $$\phi$$. The fermions have the equal-time algebra

$$\left\lbrace \psi_R(x_1), \psi_R^\dagger(x_1')\right\rbrace = \left\lbrace \psi_L(x_1), \psi_L^\dagger(x_1')\right\rbrace = \delta(x_1-x_1')$$

The first problem, clearly, is that the fermion and boson fields have different statistics. To have any hope of reproducing the bosonic algebra, we need to look at an operator containing an even number of fermionic fields. In the combinatorial argument a bosonic excitation was identified with creating a particle and a hole, so a natural choice of operator is $$\psi^\dagger_R(x)\psi_R(x)$$ or $$\psi^\dagger_L(x)\psi_L(x)$$. 

These operators appear in the two conserved currents of the classical theory. From the Lagrangian

$$\mathcal{L} = \int d^2x\,i\overline{\Psi}\!\not{\partial}\Psi, $$

we see that there are two symmetries $$\Psi \mapsto e^{i\alpha}\Psi$$ and $$\Psi\mapsto e^{i\alpha\gamma^5}\Psi$$, where $$\gamma^5 = \gamma^0\gamma^1$$. The corresponding currents are

$$\begin{aligned}
j_\mu &= \begin{pmatrix} \psi_R^\dagger\psi_R + \psi_L^\dagger\psi_L \\ \psi_R^\dagger\psi_R - \psi_L^\dagger\psi_L \end{pmatrix} & j^5_\mu &= \begin{pmatrix} \psi_R^\dagger\psi_R - \psi_L^\dagger\psi_L \\ -(\psi_R^\dagger\psi_R + \psi_L^\dagger\psi_L) \end{pmatrix}
\end{aligned}$$

Both of these currents are also conserved in the quantum theory, provided the fermion remains free. But if we couple it to a background gauge field, with an interaction Lagrangian \\(\mathcal{L}\_{\mathrm{int}} = eA^\mu j_\mu\\), things get trickier. The current $$j_\mu$$ must remain conserved, because it is the gauge current; imposing this condition forces us to break the conservation of $$j^5\_\mu$$. This phenomenon is called an *anomaly* of the theory. The result is

$$ \partial^\mu j^5_\mu = \frac{e}{2\pi}\epsilon_{\mu\nu}F^{\mu\nu}. $$

We will not derive this result in full, but we can give a short heuristic argument. Looking at the charges $$Q = \int dx_1 j_0(x_1)$$ and $$Q^5 = \int dx_1 j^5_0(x_1)$$, we find

$$\begin{aligned} Q &= N_R + N_L, & Q^5 = N_R - N_L \end{aligned}$$

where $$N_R$$ and $$N_L$$ are the numbers of left and right moving particles. Clearly $$Q$$ ought to be conserved, but $$Q^5$$ is not sacrosanct; for instance, turning on a background rightwards electric field ought to shift more particles into right-moving modes rather than left-moving modes. Indeed, by solving the Dirac equation on a circle $$x^1 \sim x^1 + 2\pi R$$, one can show that

$$\frac{dQ^5}{dx^0} = 2R\frac{dA_1}{dx^0}.$$

Since $$Q^5 = \int\_0^{2\pi R}dx^1\,j^5\_0$$, this suggests the local relationship

$$\partial^\mu j^5_\mu = \frac{1}{\pi}\partial_0 A_1 = \frac{1}{2\pi}\epsilon_{\mu\nu}F^{\mu\nu}.$$

Okay, so what does this mean for bosonization? Well, let's return to the operators $$j_R(x_1) = \psi^\dagger_R(x_1) \psi_R(x_1)$$. If we compute its equal-time commutator without being careful, we find

$$\begin{aligned}
\left\lbrack j_R(x_1), j_R(x_1')\right\rbrack &= \psi^\dagger_R(x_1) \psi_R(x_1)\psi^\dagger_R(x_1') \psi_R(x_1') - (x_1\leftrightarrow x_1') \\
&= \delta(x_1-x_1')\left(\psi^\dagger_R(x_1)\psi_R(x_1') - \psi^\dagger_R(x_1')\psi_R(x_1)\right) \\
&= 0
\end{aligned}$$

But this can't possibly be the case! It would imply that $$j_\mu$$ and $$j^5_\mu$$ commute, which is inconsistent with the anomaly we found. So maybe not being careful wasn't a good idea. Right now $$j_R(x_1)$$ isn't normal-ordered. Indeed, from the fermion propagator one can work out that

$$\left\langle \psi_R(x)\psi_R(0)\right\rangle = -\frac{i}{2\pi(x_0-x_1)},$$

which is singular as $$x\to 0$$, and so we need to subtract this singular contribution when we properly define $$j_R(x_1)$$:

$$\begin{aligned}
j_R(x_1) &= :\psi_R^\dagger(x_1)\psi_R(x_1): \\
&= \lim_{\epsilon\to 0}\left\lbrack \psi_R^\dagger(x_1+\epsilon)\psi_R(x_1-\epsilon) - \left\langle \psi_R^\dagger(x_1+\epsilon)\psi_R(x_1-\epsilon)\right\rangle\right\rbrack
\end{aligned}$$

Using this prescription, we instead find for the commutator

$$\left\lbrack j_R(x_1), j_R(x_1')\right\rbrack = \delta(x_1-x_1')\left(:\psi^\dagger_R(x_1)\psi_R(x_1'): - :\psi^\dagger_R(x_1')\psi_R(x_1):\right) = \frac{i}{2\pi}\frac{\delta(x_1-x_1')}{x_1-x_1'}.$$

Now for some fancy footwork with distributions. Taking an arbitrary test function $$f(x)$$, we have

$$\int dx\,x\delta'(x)f(x) = -\int dx\,\delta(x)\left(f(x) + xf'(x)\right) = -f(0),$$

so $$x\delta'(x) = -\delta(x)$$. It follows that

$$\left\lbrack j_R(x_1), j_R(x_1')\right\rbrack = -\frac{i}{2\pi}\partial_1 \delta(x_1-x_1').$$

Very similarly, one can show that

$$\left\lbrack j_L(x_1), j_L(x_1')\right\rbrack = \frac{i}{2\pi}\partial_1 \delta(x_1-x_1').$$

From this it follows immediately that

$$\left\lbrack j_0(x_1), j_1(x_1')\right\rbrack = -\frac{i}{\pi}\partial_1 \delta(x_1-x_1'), \qquad \left\lbrack j_0, j_0\right\rbrack = \left\lbrack j_1, j_1\right\rbrack = 0.$$

In a rough sense, the anomaly forced us to have a nonzero commutator here; we'll say more about the anomaly later. As far as bosonization is concerned, this is very good news, because we needed two bosonic operators with a commutator involving a $$\delta$$ function. We're not quite done yet, though, because we ended up with a $$\delta$$ derivative. Indeed, counting the mass dimensions, we couldn't have gotten just a $$\delta$$ function out of the two current operators. 

Let's look at the bosonic algebra to find a natural way to stick in this derivative. If we have a generic boson,

$$\mathcal{L} = \int d^2x\,\left\lbrack \left(\partial\phi\right)^2 - V(\phi)\right\rbrack,$$

then the canonical momentum is $$\partial_0\phi$$ and so we have

$$\left\lbrack \phi(x_1), \partial_0\phi(x_1')\right\rbrack = i\delta(x_1-x_1').$$

That was easier than expected; there's already a $$\partial_0$$ present, so it seems natural enough to stick a $$\partial_1$$ on the first $$\phi$$. A minus sign and some $$\sqrt{\pi}$$'s make everything line up:

$$\left\lbrack -\frac{1}{\sqrt{\pi}}\partial_1\phi(x_1), \frac{1}{\sqrt{\pi}}\partial_0\phi(x_1')\right\rbrack = -\frac{i}{\pi}\partial_1\delta(x_1-x_1').$$

We should thus identify

$$j_0 \leftrightarrow -\frac{1}{\sqrt{\pi}}\partial_1\phi, \qquad j_1\leftrightarrow \frac{1}{\sqrt{\pi}}\partial_0\phi,$$

or covariantly,

$$j_\mu = \frac{1}{\sqrt{\pi}}\epsilon_{\mu\nu}\partial^\nu\phi.$$

With this identification, we should be able to map statements in the fermion theory to statements in the boson theory. For instance, what does current conservation in the fermion theory correspond to in the boson theory? Conservation of $$j_\mu$$ is automatic, since

$$ \partial^\mu j_\mu = \frac{1}{\sqrt{\pi}}\epsilon_{\mu\nu}\partial^\mu\partial^\nu\phi = 0.$$

However, conservation of the axial current $$j^5\_\mu$$ is nontrivial. The components are $$j^5\_\mu = \epsilon\_{\mu\nu}j^\nu$$, so

$$ \partial^\mu j^5_\mu = \partial^\mu \epsilon_{\mu\nu} \left(\frac{1}{\sqrt{\pi}}\epsilon^{\nu\sigma}\partial_\sigma\phi\right) = \frac{1}{\sqrt{\pi}}\partial^2\phi.$$

Thus, if the axial current is conserved, the corresponding boson must satisfy the massless Klein-Gordon equation; that is, the boson should be free.

But what if we add in a background gauge field for the fermions? Then we know that the axial current is not conserved, but picks up an anomaly. Let's see how this happens in the boson theory. When we add the term $$\mathcal{L}\_\mathrm{int} = eA^\mu j_\mu$$, we should add the corresponding term to the boson Lagrangian, $$\frac{e}{\sqrt{\pi}}A^\mu \epsilon\_{\mu\nu}\partial^\nu\phi$$. The equation of motion for $$\phi$$ becomes

$$\partial^\mu\left(\partial_\mu\phi + \frac{e}{\sqrt{\pi}}A^\nu \epsilon_{\nu\mu}\right) = 0,$$

or

$$\partial^2\phi = \frac{e}{\sqrt{\pi}}\epsilon_{\mu\nu}\partial^\mu A^\nu = \frac{e}{\sqrt{2\pi}}\epsilon_{\mu\nu}F^{\mu\nu}.$$

Since $$\partial^\mu j^5_\mu = \frac{1}{\sqrt{\pi}}\partial^2\phi$$, this immediately reproduces the anomaly we quoted before!

## Characters of Lie Algebras

Now again for something totally different. A Lie algebra is a vector space $$\mathfrak{g}$$ equipped with a bilinear product $$[\cdot, \cdot]$$ called a Lie bracket satisfying

$$\begin{aligned}
[x, y] &= -[y, x] & &\text{antisymmetry} \\
[x, [y, z]] + [y, [z, x]] + [z, [x, y]] &= 0 & &\text{Jacobi identity}
\end{aligned}$$

These identities are automatically satisfied if we take an associative algebra and define $$[x, y] = xy-yx$$; that is, we take the Lie bracket to be the commutator.

The prototypical example is called $$\mathfrak{sl}_2(\mathbb{C})$$. We can define this algebra abstractly as a three-dimensional vector space spanned by $$\{e, f, h\}$$ with Lie bracket

$$[e, f] = h, \qquad [h, e] = 2e, \qquad [h, f] = -2f.$$

We could also define $$\mathfrak{sl}_2(\mathbb{C})$$ as the vector space of $$2\times 2$$ trace-free complex matrices, with the commutator as the Lie bracket. If we set

$$e = \begin{pmatrix} 0 & 1 \\ 0 & 0 \end{pmatrix}, \qquad f = \begin{pmatrix} 0 & 0 \\ 1 & 0 \end{pmatrix}, \qquad h = \begin{pmatrix} 1 & 0 \\ 0 & 1 \end{pmatrix},$$

then we recover the same relations as before.

This Lie algebra is the one familiar to anyone who has studied angular momentum in quantum mechanics. If we interpret $$h\mapsto 2J_z$$, $$e\mapsto J_+$$, and $$f\mapsto J_-$$, then recover the correct commutators for these operators. The reason for this is that $$\text{SO}(3)$$ has the same Lie algebra as $$\text{SU}(2)$$, its universal cover; and the complexified Lie algebras $$\mathfrak{su}_n$$ and $$\mathfrak{sl}_n$$ are isomorphic.

In the mathematical literature this Lie algebra is called $$\mathfrak{sl}_2(\mathbb{C})$$, so we'll stick with this notation, but keep in mind the interpretations of $$e$$ and $$f$$ as raising and lowering operators for $$h$$.

A *representation* of a Lie algebra is a vector space $$V$$ together with a left $$\mathfrak{g}$$-action which respects the Lie bracket; that is, for every $$g,h\in\mathfrak{g}$$ and $$v\in V$$, we have

$$[g,h]v = g(hv) - h(gv).$$

Since the elements of $$\mathfrak{g}$$ act on vectors in $$V$$, we can represent them as matrices in $$\text{End}(V)$$. For example, when we wrote $$\{e,f,h\}$$ as $$2\times 2$$ matrices above, this was a 2-dimensional representation of $$\mathfrak{sl}_2(\mathbb{C})$$.

What about other representations of $$\mathfrak{sl}_2(\mathbb{C})$$? We know from physics that we should get the various spin representations; let's see how these arise. Given some vector space $$V$$ with a left action of $$\mathfrak{sl}_2(\mathbb{C})$$, we know that the action of $$h$$ must have at least one eigenvector $$v$$; call its eigenvalue $$\lambda$$. Then we have

$$h(ev) = e(hv) + [h,e]v = \lambda (ev) + 2(ev),$$

so $$ev$$ is an eigenvector of $$h$$ with eigenvalue $$\lambda+2$$. Likewise, $$fv$$ is an eigenvector of $$h$$ with eigenvalue $$\lambda-2$$. 

It seems like we can generate an infinite family of eigenvectors of $$h$$, all with different eigenvalues, by considering $$e^nv$$ or $$f^nv$$. And indeed, we could form an infinite-dimensional representation this way; so long as we make the chain of eigenvectors infinite in only one direction, this corresponds to an important representation called a Verma module. But let's instead focus on finite-dimensional representations. Then we must break the chain at both ends. At the upper end, we have to have $$e^nv = 0$$ for some $$n$$; without loss of generality, let's make $$v$$ the vector with the "highest weight" (to be defined more precisely shortly), so that $$ev = 0$$. Then we have $$v, fv, f^2v, \ldots$$. We must also have $$f^mv = 0$$ for all $$m$$ greater than some minimal $$N$$, so that the vectors $$v, fv, \ldots, f^Nv$$ span $$V$$.

The value of $$N$$ is fixed by prior definitions. First, let's see what happens when we go down $$k$$ steps and back up one:

$$e(f^kv) = fef^{k-1}v + hf^{k-1}v = fef^{k-1}v + (\lambda - 2(k-1))f^{k-1}v.$$

By induction, it follows that

$$e(f^k v) = \left(\lambda - (k-1)\right)f^{k-1}v,$$

where in the last step we have used that $$ev = 0$$. Using our definition of $$N$$, this implies

$$0 = (\lambda-N)f^Nv \implies \lambda = N.$$

Thus, for any integer $$\lambda$$, we get an $$(N+1)$$-dimensional representation spanned by $$v, fv, \ldots, f^Nv$$, with $$h$$-eigenvalues $$\lambda, \lambda-2, \ldots, -\lambda$$. The actions of $$e$$ and $$f$$ on this representation are shown below.
{% tikz %}
\node[draw,circle,minimum size=1.3cm] at (0,0) (1) {$$v$$};
\node[draw,circle,minimum size=1.3cm] at (2,0) (2) {$$fv$$};
\node at (4, 0) (3) {$$\cdots$$};
\node[draw,circle,minimum size=1.3cm] at (6,0) (4) {$$f^{N-1}v$$};
\node[draw,circle,minimum size=1.3cm] at (8,0) (5) {$$f^N v$$};
\foreach \n/\m in {1/2,2/3,3/4,4/5} {
    \draw[->,bend left] (\n) ..controls ($$(\n)!0.5!(\m)+(0,.5)$$).. node[above] {$$f$$} (\m);
    \draw[->,bend left] (\m) ..controls ($$(\n)!0.5!(\m)+(0,-.5)$$).. node[below] {$$e$$} (\n);
};
{% endtikz %}

This alone is very interesting, but it turns out to have far-reaching consequences for the representations of more general Lie algebras. This calculation rested on having the operator $$h$$ which is diagonalizable, and hence allows us to split the representation into its eigenspaces. For a (semisimple) Lie algebra $$\mathfrak{g}$$, we can identify a subalgebra $$\mathfrak{h}$$ called the Cartan subalgebra which shares this property: all its elements are diagonalizable in a special representation called the *adjoint*. The adjoint representation sets $$V = \mathfrak{g}$$, and the $$\mathfrak{g}$$-action is given by the Lie bracket. For $$\mathfrak{sl}_2(\mathfrak{C})$$, using a basis $$\{e, f, h\}$$, the adjoint representation of $$h$$ is

$$ \text{ad}_h = \begin{pmatrix} 2 & 0 & 0 \\ 0 & -2 & 0 \\ 0 & 0 & 0 \end{pmatrix},$$

which is indeed diagonalizable. Additionally, a Cartan subalgebra is required to be abelian, so that all its elements are simultaneously diagonalizable. We denote the Cartan subalgebra of $$\mathfrak{g}$$ by $$\mathfrak{h}$$.

Given some representation $$V$$ of $$\mathfrak{g}$$, we can diagonalize each independent element of $$\mathfrak{h}$$ on $$V$$. A simultaneous eigenspace of $$\mathfrak{h}$$ can be identified with a linear functional in $$\mathfrak{h}^\*$$, with components giving the eigenvalues for each basis element of $$\mathfrak{h}$$. We will call one of these functionals $$\lambda\in\mathfrak{h}^\*$$, by analogy with the eigenvalues of $$h\in\mathfrak{sl}\_2(\mathbb{C})$$. We can decompose $$V$$ into these eigenspaces:

$$V = \bigoplus_{\lambda\in\mathfrak{h}^\*} V_\lambda, \qquad V_\lambda = \left\lbrace v\in V\mid H(v) = \lambda(H)v,\quad\forall H\in\mathfrak{h}\right\rbrace.$$

The same decomposition can be used on $$\mathfrak{g}$$ itself using the adjoint representation. In this special case, we refer to the weights as *roots*. A root $$\alpha\in \mathfrak{h}^*$$ is a functional for which the space

$$\mathfrak{g}_\alpha = \left\lbrace g\in\mathfrak{g}\mid [H, g] = \alpha(H)g\quad\forall H\in\mathfrak{h}\right\rbrace$$

is nontrivial. For instance, in $$\mathfrak{sl}\_2(\mathbb{C})$$, the roots were $$\pm 2$$ and the root spaces were $$g\_2 = \{e\}$$ and $$g\_{-2} = \{f\}$$ (as well as $$\mathfrak{g}\_0 = \mathfrak{h}$$, which holds for any Lie algebra). The root space decomposition of a Lie algebra is

$$\mathfrak{g} = \mathfrak{h} \oplus \bigoplus_{\alpha\in\Delta} \mathfrak{g}_\alpha,$$

where $$\Delta$$ is the set of nonzero roots.

Now we make a simple observation with far-reaching consequences. Let $$H\in\mathfrak{h}$$ and $$X\in\mathfrak{g}\_\alpha$$, and let $$v\in V\_\lambda$$. Then

$$H(Xv) = X(Hv) + [H, X]v = \lambda(H) (Xv) + (\alpha(H) X)v = \left\lbrack (\lambda+\alpha)(H)\right\rbrack(Xv).$$

Thus, $$Xv\in V\_{\lambda+\alpha}$$. Note that this generalizes the concept of raising and lowering operators in $$\mathfrak{sl}\_2(\mathbb{C})$$. Except, we're missing one thing: which direction is "raising" and which is "lowering"? There is no canonical choice; we will simply choose some subset of *positve roots* $$\Delta^+\subset\Delta$$ such that for every root $$\alpha$$, either $$\alpha\in\Delta^+$$ or $$-\alpha\in\Delta^+$$, and also for any $$\alpha,\beta\in\Delta^+$$, we have $$\alpha+\beta\in\Delta^+$$. We then say that "raising" corresponds to moving in the direction of positive roots; that is, a weight $$\mu$$ is higher than a weight $$\lambda$$ if $$\mu-\lambda$$ is a linear combination of positive roots with positive coefficients.

Now, at last, we are prepared to generalize the construction of representations of $$\mathfrak{sl}_2(\mathbb{C})$$. Given some irreducible representation $$V$$ of a (semisimple) Lie algebra $$\mathfrak{g}$$, we split it into weight spaces $$V\_\lambda$$. We then identify the highest such weight $$\lambda$$, under the notion of "highest" explained above. The representation is formed by acting on the highest-weight vector with "lowering" operators coming from the root spaces $$\mathfrak{g}\_{-\alpha}$$, with $$\alpha\in\Delta^+$$. The key point is that *every irreducible representation is formed in this way*, and *two irreps with the same highest weight are isomorphic*. 

This is a very strong statement: an entire irrep of $$\mathfrak{g}$$ is determined by this single vector in $$\mathfrak{h}^\*$$, the highest weight. Can we say more about the structure of the representation? For example, in $$\mathfrak{sl}_2(\mathbb{C})$$, for highest weight $$\lambda$$ we had weight spaces with weights $$\lambda, \lambda-2, \ldots, -\lambda$$, each appearing once.

This data is captured in the *character* of a representation. The character of a group representation is the trace of the matrix corresponding to each group element; to go from a Lie algebra representation to a Lie group representation, we should take an exponential. So we define the character as the trace of an exponential of the representation of an element of the Cartan subalgebra. That is, for a representation $$\pi:\mathfrak{g}\to\text{End}(V)$$, we define

$$\text{ch}_\pi(H) = \text{tr}\left(\exp\left(\pi(H)\right)\right).$$

If we split $$V$$ into its weight spaces, then we can sum the trace over each weight space, giving

$$\text{ch}_\pi(H) = \sum_{\lambda} \left(\dim V_\lambda\right) e^{\lambda(H)}.$$

For $$\mathfrak{sl}\_2(\mathbb{C})$$, for the $$N+1$$-dimensional representation with highest weight $$\lambda = N$$, we have

$$\text{ch}_N(zh) = \sum_{j=-N/2}^{N/2} e^{2jz},$$

since each weight space is one-dimensional. We can sum the series, giving

$$\text{ch}_N(zh) = \frac{e^{(N+1)z} - e^{-Nz}}{e^z-1} = \frac{e^{(N+1/2)z} - e^{-(N+1/2)z}}{e^{z/2}-e^{-z/2}}. $$

This formula can actually be generalized to a highest-weight representation for any (semisimple) Lie algebra $$\mathfrak{g}$$. We just have to generalize a few things. First, $$\frac{1}{2}$$ appears in the numerator added to the highest weight; we will replace this with the *Weyl vector*

$$\rho = \frac{1}{2}\sum_{\alpha\in\Delta^+}\alpha.$$

Second, the numerator is a difference of $$e^{(\lambda+\rho)(H)}$$ and the same term but with the weight negated. We replace this by a sum over the *Weyl group* $$W$$, the group generated by all the reflections that form isometries of the root system $$\Delta$$. For $$\mathfrak{sl}_2(\mathbb{C})$$, this is just the $$\mathbb{Z}\_2$$ group generated by the reflection $$\alpha\mapsto -\alpha$$. Each element $$w\in W$$ has a signature $$\epsilon(w) = \pm 1$$ given by its determinant as a linear map.

Using these generalizations, we can write down the *Weyl character formula* for a general highest-weight representation $$V$$:

$$\text{ch}_V(H) = \frac{\sum_{w\in W} \epsilon(w) e^{w(\lambda+\rho)(H)}}{\prod_{\alpha\in\Delta^+} \left(e^{\alpha(H)/2} - e^{-\alpha(H)/2}\right)}.$$

Why did we write the denominator as a product over positive roots, instead as another sum over the Weyl group? Well, we could have gone either way. The formula above is true, but by setting $$\lambda = 0$$, we get the trivial representation with character 1, showing that

$$\prod_{\alpha\in\Delta^+} \left(e^{\alpha(H)/2} - e^{-\alpha(H)/2}\right) = \sum_{w\in W} \epsilon(w) e^{w(\rho)}.$$

This is called the *Weyl denominator formula*.

### Example: $$\mathrm{sl}_3(\mathbb{C})$$

Before moving on, let's look at one relatively simple example, $$\mathbb{sl}_3(\mathbb{C})$$. This is the Lie algebra of traceless complex $$3\times 3$$ matrices with the commutator as the Lie bracket. Let's write down a basis for them.
```mma
sl3 = Join[
   Table[SparseArray[{ij -> 1}, {3, 3}], {ij, 
     Flatten[Permutations /@ Subsets[Range[3], {2}], 1]}], 
   DiagonalMatrix /@ {{1, -1, 0}, {0, 1, -1}}];
MatrixForm /@ sl3
```
The last two elements commute with one another; in fact, they generate the Cartan subalgebra. We can use them to compute the roots. First, we calculate the adjoint actions of the two Cartan generators:
```mma
cartan = sl3[[-2 ;;]];
coeffs[mat_, mats_] := 
  LinearSolve[Transpose[Flatten /@ mats], Flatten[mat]];
adjoints = Table[coeffs[h . g - g . h, sl3], {h, cartan}, {g, sl3}];
MatrixForm /@ adjoints
```
Generally we would have to simultaneously diagonalize these matrices, but conveniently they're already diagonal. We can read off the roots from the diagonal entries and plot them.
```mma-nocode
ListPlot[Transpose[
  Diagonal /@ adjoints], 
 Axes -> False, Frame -> True, PlotStyle -> {Black, PointSize[.02]}, 
 ImageSize -> 500, Evaluate@texStyle]
```
This looks like a hexagon. The only reason it seems a bit sheared is that we chose a basis for the Cartan subalgebra for which this is the case; in another basis, we recover a prettier hexagon.
```mma-nocode
roots = Transpose[Diagonal /@ (( {
       {0, -1/2},
       {Sqrt[3]/3, Sqrt[3]/6}
      } ) . adjoints)];
hexagon = ListPlot[roots, 
 Ticks -> {Thread[{#, MaTeX[#, Magnification -> 2]} &@{-1, -1/2, 1/2, 
      1}], Thread[{#, MaTeX[#, Magnification -> 2]} &@{-Sqrt[3]/2, 
      Sqrt[3]/2}]}, PlotStyle -> {Black, PointSize[.02]}, 
 AspectRatio -> 1, ImageSize -> 500, 
 Prolog -> {FaceForm[], EdgeForm[{Thick, Blue}], RegularPolygon[6]}, 
 Evaluate@texStyle]
```

Now, what about the representations? We simply need to identify the set of possible highest weights. Let's start with the representation we already have. Using the basis in which we get the pretty hexagon as the root system, we find that the weights of this representation are
```mma
weights = Transpose[Diagonal /@ (( {
       {0, -1/2},
       {Sqrt[3]/3, Sqrt[3]/6}
      } ) . cartan)];
MatrixForm /@ weights
Show[hexagon, 
 ListPlot[weights, PlotStyle -> {Red, PointSize[.02]}, 
  PlotLegends -> 
   PointLegend[{Black, Red}, 
    Evaluate[
     Style[#, 20, FontFamily -> "CMU Serif"] & /@ {"Roots", 
       "Weights"}], LegendFunction -> "Frame"]], 
 Epilog -> {EdgeForm[{Thick, Red}], FaceForm[], Polygon[weights]}]
```
These form a unit equilateral triangle. Of course, this makes sense: we know that we can add roots to weights, so the differences between weights should come from the hexagonal lattice generated by the roots. This implies that the weights should lie on a triangular lattice.

This actually reflects a more general fact. When drawn in this particular basis -- which, in addition to looking nice, is such that the Euclidean inner product coincides with a distinguished bilinear form called the Killing form, which we haven't defined here -- the weights lie on the lattice dual to the lattice spanned by the roots, scaled by a factor of $$\frac{1}{2}$$.

Using this property, we can look at the lattice of all possible weights for finite-dimensional representations. The root system is shown for comparison.
```mma-nocode
lattice = Normal[Plot[
  Table[Tan[\[Theta]] x - 0.5 shift Sec[\[Theta]], {\[Theta], 0, 
    2 Pi/3, Pi/3}, {shift, -7, 7}], {x, -4, 4}, Axes -> False, 
  AspectRatio -> Full, PlotStyle -> Green], Pi/6] /. 
prim : _Line | _Point | _Polygon :> 
  GeometricTransformation[prim, RotationTransform[Pi/6]];

Show[hexagon, lattice, 
 PlotRange -> {{-1.5, 1.5}, {-1.5, 1.5}}, Ticks -> None]
```

To give an ordering to these weights, we need to pick which roots are positive. It doesn't matter so much which, so let's pick the first three counting counterclockwise from the positive $$x$$-axis. Then we see there are two weights, called the fundamental weights, which generate the weight lattice and have nonnegative inner products with the positive roots.

Each of the fundamental weights $$\omega_1$$ and $$\omega_2$$, when taken as the highest weight, lead to a three-dimensional representation. What about when we use various sums of $$\omega_1$$ and $$\omega_2$$ as the highest weight? We could work this out rather tediously just by acting on a vector with lowering operators, but let's use the Weyl character formula instead. We can work out the denominator in the first form given above:

$$\prod_{\alpha\in\Delta^+} \left(e^{\alpha/2} - e^{-\alpha/2}\right) = e^{\rho}\left(1-e^{-\alpha_1}\right)\left(1-e^{-\alpha_2}\right)\left(1-e^{-\alpha_1+\alpha_2}\right),$$

where $$\alpha_1 = (1,0)$$ and $$\alpha_2 = \left(-\frac{1}{2}, \frac{\sqrt{3}}{2}\right)$$ are the simple roots. Note that we are no longer evaluating the roots at some $$H\in\mathfrak{h}$$; instead, we are treating these as formal exponentials.

If we take the reciprocal, again formally, then we obtain

$$\text{ch}_V = e^{-\rho}\left(\sum_{w\in W} \epsilon(w) e^{w(\lambda+\rho)}\right)\left(\sum_{n=0}^\infty e^{-n\alpha_1}\right)\left(\sum\_{n=0}^\infty e^{-n\alpha\_2}\right)\left(\sum\_{n=0}^\infty e^{-n(\alpha\_1+\alpha\_2)}\right).$$

The product of the three infinite sums will be $$\sum\_{m,n} \min(m, n)e^{-m\alpha_1-n\alpha_2}$$, because there are $$\min(m,n)+1$$ choices of how many $$\alpha_1+\alpha_2$$'s to include when writing $$m\alpha_1+n\alpha_2$$ as a sum of $$\alpha_1$$'s, $$\alpha_2$$'s, and $$\alpha_1+\alpha_2$$'s. This leads to the following pattern.

```mma
a1 = {1, 0};
a2 = {-1/2, Sqrt[3]/2};

Show[lattice, 
 ListPlot[Flatten@
   Table[Labeled[-m a1 - n a2, 
     Style[Min[m, n] + 1, 16, FontFamily -> "CMU Serif"], Above], {m, 
     0, 5}, {n, 0, 5}]], PlotRange -> {{-3.7, 4}, {-3.6, 1}}, 
 AspectRatio -> Automatic, Background -> Transparent]
```

So, to find the character of a representation, we just need to form a sum over the six-element Weyl group and then multiply by this pattern, and finally shift by $$-\rho$$. It's a bit tedious for a person, but no sweat for Mathematica. Here's the fundamental representation, just to double check our method.

```mma-hide
isPositive[{x_, y_}] := 0 <= ArcTan[y, x] <= 2 Pi/3;

simpleRoots = Transpose[{a1, a2}];
fundWeights = {{0, 1/2}, {1/Sqrt[3], Sqrt[3]/6}};

fromRoots[{x_, y_}] := simpleRoots . {x, y};
toRoots[{x_, y_}] := Inverse[simpleRoots] . {x, y};
fromWeights[{x_, y_}] := fundWeights . {x, y};
toWeights[{x_, y_}] := Inverse[fundWeights] . {x, y};

weyl = Join[Table[RotationMatrix[2 n Pi/3], {n, 3}], 
   Table[ReflectionMatrix[{Cos[n Pi/3], Sin[n Pi/3]}], {n, 1, 5, 2}]];
eweyl = {1, 1, 1, -1, -1, -1};

\[Rho] = fromRoots[{1, 1}];
```

```mma-hide
numerator[m_, n_] := 
  Thread[{Table[w . (\[Rho] + fromWeights[{m, n}]), {w, weyl}], 
    eweyl}];
hull[m_, n_] := ConvexHullRegion[First /@ numerator[m, n]];

pts[m_, n_] := 
  With[{mem = RegionMember[hull[m, n]]}, 
   fromWeights /@ 
    Select[Tuples@*
       List @@ (Range @@@ 
        Simplify@
         RegionBounds[
          ConvexHullRegion[toWeights /@ (First /@ numerator[m, n])]]),
      mem[fromWeights[#]] &]
   ];

ct[{x_, y_}] := With[{rt = Simplify@toRoots[{x, y}]},
   If[! AllTrue[rt, # >= 0 && IntegerQ[#] &], 0, Min @@ rt + 1]
   ];

char[m_, n_] := 
  Select[Thread[{pts[m, n], 
     Table[Sum[hex[[2]] ct[hex[[1]] - p], {hex, numerator[m, n]}], {p,
        pts[m, n]}]}], #[[2]] != 0 &];

charPlot[m_, n_] := 
 ListPlot[Labeled[#1, Style[#2, 20, FontFamily -> "CMU Serif"], 
     Above] & @@@ char[m, n], Axes -> False, AspectRatio -> Automatic,
   Background -> Transparent, texStyle]
```

```mma
charPlot[1,0]
```

We recover the triangle we had above. Now what about other representations? If we take some number of copies of $$\omega_1$$, we get a larger triangle. The representation with highest weight $$3\omega_1$$ was used to deduce the existence of the [Omega baryon](https://en.wikipedia.org/wiki/Omega_baryon).

```mma
GraphicsRow[
 Table[Show[charPlot[n, 0], 
   PlotLabel -> 
    MaTeX[ToString[n] <> "\\omega_1", Magnification -> 2]], {n, 3}], 
 ImageSize -> 800]
```

If we take $$\omega_1+\omega_2$$, we recover the adjoint representation. The multiplicity-two point in the center is the Cartan subalgebra.
```mma
charPlot[1, 1]
```

Just for fun, here's a larger example, taking $$3\omega_1+2\omega_2$$ as the highest weight.
```mma
charPlot[3, 2]
```

The intuition used here to work with the Weyl character formula is made precise in the Kostant multiplicity formula.

## Affine Algebras

Going back to the more abstract discussion, the Weyl denominator formula has the potential to be interesting: it relates a product to a sum, much like the Jacobi triple product. Of course, with a simple Lie algebra, both the product and the sum are finite. If we had an infinite-dimensional Lie algebra, though -- and if we had a similar formula for these -- we might get something interesting.

Infinite-dimensional Lie algebras are quite intricate, and few of the details will be explained here. Nonetheless, let me sketch the construction in two ways. One, the more abstract method, proceeds through the *Cartan matrix*. The Cartan matrix of a Lie algebra with roots $$\alpha_i$$ is given by

$$ a_{ij} = 2\frac{\langle \alpha_i, \alpha_j\rangle}{\langle \alpha_j, \alpha_j\rangle},$$

where $$\langle\cdot, \cdot\rangle{}$$ is an inner product defined using the Killing form. (In the example above, when we changed the basis so that the roots formed a regular hexagon, we were effectively choosing a basis for which the Killing form coincides with the Euclidean metric.) The Cartan matrix encodes the geometry of the roots, which we can then use to study the representations of the Lie algebra.

In fact, the Cartan matrix contains enough data to tell us exactly what Lie algebra we have. Conversely, we can specify a few conditions on matrix elements, and then any matrix satisfying those conditions is the Cartan matrix for some Lie algebra (which one can show via a simple construction). The conditions are as follows:
* Each entry is an integer
* Each diagonal entry must be 2
* For $$i\neq j$$, $$a_{ij} \le 0$$, and $$a_{ij} = 0$$ iff $a_{ji} = 0$
* The matrix is positive definite

The simplest possible matrix satisfying these conditions is the $$1\times 1$$ matrix with $$a_{11} = 2$$. This is of course the Cartan matrix for $$\mathfrak{sl}(2,\mathbb{C})$$. If we look at $$2\times 2$$ matrices, there are several possibilities. We could have $$\begin{pmatrix} 2 & 0 \\ 0 & 2\end{pmatrix}$$; this would give the direct product $$\mathfrak{sl}(2,\mathbb{C})\times \mathfrak{sl}(2,\mathbb{C})$$. If we make one off-diagonal entry nonzero, the other must be nonzero as well. If both entries are -1, we get $$\mathfrak{sl}(3,\mathbb{C})$$. If one is -1 and one is -2, we get $$\mathfrak{sp}(4)$$, and if one is -1 and one is -3, we get an exceptional Lie algebra called $$G_2$$. These are the only possibilities, since we required our matrix to be positive definite.

Now what if we relax the condition that the matrix be positive definite? This gives "generalized" Cartan matrices, which lead to Kac-Moody algebras. Kac-Moody algebras are an infinite-dimensional generalization of Lie algebras, which (owing to their construction from finite generalized Cartan matrices) can still be understood in terms of a finite number of roots. This in turn gives rise to a representation theory for Kac-Moody algebras analogous to that of Lie algebras.

When the generalized Cartan matrix is positive semidefinite (and has determinant zero, so that we are not in the previous case), then the corresponding algebra is called an *affine* Lie algebra. These can be constructed in an alternate way, which is far more prominent in physics literature since it arises in a natural way from conformal field theory on a cylinder. Starting from a simple Lie algbra $$\mathfrak{g}$$, we consider the loop algebra $$L\mathfrak{g}$$. This is the set of smooth functions $$S^1\to \mathfrak{g}$$ -- i.e., "loops" through the algebra, or alternatively, $$\mathfrak{g}$$-valued functions on a circle -- with a Lie bracket inherited from $$\mathfrak{g}$$. That is, if we have constant functions $$f_1(\theta) = g_1$$ and $$f_2(\theta) = g_2$$, their Lie bracket is the constant function with value $$[g_1, g_2]$$, and then we extend this by linearity.

We can write down this algebra more explicitly by expanding the functions in a Fourier series. We have

$$f(\theta) = \sum_{n\in\mathbb{Z}} g_n e^{in\theta} = \sum_{n\in\mathbb{Z}} g_n z^n,$$

where $$z = e^{i\theta}$$. Then we have

$$\left\lbrack g_m, h_n\right\rbrack = [g, h]_{m+n}$$

where we have dropped the powers of $$z$$ but left the information in the subscript. We can thus think of the loop algebra as an infinite graded Lie algebra, where we take the Lie bracket as usual and then add the gradings.

The affine algebras are *central extensions* of loop algebras over finite Lie algebras. A central extension of an algebra $$\mathfrak{h}$$ is a short exact sequence

$$\mathfrak{u}(1) \to \hat{\mathfrak{h}} \to \mathfrak{h}$$

Concretely, a central extension can be specified by adding a generator $$c$$ to the algebra such that $$[c,h] = 0$$ for all $$h\in\mathfrak{h}$$.

It turns out that all central extension of a loop algebra $$L\mathfrak{g}$$ have the form

$$\left\lbrack g_m, h_n\right\rbrack = [g,h]_{m+n} + km\langle g, h\rangle \delta_{m+n,0} c,$$

where $$\langle \cdot, \cdot\rangle{}$$ is the Killing form on $$\mathfrak{g}$$ and $$k\in\mathbb{Z}$$ is called the *level* of the resulting affine algebra.

The relation to the Jacobi triple product comes from the following fact. When we enumerated the classical rank-two Lie algebras above, we had to stop when the off-diagonal elements of the Cartan matrix got too big. If we go one step further, we get two generalized Cartan matrices which are singular, and hence correspond to affine Lie algebras:

$$A_1^{(1)} = \displaystyle\begin{pmatrix} 2 & -2 \\ -2 & 2 \end{pmatrix}, \qquad A_2^{(2)} = \displaystyle\begin{pmatrix} 2 & -4 \\ -1 & 2 \end{pmatrix}.$$

These are labeled by their origin as central extensions of loop algebras; for example, the affine algebra corresponding to $$A_1^{(1)}$$ is a central extension of $$\mathfrak{sl}(2,\mathbb{C})$$ (which has root system $$A_1$$) with level $$k = 1$$.

The Weyl character formula for Lie algebras can be generalized to the Weyl-Kac formula for Kac-Moody algebras, including affine algebras. This is very similar to the Weyl character formula, and in particular, it gives rise to a denominator formula relating a product over roots to a sum over the Weyl group. For $$A_1^{(1)}$$, the Weyl group is the infinite dihedral group, and so we can write the sum over it as a sum over integers. The end result for the denominator formula for $$A_1^{(1)}$$ is

$$\prod_{n=1}^\infty \left(1-u^n v^n\right)\left(1-u^{n-1}v^n\right)\left(1-u^nv^{n-1}\right) = \sum_{n=-\infty}^\infty \left(u^{n(2n+1)}v^{n(2n-1)} - u^{n(2n+1)}v^{(n+1)(2n+1)}\right).$$

Let $$u = -z\sqrt{q}$$ and $$v = -z^{-1}\sqrt{q}$$. Then, simplifying the right hand side a bit, this becomes

$$\prod_{n=1}^\infty \left(1-q^n\right)\left(1+zq^{n-1/2}\right)\left(1+z^{-1}q^{n-1/2}\right) = \sum_{n=-\infty}^\infty q^{n^2/2}z^n$$

So the Jacobi triple product is the denominator identity for the affine algebra $$A_1^{(1)}$$!

The denominator identities for affine algebras are called the MacDonald identities. They are in some sense a generalization of the Jacobi triple product. For instance, if we take the other rank 2 affine algebra $$A_2^{(2)}$$ and work out its denominator identity, we find a quintuple product identity originally due to Watson in 1929:

$$\prod_{n=1}^\infty \left(1-s^n\right)\left(1-s^n t\right)\left(1-s^{n-1}t^{-1}\right)\left(1-s^{2n-1}t^2\right)\left(1-s^{2n-1}t^{-2}\right) = \sum_{n=-\infty}^\infty s^{\left(3n^2+n\right)/2}\left(t^{3n}-t^{-3n-1}\right)$$