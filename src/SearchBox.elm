module SearchBox exposing (searchBox)

import Css exposing (..)
import Html.Styled as H exposing (Attribute, Html, styled, text)
import Html.Styled.Attributes exposing (css, id, placeholder, type_)
import Html.Styled.Events exposing (onInput, onSubmit)
import Icons
import String exposing (isEmpty)


type alias Model msg =
    { value : String
    , id : String
    , onSearch : msg
    , onChange : String -> msg
    }


searchBox : Model msg -> H.Html msg
searchBox model =
    let
        labelVisible = isEmpty model.value
    in
    form
        [ onSubmit model.onSearch ]
        [ input
            [ onInput model.onChange
            , id model.id
            ]
            [ text model.value ]
        , button [] [ Icons.magnifyingGlass colors.text ]
        , label labelVisible [] [ text "Search Wikipedia" ]
        ]


form =
    styled H.form
        [ displayFlex
        , alignItems stretch
        , backgroundColor colors.primary
        , color colors.text
        , padding (em 1)
        , fontSize (px 32)
        , lineHeight (int 2)
        , position relative
        , overflow hidden
        ]


label : Bool -> List (Attribute msg) -> List (Html msg) -> Html msg
label show =
    let
        style =
            if show then
                labelBaseStyle

            else
                labelBaseStyle ++ [ top (em -2) ]
    in
    styled H.label style


labelBaseStyle =
    [ position absolute
    , fontFamilies [ "Arial" ]
    ]


input =
    styled H.input
        [ flex (int 1)
        , color inherit
        , borderWidth (px 0)
        , backgroundColor transparent
        , fontSize (em 1)
        , lineHeight (em 2)
        , borderBottom3 (px 2) solid colors.text
        , noOutline
        ]


button =
    styled H.button
        [ color inherit
        , displayFlex
        , borderStyle none
        , backgroundColor transparent
        , fontSize (em 1.5)
        , lineHeight (em 2)
        , borderBottom3 (px 2) solid colors.text
        , noOutline
        ]


colors =
    { primary = hex "#089CE8"
    , secondary = hex "#2CA9D2"
    , text = hex "#FBFBFB"
    }

noOutline = focus [ outline none ]
