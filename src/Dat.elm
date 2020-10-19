module Dat exposing
    ( gui, focusStyle
    , action, boolean, string, integer, float
    )

{-| `Dat.gui` provides a low footprint way of easily tweaking variables and
settings within your elm project. This project is based off of the
[elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/)
library. The main focus of this library is to provide easy and quick access
to parameters within your application. This package api is different from
the original [dat.GUI](https://github.com/dataarts/dat.gui) application
because of language differences between JavaScript and Elm. However, the same
clean interface is provided.

The way this package works is to think of the gui as a form element with
different parameters within the form. This means that you have to keep
track of all the parameter updating as you would from other forms in the
`update` function.


# Structure

The gui is structured around passing `OnChange` events to the update function
so that you can update your model with new values from the gui. The gui elements
take in a `Form` type with each of the variables you are controlling within
your application. Here, I'm using very generic names for the types so don't
think that you need to stick to my naming conventions. In fact, you should
use something more descriptive to your project.

    type Form
        = Action
        | Boolean Bool
        | Text String
        | Integer Int
        | Floating Float

The gui also needs the messages to be able to change values within your project
as well as toggling the open/close state of the gui window. To change the
values of all the elements in the project, we use a single message `OnChange`
which takes the `Form` object that is being changed. This gives the new
value to change your model.

    type Msg
        = ToggleControls
        | OnChange Form


# Main

@docs gui, focusStyle


# Input Types

These are all the different variable/action types which can be added and changed
from the gui. Each type needs to be added to the main gui view function and
added with a new `Form` handler.

@docs action, boolean, string, integer, float

-}

import Config
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input



-- Main Components


{-| The main view function for the gui. This is the container wrapper for the
whole gui. To add this to your application, you are most likely going to need
to use the [Element.inFront](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element#inFront)
function in order to place this above everything else you are trying to put
into your application. This however, is up to you. In the attributes is
where you would put any location information for the gui.
-}
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


{-| This removes the default focus style for elm-ui. In order to remove the normal
focus you must initialize the app with the following

    Element.layoutWith
        { options = [ Dat.focusStyle ] }
        []   -- Attributes
        none -- Page Body

Note: All this does is set the three attributes for `Element.focusStyle` to
`Nothing`. If you are already using the `Element.layoutWith` function, just
know that the focus styling will also be propagated into Dat.

-}
focusStyle : Option
focusStyle =
    Element.focusStyle
        { borderColor = Nothing
        , backgroundColor = Nothing
        , shadow = Nothing
        }



-- Input Attributes


{-| An element that triggers some sort of event. This is used to send an
event to the `update` function. In this case it sends the `Action` message.

    Dat.action
        { text = "Action Button"
        , form = Action
        , onPress = OnChange
        }

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
                    [ Background.color Config.color.backgroundHover
                    ]
                ]
                { onPress = Just <| options.onPress options.form
                , label = label [] options.text
                }
        }


{-| Input selection for toggling boolean values.

    Dat.boolean
        { text = "Boolean Box"
        , form = Boolean
        , onClick = OnChange
        , checked = model.boolean
        }

-}
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
            Input.checkbox [ height fill ]
                { onChange = options.form >> options.onClick
                , checked = options.checked
                , label =
                    Input.labelLeft [ width fill, centerY ] <|
                        label [] options.text
                , icon = Input.defaultCheckbox
                }
        }


{-| Text area selection for relatively short string values. This provides
generally a several word length box. This is good for changing titles,
names, and the like.

    Dat.string
        { text = "Text Value"
        , form = Text
        , onChange = OnChange
        , value = model.text
        }

-}
string :
    { text : String
    , form : String -> form
    , onChange : form -> msg
    , value : String
    }
    -> Element msg
string options =
    let
        stringLabel =
            label [ width <| fillPortion 1 ] options.text

        inputBox =
            Input.text
                [ width <| fillPortion 2
                , height <| px 20
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
                , label = Input.labelHidden options.text
                }
    in
    inputBar
        { color = Config.color.string
        , element =
            row
                [ width fill
                , centerY
                ]
                [ stringLabel
                , inputBox
                ]
        }


{-| An input slider for changing integer values. The slider step can be changed
to provide more or less precision over the input values between the upper
and lower values.

    Dat.integer
        { text = "Integer"
        , form = Integer
        , onChange = OnChange
        , value = model.integer
        , min = 0
        , max = 100
        , step = 1
        }

-}
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


{-| Similar to the integer slider for selecting a values within a range. This
selection provides a fine granularity over your input range. For this slider,
the step value is much more important. You want to make sure that the step
value is small enough so that the input slider is smooth. However, if you
have some function that updates on every value change, small step precisions
could cause lag when selecting new values.

    Dat.float
        { text = "Float"
        , form = Floating
        , onChange = OnChange
        , value = model.float
        , min = 0
        , max = 10
        , step = 0.1
        }

-}
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
        floatLabel =
            label [ width <| fillPortion 3 ] options.text

        slider =
            Input.slider
                [ width <| fillPortion 4
                , Background.color Config.color.input
                ]
                { onChange = options.form >> options.onChange
                , value = options.value
                , step = Just <| options.step
                , min = options.min
                , max = options.max
                , label = Input.labelHidden options.text
                , thumb =
                    Input.thumb
                        [ width <| px 3
                        , height <| px 20
                        , Background.color Config.color.number
                        ]
                }

        numberValue =
            el
                [ width <| fillPortion 2
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
                [ floatLabel
                , slider
                , numberValue
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
