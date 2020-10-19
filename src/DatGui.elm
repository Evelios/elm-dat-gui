module DatGui exposing
    ( gui
    , action, boolean, string
    )

{-|


# Main

@docs gui


# Input Types

@docs action, boolean, string

-}

import Config
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input



-- Main Components


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



-- Input Attributes


{-| An element that triggers some sort of event.
-}
action :
    { text : String
    , form : form
    , onPress : form -> msg
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
                    [ Background.color Config.color.border
                    ]
                ]
                { onPress = Just <| options.onPress options.form
                , label = label [] options.text
                }
        }


{-| -}
boolean :
    { text : String
    , form : Bool -> form
    , checked : Bool
    , onClick : form -> msg
    }
    -> Element msg
boolean options =
    inputBar
        { color = Config.color.boolean
        , element =
            Input.checkbox []
                { onChange = options.form >> options.onClick
                , checked = options.checked
                , label = Input.labelLeft [] <| label [] options.text
                , icon = Input.defaultCheckbox
                }
        }


string :
    { text : String
    , form : String -> form
    , value : String
    , onChange : form -> msg
    }
    -> Element msg
string options =
    inputBar
        { color = Config.color.string
        , element =
            Input.text
                [ height <| px 20
                , Background.color Config.color.input
                , Config.font.family
                , Font.size Config.font.size
                , Font.color Config.color.string
                , Border.width 0
                , Border.rounded 0
                , paddingXY 5 4
                ]
                { onChange = options.form >> options.onChange
                , text = options.value
                , placeholder = Nothing
                , label = Input.labelLeft [ centerY ] <| label [] options.text
                }
        }



-- Private


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
        , Border.color Config.color.border
        , Border.widthEach
            { top = 0
            , bottom = 1
            , left = 0
            , right = 0
            }
        ]
        [ accent
        , el
            [ width fill
            , paddingXY 5 0
            ]
            options.element
        ]


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
label attributes value =
    el
        ([ Font.color Config.color.font
         , Config.font.family
         , Font.size Config.font.size
         ]
            ++ attributes
        )
        (text value)
