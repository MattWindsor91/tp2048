{ 2048 clone in Turbo Pascal: state unit }

unit State;

interface

type
    Points    = Integer;                       { Score points type. }
    GameState = (InProgress, Won, Lost, Quit); { States the game can take. }

procedure InitialiseState;

function CurrentState : GameState;
function GameOver     : Boolean;
procedure WinGame;
procedure LoseGame;
procedure QuitGame;

function CurrentScore : Points;
procedure AddScore(Delta : Points);

implementation

var
    CurrentPoints    : Points;    { The score counter. }
    CurrentGameState : GameState; { The current game state. }

{ Initialises the game state and score counter. }
procedure InitialiseState;
begin
    CurrentPoints    := 0;
    CurrentGameState := InProgress;
end;

{ Returns the current game state. }
function CurrentState : GameState;
begin
  CurrentState := CurrentGameState;
end;

{ Returns True if the game is over. }
function GameOver : Boolean;
begin
    GameOver := CurrentGameState <> InProgress;
end;

{ Marks the game as won. }
procedure WinGame;
begin
    CurrentGameState := Won;
end;

{ Marks the game as lost. }
procedure LoseGame;
begin
    CurrentGameState := Lost;
end;

{ Marks the game as quit. }
procedure QuitGame;
begin
    CurrentGameState := Quit;
end;

{ Returns the current score. }
function CurrentScore : Points;
begin
    CurrentScore := CurrentPoints;
end;

{ Adds to the score. }
procedure AddScore(Delta: Points);
begin
    CurrentPoints := CurrentPoints + Delta;
end;

end.
