port module Walkthrough exposing (elmToJS)

import Platform
import VegaLite exposing (..)


stripPlot : Spec
stripPlot =
    toVegaLite
        [ dataFromUrl "https://vega.github.io/vega-lite/data/seattle-weather.csv" []
        , tick []
        , encoding (position X [ PName "temp_max", PmType Quantitative ] [])
        ]


histogram : Spec
histogram =
    let
        enc =
            encoding
                << position X [ PName "temp_max", PmType Quantitative, PBin [] ]
                << position Y [ PAggregate Count, PmType Quantitative ]
    in
    toVegaLite
        [ dataFromUrl "https://vega.github.io/vega-lite/data/seattle-weather.csv" []
        , bar []
        , enc []
        ]


stackedHistogram : Spec
stackedHistogram =
    let
        enc =
            encoding
                << position X [ PName "temp_max", PmType Quantitative, PBin [] ]
                << position Y [ PAggregate Count, PmType Quantitative ]
                << color [ MName "weather", MmType Nominal ]
    in
    toVegaLite
        [ dataFromUrl "https://vega.github.io/vega-lite/data/seattle-weather.csv" []
        , bar []
        , enc []
        ]


weatherColors : List ScaleProperty
weatherColors =
    categoricalDomainMap
        [ ( "sun", "#e7ba52" )
        , ( "fog", "#c7c7c7" )
        , ( "drizzle", "#aec7ea" )
        , ( "rain", "#1f77b4" )
        , ( "snow", "#9467bd" )
        ]


stackedHistogram2 : Spec
stackedHistogram2 =
    let
        enc =
            encoding
                << position X [ PName "temp_max", PmType Quantitative, PBin [] ]
                << position Y [ PAggregate Count, PmType Quantitative ]
                << color [ MName "weather", MmType Nominal, MScale weatherColors ]
    in
    toVegaLite
        [ dataFromUrl "https://vega.github.io/vega-lite/data/seattle-weather.csv" []
        , bar []
        , enc []
        ]


lineChart : Spec
lineChart =
    let
        enc =
            encoding
                << position X [ PName "temp_max", PmType Quantitative, PBin [] ]
                << position Y [ PAggregate Count, PmType Quantitative ]
                << color [ MName "weather", MmType Nominal, MScale weatherColors ]
    in
    toVegaLite
        [ dataFromUrl "https://vega.github.io/vega-lite/data/seattle-weather.csv" []
        , line []
        , enc []
        ]


multiBar : Spec
multiBar =
    let
        enc =
            encoding
                << position X [ PName "temp_max", PmType Quantitative, PBin [] ]
                << position Y [ PAggregate Count, PmType Quantitative ]
                << color [ MName "weather", MmType Nominal, MLegend [], MScale weatherColors ]
                << column [ FName "weather", FmType Nominal ]
    in
    toVegaLite
        [ dataFromUrl "https://vega.github.io/vega-lite/data/seattle-weather.csv" []
        , bar []
        , enc []
        ]


barChart : Spec
barChart =
    let
        enc =
            encoding
                << position X [ PName "date", PmType Ordinal, PTimeUnit Month ]
                << position Y [ PName "precipitation", PmType Quantitative, PAggregate Mean ]
    in
    toVegaLite
        [ dataFromUrl "https://vega.github.io/vega-lite/data/seattle-weather.csv" []
        , bar []
        , enc []
        ]


barChartWithAverage : Spec
barChartWithAverage =
    let
        precipEnc =
            encoding << position Y [ PName "precipitation", PmType Quantitative, PAggregate Mean ]

        barEnc =
            encoding << position X [ PName "date", PmType Ordinal, PTimeUnit Month ]
    in
    toVegaLite
        [ dataFromUrl "https://vega.github.io/vega-lite/data/seattle-weather.csv" []
        , precipEnc []
        , layer [ asSpec [ bar [], barEnc [] ], asSpec [ rule [] ] ]
        ]


barChartPair : Spec
barChartPair =
    let
        bar1Enc =
            encoding
                << position X [ PName "date", PmType Ordinal, PTimeUnit Month ]
                << position Y [ PName "precipitation", PmType Quantitative, PAggregate Mean ]

        bar2Enc =
            encoding
                << position X [ PName "date", PmType Ordinal, PTimeUnit Month ]
                << position Y [ PName "temp_max", PmType Quantitative, PAggregate Mean ]
    in
    toVegaLite
        [ dataFromUrl "https://vega.github.io/vega-lite/data/seattle-weather.csv" []
        , vConcat [ asSpec [ bar [], bar1Enc [] ], asSpec [ bar [], bar2Enc [] ] ]
        ]


