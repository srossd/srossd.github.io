---
layout: post
title: "Continued Fractions 2: The Final $$F$$-coalgebra"
sources:
  - title: The continuum as a final coalgebra (Pavlovic and Pratt)
    link: https://www.sciencedirect.com/science/article/pii/S0304397501000226
    type: paper
tags: category-theory
tikzjax: true
---

In a [previous post](/posts/2020-09-18-gosper-1/), we addressed some questions whether continued fractions can be considered a natural and practical way to represent real numbers. From a decimal standpoint, continued fractions can at first seem awkward, but soon some nice properties start to emerge. For instance, a number is rational if and only if its continued fraction expansion terminates. This is much simpler than in decimal expansions, when rational numbers can either have finite expansions or infinite but eventually periodic ones. Better yet, infinite but eventually periodic expansions also have their place in the land of continued fractions: they correspond to quadratic irrationals, a beautiful fact that is somewhat harder to prove.

However, when one tries to add or multiply continued fractions, the magic might seem to be lost lost. It is not at all obvious how to achieve this without first converting the continued fraction into a regular fraction and then adding or multiplying the fractions. However, the situation is in fact much better. Some clever algorithms due to Gosper allow us to do arithmetic on continued fractions as such, without having to convert them into any other form in the process. The algorithm is guaranteed to succeed with any rational inputs, when the continued fraction terminates. It can even succeed in some irrational cases; for instance, given the continued fraction expansion of $$\sqrt{2}$$, we computed the expansion for $$\frac{4}{3}+\sqrt{2}$$. It would be impossible to do this using a decimal expansion, because we cannot write down an exact specification of the decimal expansion of $$\sqrt{2}$$ in a finite way.

