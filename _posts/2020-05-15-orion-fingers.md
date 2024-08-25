---
layout: publication
title: "Formation of Orion Fingers"
authors: 'Ross Dempsey, Nadia Zakamska, and James Owen'
date: 2020-05-15
venue: 'MNRAS'
paperurl: 'https://srossd.com/files/orion.pdf'
arxiv: 'https://arxiv.org/abs/2005.01902'
doi: 'https://doi.org/10.1093/mnras/staa1264'
tags: astrophysics
categories: publication-posts
---

A short time ago (about 500 -- 1000 years), in a galaxy very nearby (our own Milky Way, in fact), something fascinating happened in the Orion Nebula. If only humans had evolved and developed astronomy on a slightly faster schedule, we might have witnessed this event. Regrettably, we procrastinated for several hundred years in the Middle Ages, and missed the show. All we can see is the aftermath, known as the Orion fingers.

<figure>
<a href='https://apod.nasa.gov/apod/ap190303.html'><img style='width: 100%' src="https://srossd.com/images/orion_fingers.jpg" alt="OMC-1 Outflow" title="A few of the hundreds of Orion fingers. Image Credit: GeMS/GSAOI Team, Gemini Observatory"/></a>
<figcaption>
A few of the hundreds of Orion fingers. Image Credit: GeMS/GSAOI Team, Gemini Observatory
</figcaption>
</figure>

There are hundreds of these triangular formations, all pointing outwards from a central point. Better yet, since the Orion Nebula is quite close to Earth, we can measure the motion of the triangle tips across the sky. They all move away from the central point, and by extrapolating their trajectories backwards, we conclude that they all launched from that central point roughly 500 years ago.

This looks like a smoking gun. Something cataclysmic must have happened at that central point 500 years ago, which launched shrapnel out into the surrounding cloud of gas. The pieces of shrapnel are at the tips of the triangles, and the triangles themselves are the wakes left by their fast (supersonic) motion through the gas.

What could the cataclysmic event have been? Well, Orion is a star-forming region -- one of the nurseries in our galaxy where hydrogen gas is squeezed together by gravity, slowly increasing its temperature and pressure, until finally a core becomes so hot that it can begin fusing hydrogen into helium. So there are young stars present in Orion, and since they all reside in the same gravitational well, there are opportunities for these stars to come close or even collide. And in fact, if we trace the trajectories of a few of these young stars backwards about 500 years, we find that they all coincide on roughly the same point about 500 years ago. And that point is the very same point from which the BN/KL outflow appears to originate!

