BASE := $(dir $(lastword $(MAKEFILE_LIST)))

RMD=$(wildcard *_*.Rmd)

RCD=$(RMD:.Rmd=.R)
HTM=$(RMD:.Rmd=.html)
PDF=$(RMD:.Rmd=.pdf)
ODT=$(RMD:.Rmd=.odt)
DOC=$(RMD:.Rmd=.docx)
MDN=$(RMD:.Rmd=.md)
IPY=$(RMD:.Rmd=.ipynb)

site: $(RCD) $(PDF) $(HTM) $(DOC) $(ODT) $(MDN) $(IPY)
	Rscript -e 'rmarkdown::render_site("index.Rmd")'

site.view: site
	firefox _site/index.html &

book.pdf: *.Rmd
	Rscript -e 'bookdown::render_book("index.Rmd", output_format="bookdown::pdf_book")'
	mv _book/_main.pdf $@
	rmdir _book

book.html: *.Rmd
	Rscript -e 'bookdown::render_book("index.Rmd", output_format="bookdown::gitbook")'
	mv _book _html

%.R: %.Rmd
	Rscript -e 'knitr::purl("$*.Rmd")'

%.md: %.Rmd
	Rscript -e 'rmarkdown::render("$*.Rmd", "rmarkdown::md_document")'

%.html: %.Rmd
	Rscript -e 'rmarkdown::render("$*.Rmd", "rmarkdown::html_document")'

%.pdf: %.Rmd
	Rscript -e 'rmarkdown::render("$*.Rmd", "rmarkdown::pdf_document")'

%.view: %.pdf
	evince $^

%.ipynb: %.Rmd
	notedown $^ --nomagic > $@
	sh $(BASE)fix_ipynb.sh $@

%.docx: %.Rmd
	Rscript -e 'rmarkdown::render("$*.Rmd", "rmarkdown::word_document")'

%.odt: %.Rmd
	Rscript -e 'rmarkdown::render("$*.Rmd", "rmarkdown::odt_document")'

install: realclean site
	sudo rsync -avzh _site/ /var/www/html/resources/
	sudo chmod -R go+rX /var/www/html/resources/
	rsync -avzh _site/*.ipynb adsapldsvm:notebooks/dsr/
	firefox /var/www/html/resources/index.html &

clean:
	rm -f *.docx *.R *.odt *.pdf *.html *.md *.ipynb

realclean: clean
	rm -f *~
	rm -rf _book _site _html data models
	rm -rf app_education_files

wwwclean:
	sudo rm -rf /var/www/html/resources/*
