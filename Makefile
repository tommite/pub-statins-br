OUTCOMES := cerebrovasc ck-elevation coronary discontinuation mortality myalgia transaminase
MTCSAMPLES := $(OUTCOMES:%=%.mtc.result.txt)
MTCDATA := $(OUTCOMES:%=%.data.txt)
SMAAMEAS := $(OUTCOMES:%=%.meas.txt)

all: summaries.pdf mcda.pdf

.PRECIOUS: $(MTCSAMPLES)

%.mtc.result.txt: %.data.txt code/read.bugs.data.R code/run.mtc.R
	echo "source('code/read.bugs.data.R'); source('code/run.mtc.R'); dput(run.mtc(read.bugs.data('$<')), '$@')" | R --vanilla --slave

%.meas.txt: %.mtc.result.txt %.data.txt analysis.R
	echo "source('analysis.R'); write.measurement('$*')" | R --vanilla --slave

summaries.tex: summary.Rnw $(MTCDATA) $(MTCSAMPLES)

mcda.tex: $(SMAAMEAS)

%.tex: %.Rnw
	R CMD Sweave $<

%.pdf: %.tex
	pdflatex $<
