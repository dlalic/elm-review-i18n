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
import Html exposing (h1, h2, text)
import I18Next

view : I18Next.Translations -> String -> Html msg
view translations name =
    [ h1 [] [ text (hello translations name) ]
    , h2 [] [ text "This text is hardcoded" ]
    ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Found hardcoded user facing text: This text is hardcoded"
                            , details = [ "" ]
                            , under = "text \"This text is hardcoded\""
                            }
                        ]
        , test "should not report an error text is not from Html module" <|
            \() ->
                """module NoMissingTranslations exposing (..)
import Foo exposing (text)

foo : Html msg
foo =
    text ""
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectNoErrors
        ]