We will now look at the naturalness of continued fractions from the point of view of [abstract nonsense](https://en.wikipedia.org/wiki/Abstract_nonsense). Following the paper shown above, we find that the continued fraction representation of real numbers satisfies a universal property which puts it on par with, for instance, the unary representation of natural numbers used in the Peano axioms.

## Initial and Final Objects

In some categories, there exists an object $$A$$ for which, for every other object $$B$$, there exists a unique morphism $$A\to B$$. We call $$A$$ an *initial object*. 

{% tikz %}
\begin{tikzcd}
% https://tikzcd.yichuanshen.de/#N4Igdg9gJgpgziAXAbVABwnAlgFyxMJZAZgBoBGAXVJADcBDAGwFcYkQQBfU9TXfQigAspAAzU6TVuy48QGbHgJEArKQBMEhizaIO3XooFEymmtul7Zh-spSiKWqbpABBLhJhQA5vCKgAMwAnCABbJAcQHAgkcgMQYLDYmmikdXjE8MRI1MR0uUykMiiYvJpGLDAXOAgKqGsEkKyREuSQCqr2KAgcHC8GwsQW3MiOl27e-oympGHS4rGunr766aShlNL1csrx5anKTiA
                                                                                        &  &  &                           & {w} \arrow[rdd] &    \\
A \arrow[rrrru, dotted] \arrow[rrr, dotted] \arrow[rrrd, dotted] \arrow[rrrrrd, dotted] &  &  & {x} \arrow[ru] \arrow[rrd] &                &    \\
                                                                                        &  &  & {y} \arrow[rr]             &                & {z}
\end{tikzcd}
{% endtikz %}

Initial objects are unique, up to isomorphism. To see this, imagine that both $$A$$ and $$B$$ are initial objects. Since $$A$$ is initial, we have a unique morphism $$f:A\to B$$. Since $$B$$ is initial, we have a unique morphism $$g:B\to A$$. Since we are in a category, we can compose morphisms to form $$gf:A\to A$$ and $$fg:B\to B$$. But since $$A$$ and $$B$$ are initial, there can only be one morphism $$A\to A$$ and $$B\to B$$, and in each case that morphism must be the identity. Thus $$fg = \text{id}_A$$ and $$gf = \text{id}_B$$, and so $$f$$ and $$g$$ form an isomorphism between $$A$$ and $$B$$, as desired.

Initial objects in various categories of interest tend to be simple and/or important. For instance:

- If $$\mathcal{C}$$ is a poset, then its initial object is the least element, if one exists. For example, if $$\mathcal{C}$$ has natural numbers as objects, and a morphism $$a\to b$$ whenever $$a\mid b$$, then the initial object is the number 1, since 1 divides every natural number.
- In the category of groups, the initial object is the trivial group $$\ast \equiv \lbrace e\rbrace $$, since for any group $$G$$, there is a unique homomorphism $$\ast\to G$$ obtained by sending the sole element to the identity.
- In the category of rings with unity, the initial object is $$\mathbb{Z}$$ with the usual addition and multiplication. To form the unique ring homomorphism $$\mathbb{Z}\to R$$ for some arbitrary ring $$R$$, we send $$0\in\mathbb{Z}$$ to the additive identity in $$R$$ and $$1\in \mathbb{Z}$$ to the multplicative identity in $$R$$. The rest of the homomorphism is fixed by
$$\phi(n) = \phi(\underbrace{1+1+\cdots+1}_{n\text{ times}}) = \underbrace{\phi(1)+\phi(1)+\cdots+\phi(1)}_{n\text{ times}}.$$

Initial objects can get more interesting if we form categories in which the objects are particular kinds of diagrams (which, if one wants to fully embrace the nonsense, are themselves functors from a small category into some other category). For instance, in the category of sets, fix two sets $$X$$ and $$Y$$ and consider diagrams of the form
{% tikz %}
\begin{tikzcd}
X \arrow[rd] & \\
 & A\\
Y \arrow[ru] & 
\end{tikzcd}
{% endtikz %}
where $$A$$ is some other set. These diagrams form a category, with morphisms given by commuting diagrams of the form
{% tikz %}
\begin{tikzcd}
X \arrow[rd] \arrow[rrd] & & \\
 & A \arrow[r] & A'\\
Y \arrow[ru] \arrow[rru] & & 
\end{tikzcd}
{% endtikz %}
What is an initial object in this category? It would be a set $$Z$$ together with morphisms $$\iota_X:X\to Z$$ and $$\iota_Y:Y\to Z$$, such that for any other set $$A$$ and morphisms $$X\to A$$, $$Y\to A$$, we could "factor" these morphisms through $$\iota_X$$ and $$\iota_Y$$ in a unique way and draw a diagram of the form
{% tikz %}
\begin{tikzcd}
X \arrow[rd,"\iota_X"'] \arrow[rrd,bend left=30,"a_X"] & & \\
 & Z \arrow[r,dashed,"f"] & A \\
Y \arrow[ru,"\iota_Y"] \arrow[rru,bend right=30,"a_Y"'] & & 
\end{tikzcd}
{% endtikz %}
There is a set $$Z$$ with these properties: the disjoint union $$X\sqcup Y$$, with the canonical inclusions $$\iota_X$$ and $$\iota_Y$$. It is clear how to define the morphism $$f:X\sqcup Y\to A$$ in a unique way: we define $$f(\iota_X(x)) = a_X(x)$$ for all $$x\in X$$, and $$f(\iota_Y(y)) = a_Y(y)$$ for all $$y\in Y$$.

In a general category, the initial diagram of this form is called the *coproduct* of the objects $$X$$ and $$Y$$. We have found that in the category of sets, all coproducts exist, and the coproduct coincides with the disjoint union. Coproducts are useful in other categories as well:
- In the category described previously in which objects are natural numbers and morphisms indicate divisibility, the coproduct of $$x$$ and $$y$$ is the least common multiple of $$x$$ and $$y$$.
- In the category of $$k$$-vector spaces, the coproduct of two vector spaces is their direct sum.
- In the category of topological spaces, the coproduct is the disjoint union of the spaces, together with a topology in which a set is open if and only if its preimage in both spaces is open. If we allowed any more open sets than this, the inclusion maps would not be continuous. If we allowed any fewer open sets than this, we would not have the initial object.

One final layer of abstraction: the coproduct is an instance of a more general construction called a colimit. To form a colimit, we first specify some diagram in $$\mathcal{C}$$, and then form the category of *co-cones* of this diagram. A co-cone is simply another object in $$\mathcal{C}$$, together with a morphism out of every object in our diagram to this other object, such that we get a commuting diagram. For instance, the diagrams involved in coproducts are co-cones of diagrams containing just the two objects $$X$$ and $$Y$$, with no arrows (other than identities). Another useful colimit starts from a diagram
{% tikz %}
\begin{tikzcd}
C \arrow[r,"f"] \arrow[d,"g"'] & A \\
B & 
\end{tikzcd}
{% endtikz %}
A co-cone for this diagram is an object $$D$$ together with morphisms $$u:A\to D$$, $$v:B\to D$$ such that the following diagram commutes (i.e., $$vg = uf$$):
{% tikz %}
\begin{tikzcd}
C \arrow[r,"f"] \arrow[d,"g"'] & A \arrow[d,"u"] \\
B \arrow[r,"v"'] & D
\end{tikzcd}
{% endtikz %}

The colimit is then the initial co-cone of the diagram. In this new example, the colimit is called the *pushout*. If it were not for the presence of $$C$$, we would just have the coproduct $$A\sqcup B$$, and in fact we denote the pushout of the diagram above by $$A\sqcup_C B$$. It differs from the coproduct because now the arrows coming out of $$A$$ and $$B$$ have to agree on the images of any $$c\in C$$. In the category of sets, we can construct the coproduct as a quotient:
\\[A\sqcup_C B = (A\sqcup B)/\lbrace f(c) \sim g(c)\mid \forall c\in C\rbrace .\\]
That is, we form the disjoint union of $$A$$ and $$B$$, but then identify the images of $$C$$ in each set with each other.

For one last example of a colimit, consider the following infinite diagram:
{% tikz %}
\begin{tikzcd}
X_0 \arrow[r] & X_1 \arrow[r] & X_2 \arrow[r] & X_3 \arrow[r] & \cdots
\end{tikzcd}
{% endtikz %}
A co-cone for this diagram is an object, which we denote $$\displaystyle\lim_\to X_i$$, together with morphisms $$f_i:X_i\to \displaystyle\lim_\to X_i$$. We can think of it as sitting below the infinite chain (and here it becomes more clear where the "cone" terminology comes from):
{% tikz %}
\begin{tikzcd}
X_0 \arrow[r] \arrow[rrrrdd,"f_0"'] & X_1 \arrow[r] \arrow[rrrdd] & X_2 \arrow[r] \arrow[rrdd] & X_3 \arrow[r] \arrow[rdd] & \cdots \arrow[dd] \\
 & & & & \\
 & & & & \displaystyle\lim_\to X_i
\end{tikzcd}
{% endtikz %}
This colimit is called the *direct limit* of the sequence of objects $$X_i$$. The lack of a "co" in this term is terribly confusing, as we will see shortly, but so it goes. The direct limit gives a sort of infinite union of objects. In the category of sets, this analogy is precise: we have $$\displaystyle\lim_\to X_i = \bigcup X_i$$, assuming the union exists. In other categories, it can be somewhat more subtle. For instance, in the category of groups, we can form the diagram
{% tikz %}
\begin{tikzcd}
\mathbb{Z}/p\mathbb{Z} \arrow[r] & \mathbb{Z}/p^2\mathbb{Z} \arrow[r] & \mathbb{Z}/p^3\mathbb{Z} \arrow[r] & \mathbb{Z}/p^4\mathbb{Z} \arrow[r] & \cdots
\end{tikzcd}
{% endtikz %}
where the homomorphism $$\mathbb{Z}/p^n\mathbb{Z}\to \mathbb{Z}/p^{n+1}\mathbb{Z}$$ is multiplication by $$p$$. The direct limit is the Prüfer $$p$$-group, denoted $$\mathbb{Z}\left(p^\infty\right)$$. It can be presented explicitly as
\\[\left\lbrace z\in \mathbb{C}\mid z^{p^n} = 1\text{ for some }n\in \mathbb{N}\right\rbrace.\\]
Direct limits are especially useful for classical matrix groups. For instance, we can always embed unitary groups $$U(n)\mapsto U(n+1)$$ by putting the $$n\times n$$ matrix in the upper left corner of the $$(n+1)\times (n+1)$$ matrix. We then get a diagram of the appropriate form, and its direct limit is called the *stable unitary group*, denoted $$U(\infty)$$. 

Now that we've covered initial objects, we'll turn to the concept we'll be more interested in in the following, final objects. A final object is dual to an initial object: it an object $$A$$ for which, for any other object $$B$$, there is a unique morphism $$B\to A$$. If $$A$$ is initial in $$\mathcal{C}^\text{op}$$, then $$A$$ is final in $$\mathcal{C}$$. If $$\mathcal{C}$$ is a poset, the final object is the greatest element, if one exists.

Just as initial objects give rise to colimits, final objects give rise to the dual concept, limits. Limits are the final objects in categories of cones, which are like co-cones except that the arrows go out of the new object, into the diagram. For instance, the limit of the diagram
{% tikz %}
\begin{tikzcd}
X \\
\\
Y
\end{tikzcd}
{% endtikz %}
consists of an object called the *product*, denoted $$X\times Y$$, together with projections $$\pi_X:X\times Y\to X$$ and $$\pi_Y:X\times Y\to Y$$, which is final in the category of diagrams of the form
{% tikz %}
\begin{tikzcd}
 & X \\
Z \arrow[ru] \arrow[rd] & \\
 & Y
\end{tikzcd}
{% endtikz %}
This means that for any such $$Z$$, we have a commuting diagram 
{% tikz %}
\begin{tikzcd}
 & & X \\
Z \arrow[rru,bend left=30] \arrow[rrd,bend right=30] \arrow[r,dashed] & X\times Y \arrow[ru,"\pi_X"] \arrow[rd,"\pi_Y"] & \\
 & & Y
\end{tikzcd}
{% endtikz %}
It is straightforward to check that this categorical product coincides with the usual Cartesian product of sets, product of groups, product of rings, product of topological spaces endowed with the product topology, and so on.

The notion dual to a pushout is a *pullback*. It is a limit of the diagram
{% tikz %}
\begin{tikzcd}
& A \arrow[d,"f"] \\
B \arrow[r,"g"'] & C
\end{tikzcd}
{% endtikz %}
It is denoted by $$A\times_C B$$. A pullback is like a product, except the pairs $$(a, b)$$ have to satisfy $$f(a) = g(b)$$. In categories where this language makes sense, we can think of $$A\times_C B$$ as the subobject of $$A\times B$$ satisfying this condition. For instance, in the category of groups, we have
\\[A\times_C B = \left\lbrace (a,b)\in A\times B\mid f(a) = g(b)\right\rbrace.\\]
Alternatively, $$A\times_C B$$ is the kernel of the homomorphism $$(a,b)\mapsto f(a)g(b)^{-1}$$, which makes it manifestly into a subgroup.

Finally, the concept dual to the direct limit is called the *inverse limit*. One important example of the inverse limit starts from the same diagram as before, but now with arrows reversed:
{% tikz %}
\begin{tikzcd}
\cdots \arrow[r] & \mathbb{Z}/p^4\mathbb{Z} \arrow[r] & \mathbb{Z}/p^3\mathbb{Z} \arrow[r] & \mathbb{Z}/p^2\mathbb{Z} \arrow[r] & \mathbb{Z}/p\mathbb{Z}
\end{tikzcd}
{% endtikz %}
The homomorphisms are quotienting by the $$\mathbb{Z}/p\mathbb{Z}$$ subgroup (i.e., we have $$f_n:\mathbb{Z}/p^{n+1}\to\mathbb{Z}/p^n\mathbb{Z}$$ where $$f_n(a) = a\pmod{p^n}$$). The inverse limit is the group of $$p$$-adic integers. It consists of sequences $$a_n$$ for which $$a_n\in \mathbb{Z}/p^n\mathbb{Z}$$ and $$a_n = a_{n+1}$$. We can add these sequences pointwise, and if we perform the same construction in the category of rings, we can multiply them as well.

The $$p$$-adic integers lead to tons of interesting mathematics, but here is just one tidbit. Consider the 5-adic integers. The number $$-4$$, when projected into each of the groups $$\mathbb{Z}/p^n\mathbb{Z}$$, gives the sequence $$(1, 21, 121, \ldots)$$. If we take the multiplicative inverse of each element of the sequence in its respective ring, we find $$(1, 6, 31, \ldots)$$. These are the partial sums of the series $$\sum 5^i$$, so in the 5-adic integers we find the relationship
\\[-\frac{1}{4} = \sum_{i=0}^\infty 5^i.\\]
Note that this is what we would get if we blindly used the expansion $$\frac{1}{1-r} = 1+r+r^2+\ldots$$ beyond its domain of convergence.

## $$F$$-algebras

Now we will turn to the objects of interest, $$F$$-algebras, and their dual concept, $$F$$-coalgebras. The $$F$$ in the name refers to a functor. Recall that a (covariant) functor $$F:\mathcal{C}\to\mathcal{D}$$ maps objects of $$\mathcal{C}$$ to objects of $$\mathcal{D}$$, and morphisms $$f:A\to B$$ in $$\mathcal{C}$$ to morphisms $$F(f):F(A)\to F(B)$$ in $$D$$, such that the following diagram commutes:
{% tikz %}
\begin{tikzcd}
A \arrow[r] \arrow[d,"f"'] & F(A) \arrow[d,"F(f)"] \\
B \arrow[r] & F(B)
\end{tikzcd}
{% endtikz %}

Here are a few examples:
- The forgetful functor from groups to sets takes a group to its underlying set. Commutativity of the diagram above requires that group homomorphisms are mapped to their underlying set functions.
- The fundamental group is a functor from topological spaces with a base point to groups. The map of objects is familiar (it takes a topological space $$X$$ with base point $$x\in X$$ to the group $$\pi_1(X, x)$$ of homotopy classes of maps $$\gamma:S^1\to X$$ with $$\gamma(0) = x$$). To see that it is a functor, we have to show that a base-point-preserving continuous map $$f:X\to Y$$ of topological spaces can be turned into a group homomorphism $$\pi_1(X, x)\to \pi_1(Y, y)$$. Indeed, we can send any $$\gamma:S^1\to X$$ to $$f\circ \gamma:S^1\to Y$$, and it is straightforward to show that this gives a group homomorphism for which the diagram above commutes.
- A group can be represented as a category with a single object, with morphisms corresponding to the elements of $$G$$. A functor from this one-object category to $$k$$-vector spaces picks out a vector space $$X$$, and sends each group element to an automorphism of $$X$$. This is a representation of $$G$$, so representations are functors.

An $$F$$-algebra uses a functor $$F$$ to encode the *signature* of some algebraic object, the types of operations it supports. For example, when we give an explicit definition of a group, we refer to its identity element $$e\in G$$, an inverse operator $$G\to G$$ which sends $$x\mapsto x^{-1}$$, and of course a binary product $$G\times G\to G$$. A group can be thought of as a set, together with these three pieces of data, satisfying additional conditions (associativity, and the identity and inverse working as they should).

We can encode the first part of the definition -- a set having some operations -- using a functor. Given some set $$G$$, we can form the set $$\lbrace \ast\rbrace \sqcup G \sqcup G\times G$$. Defining the three operations corresponds to defining a function from this set to $$G$$: the sole element $$\ast$$ of the singleton is sent to $$e\in G$$, elements $$x\in G$$ are sent to $$x^{-1}$$, and pairs $$(x, y)\in G\times G$$ are sent to $$xy\in G$$. So, let $$F$$ be a functor from sets to sets, sending $$G$$ to $$\lbrace \ast\rbrace \sqcup G \sqcup G\times G$$. Then the data defining a group corresponds to a function $$F(G)\to G$$.

Since we stated everything over sets, we didn't really need category theory here. But remember that the disjoint union of sets corresponds to the categorical coproduct, and the product of sets to the categorical product. Furthermore, the singleton set $$\lbrace \ast\rbrace $$ is the final object in the category of sets, which we can think of as teh coproduct of an empty list of sets. Thus, for any category which has (finite) products and coproducts, we could form the functor $$F:\mathcal{C}\to \mathcal{C}$$ which sends an object $$G\in\mathcal{C}$$ to $$1+G+G\times G$$, where $$+$$ denotes the coproduct, $$\times$$ denotes the product, and $$1$$ is the final object of $$\mathcal{C}$$. It is straightforward to show how this map of objects becomes a functor. The group data is then a morphism in $$\mathcal{C}$$ from $$F(G)\to G$$.

This is not just abstraction for abstraction's sake; by changing the category $$\mathcal{C}$$, we get interesting new notions. For instance, taking $$\mathcal{C}$$ to be finite sets, we get the data of a finite group. Taking $$\mathcal{C}$$ to be smooth manifolds where morphisms are smooth maps, we get the data of a Lie group. 

Of course, we're missing something very significant about groups: in this language we don't have a way to say that the product is associative, or that the product of an element and its inverse gives the identity. When $$F$$ is the functor defined above, all groups are $$F$$-algebras, but not all $$F$$-algebras are groups. There are of course ways of refining the language to handle such constraints, but for now we can focus instead on objects that can be phrased as $$F$$-algebras which need no constraints.

We will start with the functor $$F(X) = 1 + X$$. The corresponding $$F$$-algebras are objects equipped with a specified element (in set language, the image of the singleton 1) and an endomorphism (in set language, the function $$X\to X$$). What does the class of all such objects look like? We should of course define a category for them. Since an $$F$$-algebra is a morphism $$F(X)\to X$$, a morphism of $$F$$-algebras should be a commutative diagram of the form
{% tikz %}
\begin{tikzcd}
F(X) \arrow[r] \arrow[d] & X \arrow[d] \\
F(Y) \arrow[r] & Y
\end{tikzcd}
{% endtikz %}
For our particular functor $$F$$ over the category of sets, this implies that if we have a set $$X$$ with specified element $$x_0$$ and a function $$\alpha_X:X\to X$$, then our function $$f:X\to Y$$ should satisfy $$f(x_0) = y_0$$ and $$f(\alpha_X(x)) = \alpha_Y(f(x))$$, where $$y_0$$ and $$\alpha_Y$$ are the $$F$$-algebra data of $$Y$$.

Now we come to the main sort of question we want to ask: what is the initial $$F$$-algebra for this functor $$F$$ over the category of sets? Sometimes initial objects are small, so let's first try the smallest possible $$F$$-algebra, the singleton set $$\lbrace x_0\rbrace $$ with $$\alpha_X(x_0) = x_0$$. We quickly run into trouble: for some other $$F$$-algebra $$(Y, y_0, \alpha_Y)$$, we have to send $$x_0$$ to $$y_0$$. But then if $$\alpha_Y(y_0) \neq y_0$$, we don't have an $$F$$-algebra morphism. So setting $$\alpha_X(x_0) = x_0$$ was a constraint that we can't afford. Instead, let's have a new element $$x_1$$ and set $$\alpha_X(x_0) = x_1$$. If we set $$\alpha_X(x_1)$$ to be any of the existing elements, we run into the same problem, so we need an $$x_2$$. And so on...we eventually end up with the set $$\lbrace x_0, x_1, x_2, \ldots\rbrace $$ where $$\alpha(x_i) = x_{i+1}$$. This is just the natural numbers $$\mathbb{N}$$, with $$\alpha_X$$ the successor function $$\mathbb{N}\to\mathbb{N}$$.

Now let's look at the dual concept, $$F$$-coalgebras. Of course we simply reverse the arrows, so now we want a morphism $$X\to F(X)$$. But what does this mean? With an $$F$$-algebra, we would first "leave" the object $$X$$ by thinking about some structure built from elements of $$X$$ -- that is, an object of $$F(X)$$ -- and then go back to $$X$$. With an $$F$$-coalgebra, we start with an element of $$X$$ and then generate something from it. It is thus common to think of $$F$$-coalgebras as a model for systems. For instance:
- If $$F(X) = S\times X$$, for some fixed set $$S$$, then an $$F$$-coalgebra is an infinite string formed from elements of $$S$$. We start from an element $$x_0\in X$$, and then use the morphism $$(\text{head}, \text{tail}):X\to S\times X$$ to generate the sequence
\\[\text{head}(x_0), \text{head}(\text{tail}(x_0)), \text{head}(\text{tail}(\text{tail}(x_0))), \ldots\\]
- If $$F(X) = S\times X + 1$$, then an $$F$$-coalgebra is a list of elements in $$S$$ which can be finite or infinite. If acting with the morphism $$X\to F(X)$$ gives the element of the singleton instead of a pair in $$S\times X$$, then we can no longer recurse and the list terminates.
- If $$F(X) = \lbrace 0,1\rbrace \times X^S$$, then from an element of $$X$$, we get an element of $$\lbrace 0,1\rbrace $$ -- which we think of as a decision -- and a function from the alphabet $$S$$. This is a deterministic finite automaton (DFA). The set $$X$$ is the set of states, and each state is either accepting or not (the $$\lbrace 0,1\rbrace $$), and has a state transition table (the function $$S\to X$$, that tells us which state to go to depending on the input).

Since we asked about initial $$F$$-algebras, we should ask about final $$F$$-coalgebras. We'll use the second example above: what's the final $$F$$-coalgebra for $$F(X) = S\times X + 1$$? A morphism of co-algebras with target $$X\to F(X)$$ is a commuting diagram of the form
{% tikz %}
\begin{tikzcd}
Y \arrow[r] \arrow[d] & F(Y) \arrow[d] \\
X \arrow[r] & F(X)
\end{tikzcd}
{% endtikz %}
Let's proceed the same way as before: what if $$X = \lbrace x_0\rbrace $$ and the morphism sends $$x_0 \mapsto (s, x_0)$$ where $$s\in S$$? This represents the sequence $$(s, s, s, \ldots)$$. To construct a morphism from $$Y\to F(Y)$$, we would need to pick an element of $$Y$$ and send it to $$x_0$$. But then this element of $$Y$$ would have to be mapped to itself, and so we find we can only support incoming morphisms from sequences of a single repeating element, so we have to expand $$X$$. 

We could follow this train of logic as before, but instead, we'll prove a pair of theorems (from [ncatlab](https://ncatlab.org/nlab/show/terminal+coalgebra+for+an+endofunctor)) that give a more systematic way of computing a final $$F$$-coalgebra. The first is straightforward, once you think about it:

**Theorem**: If $$\theta:X\to F(X)$$ is a final $$F$$-coalgebra, then $$\theta$$ is an isomorphism, so that $$X$$ is a "fixed point" of the functor $$F$$.
**Proof**: Since $$F$$ is a functor, we can act with it on $$\theta$$ to get $$F(\theta):F(X)\to F^2(X)$$. Since $$\theta$$ is a final $$F$$-coalgebra, there is a unique diagram
{% tikz %}
\begin{tikzcd}
F(X) \arrow[r,"F(\theta)"] \arrow[d,"f"'] & F^2(X) \arrow[d,"F(f)"] \\
X \arrow[r,"\theta"'] & F(X)
\end{tikzcd}
{% endtikz %}
But of course, we can also use $$\theta$$ itself to construct an $$F$$-coalgebra morphism going the other way:
{% tikz %}
\begin{tikzcd}
X \arrow[r,"\theta"] \arrow[d,"\theta"'] & F(X) \arrow[d,"F(\theta)"] \\
F(X) \arrow[r,"F(\theta)"'] & F^2(X) 
\end{tikzcd}
{% endtikz %}
We can stack this on top of the other diagram to get an $$F$$-coalgebra morphism from $$\theta:X\to F(X)$$ to itself:
{% tikz %}
\begin{tikzcd}
X \arrow[r,"\theta"] \arrow[d,"\theta"'] & F(X) \arrow[d,"F(\theta)"] \\
F(X) \arrow[r,"F(\theta)"] \arrow[d,"f"'] & F^2(X) \arrow[d,"F(f)"] \\
X \arrow[r,"\theta"'] & F(X)
\end{tikzcd}
{% endtikz %}
Since $$\theta$$ is final, this morphism must be the identity. What if we stack the diagrams in the other direction? Then we get a morphism from $$F(\theta)$$ to itself:
{% tikz %}
\begin{tikzcd}
F(X) \arrow[r,"F(\theta)"] \arrow[d,"f"'] & F^2(X) \arrow[d,"F(f)"] \\
X \arrow[r,"\theta"] \arrow[d,"\theta"'] & F(X) \arrow[d,"F(\theta)"] \\
F(X) \arrow[r,"F(\theta)"'] & F^2(X) 
\end{tikzcd}
{% endtikz %}
But compare this with the first diagram above: this says that $$\theta\circ f = F(f)\circ F(\theta)$$. We've already shown that $$f\circ\theta$$ is the identity, so $$F(f)\circ F(\theta) = F(f\circ \theta)$$ must be an identity morphism as well. This shows that $$\theta$$ is an isomorphism, with $$f$$ its inverse, and hence that $$\theta:X\to F(X)$$ is an isomorphism.

Note that we think of $$\theta$$ differently when it is horizontal and when it is vertical. When $$\theta$$ is a horizontal arrow, it is the $$F$$-coalgebra object, since objects of the category of $$F$$-coalgebras are themselves morphisms in the underlying category. When $$\theta$$ is a vertical arrow, it is a morphism of $$F$$-coalgebras. The fact that $$\theta$$ can act in both of these ways is the crux of the proof.

We could use this theorem itself to intuit what a final $$F$$-coalgebra should be. For a simpler example, one could prove a similar theorem for $$F$$-algebras, and then apply it to the previous example: what is a fixed point of a functor $$F(X) = 1+X$$ in the category of sets? That is, what set is unchanged when we add a single object to it? The natural numbers have this property -- this is the point of the [Hilbert Hotel](https://en.wikipedia.org/wiki/Hilbert%27s_paradox_of_the_Grand_Hotel) parable.

But of course, other sets with larger cardinality have this property too, and it is unclear from this perspective if they form isomorphic $$F$$-coalgebras. We would like some way of constructing the fixed point required by this theorem. Generally, if we want a fixed point of some sort of map $$F$$, we just iterate $$F$$ until it converges. This holds, in a sense, in the categorical setting. The following result provides a construction (albeit a rather abstract one) for the final $$F$$-coalgebra (again, credit to [ncatlab](https://ncatlab.org/nlab/show/terminal+coalgebra+for+an+endofunctor) for the proof):

**Theorem**: If $$\mathcal{C}$$ has a final object 1, and $$F:\mathcal{C}\to\mathcal{C}$$ is a functor, then we have a diagram
{% tikz %}
\begin{tikzcd}
\cdots \arrow[r] & F^3(1) \arrow[r] & F^2(1) \arrow[r] & F(1) \arrow[r] & 1
\end{tikzcd}
{% endtikz %}
If the limit $$L$$ exists, and $$F$$ preserves this limit, then $$L$$ is a final $$F$$-coalgebra.

**Proof**: There's a lot to unpack here. First, how do we construct the diagram in the proof? We know there is a unique arrow $$F(1)\to 1$$ because 1 is the final object of $$\mathcal{C}$$. We then use $$F$$ repeatedly on this arrow to construct all the other arrows.

Next, what does it mean for $$F$$ to preserve the limit $$L$$? It means that if we take the limit of the diagram and act with $$F$$, getting $$F(L)$$, this is the same as acting with $$F$$ on the diagram, getting a similar chain that ends at $$F(1)$$, and then taking the limit of this diagram.

With that out of the way, we can proceed. If $$L$$ is the limit of the diagram, then by definition $$L$$ forms a cone over the diagram:
{% tikz %}
\begin{tikzcd}
L \arrow[d,dashed] \arrow[rd,dashed] \arrow[rrd,dashed] \arrow[rrrd,dashed] \arrow[rrrrd,dashed,"\pi_0"] & & & & \\
\cdots \arrow[r] & F^3(1) \arrow[r] & F^2(1) \arrow[r] & F(1) \arrow[r] & 1
\end{tikzcd}
{% endtikz %}
We have labeled the last arrow of the cone as $$\pi_0$$, and generally we let $$\pi_n:L\to F^n(1)$$ be the $$n$$th arrow of the cone. To give $$L$$ the structure of an $$F$$-coalgebra, we need a morphism $$\theta:L\to F(L)$$. We can use a bit of Hilbert Hotel-style footwork to get there. First, we are given that $$F$$ preserves the limit, so
{% tikz %}
\begin{tikzcd}
F(L) \arrow[d,dashed] \arrow[rd,dashed] \arrow[rrd,dashed] \arrow[rrrd,dashed] \arrow[rrrrd,dashed,"F(\pi_0)"] & & & & \\
\cdots \arrow[r] & F^4(1) \arrow[r] & F^3(1) \arrow[r] & F^2(1) \arrow[r] & F(1)
\end{tikzcd}
{% endtikz %}
is a limit cone for this diagram. But we could just as easily build a cone for the same diagram by chopping off the last segment of the diagram above:
{% tikz %}
\begin{tikzcd}
L \arrow[d,dashed] \arrow[rd,dashed] \arrow[rrd,dashed] \arrow[rrrd,dashed] \arrow[rrrrd,dashed,"\pi_1"] & & & & \\
\cdots \arrow[r] & F^4(1) & F^3(1) \arrow[r] & F^2(1) \arrow[r] & F(1)
\end{tikzcd}
{% endtikz %}
Since $$F(L)$$ is the limit of the diagram, there must be a unique way to assemble these two cones, like so:
{% tikz %}
\begin{tikzcd}
L \arrow[d,"\theta"'] \arrow[rdd,dotted] \arrow[rrdd,dotted] \arrow[rrrdd,dotted] \arrow[rrrrdd,dotted,"\pi_1"] & & & & \\
F(L) \arrow[d,dashed] \arrow[rd,dashed] \arrow[rrd,dashed] \arrow[rrrd,dashed] \arrow[rrrrd,dashed,"F(\pi_0)"] & & & & \\
\cdots \arrow[r] & F^4(1) & F^3(1) \arrow[r] & F^2(1) \arrow[r] & F(1)
\end{tikzcd}
{% endtikz %}
This construction gives us what we needed, the coalgebra structure $$\theta:L\to F(L)$$. Now we need to show that $$\theta$$ is final.

Let $$\eta:X\to F(X)$$ be some other $$F$$-coalgebra. We want to construct a unique $$F$$-coalgebra morphism from $$\eta\to\theta$$. The only tool we have is $$L$$ being the limit of the diagram in the proof, so let's use this fact. We can construct a cone from $$X$$ as follows. First, there is a unique morphism $$X\to 1$$, by definition. Acting with $$F$$, we get a morphism $$F(X) \to F(1)$$, and we already have $$\eta:X\to F(X)$$, so composing these gives $$X\to F(1)$$. Following this same pattern, we can inductively define all the maps $$X\to F^n(1)$$, and you can check that they form a cone. Since $$L$$ is the limit, we get a unique map $$f:X\to L$$. But we need more than that, namely, a morphism of $$F$$-coalgebras. In fact we can get that as well. We know that $$F(L)$$ is the limit of the chain ending at $$F(1)$$, and there are two ways to get to $$F(L)$$ from $$X$$: we can use $$f$$ to go to $$L$$, and then $$\theta$$ to go to $$F(L)$$, or we can use $$\eta$$ to go to $$F(X)$$, and then use finality of the $$F(L)$$ cone to get a map $$F(X)\to F(L)$$. And by finality of $$F(L)$$, these two paths must coincide. Drawing a picture of this, we find
{% tikz %}
\begin{tikzcd}
X \arrow[r,"\eta"] \arrow[d,"f"'] & F(X) \arrow[d] \\
L \arrow[r,"\theta"'] & F(L)
\end{tikzcd}
{% endtikz %}
This is an $$F$$-coalgebra morphism from our arbirary $$\eta:X\to F(X)$$ to $$\theta:L\to F(L)$$.

We haven't proved uniqueness, but you can sort of feel it: there were no choices made, everything was forced from the start. More details can be found in the proof on ncatlab.

So, equipped with this theorem, let's find the final $$F$$-coalgebra for $$F(X) = 1 + S\times X$$. We start with $$1 = \lbrace\ast\rbrace$$. Acting with $$F$$, we get $$F(1) = 1+ S$$. Acting again, we get $$1 + S + S^2$$. The pattern is clear; $$F^n(1)$$ is the set of all sequences in the alphabet $$S$$ of length up to $$n$$. Furthermore, it is clear what the limit should be: the set of all sequences, finite or infinite, over $$S$$.

If we set $$S = \mathbb{N}$$, these are the (non-negative) continued fractions! A finite sequence of natural numbers is the continued fraction for a rational number, and an infinite sequence is the continued fraction of an irrational number.

## Induction and Coinduction

We certainly didn't need all this categorical machinery just to realize an isomorphism between continued fractions and sequences of natural numbers. But there is something to be gained from it all.

We've seen that the natural numbers are the initial $$F$$-algebra for the endofunctor $$F(X) = 1+X$$. This is actually a good categorical setting in which to formulate the principle of induction. Induction is generally used in two ways: to define something, or to prove something. Consider the following elementary examples:
 - Let $$f(1) = 1$$. Given $$f(n)$$, we define by induction $$f(n+1) = f(n) + 2n + 1$$.
 - Let $$f(n) = \sum_{i=1}^n (2i-1)$$. We prove by induction that $$f(n) = n^2$$. First, it is clear that $$f(1) = 1$$. Given $$f(n) = n^2$$, it follows that $$f(n+1) = f(n) + 2n + 1 = n^2 + 2n + 1 = (n+1)^2$$, so the claim follows.

In the first case, it is not too difficult to see the relationship with an $$F$$-algebra, where here $$F(X) = 1 + X$$. Recall that an $$F$$-algebra is defined by a set $$X$$ and a morphism (i.e., set function) $$FX\to X$$. Furthermore, we've seen that such a set function is defined by an initial element $$x_0\in X$$, and a successor function $$X\to X$$. This is exactly what a "definition by induction" consists of: a starting value, and a way of getting from one value to the next. So, we can build an $$F$$-algebra: let $$X = \mathbb{N}\times\mathbb{R}$$. An element of $$X$$ consists of an index from $$\mathbb{N}$$ and a function value from $$\mathbb{R}$$. Our specified element $$x_0\in X$$ is $$(1, 1)$$. Our successor function $$\text{succ}:X\to X$$ is defined by $$\text{succ}((i, x)) = (i+1, x + 2i + 1)$$.

Now we use initiality. Since we have defined an $$F$$-algebra $$FX\to X$$, there exists a unique homomorphism from $$\mathbb{N}$$ with its $$F$$-algebra structure to our new $$F$$-algebra. And *this* is what guarantees that our definition gives rise to a unique function $$f$$: we use the inductive data to construct the $$F$$-algebra, take the unique homomorphism from $$\mathbb{N}$$, and define the value of $$f(n)$$ as the image of $$n\in\mathbb{N}$$ under this homomorphism.

Now let's think about a proof by induction. Here we lean more on the uniqueness aspect of initiality: we will construct one $$F$$-algebra homomorphism from $$\mathbb{N}$$, and since $$\mathbb{N}$$ is initial, there can be no others. Our target $$F$$-algebra will be the set $$X = \mathbb{N}\times \{\text{T}, \text{F}\}$$. Elements of this set consist of an index from $$\mathbb{N}$$ and a label for whether our claim is true or false at this index. Since we have proved the result for 1, our initial element shall be $$(1, \text{T})$$. Since we have proved that the claim for $$n$$ implies the claim for $$n+1$$, we know that our successor function must satisfy $$\text{succ}((i, \text{T})) = (i+1, \text{T})$$. Now, clearly the set function $$\mathbb{N}\to X$$ defined by $$n\mapsto (n, \text{T})$$ can be lifted to an $$F$$-algebra homomorphism. But, since $$\mathbb{N}$$ is initial, this is the unique $$F$$-algebra homomorphism. Hence, proving that the claim holds for one and proving the inductive step is enough to show that the claim must hold for all $$n\in\mathbb{N}$$.

This wasn't difficult; the more interesting part is that we don't have to use the functor $$F(X) = 1 + X$$. For instance, what if we change things ever so slightly by making $$F(X) = 1 + X^2$$, where here $$X^2 = X\times X$$ is the product of sets. Then an $$F$$-algebra over the set $$X$$ consists of a specified element of $$X$$ and a binary operation on $$X$$. One can show that the initial $$F$$-algebra is the set of all rooted binary trees, where the specified element is the empty tree and the binary operation joins two trees together under a root, like so:
{% tikz %}
\begin{tikzpicture}
\tikzset{dot/.style={fill,circle,minimum size=5,inner sep=0}}
\node at (0,2) {$$T$$};
\node at (1.5, 2) {$$\times$$};
\node at (3, 2) {$$T$$};
\node at (5, 2) {$$\to$$};
\node at (9, 2) {$$T$$};

\node[dot] at (0,0) (A) {};
\draw (A) -- ++(-1,-1) node[dot] {};
\draw (A) -- ++(+1,-1) node[dot] {};
\node at (1.5, -0.5) {$$\times$$};
\begin{scope}[xshift=3cm]
\node[dot] at (0,0) (B) {};
\draw (B) -- ++(-1,-1) node[dot] {};
\draw (B) -- ++(+1,-1) node[dot] (C) {};
\draw (C) -- ++(-1,-1) node[dot] {};
\draw (C) -- ++(+1,-1) node[dot] {};
\end{scope}
\node at (5, -0.5) {$$\mapsto$$};
\begin{scope}[xshift=9cm]
\node[dot] at (0,0) (W) {};
\draw (W) -- ++(-1.5,-1) node[dot] (X) {};
\draw (W) -- ++(+1.5,-1) node[dot] (Y) {};

\draw (X) -- ++(-1,-1) node[dot] {};
\draw (X) -- ++(+1,-1) node[dot] {};

\draw (Y) -- ++(-1,-1) node[dot] {};
\draw (Y) -- ++(+1,-1) node[dot] (Z) {};
\draw (Z) -- ++(-1,-1) node[dot] {};
\draw (Z) -- ++(+1,-1) node[dot] {};
\end{scope}
\end{tikzpicture}
{% endtikz %}

Now, using the arguments above verbatim, we have the logical foundations for defining a function over trees inductively. For example, we could define a size function by setting it equal to 1 on the tree with only a root, and defining $$\text{size}(T_1\times T_2) = 1 + \text{size}(T_1) + \text{size}(T_2)$$. It might be very slightly less obvious in this case that we get a unique and well-defined function over trees from this specification, but this follows from the initiality of the set of trees as an $$F$$-algebra.

What about $$F$$-coalgebras? If we have a final $$F$$-coalgebra, then we can again construct a unique homomorphism, this time *from* any other $$F$$-coalgebra. We can use this to motivate a principle of *coinduction*. For example, let $$F(X) = 1 + \mathbb{N}\times X$$, so the final $$F$$-coalgebra consists of sequences of natural numbers, which we may regard as continued fractions and denote by $$\text{CF}$$. Let $$(\text{head},\text{tail}):\text{CF}\to F(\text{CF})$$ denote the $$F$$-coalgebra structure, where $$\text{head}:\text{CF}\to (1+\mathbb{N})$$ either gives the integer part or outputs $$\ast$$ to indicate termination. For purposes of arithmetic, we may think of $$\ast$$ as infinity.

Since finality concerns homomorphisms into the final $$F$$-coalgebra, we use coinduction to define functions which have continued fractions as their output. A familiar example is Gosper arithmetic, but let's use a simpler example than a general (bi)homographic function. We define the inverse $$\text{inv}:\text{CF}\to\text{CF}$$ by
$$\begin{align}\begin{split}
\text{head}(\text{inv}(x)) &= 0 \\
\text{tail}(\text{inv}(x)) &= x
\end{split}\end{align}$$
Note how this differs from induction. When we define some function $$f$$ on the natural numbers by induction, we give the value of $$f(1)$$ and $$f(\text{succ}(n))$$. Here, instead, we define how the $$F$$-coalgebra structure acts on our function $$\text{inv}$$. Intuitively, induction is for analyzing data (like a natural number, a list, or a tree), while coinduction is for building data (in this case, a finite or infinite sequence).

Gosper arithmetic is more complicated, but it works in the same way. We specify how to compute the head and tail (i.e., the integer part and the remainder), and this suffices to define a continued fraction. 