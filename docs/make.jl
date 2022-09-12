using EnergyPlusWeather
using Documenter

DocMeta.setdocmeta!(EnergyPlusWeather, :DocTestSetup, :(using EnergyPlusWeather); recursive=true)

makedocs(;
    modules=[EnergyPlusWeather],
    authors="Thomas Dougherty",
    repo="https://github.com/trdougherty/EnergyPlusWeather.jl/blob/{commit}{path}#{line}",
    sitename="EnergyPlusWeather.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://trdougherty.github.io/EnergyPlusWeather.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/trdougherty/EnergyPlusWeather.jl",
    devbranch="main",
)
