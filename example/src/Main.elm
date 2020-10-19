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
    }


init : Model
init =
    { showControls = True
    , boolean = True
    , text = ""
    }



-- Update


type Form
    = Action
    | Boolean Bool
    | Text String


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
                    , checked = model.boolean
                    , onClick = OnChange
                    }
                , DatGui.string
                    { text = "Text Value"
                    , form = Text
                    , value = model.text
                    , onChange = OnChange
                    }
                ]
            }
