module DatGui exposing
    ( gui
    , action
    )

{-|


# Main

@docs gui


# Input Types

@docs action

-}

import Color.Extra
import Config
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
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
        guiAttributes =
            [ width (shrink |> minimum 246)
            , alignRight
            , moveLeft 15
            ]
                ++ attributes

        guiElements =
            if options.showControls then
                options.elements ++ [ toggleControls ]

            else
                [ toggleControls ]

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
    column guiAttributes guiElements


{-| An element that triggers some sort of event.
-}
action :
    { onPress : msg
    , text : String
    }
    -> Element msg
action options =
    inputBar
        { color = Config.color.function
        , element =
            Input.button
                [ height fill
                , width fill
                , pointer
                , mouseOver
                    [ Background.color <| Color.Extra.darken 0.05 Config.color.background
                    ]
                ]
                { onPress = Just options.onPress
                , label = label [ paddingXY 5 0 ] options.text
                }
        }


inputBar :
    { color : Color
    , element : Element msg
    }
    -> Element msg
inputBar options =
    let
        accent =
            el
                [ width <| px 3
                , height fill
                , Background.color options.color
                ]
                none
    in
    row
        [ width fill
        , height <| px 28
        , Background.color Config.color.background
        , Border.color <| Color.Extra.lighten 0.07 Config.color.background
        , Border.widthEach
            { top = 0
            , bottom = 1
            , left = 0
            , right = 0
            }
        ]
        [ accent
        , options.element
        ]



-- Private


{-| An interface button which is used to break up sections within the gui. This
button isn't used directly by the user.
-}
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
         , Background.color Config.color.button
         ]
            ++ attributes
        )
        { onPress = Just options.onPress
        , label =
            label [ centerX, centerY ] options.text
        }


{-| Text elements within the gui interface.
-}
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