This is fascinating, but it was all well-understood before our paper (see, for instance, [Bally et al. 2015](https://arxiv.org/abs/1502.04711), or several of John Bally's other papers). We wanted to understand some more details of the situation. For example: how large are the "bullets" which are flying through Orion? How massive are they? How did they form? And a key question (which we'll come back to later): will they survive long-term, or will they disintegrate?

There's lots of different evidence we can use to try and pin down the mass and size of the bullets. One point is rather obvious: the bullets themselves don't show up in the picture above (the blue dots are not the bullets -- they simply indicate the presence of an emission line of iron). So the bullets have to be smaller than the resolution limit of the Gemini South Adaptive Optics Imager (GSAOI), which took the picture. There also has to be enough mass contained in the bullets to produce those iron emission lines indicated by the blue dots. And, there can't be too much mass -- these bullets had to come from somewhere, and there's only so much mass that could plausibly have gotten tangled up in this mess when it all happened.

Put together, these are some relatively mild constraints on the mass and size of the bullets. But we can ask more questions. How are the bullets confined? Gas doesn't just stay in little clumps on its own; it would prefer to expand. Something has to keep it there, whether that be gravity, or the pressure of surrounding gas. Both options add constraints. How small could the bullets have gotten in 500 years? Planets aren't formed in a day, nor in 500 years, and so the bullets must be larger now than they would be as planets of the same mass. How did the wakes in the figure above form? There must be enough energy in the bullets to power those large wakes, which sets a lower limit on their mass. 

In light of all this, the idea of bullets being flung out from a central explosive point and forming the present-day wakes seems less plausible. Other investigations also call the scenario into question -- if we try to simulate the bullets being accelerated gravitationally while the stars come close together, it's hard to construct an event in which the bullets reach their present very high velocities and also the stars are ejected in the way we observe. And even if the bullets could be accelerated enough, it would be hard for them to survive the process -- that much gravity tends to rip things apart. While it's not necessarily *impossible* that such bullets form the Orion fingers, it's worth looking for another explanation.

There is another possible explanation, but it sounds a bit wacky at first. Water is more dense than oil, so if you put water on top of oil, it will sink down below. How exactly does it do that? This is a classic problem in fluid dynamics, whose answer is the Rayleigh-Taylor instability. According to Rayleigh and Taylor, the water will start to probe down into the oil, forming a sort of ``finger.'' Could the Orion fingers have originated in this way? There's no oil or water in the Orion Nebula, but there is a lot of hydrogen. Could that hydrogen be clumped into a denser portion and a less dense portion (the analogues of water and oil), and be accelerated in a way that mimics the gravity which pulls the water down?

The answer turns out to be yes, thanks to those young stars from earlier. Star formation is a cataclysmic process, and in its aftermath, young stars power intense stellar winds which sweep up the gas in their vicinities. In some circumstances, which might have been exacerbated by the interaction of several stars at that central point 500 or so years ago, the strength of these winds can be strongly time-dependent. So what happens when a time-varying stellar wind blows on the surrounding gas?

This question was first asked in the context of Orion by Jim Stone, [back in 1997](https://ui.adsabs.harvard.edu/abs/1997AJ....113..391M/abstract). We used [Athena++](https://princetonuniversity.github.io/athena/), software created by Jim Stone and collaborators, to investigate the question further. So, much credit to Jim Stone here! The video below shows the result of a variable stellar wind blowing outward from the lower left. And indeed, we see some features which qualitatively resemble the Orion fingers.

<video width="100%" controls>
  <source src="/assets/video/rt_wind.mp4" type="video/mp4">
Your browser does not support the video tag.
</video>

This simulation spanned 2000 years, but it doesn't have to -- with a different set of parameters, we could see the same fingers forming in 500 or 1000 years. In any case, stellar winds have enough energy to drive the fingers to their very high velocities. And they can do that without destroying anything (as was the case for gravitational acceleration of bullets), because there's nothing to destroy! The fingers, and their dense tips, are emergent phenomena in an ongoing hydrodynamic event.

There's a lot more to explore here. We've tried a lot of different physical setups -- different density profiles in the surrounding gas, different time-variability patterns for the wind, and so on -- and found that the onset of the Rayleigh-Taylor instability is quite generic. It would be interesting to explore more of the space of possibilities here. Even more broadly, stellar winds work, but they aren't the only energy source which could plausibly drive this process in Orion. But in any case, a hydrodynamic process forming the Orion fingers is certainly plausible, and possibly moreso than bullets being accelerated gravitationally.

So, then comes the tantalizing question: what happens next? If we turn our telescopes to Orion in another 500, 1000, 10,000 years, what will we see? It's certainly possible that everything will disintegrate, and that this is just a transient phenomenon with few lasting remnants. But what if the fingertips are dense enough to be self-gravitating? In the bullets scenario, this was one of two possibilities; in the hydrodynamic scenario, it's hard to say whether this is the case or ever will be. But if so, then there's a real possibility of the bullets persisting indefinitely...*as planets*. I left out the numbers from the discussion before, to save the surprise for now: the plausible ranges for the masses and sizes of these objects, however they formed, are on the order of the mass and size of Jupiter. So if they persist, they will become Jupiter-like objects.

I don't want to make this sound more certain than it is; we really can't be sure about the future fate of these objects. But if they manage to survive, then the Orion Nebula is not only a nursery for stars and the planets which will coalesce in orbit around them. It is also producing free-floating planets which will chart their own course through the galaxy, unfettered by the gravity of a host star.

This is a truly fascinating possibility. But even if it isn't true, the Orion fingers are spectacular, and form a fabulous laboratory for galactic, stellar, and planetary physics. Maybe even more striking is that, in terms of when the light reached Earth, they formed as recently as 500 years ago. In a universe home to structures and phenomena which have lasted billions of years, it can be tempting to think of the skies as static, waiting patiently for us to observe and catalog and understand. This is not so. There is a complex dance happening constantly all around us, on all scales -- whether it be storms forming on Neptune, planets forming in Orion, or black holes colliding. Now is the time to point our best technology to the sky and watch it unfold.