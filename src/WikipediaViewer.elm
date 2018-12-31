
import Browser
import Browser.Dom as Dom
import Css exposing (..)
import Html exposing (Html, a, div, li, p, text, ul)
import Html.Attributes exposing (href, id, style, target, type_)
import Html.Events exposing (onInput, onSubmit)
import Html.Styled exposing (toUnstyled)
import SearchBox exposing (searchBox)
import String.Extra
import Task
import Api


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
    | GotResults Api.PageDataResults
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeSearchValue value ->
            ( { model | searchValue = value }, Cmd.none )

        Search ->
            ( { model | searching = True, results = [] }, Api.fetchResults model.searchValue GotResults )

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
                [ href Api.getRandomArticleUrl, target "_blank" ]
                [ text "Random article" ]
            ]
        , toUnstyled <|
            searchBox
                { value = model.searchValue
                , id = searchBoxId
                , onChange = ChangeSearchValue
                , onSearch = Search
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
                    [ href (Api.getPageUrl pageData)
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

