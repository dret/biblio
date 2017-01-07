# dretbiblio

[`dret.bib`](dret.bib) is [Erik Wilde](http://dret.net/netdret)'s personal bibliography. I started it working on my Ph.D., and have updated it ever since. Naturally, it is very biased towards the things that I have been working on since then, mostly application layer communications systems, structured information representation and management, Web technologies, and service architecture.

I have been constantly updating the bibliography for 25+ years, but over the course of my career, my focus has switched from academia to a more applied angle. I still try to follow all relevant developments in the standardization area, mostly focusing on W3C and IETF specifications.


## Contributing

Please refrain from submitting pull requests that add new entries. This is my personal bibliography, and it is unlikely that I will add anything unless I have to, and in that case I will just do it myself.

However, if you have other contributions, such as fixing typos or adding useful fields to entries, please submit a pull request. I will try to look at it as soon as possible.


## Building

[`dret.bib`](dret.bib) is first and foremost a BibTeX bibliography, intended to be used with LaTeX. If for some reason you want to create a PDF version of the bibliography, [`build`](build) has everything you need (it also has [possibly slightly outdated PDF version](build/dretbiblio.pdf)).

A long time ago, I was able to generate XML from the BibTeX source, and generate Web pages from that. However, the code that did that stopped working, and I never got around to get it running again. The [`sharef`](sharef) directory contains some artifacts from this time, but at this point it is purely historical.