barChartTriplet : Spec
barChartTriplet =
    let
        enc =
            encoding
                << position X [ PName "date", PmType Ordinal, PTimeUnit Month ]
                << position Y [ PRepeat Row, PmType Quantitative, PAggregate Mean ]

        spec =
            asSpec
                [ dataFromUrl "https://vega.github.io/vega-lite/data/seattle-weather.csv" []
                , bar []
                , enc []
                ]
    in
    toVegaLite
        [ repeat [ RowFields [ "precipitation", "temp_max", "wind" ] ]
        , specification spec
        ]


splom : Spec
splom =
    let
        enc =
            encoding
                << position X [ PRepeat Column, PmType Quantitative ]
                << position Y [ PRepeat Row, PmType Quantitative ]

        spec =
            asSpec
                [ dataFromUrl "https://vega.github.io/vega-lite/data/seattle-weather.csv" []
                , point []
                , enc []
                ]
    in
    toVegaLite
        [ repeat
            [ RowFields [ "temp_max", "precipitation", "wind" ]
            , ColumnFields [ "wind", "precipitation", "temp_max" ]
            ]
        , specification spec
        ]


dashboard1 : Spec
dashboard1 =
    let
        histoEnc =
            encoding
                << position X [ PName "temp_max", PmType Quantitative, PBin [] ]
                << position Y [ PAggregate Count, PmType Quantitative ]

        histoSpec =
            asSpec [ title "Frequency histogram", bar [], histoEnc [] ]

        scatterEnc =
            encoding
                << position X [ PName "temp_max", PmType Quantitative ]
                << position Y [ PName "precipitation", PmType Quantitative ]

        scatterSpec =
            asSpec [ title "Scatterplot", point [], scatterEnc [] ]

        barEnc =
            encoding
                << position X [ PName "date", PmType Ordinal, PTimeUnit Month ]
                << position Y [ PName "precipitation", PmType Quantitative, PAggregate Mean ]

        barSpec =
            asSpec [ title "Bar chart", bar [], barEnc [] ]

        annotationEnc =
            encoding
                << position Y [ PName "precipitation", PmType Quantitative, PAggregate Mean, PScale [ SDomain (DNumbers [ 0, 5.5 ]) ] ]

        annotationSpec =
            asSpec [ title "Annotation", width 200, rule [], annotationEnc [] ]
    in
    toVegaLite
        [ dataFromUrl "https://vega.github.io/vega-lite/data/seattle-weather.csv" []
        , hConcat [ histoSpec, scatterSpec, barSpec, annotationSpec ]
        ]


dashboard2 : Spec
dashboard2 =
    let
        histoEnc =
            encoding
                << position X [ PName "temp_max", PmType Quantitative, PBin [] ]
                << position Y [ PAggregate Count, PmType Quantitative ]
                << color [ MName "weather", MmType Nominal, MLegend [], MScale weatherColors ]
                << column [ FName "weather", FmType Nominal ]

        histoSpec =
            asSpec [ bar [], histoEnc [] ]

        scatterEnc =
            encoding
                << position X [ PRepeat Column, PmType Quantitative ]
                << position Y [ PRepeat Row, PmType Quantitative ]

        scatterSpec =
            asSpec [ point [], scatterEnc [] ]

        barEnc =
            encoding
                << position X [ PName "date", PmType Ordinal, PTimeUnit Month ]
                << position Y [ PRepeat Row, PmType Quantitative, PAggregate Mean ]

        annotationEnc =
            encoding
                << position Y [ PRepeat Row, PmType Quantitative, PAggregate Mean ]

        layerSpec =
            asSpec
                [ layer
                    [ asSpec [ bar [], barEnc [] ]
                    , asSpec [ rule [], annotationEnc [] ]
                    ]
                ]

        barsSpec =
            asSpec
                [ repeat [ RowFields [ "precipitation", "temp_max", "wind" ] ]
                , specification layerSpec
                ]

        splomSpec =
            asSpec
                [ repeat
                    [ RowFields [ "temp_max", "precipitation", "wind" ]
                    , ColumnFields [ "wind", "precipitation", "temp_max" ]
                    ]
                , specification scatterSpec
                ]
    in
    toVegaLite
        [ --  dataFromUrl "https://vega.github.io/vega-lite/data/newYork-weather.csv" []
          dataFromUrl "https://vega.github.io/vega-lite/data/seattle-weather.csv" []
        , vConcat
            [ asSpec [ hConcat [ splomSpec, barsSpec ] ]
            , histoSpec
            ]
        ]


