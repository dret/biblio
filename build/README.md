# Building dretbiblio

In case you want to build [..](dretbiblio), these instructions will help you do do that. But keep in mind that all you will get out of this is a rather big PDF (300+ pages).

The assumption is that you have a working BibTeX/LaTeX installation, and if you want to generate the author index, you need Perl as well.

The starting point is [`dretbiblio.tex`)[dretbiblio.tex], a simple LaTeX document with almost no content at all, but an instruction to include all references from the [`dret.bib`](../dret.bib) bibliography. Simply follow the steps shown in [`make.sh`](make.sh) (or just run it), and you should have the dretbiblio PDF as the end result.

