# EnergyPlusWeather

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://trdougherty.github.io/EnergyPlusWeather.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://trdougherty.github.io/EnergyPlusWeather.jl/dev/)
[![Build Status](https://github.com/trdougherty/EnergyPlusWeather.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/trdougherty/EnergyPlusWeather.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/trdougherty/EnergyPlusWeather.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/trdougherty/EnergyPlusWeather.jl)

## Introduction
This package is meant to faciliate the easy use of .epw files (EnergyPlus Weather) outside of the EnergyPlus envirionment for building energy consumption. The documentation used to identify missing values, variable names, and index the rows can be found [here](https://bigladdersoftware.com/epx/docs/8-3/auxiliary-programs/energyplus-weather-file-epw-data-dictionary.html). Below you can find a sample of how this package might be used in practice:

```julia
using EnergyPlusWeather

epw_path = "path/to/sample.epw"
epw_dataframe = EnergyPlusWeather.read(epw_path)
```
