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
    }


init : Model
init =
    { showControls = True
    , boolean = True
    }



-- Update


type Form
    = Action
    | Boolean Bool


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
                ]
            }
