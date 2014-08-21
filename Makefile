OUTCOMES := cerebrovasc ck-elevation coronary discontinuation mortality myalgia transaminase
MTCSAMPLES := $(OUTCOMES:%=data/%.mtc.result.txt)
MTCDATA := $(OUTCOMES:%=data/%.data.txt)
SMAAMEAS := $(OUTCOMES:%=data/%.meas.txt)
FIGS = figs/network.pdf

all: $(MTCSAMPLES) $(SMAAMEAS) $(FIGS)

.PRECIOUS: $(MTCSAMPLES)

data/%.mtc.result.txt: data/%.data.txt code/read.bugs.data.R code/run.mtc.R
	echo "source('code/read.bugs.data.R'); source('code/run.mtc.R'); dput(run.mtc(read.bugs.data('$<')), '$@')" | R --vanilla --slave

data/%.meas.txt: data/%.mtc.result.txt data/%.data.txt analyses/analysis-mtc.R
	echo "source('analyses/analysis-mtc.R'); write.measurement('$*')" | R --vanilla --slave

figs/%.pdf: $(MTCSAMPLES) figs/%.R
	R --vanilla --slave -f $<
