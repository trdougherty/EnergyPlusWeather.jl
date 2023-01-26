module EnergyPlusWeather
using CSV, DataFrames, Dates, Statistics

_columnnames = [
	"Year",
	"Month",
	"Day",
	"Hour",
	"Minute",
	"Data Source and Uncertainty Flags",
	"Drybulb Temperature (°C)",
	"Dewpoint Temperature (°C)",
	"Relative Humidity (%)",
	"Atmospheric Station Pressure (Pa)",
	"Extraterrestrial Horizontal Radiation (Wh/m²)",
	"Extraterrestrial Direct Normal Radiation (Wh/m²)",
	"Horizontal Infrared Radiation Intensity (Wh/m²)",
	"Global Horizontal Radiation (Wh/m²)",
	"Direct Normal Radiation (Wh/m²)",
	"Diffuse Horizontal Radiation (Wh/m²)",
	"Global Horizontal Illuminance (lux)",
	"Direct Normal Illuminance (lux)",
	"Diffuse Horizontal Illuminance (lux)",
	"Zenith Luminance (Cd/m²)",
	"Wind Direction (deg)",
	"Wind Speed (m/s)",
	"Total Sky Cover",
	"Opaque Sky Cover",
	"Visibility (km)",
	"Ceiling Height (m)",
	"Present Weather Observation",
	"Present Weather Codes",
	"Precipitable Water (mm)",
	"Aerosol Optical Depth (thousandths)",
	"Snow Depth (cm)",
	"Days Since Last Snowfall",
	"Albedo",
	"Liquid Precipitation Depth (mm)",
	"Liquid Precipitation Quantity (hr)"
]

_col_ofinterest = [
	"Drybulb Temperature (°C)",
	"Dewpoint Temperature (°C)",
	"Relative Humidity (%)",
	"Atmospheric Station Pressure (Pa)",
	"Horizontal Infrared Radiation Intensity (Wh/m²)",
	"Direct Normal Radiation (Wh/m²)",
	"Diffuse Horizontal Radiation (Wh/m²)",
	"Wind Direction (deg)",
	"Wind Speed (m/s)",
	"Present Weather Observation",
	"Present Weather Codes",
	"Snow Depth (cm)",
	"Liquid Precipitation Depth (mm)"
]

_missingvalues_map = Dict(
    "Drybulb Temperature (°C)" => (==, 99.9),
    "Dewpoint Temperature (°C)" => (==, 99.9),
    "Relative Humidity (%)" => (==, 99.0),
    "Atmospheric Station Pressure (Pa)" => (==, 999999.0),
    "Extraterrestrial Horizontal Radiation (Wh/m²)" => (==, 9999.0),
    "Extraterrestrial Direct Normal Radiation (Wh/m²)" => (==, 9999.0),
    "Horizontal Infrared Radiation Intensity (Wh/m²)" => (==, 9999.0),
    "Global Horizontal Radiation (Wh/m²)" => (==, 9999.0),
	"Direct Normal Radiation (Wh/m²)" => (==, 9999.0),
	"Global Horizontal Illuminance (lux)" => (>=, 999900.0),
    "Direct Normal Illuminance (lux)" => (>=, 999900.0),
    "Diffuse Horizontal Illuminance (lux)" => (>=, 999900.0),
    "Zenith Luminance (Cd/m²)" => (>=, 9999),
    "Wind Direction (deg)" => (==, 999.0),
    "Wind Speed (m/s)" => (==, 999.0),
    "Total Sky Cover" => (==, 99),
    "Opaque Sky Cover" => (==, 99),
    "Visibility (km)" => (==, 9999),
    "Ceiling Height (m)" => (==, 99999),
    "Precipitable Water (mm)" => (==, 999),
    "Aerosol Optical Depth (thousandths)" => (==, 0.999),
    "Snow Depth (cm)" => (==, 999),
    "Days Since Last Snowfall" => (==, 99),
    "Albedo" => (==, 999.0),
    "Liquid Precipitation Depth (mm)" => (==, 999.0),
    "Liquid Precipitation Quantity (hr)" => (==, 99.0)
)

function _strip_missing!(epw_data::DataFrame)
    for (key, (operator, missing_value)) in _missingvalues_map
        epw_data[!, key] = [ operator(term, missing_value) | isnan(term) ? missing : term for term in epw_data[:, key] ]
    end
end

function read(filename::String; subsetcols=true)::DataFrame
    epw_dataframe::DataFrame = CSV.read(filename, skipto=9, header=_columnnames, DataFrames.DataFrame)
    _strip_missing_epw!(epw_dataframe)

    aggregation_terms = subsetcols ? 
        names(select(epw_dataframe, _col_ofinterest), Union{Missing, Real}) : 
        names(epw_dataframe, Union{Missing, Real})

    epw_average = DataFrames.combine(
        DataFrames.groupby(epw_dataframe, ["Month","Day","Hour"]),
        [aggregation_terms...] .=> mean,
        renamecols=false
    )

    epw_average[!, "Date"] = Dates.DateTime.(
        # Dates.Year.(epw_dataframe.Year),
        Dates.Month.(epw_average.Month),
        Dates.Day.(epw_average.Day),
        Dates.Hour.(epw_dataframe.Hour)
    )
    
    DataFrames.select!(epw_average, Not([:Month, :Day, :Hour]))
end

end