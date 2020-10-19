module Main exposing (..)

import Browser
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
    ()


init : Model
init =
    ()



-- Update


type Msg
    = None


update : Msg -> Model -> Model
update msg model =
    case msg of
        None ->
            model



-- View


view : Model -> Html msg
view _ =
    Html.div [] []
