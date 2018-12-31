module Theme exposing (Colors, Theme, defaultTheme, defaultColors)

import Css exposing (..)


type alias Theme =
    { colors : Colors
    , fontFamilies : Style
    }


defaultTheme : Theme
defaultTheme =
    { colors = defaultColors
    , fontFamilies = fontFamilies [ "Arial" ]
    }


defaultColors : Colors
defaultColors =
    { primary = hex "#089CE8"
    , text = hex "#FBFBFB"
    }


type alias Colors =
    { primary : Color
    , text : Color
    }
