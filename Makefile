all: quantfig

clean:
	-rm -f *.pdf *.aux *.out *.log

.PHONY: clean all quantfig

quantfig:
	R --vanilla --silent < quantile-fig.R
	sh process-quantfigs.sh
	pdflatex quantile-fig.tex
	pdfcrop quantile-fig.pdf quantile-fig.pdf
	pdf2ps -sOutputFile=%stdout% quantile-fig.pdf |ps2eps > quantile-fig.eps

preffree:
	R --vanilla --silent < analysis-preffree.R
	pdfcrop ra-preffree.pdf ra-preffree.pdf
	pdfcrop cw-preffree.pdf cw-preffree.pdf
	pdf2ps -sOutputFile=%stdout% ra-preffree.pdf |ps2eps > ra-preffree.eps
	pdf2ps -sOutputFile=%stdout% cw-preffree.pdf |ps2eps > cw-preffree.eps
