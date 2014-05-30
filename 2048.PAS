{ 2048 clone in Turbo Pascal.
- Licenced under the MIT licence.
}
program TP2048;
uses AddTile, Graphics, Grid, Keymap, Messages, Motion, Stages, State;

{ Waits for, and handles, a keypress. }
function HandleKey : Boolean;
var
    Moved : Boolean;
begin
    Moved := False;

    case GetKey of
        QuitKey  : QuitGame;
        UpKey    : Moved := MoveUp;
        LeftKey  : Moved := MoveLeft;
        RightKey : Moved := MoveRight;
        DownKey  : Moved := MoveDown;
    end;

    HandleKey := Moved and not GameOver
end;

{ Checks to see if any moves are possible on the board. }
function OutOfMoves : Boolean;
var
    X: GridX;
    Y: GridY;
begin
    OutOfMoves := True;

    for X := 1 to GridWidth do
    begin
        for Y := 1 to GridHeight do
        begin
            if CanMergeTile(X, Y, 1, 0) then OutOfMoves := False;
            if CanMergeTile(X, Y, 0, 1) then OutOfMoves := False;
            if not HasTileAt(X, Y)      then OutOfMoves := False;
        end;
    end;
end;

{ Checks to see if the game has been lost.
  If it is, the game state is changed accordingly. }
procedure CheckGameLost;
begin
    if OutOfMoves then LoseGame;
end;

{ A step of the main loop. }
procedure LoopStep;
var
    Stepped : Boolean;
begin
    DrawGrid;

    Stepped := HandleKey;
    if Stepped then
    begin
        AddRandomTile;
        CheckGameLost;
    end;

    UnlockTiles;
    AnnounceScore;
end;

{ The main game loop. }
procedure Loop;
begin
    repeat LoopStep until GameOver;
end;

{ Initialises the game state. }
procedure Initialise;
begin
    Randomize;
    ZeroGrid;
    AddInitialTiles;

    InitialiseKeyMaps;
    InitialiseState;
    InitialiseGraphics;

    SayHi;
end;

{ Displays a game over message and waits to end the game. }
procedure PostGame;
begin
    SayBye;
    PauseUntilKey;

    CleanupGraphics;
end;

{ And now, the main procedure. }
begin
    Initialise;
    Loop;
    PostGame;
end.
