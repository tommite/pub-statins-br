OUTCOMES := cerebrovasc ck-elevation coronary myalgia transaminase
MTCSAMPLES := $(OUTCOMES:%=data/%.mtc.result.txt)
MTCDATA := $(OUTCOMES:%=data/%.data.txt)
MEAS := $(OUTCOMES:%=data/%.p.meas.txt) $(OUTCOMES:%=data/%.s.meas.txt) $(OUTCOMES:%=data/%.m.meas.txt) $(OUTCOMES:%=data/%.p.s.m.meas.txt)
FIGS = figs/network.pdf figs/quantile-fig.pdf

all: $(MTCSAMPLES) $(MEAS) $(FIGS)

samples: $(MEAS)

.PRECIOUS: $(MTCSAMPLES) $(MEAS)

print-subgroups: $(MEAS)
	R --vanilla --slave < analyses/subgroups.R

data/%.mtc.result.txt: data/%.data.txt code/read.bugs.data.R code/run.mtc.R
	echo "source('code/read.bugs.data.R'); source('code/run.mtc.R'); dput(run.mtc(read.bugs.data('$<')), '$@')" | R --vanilla --slave

data/%.p.meas.txt: data/%.mtc.result.txt data/%.data.txt analyses/analysis-mtc.R
	echo "source('analyses/analysis-mtc.R'); write.measurement('$*', 'p')" | R --vanilla --slave

data/%.s.meas.txt: data/%.mtc.result.txt data/%.data.txt analyses/analysis-mtc.R
	echo "source('analyses/analysis-mtc.R'); write.measurement('$*', 's')" | R --vanilla --slave

data/%.m.meas.txt: data/%.mtc.result.txt data/%.data.txt analyses/analysis-mtc.R
	echo "source('analyses/analysis-mtc.R'); write.measurement('$*', 'm')" | R --vanilla --slave

data/%.p.s.m.meas.txt: data/%.mtc.result.txt data/%.data.txt analyses/analysis-mtc.R
	echo "source('analyses/analysis-mtc.R'); write.measurement('$*', c('p', 's', 'm'))" | R --vanilla --slave


figs/quantile-fig.pdf: $(MTCSAMPLES) figs/quantile-fig.tex figs/quantile-fig.R figs/process-quantfigs.sh
	R --vanilla --slave < figs/quantile-fig.R
	cd figs; sh process-quantfigs.sh
	cd figs; pdflatex quantile-fig

figs/%.pdf: figs/%.R $(MTCSAMPLES) analyses/analysis-base.R
	R --vanilla --slave -f $<
