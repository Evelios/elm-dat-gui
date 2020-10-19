module Color.Extra exposing
    ( darken, lighten
    , fromColor, toColor
    , hexToColor
    )

{-|


# Utilities

@docs darken, lighten


# Convertions to/from Hex

@docs colorToHex


# Convertions to/from Color.Color

@docs fromColor, toColor

-}

import Color
import Color.Convert
import Color.Manipulate
import Element


{-| Convert an Element.Color into a Color.Color
-}
toColor : Element.Color -> Color.Color
toColor elementColor =
    let
        cl =
            Element.toRgb elementColor
    in
    Color.rgba cl.red cl.green cl.blue cl.alpha


{-| Convert a Color.Color into an Element.Color
-}
fromColor : Color.Color -> Element.Color
fromColor elementColor =
    let
        cl =
            Color.toRgba elementColor
    in
    Element.rgba cl.red cl.green cl.blue cl.alpha


{-| Increase the lightning of a color
-}
lighten : Float -> Element.Color -> Element.Color
lighten offset elementColor =
    let
        cl =
            toColor elementColor
    in
    fromColor <| Color.Manipulate.lighten offset cl


{-| Decrease the lightning of a color
-}
darken : Float -> Element.Color -> Element.Color
darken offset elementColor =
    let
        cl =
            toColor elementColor
    in
    fromColor <| Color.Manipulate.darken offset cl


{-| Converts a string to a color.
-}
hexToColor : String -> Element.Color
hexToColor string =
    let
        cl =
            Color.Convert.hexToColor string
    in
    fromColor <| Result.withDefault (Color.rgb 0 0 0) cl
