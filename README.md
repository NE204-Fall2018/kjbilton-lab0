# NE 204 Report Template

## Overview
This repo contains the skeleton of a project for building lab reports from
source using `make` and `pdflatex` (texlive).

For a more fleshed-out example of writing a lab report in LaTeX, see the
`lab_report_example` directory of
[this repo](https://github.com/rossbar/LaTeXIntro.git).

## Usage
### Environment
You must first have conda installed before the environment can be built. To install the environment, run

```
make env
```

This command will create a conda environment named `ne204` (specified in the file environment.yml) with all Python packages required to run the analyses.

### Running the analyses
All code can be ran and figures saved by running
```
make analysis
```
Alternatively, one can run all notebooks individually and explore intermediate results along the way.

### Testing
Modules can be tested from the top-level directory with the command
```
make test
```
This runs all tests within the `test` directory.

## How to use this template
[H/T stack overflow](https://stackoverflow.com/questions/1657017/how-to-squash-all-git-commits-into-one/9254257#9254257)

```bash
# Create a new directory for your report
mkdir my_lab_report && cd $_
# Create an empty repository
git init
# Initialize the repo with the template
git fetch --depth=1 -n https://github.com/kjbilton/lab_report_template.git
git reset --hard $(git commit-tree FETCH_HEAD^{tree} -m "initial commit")
```
