module Model exposing (..)

import Board exposing (createInitialBoard)
import ChessApi
import Http
import Time exposing (Time, second)
import Types exposing (Board, Color, Game, Move, PlayerScore)


-- Model definition for the chess game


type ClickType
    = FirstClick
    | MoveFigure


type Route
    = MainMenu
    | HighscoresMenu
    | GameTypeMenu
    | GameOne
    | GameTwo
    | GameOverMenu
    | GameOverLost


type Msg
    = SquareSelected Int Int ClickType
    | Highscores (Result Http.Error (List PlayerScore))
    | GameOneStart (Result Http.Error String)
    | OnePlayerGame
    | TwoPlayerGame
    | ShowMainMenu
    | ShowGameTypesMenu
    | ShowHighscoresMenu
    | ShowGameOverMenu
    | Tick Time
    | MoveFigurePlayerOne (Result Http.Error String)
    | MoveFigureAi (Result Http.Error Move)
    | PlayerVsAiHelp (Result Http.Error Move)
    | Help
    | QuitGame
    | NameChanged String
    | PostHighscores
    | PostScore (Result Http.Error String)
    | GameOver
    | CheckmateCheck (Result Http.Error String)
    | SendCheckmateCheck


init : ( Model, Cmd Msg )
init =
    ( { selectedSquare = ( -1, -1 )
      , playerColor = Types.White
      , errors = []
      , game = { gameType = Types.NoGame, gameId = "" }
      , board = createInitialBoard
      , highscores = []
      , route = MainMenu
      , currTime = 0
      , startTime = 0
      , score = 0
      , tipCount = 15
      , helpHighlightPos = ( -1, -1 )
      , playersName = ""
      , winner = False
      }
    , getHighscores
    )


type alias Model =
    { selectedSquare : ( Int, Int )
    , playerColor : Color
    , board : Board
    , game : Game
    , highscores : List PlayerScore
    , errors : List Http.Error
    , route : Route
    , currTime : Time
    , startTime : Time
    , score : Int
    , tipCount : Int
    , helpHighlightPos : ( Int, Int )
    , playersName : String
    , winner : Bool
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick


postHighscores name score =
    Http.send PostScore (ChessApi.postScore name score)



-- Returns highscores


getHighscores =
    Http.send Highscores ChessApi.getHighscore



-- Starts a game against a computer


startGameOne =
    Http.send GameOneStart ChessApi.startGameOne



-- Moves a figure for a player in PlayerVsAI


moveFigurePlayerOne game_id from to =
    Http.send MoveFigurePlayerOne (ChessApi.moveFigurePlayerOne game_id from to)



-- Moves a figure for Ai in PlayerVsAi


moveFigureAi game_id =
    Http.send MoveFigureAi (ChessApi.moveFigureAi game_id)



-- Returns a help move suggestion when playing against AI


playerVsAiHelp game_id =
    Http.send PlayerVsAiHelp (ChessApi.playerVsAiHelp game_id)


playervsAiCheckmateCheck game_id =
    Http.send CheckmateCheck (ChessApi.playervsAiCheckmateCheck game_id)