scatterProps : List ( VLProperty, Spec )
scatterProps =
    let
        trans =
            -- This rounds the year-month-day format to just year for later selection.
            transform
                << calculateAs "year(datum.Year)" "Year"

        enc =
            encoding
                << position X [ PName "Horsepower", PmType Quantitative ]
                << position Y [ PName "Miles_per_Gallon", PmType Quantitative ]
                << color
                    [ MSelectionCondition (SelectionName "picked")
                        [ MName "Origin", MmType Nominal ]
                        [ MString "grey" ]
                    ]
    in
    [ dataFromUrl "https://vega.github.io/vega-lite/data/cars.json" []
    , trans []
    , circle []
    , enc []
    ]


interactiveScatter1 : Spec
interactiveScatter1 =
    let
        sel =
            selection
                << select "picked" Single []
    in
    toVegaLite <| sel [] :: scatterProps


interactiveScatter2 : Spec
interactiveScatter2 =
    let
        sel =
            selection
                << select "picked" Multi []
    in
    toVegaLite <| sel [] :: scatterProps


interactiveScatter3 : Spec
interactiveScatter3 =
    let
        sel =
            selection
                << select "picked" Multi [ On "mouseover" ]
    in
    toVegaLite <| sel [] :: scatterProps


interactiveScatter4 : Spec
interactiveScatter4 =
    let
        sel =
            selection
                << select "picked" Single [ Empty, Fields [ "Cylinders" ] ]
    in
    toVegaLite <| sel [] :: scatterProps


interactiveScatter5 : Spec
interactiveScatter5 =
    let
        sel =
            selection
                << select "picked"
                    Single
                    [ Fields [ "Cylinders" ]
                    , Bind [ IRange "Cylinders" [ InMin 3, InMax 8, InStep 1 ] ]
                    ]
    in
    toVegaLite <| sel [] :: scatterProps


interactiveScatter6 : Spec
interactiveScatter6 =
    let
        sel =
            selection
                << select "picked"
                    Single
                    [ Fields [ "Cylinders", "Year" ]
                    , Bind
                        [ IRange "Cylinders" [ InMin 3, InMax 8, InStep 1 ]
                        , IRange "Year" [ InMin 1969, InMax 1981, InStep 1 ]
                        ]
                    ]
    in
    toVegaLite <| sel [] :: scatterProps


interactiveScatter7 : Spec
interactiveScatter7 =
    let
        sel =
            selection
                << select "picked" Interval []
    in
    toVegaLite <| sel [] :: scatterProps


interactiveScatter8 : Spec
interactiveScatter8 =
    let
        sel =
            selection
                << select "picked" Interval [ Encodings [ ChX ] ]
    in
    toVegaLite <| sel [] :: scatterProps


interactiveScatter9 : Spec
interactiveScatter9 =
    let
        sel =
            selection
                << select "picked" Interval [ Encodings [ ChX ], BindScales ]
    in
    toVegaLite <| sel [] :: scatterProps


coordinatedScatter1 : Spec
coordinatedScatter1 =
    let
        enc =
            encoding
                << position X [ PRepeat Column, PmType Quantitative ]
                << position Y [ PRepeat Row, PmType Quantitative ]
                << color
                    [ MSelectionCondition (SelectionName "picked")
                        [ MName "Origin", MmType Nominal ]
                        [ MString "grey" ]
                    ]

        sel =
            selection
                << select "picked" Interval [ Encodings [ ChX ] ]

        spec =
            asSpec
                [ dataFromUrl "https://vega.github.io/vega-lite/data/cars.json" []
                , circle []
                , enc []
                , sel []
                ]
    in
    toVegaLite
        [ repeat
            [ RowFields [ "Displacement", "Miles_per_Gallon" ]
            , ColumnFields [ "Horsepower", "Miles_per_Gallon" ]
            ]
        , specification spec
        ]


