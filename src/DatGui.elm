module DatGui exposing (gui)

{-|


# Main

@docs gui

-}

import Config
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input


{-| -}
gui :
    List (Attribute msg)
    ->
        { toggleControls : msg
        , showControls : Bool
        , elements : List (Element msg)
        }
    -> Element msg
gui attributes options =
    let
        toggleControls =
            sectionButton []
                { onPress = options.toggleControls
                , text =
                    if options.showControls then
                        "Close Controls"

                    else
                        "Open Controls"
                }
    in
    column
        ([ width (shrink |> minimum 246)
         , alignRight
         , moveLeft 15
         ]
            ++ attributes
        )
        (options.elements ++ [ toggleControls ])


sectionButton :
    List (Attribute msg)
    ->
        { onPress : msg
        , text : String
        }
    -> Element msg
sectionButton attributes options =
    Input.button
        ([ width fill
         , height <| px 20
         , Background.color Config.color.background
         ]
            ++ attributes
        )
        { onPress = Just options.onPress
        , label =
            label [ centerX, centerY ] options.text
        }


label : List (Attribute msg) -> String -> Element msg
label attributes string =
    el
        ([ Font.color Config.color.font
         , Config.font.family
         , Font.size Config.font.size
         ]
            ++ attributes
        )
        (text string)
