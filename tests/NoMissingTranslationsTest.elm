module NoMissingTranslationsTest exposing (all)

import NoMissingTranslations exposing (rule)
import Review.Test
import Test exposing (Test, describe, test)


all : Test
all =
    describe "NoMissingTranslations"
        [ test "should report an error when Html.text is hardcoded" <|
            \() ->
                """module NoMissingTranslations exposing (..)
import Html exposing (Html, h1, text)

view : View msg
view =
    [ h1 [] [ text (hello translations name) ]
    , h2 [] [ text "This text is user facing" ]
    ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Found hardcoded user facing text: This text is user facing"
                            , details = [ "Localize it with elm-i18next-gen" ]
                            , under = "text \"This text is user facing\""
                            }
                        ]
        , test "should not report an error text is not from Html module" <|
            \() ->
                """module NoMissingTranslations exposing (..)
import Foo exposing (text)

init : Cmd msg
init =
    text ""
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectNoErrors
        ]
