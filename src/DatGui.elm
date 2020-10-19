module DatGui exposing
    ( gui
    , action, boolean, string, integer, float
    )

{-|


# Main

@docs gui


# Input Types

@docs action, boolean, string, integer, float

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
    , onClick : form -> msg
    , checked : Bool
    }
    -> Element msg
boolean options =
    inputBar
        { color = Config.color.boolean
        , element =
            Input.checkbox [ centerY ]
                { onChange = options.form >> options.onClick
                , checked = options.checked
                , label = Input.labelLeft [] <| label [] options.text
                , icon = Input.defaultCheckbox
                }
        }


{-| -}
string :
    { text : String
    , form : String -> form
    , onChange : form -> msg
    , value : String
    }
    -> Element msg
string options =
    inputBar
        { color = Config.color.string
        , element =
            Input.text
                [ height <| px 20
                , centerY
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


{-| -}
integer :
    { text : String
    , form : Int -> form
    , onChange : form -> msg
    , value : Int
    , min : Int
    , max : Int
    , step : Int
    }
    -> Element msg
integer options =
    float
        { text = options.text
        , form = round >> options.form
        , onChange = options.onChange
        , value = toFloat options.value
        , min = toFloat options.min
        , max = toFloat options.max
        , step = toFloat options.step
        }


{-| -}
float :
    { text : String
    , form : Float -> form
    , onChange : form -> msg
    , value : Float
    , min : Float
    , max : Float
    , step : Float
    }
    -> Element msg
float options =
    let
        slider =
            Input.slider
                [ Background.color Config.color.input
                ]
                { onChange = options.form >> options.onChange
                , value = options.value
                , step = Just <| options.step
                , min = options.min
                , max = options.max
                , thumb = Input.defaultThumb
                , label = Input.labelLeft [ centerY ] <| label [] options.text
                }

        text =
            el
                [ width <| px 38
                , height <| px 20
                , Background.color Config.color.input
                ]
            <|
                label
                    [ Font.color Config.color.number
                    , paddingXY 5 0
                    , centerY
                    ]
                    (String.fromFloat options.value)
    in
    inputBar
        { color = Config.color.number
        , element =
            row
                [ width fill
                , spacing 5
                , centerY
                ]
                [ slider
                , text
                ]
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
            , height fill
            , centerY
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
