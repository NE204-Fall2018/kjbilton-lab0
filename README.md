[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/NE204-Spring2018/kjbilton-lab0/master)

# NE 204 Lab 0

## Overview
In this analysis, we perform an HPGe energy calibration using spectroscopic data from a number of gamma-ray sources.

## Usage
### Environment
You must first have conda installed before the environment can be built. To install the environment, run

```
make env
```

This command will create a conda environment named `ne204lab0` (specified in the file environment.yml) with all Python packages required to run the analyses. This environment can be activated using

```
source activate ne204lab0
```

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
