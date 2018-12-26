module WikipediaViewer exposing (Model, Msg(..), init, main, searchBox, subscriptions, update, view)

import Browser
import Html exposing (Html, button, div, form, input, li, text, ul)
import Html.Attributes exposing (style)
import Html.Events exposing (onInput, onSubmit)
import Http
import Json.Decode as D
import Url.Builder exposing (crossOrigin, int, string)


main =
    Browser.element { init = init, subscriptions = subscriptions, update = update, view = view }


type alias PageData =
    { title : String
    }


type alias Query =
    { search : List PageData
    }


type alias SearchResults =
    { query : Query
    }


type alias Model =
    { searchValue : String
    , searching : Bool
    , results : List PageData
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { searchValue = ""
      , searching = False
      , results = []
      }
    , Cmd.none
    )


type Msg
    = ChangeSearchValue String
    | Search
    | GotResults (Result Http.Error SearchResults)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeSearchValue value ->
            ( { model | searchValue = value }, Cmd.none )

        Search ->
            ( { model | searching = True }, fetchResults model.searchValue )

        GotResults results ->
            case results of
                Ok value ->
                    ( { model | searching = False, results = value.query.search }, Cmd.none )

                Err _ ->
                    ( { model | searching = False, results = [] }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ searchBox model.searchValue
        , div []
            [ text
                (if model.searching then
                    "Searching"

                 else
                    ""
                )
            ]
        , resultsList model.results
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


searchBox : String -> Html Msg
searchBox value =
    form
        [ onSubmit Search
        , style "textAlign" "center"
        ]
        [ input [ onInput ChangeSearchValue ] [ text value ]
        , button [] [ text "Search" ]
        ]


resultsList : List PageData -> Html Msg
resultsList results =
    ul
        []
        (List.map
            (\pageData -> li [] [ text pageData.title ])
            results
        )


fetchResults : String -> Cmd Msg
fetchResults phrase =
    let
        url =
            crossOrigin
                "http://en.wikipedia.org"
                [ "w", "api.php" ]
                [ string "action" "query"
                , string "format" "json"
                , string "list" "search"
                , string "origin" "*"
                , string "srsearch" phrase
                ]
    in
    Http.get
        { url = url
        , expect = Http.expectJson GotResults searchResultsDecoder
        }


searchResultsDecoder : D.Decoder SearchResults
searchResultsDecoder =
    D.map
        SearchResults
        (D.field "query"
            (D.map Query
                (D.field "search"
                    (D.list
                        (D.map PageData
                            (D.field "title" D.string)
                        )
                    )
                )
            )
        )
