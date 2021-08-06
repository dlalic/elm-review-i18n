# elm-review-i18n

Provides [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) rules to detect hardcoded user facing strings.


## Provided rules

- [`NoMissingTranslations`](https://package.elm-lang.org/packages/dlalic/elm-review-i18n/1.0.0/NoMissingTranslations) - Reports hardcoded user facing strings.


## Configuration

```elm
module ReviewConfig exposing (config)

import NoMissingTranslations
import Review.Rule exposing (Rule)

config : List Rule
config =
    [ NoMissingTranslations.rule
    ]
```

## Fail

```elm
Html.text "Hello!"
```

## Success

```elm
Html.text (hello translations)
```

## When (not) to enable this rule

This rule is useful when finding user facing hardcoded strings that should be localized.

This rule is not useful when there is no i18n.


## Try it out

You can try the example configuration above out by running the following command:

```bash
elm-review --template dlalic/elm-review-i18n/preview
```
