# Set up variables specific to this analysis
LABNUMBER=0
manuscript = report

# LaTeX
latexopt = -file-line-error -halt-on-error

# Build the PDF of the lab report from the source files
$(manuscript).pdf: $(manuscript).tex text/*.tex references.bib fig/*.eps
	pdflatex $(latexopt) $(manuscript).tex
	bibtex $(manuscript).aux
	bibtex $(manuscript).aux
	pdflatex $(latexopt) $(manuscript).tex
	pdflatex $(latexopt) $(manuscript).tex


## env		: Create a conda environment required for the analysis
CONDA_REQUIREMENTS=environment.yml
CONDA_ROOT=$(shell conda info -s | grep CONDA_ROOT | cut -f2 -d ' ')
ENV=$(shell head -n 1 $(CONDA_REQUIREMENTS) | cut -f2 -d ' ')
env : $(CONDA_REQUIREMENTS)
	@echo "Installing conda environment '$(ENV)'."
	@if [ -d "$(CONDA_ROOT)/envs/$(ENV)" ]; then \
		echo "\nConda environment '$(ENV)' exists. Reinstalling now."; \
		conda env remove -n $(ENV); \
	fi
	conda env create -f $(CONDA_REQUIREMENTS)

## data		: Download necessary data
LOCDATADIR=data
FILEROOT=$(LOCDATADIR)/lab$(LABNUMBER)_spectral_data
data :
	@echo "Downloading data..."
	if [ ! -d 'data' ]; then mkdir data; fi
	wget https://www.dropbox.com/s/hutmwip3681xlup/lab0_spectral_data.txt?dl=0 -O $(FILEROOT).txt
	wget https://www.dropbox.com/s/amumdrm9zp1kn8d/lab0_spectral_data.md5?dl=0 -O $(FILEROOT).md5

## ieee		: Download IEEE TeX class
ieee :
	@echo "Downloading IEEETran.cls..."
	wget http://mirrors.ctan.org/macros/latex/contrib/IEEEtran/IEEEtran.cls

## validate	: Validate that downloaded data is not corrupted
validate :
	@echo "\nValidating data...\n"
	@python scripts/validate.py

## test		: Run tests on analysis code
test :
	pytest

## analysis	: Automate running the analysis code
NOTEBOOKDIR=notebooks/
NOTEBOOKS=$(wildcard $(NOTEBOOKDIR)*.ipynb)
NBS=$(patsubst $(NOTEBOOKDIR)%.ipynb, %nb, $(NOTEBOOKS))
analysis : $(NBS)

# Run a notebook
TIMEOUT=600
.PHONY : %nb
%nb: $(NOTEBOOKDIR)%.ipynb
	jupyter nbconvert \
		--ExecutePreprocessor.timeout=$(TIMEOUT) \
		--ExecutePreprocessor.kernel_name=python3 \
		--to notebook \
		--execute $< \
		--output $(patsubst $(NOTEBOOKDIR)%.ipynb, %.ipynb, $<)

## uninstall	: Uninstall the conda environment
uninstall :
	conda env remove -n $(ENV) -y

clean :
	rm -f *.aux *.log *.bbl *.lof *.lot *.blg *.out *.toc *.run.xml *.bcf
	rm -f text/*.aux
	rm $(manuscript).pdf

help : Makefile
	@sed -n 's/^##//p' $<

# Make keyword for commands that don't have dependencies
.PHONY : env test data validate analysis uninstall clean help ieee
