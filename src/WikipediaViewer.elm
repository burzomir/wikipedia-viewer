import Browser
import Html exposing (Html, div, text, form, input, button)
import Html.Events exposing (onSubmit, onInput)
import Html.Attributes exposing (style)

main =
  Browser.sandbox { init = init, update = update, view = view }


type alias Model =
  { searchValue: String
  , searching: Bool
  }


init : Model
init = 
  { searchValue = ""
  , searching = False
  }


type Msg 
  = ChangeSearchValue String
  | Search


update : Msg -> Model -> Model
update msg model =
  case msg of

    ChangeSearchValue value -> 
      { model | searchValue = value}

    Search ->
      { model | searching = True}


view : Model -> Html Msg
view model =
  div []
  [ searchBox model.searchValue 
  , div [] [ text (if model.searching then "Searching" else "") ]
  ]


searchBox: String -> Html Msg
searchBox value =
  form 
    [ onSubmit Search
    , style "textAlign" "center" 
    ]
    [ input [ onInput ChangeSearchValue ] [ text value ]
    , button [] [ text "Search" ]
    ]
  