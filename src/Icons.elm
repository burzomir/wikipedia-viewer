module Icons exposing (magnifyingGlass)

import Css exposing (Color, fill, em, width)
import Svg.Styled exposing (Svg, path, styled, svg)
import Svg.Styled.Attributes exposing (css, d, viewBox)


magnifyingGlassDefinition =
    "M 9 3 C 5.676 3 3 5.676 3 9 C 3 12.324 5.676 15 9 15 C 10.4812 15 11.8306 14.4653 12.875 13.582 L 18.293 19 L 19 18.293 L 13.582 12.875 C 14.4653 11.8306 15 10.4812 15 9 C 15 5.676 12.324 3 9 3 Z M 9 4 C 11.77 4 14 6.23 14 9 C 14 11.77 11.77 14 9 14 C 6.23 14 4 11.77 4 9 C 4 6.23 6.23 4 9 4 Z"


magnifyingGlass =
    icon magnifyingGlassDefinition


icon : String -> Color -> Svg msg
icon definition color =
    svg
        [ viewBox "0 0 22 22"
        , css
            [ width (em 1) ]
        ]
        [ path
            [ d definition
            , css [ fill color ]
            ]
            []
        ]
