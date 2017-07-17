<<<<<<< HEAD
=======
all:
	@echo 

>>>>>>> 6b42c4a8251d52fc9505de1b11a7083f8f3bdc93
RMD=$(wildcard *_*.Rmd)

RCD=$(RMD:.Rmd=.R)
HTM=$(RMD:.Rmd=.html)
PDF=$(RMD:.Rmd=.pdf)
ODT=$(RMD:.Rmd=.odt)
DOC=$(RMD:.Rmd=.docx)
MDN=$(RMD:.Rmd=.md)
IPY=$(RMD:.Rmd=.ipynb)

%.R: %.Rmd
	Rscript -e 'knitr::purl("$*.Rmd")'

%.md: %.Rmd
	Rscript -e 'rmarkdown::render("$*.Rmd", "rmarkdown::md_document")'

%.html: %.Rmd
	Rscript -e 'rmarkdown::render("$*.Rmd", "rmarkdown::html_document")'

.PRECIOUS: %.pdf
%.pdf: %.Rmd
	Rscript -e 'rmarkdown::render("$*.Rmd", "rmarkdown::pdf_document")'

%.view: %.pdf
	evince $^ &

%.ipynb: %.Rmd
	notedown $^ --nomagic > $@
	sh support/fix_ipynb.sh $@

%.docx: %.Rmd
	Rscript -e 'rmarkdown::render("$*.Rmd", "rmarkdown::word_document")'

%.odt: %.Rmd
	Rscript -e 'rmarkdown::render("$*.Rmd", "rmarkdown::odt_document")'

clean:
<<<<<<< HEAD
	rm -f *.docx *.R *.odt *.pdf *.html *.md *.ipynb
=======
	rm -f *.docx *.R *.odt *.pdf *.html *.ipynb
>>>>>>> 6b42c4a8251d52fc9505de1b11a7083f8f3bdc93

realclean: clean
	rm -f *~
	rm -rf _book _site _html data models
	rm -rf app_education_files

