module NoMissingTranslations exposing (rule)

{-|

@docs rule

-}

import Elm.Syntax.Exposing as Exposing
import Elm.Syntax.Expression as Expression exposing (Expression)
import Elm.Syntax.Import exposing (Import)
import Elm.Syntax.ModuleName exposing (ModuleName)
import Elm.Syntax.Node as Node exposing (Node)
import Review.Rule as Rule exposing (Error, Rule)


type Context
    = NoImport
    | Import { aliasing : Maybe ModuleName, exposed : Bool }


{-| Reports... REPLACEME

    config =
        [ NoMissingTranslations.rule
        ]


## Fail

    a =
        "REPLACEME example to replace"


## Success

    a =
        "REPLACEME example to replace"


## When (not) to enable this rule

This rule is useful when REPLACEME.
This rule is not useful when REPLACEME.


## Try it out

You can try this rule out by running the following command:

```bash
elm-review --template dlalic/elm-review-i18n/example --rules NoMissingTranslations
```

-}
rule : Rule
rule =
    Rule.newModuleRuleSchema "NoMissingTranslations" NoImport
        |> Rule.withImportVisitor importVisitor
        |> Rule.withExpressionVisitor expressionVisitor
        |> Rule.fromModuleRuleSchema


importVisitor : Node Import -> Context -> ( List (Error {}), Context )
importVisitor node context =
    case Node.value node |> .moduleName |> Node.value of
        [ "Html" ] ->
            ( []
            , let
                exposed =
                    Node.value node
                        |> .exposingList
                        |> Maybe.map (Node.value >> Exposing.exposesFunction "text")
                        |> Maybe.withDefault False

                aliasing =
                    Node.value node |> .moduleAlias |> Maybe.map Node.value
              in
              Import { aliasing = aliasing, exposed = exposed }
            )

        _ ->
            ( [], context )


expressionVisitor : Node Expression -> Rule.Direction -> Context -> ( List (Error {}), Context )
expressionVisitor expression direction context =
    case ( direction, context ) of
        ( Rule.OnEnter, Import { aliasing, exposed } ) ->
            case Node.value expression of
                Expression.Application [ function, argument ] ->
                    case ( Node.value function, Node.value argument ) of
                        ( Expression.FunctionOrValue [] "text", Expression.Literal str ) ->
                            if exposed then
                                ( [ Rule.error (error str) (Node.range expression) ], context )

                            else
                                ( [], context )

                        ( Expression.FunctionOrValue moduleName "text", Expression.Literal str ) ->
                            if moduleName == (aliasing |> Maybe.withDefault [ "Html" ]) then
                                ( [ Rule.error (error str) (Node.range expression) ], context )

                            else
                                ( [], context )

                        _ ->
                            ( [], context )

                _ ->
                    ( [], context )

        _ ->
            ( [], context )


error : String -> { message : String, details : List String }
error text =
    { message = "Found hardcoded user facing text: " ++ text
    , details = [ "Localize it with elm-i18next-gen" ]
    }
