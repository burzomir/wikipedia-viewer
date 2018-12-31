module SearchBox exposing (searchBox)

import Css exposing (..)
import Css.Transitions
import Html.Styled as H exposing (Attribute, Html, styled, text)
import Html.Styled.Attributes exposing (css, href, id, placeholder, target, type_)
import Html.Styled.Events exposing (onInput, onSubmit)
import Icons
import String exposing (isEmpty)
import Theme exposing (defaultTheme)


type alias Model msg =
    { value : String
    , id : String
    , randomArticleUrl : String
    , onSearch : msg
    , onChange : String -> msg
    }


searchBox : Model msg -> H.Html msg
searchBox model =
    let
        labelVisible =
            isEmpty model.value
    in
    container []
        [ form
            [ onSubmit model.onSearch ]
            [ input
                [ onInput model.onChange
                , id model.id
                ]
                [ text model.value ]
            , button [] [ Icons.magnifyingGlass defaultTheme.colors.text ]
            , label labelVisible [] [ text "Search Wikipedia" ]
            ]
        , randomArticleLink
            [ href model.randomArticleUrl, target "_blank" ]
            [ text "Random article" ]
        ]


container =
    styled H.div
        [ backgroundColor defaultTheme.colors.primary
        , textAlign center
        ]


form =
    styled H.form
        [ displayFlex
        , alignItems stretch
        , color defaultTheme.colors.text
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
    , defaultTheme.fontFamilies
    ]


input =
    styled H.input
        [ flex (int 1)
        , color inherit
        , borderWidth (px 0)
        , backgroundColor transparent
        , fontSize (em 1)
        , lineHeight (em 2)
        , borderBottom3 (px 2) solid defaultTheme.colors.text
        , noOutline
        , highlightFocus
        ]


button =
    styled H.button
        [ color inherit
        , displayFlex
        , borderStyle none
        , backgroundColor transparent
        , fontSize (em 1.5)
        , lineHeight (em 2)
        , borderBottom3 (px 2) solid defaultTheme.colors.text
        , noOutline
        , highlightFocus
        ]


randomArticleLink =
    styled H.a
        [ color defaultTheme.colors.text
        , fontSize (em 1)
        , defaultTheme.fontFamilies
        , margin (em 1)
        , marginBottom (em 2)
        , display inlineBlock
        , textDecoration none
        , highlightFocus
        ]


noOutline =
    focus [ outline none ]


highlightFocus =
    focus
        [ backgroundColor (rgba 255 255 255 0.3)
        , Css.Transitions.transition
            [ Css.Transitions.backgroundColor3 300 0 Css.Transitions.ease
            ]
        ]
