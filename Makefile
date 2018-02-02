# Set up variables specific to this analysis
LABNUMBER=0
manuscript = report

# LaTeX
latexopt = -file-line-error -halt-on-error

# Build the PDF of the lab report from the source files
$(manuscript).pdf: $(manuscript).tex text/*.tex references.bib fig/*.png
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

## data		: Get/download necessary data
LOCDATADIR=data
FILEROOT=$(LOCDATADIR)/lab$(LABNUMBER)_spectral_data
data :
	@echo "Downloading data..."
	if [ ! -d 'data' ]; then mkdir data; fi
	wget https://www.dropbox.com/s/k692avun0144n90/lab0_spectral_data.txt?dl=0 -O $(FILEROOT).txt
	wget https://www.dropbox.com/s/6jquiryg6jskii0/lab0_spectral_data.md5?dl=0 -O $(FILEROOT).md5

## validate	: Validate that downloaded data is not corrupted
OS=$(shell uname)
# Determine the OS, since md5 utilies vary
ifeq ($(OS),Darwin)
	MD5=md5 -r
else
	MD5=md5sum -c
endif
validate :
	#@$(eval MD5HASH_CALC=$(shell $(MD5) $(FILEROOT).txt | cut -f1 -d ' '))
	#@$(eval MD5HASH_GIVEN=$(shell head -n 1 $(FILEROOT).md5 | cut -f1 -d ' '))
	#@echo "\nValidating checksum...\n"
	@echo "\nValidation is currently broken...\n"
	#cd data/
	#$(MD5) lab0_spectral_data.md5
	#@if [ "$MD5HASH_GIVEN" = "$MD5HASH_GIVEN" ]; then \
		#echo "The given MD5 checksum matches the calculated MD5 hash\n";\
	#else \
		#echo "Oh no! The data has been corrupted.";\
	#fi


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
	rm scripts/*.pyc

help : Makefile
	@sed -n 's/^##//p' $<

# Make keyword for commands that don't have dependencies
.PHONY : env test data validate analysis uninstall clean help
