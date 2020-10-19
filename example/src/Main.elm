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
    }


init : Model
init =
    { showControls = True
    }



-- Update


type Msg
    = ToggleControls


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleControls ->
            { model | showControls = not model.showControls }



-- View


view : Model -> Html Msg
view model =
    Element.layout [] <|
        DatGui.gui []
            { toggleControls = ToggleControls
            , showControls = model.showControls
            , elements = []
            }