coordinatedScatter2 : Spec
coordinatedScatter2 =
    let
        enc =
            encoding
                << position X [ PRepeat Column, PmType Quantitative ]
                << position Y [ PRepeat Row, PmType Quantitative ]
                << color [ MName "Origin", MmType Nominal ]

        sel =
            selection
                << select "picked" Interval [ BindScales ]

        spec =
            asSpec
                [ dataFromUrl "https://vega.github.io/vega-lite/data/cars.json" []
                , circle []
                , enc []
                , sel []
                ]
    in
    toVegaLite
        [ repeat
            [ RowFields [ "Displacement", "Miles_per_Gallon" ]
            , ColumnFields [ "Horsepower", "Miles_per_Gallon" ]
            ]
        , specification spec
        ]


contextAndFocus : Spec
contextAndFocus =
    let
        sel =
            selection << select "brush" Interval [ Encodings [ ChX ] ]

        encContext =
            encoding
                << position X [ PName "date", PmType Temporal, PAxis [ AxFormat "%Y" ] ]
                << position Y
                    [ PName "price"
                    , PmType Quantitative
                    , PAxis [ AxTickCount 3, AxGrid False ]
                    ]

        specContext =
            asSpec [ width 400, height 80, sel [], area [], encContext [] ]

        encDetail =
            encoding
                << position X
                    [ PName "date"
                    , PmType Temporal
                    , PScale [ SDomain (DSelection "brush") ]
                    , PAxis [ AxTitle "" ]
                    ]
                << position Y [ PName "price", PmType Quantitative ]

        specDetail =
            asSpec [ width 400, area [], encDetail [] ]
    in
    toVegaLite
        [ dataFromUrl "https://vega.github.io/vega-lite/data/sp500.csv" []
        , vConcat [ specContext, specDetail ]
        ]


crossFilter : Spec
crossFilter =
    let
        hourTrans =
            -- This generates a new field based on the hour of day extracted from the date field.
            transform
                << calculateAs "hours(datum.date)" "hour"

        sel =
            selection << select "brush" Interval [ Encodings [ ChX ] ]

        filterTrans =
            transform
                << filter (FSelection "brush")

        totalEnc =
            encoding
                << position X [ PRepeat Column, PmType Quantitative ]
                << position Y [ PAggregate Count, PmType Quantitative ]

        selectedEnc =
            encoding
                << position X [ PRepeat Column, PmType Quantitative ]
                << position Y [ PAggregate Count, PmType Quantitative ]
                << color [ MString "goldenrod" ]
    in
    toVegaLite
        [ repeat [ ColumnFields [ "hour", "delay", "distance" ] ]
        , specification <|
            asSpec
                [ dataFromUrl "https://vega.github.io/vega-lite/data/flights-2k.json"
                    [ Parse [ ( "date", FoDate "%Y/%m/%d %H:%M" ) ] ]
                , hourTrans []
                , layer
                    [ asSpec [ bar [], totalEnc [] ]
                    , asSpec [ sel [], filterTrans [], bar [], selectedEnc [] ]
                    ]
                ]
        ]



{- This list comprises tuples of the label for each embedded visualization and
   corresponding Vega-Lite specification.
-}


mySpecs : Spec
mySpecs =
    combineSpecs
        [ ( "singleView1", stripPlot )
        , ( "singleView2", histogram )
        , ( "singleView3", stackedHistogram )
        , ( "singleView4", stackedHistogram2 )
        , ( "singleView5", lineChart )
        , ( "multiView1", multiBar )
        , ( "multiView2", barChart )
        , ( "multiView3", barChartWithAverage )
        , ( "multiView4", barChartPair )
        , ( "multiView5", barChartTriplet )
        , ( "multiView6", splom )
        , ( "dashboard1", dashboard1 )
        , ( "dashboard2", dashboard2 )
        , ( "interactive1", interactiveScatter1 )
        , ( "interactive2", interactiveScatter2 )
        , ( "interactive3", interactiveScatter3 )
        , ( "interactive4", interactiveScatter4 )
        , ( "interactive5", interactiveScatter5 )
        , ( "interactive6", interactiveScatter6 )
        , ( "interactive7", interactiveScatter7 )
        , ( "interactive8", interactiveScatter8 )
        , ( "interactive9", interactiveScatter9 )
        , ( "coordinated1", coordinatedScatter1 )
        , ( "coordinated2", coordinatedScatter2 )
        , ( "coordinated3", contextAndFocus )
        , ( "crossFilter1", crossFilter )
        ]



{- The code below is boilerplate for creating a headless Elm module that opens
   an outgoing port to Javascript and sends the specs to it.
-}


main : Program Never Spec msg
main =
    Platform.program
        { init = ( mySpecs, elmToJS mySpecs )
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = always Sub.none
        }


port elmToJS : Spec -> Cmd msg
