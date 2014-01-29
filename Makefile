all: quantfig

clean:
	-rm -f *.pdf *.aux *.out *.log

.PHONY: clean all quantfig

quantfig:
	R --vanilla --silent < quantile-fig.R
	sh process-quantfigs.sh
	pdflatex quantile-fig.tex
	pdfcrop quantile-fig.pdf quantile-fig.pdf
	pdf2svg quantile-fig.pdf quantile-fig.svg

preffree:
	R --vanilla --silent < analysis-preffree.R
	pdfcrop ra-preffree.pdf ra-preffree.pdf
	pdfcrop cw-preffree.pdf cw-preffree.pdf
	pdf2svg ra-preffree.pdf ra-preffree.svg
	pdf2svg cw-preffree.pdf cw-preffree.svg
