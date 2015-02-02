OUTCOMES := NonfatalMI NonfatalStroke All-causeMortality Discontinuations Myalgia Transaminase CK
MTCSAMPLES := $(OUTCOMES:%=data/%.mtc.result.rds)
MTCDATA := $(OUTCOMES:%=data/%.data.txt)
MEAS := $(OUTCOMES:%=data/%.meas.rds)
FIGS = figs/network.pdf figs/quantile-fig.pdf figs/ra-exact.pdf figs/ra-ordinal.pdf figs/ra-ratio.pdf figs/ra-preffree.pdf figs/odds.pdf

all: $(MEAS) $(FIGS)

data: $(MTCDATA)

mtcsamples: $(MTCSAMPLES)

samples: $(MEAS)

.PRECIOUS: $(MTCSAMPLES) $(MEAS)

print-subgroups: $(MEAS)
	R --vanilla --slave < analyses/subgroups.R

data/%.data.txt: code/excel.to.txt.R data/studies-revised.xlsx
	R --vanilla --slave --args $* $@ < code/excel.to.txt.R

data/%.mtc.result.rds: data/%.data.txt code/read.bugs.data.R code/run.mtc.R
	echo "source('code/read.bugs.data.R'); source('code/run.mtc.R'); saveRDS(run.mtc(read.bugs.data('$<')), '$@')" | R --vanilla --slave

data/%.meas.rds: data/%.mtc.result.rds data/%.data.txt analyses/analysis-mtc.R analyses/baseline.jags
	echo "source('analyses/analysis-mtc.R'); write.measurement('$*')" | R --vanilla --slave

figs/absmeas.pdf: $(MTCSAMPLES) $(MEAS) figs/absmeas.tex figs/quantile-abs.R figs/process-absfigs.sh
	R --vanilla --slave < figs/quantile-abs.R
	cd figs; sh process-absfigs.sh
	cd figs; pdflatex absmeas
	cd figs; pdfcrop absmeas.pdf
	cd figs; mv absmeas-crop.pdf absmeas.pdf

figs/odds.pdf: $(MTCSAMPLES) $(MEAS) figs/odds.tex figs/odds.R figs/process-odds.sh
	R --vanilla --slave < figs/odds.R
	cd figs; sh process-odds.sh
	cd figs; pdflatex odds
	cd figs; pdfcrop odds.pdf
	cd figs; mv odds-crop.pdf odds.pdf

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

