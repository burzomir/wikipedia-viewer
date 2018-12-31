module Api exposing (PageData, PageDataResults, fetchResults, getPageUrl, getRandomArticleUrl, getWikiUrl, searchResultsDecoder)

import Http
import Json.Decode as D
import Url.Builder exposing (crossOrigin, int, string)


type alias PageData =
    { title : String
    , intro : String
    , id : Int
    }


type alias PageDataResults =
    Result Http.Error (List PageData)


fetchResults : String -> (PageDataResults -> msg) -> Cmd msg
fetchResults phrase onResults =
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
        , expect = Http.expectJson onResults searchResultsDecoder
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
