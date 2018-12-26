module WikipediaViewer exposing (Model, Msg(..), init, main, searchBox, subscriptions, update, view)

import Browser
import Browser.Dom as Dom
import Html exposing (Html, a, button, div, form, input, li, p, text, ul)
import Html.Attributes exposing (href, id, style, target, type_)
import Html.Events exposing (onInput, onSubmit)
import Http
import Json.Decode as D
import String.Extra
import Task
import Url.Builder exposing (crossOrigin, int, string)


main =
    Browser.element { init = init, subscriptions = subscriptions, update = update, view = view }


type alias PageData =
    { title : String
    , intro : String
    , id : Int
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
    , focusSearchBox
    )


type Msg
    = ChangeSearchValue String
    | Search
    | GotResults (Result Http.Error (List PageData))
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeSearchValue value ->
            ( { model | searchValue = value }, Cmd.none )

        Search ->
            ( { model | searching = True, results = [] }, fetchResults model.searchValue )

        GotResults results ->
            case results of
                Ok value ->
                    ( { model | searching = False, results = value }, Cmd.none )

                Err _ ->
                    ( { model | searching = False, results = [] }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ p
            [ style "textAlign" "center" ]
            [ a
                [ href getRandomArticleUrl, target "_blank" ]
                [ text "Random article" ]
            ]
        , searchBox
            { value = model.searchValue
            , search = Search
            , change = ChangeSearchValue
            }
        , p
            [ style "textAlign" "center" ]
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


searchBox : { value : String, search : msg, change : String -> msg } -> Html msg
searchBox props =
    form
        [ onSubmit props.search
        , style "textAlign" "center"
        ]
        [ input
            [ onInput props.change
            , id searchBoxId
            ]
            [ text props.value ]
        , button [] [ text "Search" ]
        ]


searchBoxId =
    "search-box"


focusSearchBox =
    Task.attempt (\_ -> NoOp) (Dom.focus searchBoxId)


resultsList : List PageData -> Html Msg
resultsList results =
    ul
        []
        (List.map
            (\pageData ->
                a
                    [ href (getPageUrl pageData)
                    , target "_blank"
                    ]
                    [ li
                        []
                        [ text pageData.title
                        , p [] [ text (String.Extra.stripTags pageData.intro) ]
                        ]
                    ]
            )
            results
        )


fetchResults : String -> Cmd Msg
fetchResults phrase =
    let
        url =
            getWikiUrl
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


searchResultsDecoder : D.Decoder (List PageData)
searchResultsDecoder =
    D.at
        [ "query", "search" ]
        (D.list
            (D.map3 PageData
                (D.field "title" D.string)
                (D.field "snippet" D.string)
                (D.field "pageid" D.int)
            )
        )


getPageUrl : PageData -> String
getPageUrl pageData =
    getWikiUrl
        []
        [ int "curid" pageData.id ]


getWikiUrl =
    crossOrigin "https://en.wikipedia.org"


getRandomArticleUrl =
    getWikiUrl [ "wiki", "Special:Random" ] []
