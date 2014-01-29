all: quantfig

clean:
	-rm -f *.pdf *.aux *.out *.log

.PHONY: clean all quantfig

quantfig:
	R --vanilla --silent < quantile-fig.R
	sh process-quantfigs.sh
	pdflatex quantile-fig.tex
	pdfcrop quantile-fig.pdf quantile-fig.pdf
