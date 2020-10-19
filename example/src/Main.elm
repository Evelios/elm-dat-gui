module Main exposing (..)

import Browser
import DatGui
import Element
import Html exposing (Html)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- Init


type alias Model =
    { showControls : Bool
    , boolean : Bool
    , text : String
    , integer : Int
    , float : Float
    }


init : Model
init =
    { showControls = True
    , boolean = True
    , text = ""
    , integer = 0
    , float = 0
    }



-- Update


type Form
    = Action
    | Boolean Bool
    | Text String
    | Integer Int
    | Floating Float


type Msg
    = ToggleControls
    | OnChange Form


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleControls ->
            { model | showControls = not model.showControls }

        OnChange form ->
            case form of
                Action ->
                    model

                Boolean value ->
                    { model | boolean = value }

                Text value ->
                    { model | text = value }

                Integer value ->
                    { model | integer = value }

                Floating value ->
                    { model | float = value }



-- View


view : Model -> Html Msg
view model =
    Element.layout [] <|
        DatGui.gui []
            { toggleControls = ToggleControls
            , showControls = model.showControls
            , elements =
                [ DatGui.action
                    { text = "Action Button"
                    , form = Action
                    , onPress = OnChange
                    }
                , DatGui.boolean
                    { text = "Boolean Box"
                    , form = Boolean
                    , onClick = OnChange
                    , checked = model.boolean
                    }
                , DatGui.string
                    { text = "Text Value"
                    , form = Text
                    , onChange = OnChange
                    , value = model.text
                    }
                , DatGui.integer
                    { text = "Integer"
                    , form = Integer
                    , onChange = OnChange
                    , value = model.integer
                    , min = 0
                    , max = 100
                    , step = 1
                    }
                , DatGui.float
                    { text = "Float"
                    , form = Floating
                    , onChange = OnChange
                    , value = model.float
                    , min = 0
                    , max = 10
                    , step = 0.1
                    }
                ]
            }
