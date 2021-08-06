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


## Try it out

You can try the example configuration above out by running the following command:

```bash
elm-review --template dlalic/elm-review-i18n/preview
```
