module Config exposing (color, font)

{-|


# Configuration Information

@docs color, font

-}

import Color.Extra exposing (darken, hexToColor, lighten)
import Element exposing (Attribute, Color, Element)
import Element.Font as Font


{-| -}
color :
    { number : Color
    , boolean : Color
    , string : Color
    , function : Color
    , background : Color
    , saveRow : Color
    , button : Color
    , font : Color
    }
color =
    { font = hexToColor "#eeeeee"
    , number = hexToColor "#2fa1d6"
    , boolean = hexToColor "#806787"
    , string = hexToColor "#1ed36f"
    , function = hexToColor "#e61d5f"
    , background = hexToColor "#1a1a1a"
    , saveRow = hexToColor "#dad5cb"
    , button = hexToColor "#000000"
    }


{-| -}
font : { family : Attribute msg, size : Int }
font =
    { family = Font.family [ Font.typeface "Lucida Grande", Font.sansSerif ]
    , size = 11
    }
