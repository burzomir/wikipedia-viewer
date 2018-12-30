module SearchBox exposing (searchBox)

import Css exposing (..)
import Html.Styled as H exposing (styled, text, Html)
import Html.Styled.Attributes exposing (css, id, type_)
import Html.Styled.Events exposing (onInput, onSubmit)


type alias SearchBoxProps msg =
    { value : String
    , id : String
    , onSearch : msg
    , onChange : String -> msg
    }


searchBox : SearchBoxProps msg -> H.Html msg
searchBox props =
    form
        [ onSubmit props.onSearch ]
        [ input
            [ onInput props.onChange
            , id props.id
            ]
            [ text props.value ]
        , button [] [ text "Search" ]
        ]


form =
    styled H.form
        [ displayFlex
        , alignItems center
        , height (pct 100)
        , fontSize (em 2)
        ]


input =
    styled H.input
        [ flex (int 1) ]


button =
    styled H.button []
