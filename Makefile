LATEX = latex

DVIPS = dvips

PDFFLAGS = -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress \
           -dCompressPages=true -dUseFlateCompression=true  \
           -dEmbedAllFonts=true -dSubsetFonts=true -dMaxSubsetPct=100


%.dvi: %.tex
	$(LATEX) $<

%.ps: %.dvi
	$(DVIPS) -o $@ $<

%.pdf: %.ps
	ps2pdf $(PDFFLAGS) $<

all:	book.tex
	pdflatex book
	makeindex book.idx
	mv book.pdf thinkstats.pdf
	evince thinkstats.pdf

html:	book.tex header.html footer.html
	rm -rf html
	mkdir html
	hevea -O -e latexonly htmlonly book
# the following line is a kludge to prevent imagen from seeing
# the definitions in latexonly
	#grep -v latexonly book.image.tex > a; mv a book.image.tex
	imagen -png book
	hacha book.html
	cp up.png next.png back.png html
	mv index.html book.css book*.html book*.png *motif.gif html

DEST = /home/downey/public_html/greent/thinkstats

distrib:
	rm -rf dist
	mkdir dist dist/tex dist/tex/figs
	rsync -a thinkstats.pdf html cover_nolines.png dist
	rsync -a Makefile book.tex latexonly htmlonly dist/tex
	# rsync -a figs/*.fig figs/*.eps dist/tex/figs
	cd dist; zip -r thinkstats.tex.zip tex
	cd dist; zip -r thinkstats.html.zip html
	rsync -a dist/* $(DEST)
	chmod -R o+r $(DEST)/*

plastex:
	plastex --renderer=DocBook --theme=book --image-resolution=300 --filename=book.xml book.tex
	#~/Downloads/xxe-perso-4_8_0/bin/xxe book/book.xml

small: small.tex
	plastex --renderer=DocBook --theme=book --image-resolution=300 --filename=small.xml small.tex

sample:
	plastex --renderer=DocBook --theme=book --image-resolution=300 --image-scale-factor=0.25 --filename=sample2e.xml sample2e.tex
	~/Downloads/xxe-perso-4_8_0/bin/xxe sample2e/sample2e.xml

oreilly:
	rsync -a book/ ~/oreilly
	rsync -a figs/* ~/oreilly/figs
	cp thinkstats.pdf ~/oreilly/pdf

clean:
	rm -f *~ *.aux *.log *.dvi *.idx *.ilg *.ind *.toc



