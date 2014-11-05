OUTCOMES := cerebrovasc coronary myalgia transaminase
MTCSAMPLES := $(OUTCOMES:%=data/%.mtc.result.txt)
MTCDATA := $(OUTCOMES:%=data/%.data.txt)
MEAS := $(OUTCOMES:%=data/%.p.meas.txt)
FIGS = figs/network.pdf figs/quantile-fig.pdf figs/ra-exact.pdf figs/ra-ordinal.pdf figs/ra-ratio.pdf figs/ra-preffree.pdf

all: $(MTCSAMPLES) $(MEAS) $(FIGS)

samples: $(MEAS)

data: $(MTCDATA)

.PRECIOUS: $(MTCSAMPLES) $(MEAS)

print-subgroups: $(MEAS)
	R --vanilla --slave < analyses/subgroups.R

data/%.data.txt: code/excel.to.txt.R data/studies-with-filtering-info.xlsx
	R --vanilla --slace < code/excel.to.txt.R

data/%.mtc.result.txt: data/%.data.txt code/read.bugs.data.R code/run.mtc.R
	echo "source('code/read.bugs.data.R'); source('code/run.mtc.R'); dput(run.mtc(read.bugs.data('$<')), '$@')" | R --vanilla --slave

data/%.p.meas.txt: data/%.mtc.result.txt data/%.data.txt analyses/analysis-mtc.R analyses/baseline.jags
	echo "source('analyses/analysis-mtc.R'); write.measurement('$*', 'p')" | R --vanilla --slave

figs/absmeas.pdf: $(MTCSAMPLES) $(MEAS) figs/absmeas.tex figs/quantile-abs.R figs/process-absfigs.sh
	R --vanilla --slave < figs/quantile-abs.R
	cd figs; sh process-absfigs.sh
	cd figs; pdflatex absmeas
	cd figs; pdfcrop absmeas.pdf
	cd figs; mv absmeas-crop.pdf absmeas.pdf

figs/quantile-fig.pdf: $(MTCSAMPLES) $(MEAS) figs/quantile-fig.tex figs/quantile-fig.R figs/process-quantfigs.sh
	R --vanilla --slave < figs/quantile-fig.R
	cd figs; sh process-quantfigs.sh
	cd figs; pdflatex quantile-fig
	cd figs; pdfcrop quantile-fig.pdf
	cd figs; mv quantile-fig-crop.pdf quantile-fig.pdf

figs/ra-fig.pdf: $(MTCSAMPLES) figs/ra-exact.pdf figs/ra-preffree.pdf figs/ra-ordinal.pdf figs/ra-ratio.pdf figs/ra-fig.tex figs/process-rafigs.sh
	cd figs; sh process-rafigs.sh
	cd figs; pdflatex ra-fig
	cd figs; pdfcrop ra-fig.pdf
	cd figs; mv ra-fig-crop.pdf ra-fig.pdf

figs/%.pdf: figs/%.R $(MTCSAMPLES) analyses/analysis-base.R
	R --vanilla --slave -f $<

figs/ra-exact.pdf: analyses/analysis-exact.R analyses/analysis-base.R
	R --vanilla --slave -f analyses/analysis-exact.R

figs/ra-ratio.pdf: analyses/analysis-ratio.R analyses/analysis-base.R
	R --vanilla --slave -f analyses/analysis-ratio.R

figs/ra-ordinal.pdf: analyses/analysis-ordinal.R analyses/analysis-base.R
	R --vanilla --slave -f analyses/analysis-ordinal.R

figs/ra-preffree.pdf: analyses/analysis-ordinal.R analyses/analysis-base.R
	R --vanilla --slave -f analyses/analysis-preffree.R

