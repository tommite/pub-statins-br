OUTCOMES := cerebrovasc ck-elevation coronary discontinuation mortality myalgia transaminase
MTCSAMPLES := $(OUTCOMES:%=data/%.mtc.result.txt)
MTCPRIMARYSAMPLES := $(OUTCOMES:%=data/%.mtc.result.primary.txt)
MTCDATA := $(OUTCOMES:%=data/%.data.txt)
SMAAMEAS := $(OUTCOMES:%=data/%.meas.txt)
FIGS = figs/network.pdf figs/quantile-fig.pdf

all: $(MTCSAMPLES) $(SMAAMEAS) $(FIGS)

primary: $(MTCPRIMARYSAMPLES)

.PRECIOUS: $(MTCSAMPLES) $(MTCPRIMARYSAMPLES)

data/%.mtc.result.txt: data/%.data.txt code/read.bugs.data.R code/run.mtc.R
	echo "source('code/read.bugs.data.R'); source('code/run.mtc.R'); dput(run.mtc(read.bugs.data('$<')), '$@')" | R --vanilla --slave

data/%.mtc.result.primary.txt: data/%.data.txt code/read.bugs.data.R code/run.mtc.R
	echo "source('code/read.bugs.data.R'); source('code/run.mtc.R'); dput(run.mtc(read.bugs.data('$<', 'p')[,1:4]), '$@')" | R --vanilla --slave

data/%.meas.txt: data/%.mtc.result.txt data/%.data.txt analyses/analysis-mtc.R
	echo "source('analyses/analysis-mtc.R'); write.measurement('$*')" | R --vanilla --slave

figs/quantile-fig.pdf: $(MTCSAMPLES) figs/quantile-fig.tex figs/quantile-fig.R figs/process-quantfigs.sh
	R --vanilla --slave < figs/quantile-fig.R
	cd figs; sh process-quantfigs.sh
	cd figs; pdflatex quantile-fig

figs/%.pdf: figs/%.R $(MTCSAMPLES)
	R --vanilla --slave -f $<
