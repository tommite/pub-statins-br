all: paper.rtf

.PHONY: paper.rtf

ref.bib: ../bib/journal-short.bib ../bib/medical.bib ../bib/others.bib
	cat $^ > $@

paper.rtf: paper.md ref.bib
	pandoc $< -s -o $@
