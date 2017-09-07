port module Main exposing (..)

import Platform
import WebSocket
import Json.Decode exposing (..)


port log : String -> Cmd msg


urlFromFlags : Flags -> Maybe String
urlFromFlags flags =
    flags
        |> .args
        |> List.head


init : Flags -> ( Model, Cmd msg )
init flags =
    let
        url =
            urlFromFlags flags

        logMessage =
            url
                |> Maybe.map ((++) "Listening to ")
                |> Maybe.withDefault "Url needs to be provided as argument."
    in
        Model url ! [ log logMessage ]


subscriptions : Model -> Sub Msg
subscriptions model =
    model
        |> .url
        |> Maybe.map (flip WebSocket.listen SocketData)
        |> Maybe.withDefault Sub.none


main : Program Flags Model Msg
main =
    Platform.programWithFlags
        { init = init
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { url : Maybe String }


type alias Flags =
    { args : List String }



-- UPDATE


type Msg
    = SocketData String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SocketData data ->
            model ! [ log data ]
