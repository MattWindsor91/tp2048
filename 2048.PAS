{ 2048 clone in Turbo Pascal.
- Licenced under the MIT licence.
}
program TP2048;
uses AddTile, Crt, Grid, Keymap, Motion, Stages, State;

{
- Types
}

type
    { Screen co-ordinates, measured in characters. }
    ScreenX = 1..80; { Screen X co-ordinate. 1 is the leftmost row. }
    ScreenY = 1..25; { Screen Y co-ordinate. 1 is the topmost column. }

{
- Constants
}

const
    { Status messages to display when the game ends, for each final state. }
    GameOverMessages : array[GameState] of String
    = ( { InProgress } 'BUG: Game ended while still in progress!'
      , { Won        } 'Congraturation! You have played a great game.'
      , { Lost       } 'Game over, man, game over.'
      , { Quit       } 'Be seeing you...'
      );

    {
    - Graphics
    }

    { Screen (border) colour. }
    ScreenBG : Byte = Blue;

    { Status bar colours. }
    StatusFG : Byte = Black;
    StatusBG : Byte = LightGray;

    { Grid position and size. These are purely visual. }
    GridStartX     : ScreenX = 21; { Centres with tilewidth 10, screen 80. }
    GridStartY     : ScreenY = 1;
    GridTileWidth  : ScreenX = 10;
    GridTileHeight : ScreenY = 6;

    { Co-ordinates for tile labels, measured from the top-left of the tile. }
    TileLabelX : ScreenX = 2;
    TileLabelY : ScreenY = 2;

    { Position of the status line.  This should not overlap the grid. }
    StatusY : ScreenY = 25;

    { Screen mode.  Change ScreenX and ScreenY if you change this. }
    ScreenMode : Byte = CO80;

{
- Graphics Routines
}

{ Resets the window to cover the entire screen. }
procedure ResetWindow;
begin
    Window(1, 1, 80, 25);
end;

{ Parks the cursor in an inoffensive location. }
procedure ParkCursor;
begin
    GotoXY(1, StatusY);
end;

{ Converts from a grid X co-ordinate to a screen X co-ordinate.
  Specifically, this returns the X co-ordinate of the LEFT of the grid tile. }
function ScreenXOfGridX(X: GridX) : ScreenX;
begin
    ScreenXOfGridX := GridStartX + ((X - 1) * GridTileWidth);
end;

{ Converts from a grid Y co-ordinate to a screen Y co-ordinate.
  Specifically, this returns the Y co-ordinate of the TOP of the grid tile. }
function ScreenYOfGridY(Y: GridY) : ScreenY;
begin
    ScreenYOfGridY := GridStartY + ((Y - 1) * GridTileHeight);
end;

{ Changes the current text colours to those of the given stage. }
procedure UseStageColour(S: Stage);
begin
    TextColor(StageSpecs[S].Foreground);
    TextBackground(StageSpecs[S].Background);
end;

{ Puts a string at a given (X, Y) co-ordinate. }
procedure PutXY(X: ScreenX; Y: ScreenY; Data: String);
begin
    GotoXY(X, Y);
    Write(Data);
end;

{ Changes the current window's boundaries by the given deltas. }
procedure ResizeWindow(DLeft, DTop, DRight, DBottom: Integer);
var
    Left, Top, Right, Bottom: Integer;
begin
    Left   := WindMinX + DLeft;
    Top    := WindMinY + DTop;
    Right  := WindMaxX + DRight;
    Bottom := WindMaxY + DBottom;

    Window(Left, Top, Right, Bottom);
end;

{ Draws the four corners of a tile. }
procedure DrawTileCorners;
begin
    { Trying to PutXY at the bottom-right corner causes scrolling, so we
      briefly enlarge the window. }
    ResizeWindow(0, 0, 1, 1);

    WriteLn(WindMinX, WindMinY, WindMaxX, WindMaxY);

    PutXY(            1,              1, '+');
    PutXY(            1, GridTileHeight, '+');
    PutXY(GridTileWidth,              1, '+');
    PutXY(GridTileWidth, GridTileHeight, '+');

    ResizeWindow(0, 0, -1, -1);
end;

{ Draws a horizontal edge of a tile. }
procedure DrawTileHorizontalEdge(Y: ScreenY);
var
    X: ScreenY;
begin
    for X := 2 to GridTileWidth - 1 do PutXY(X, Y, '-');
end;

{ Draws a vertical edge of a tile. }
procedure DrawTileVerticalEdge(X: ScreenX);
var
    Y: ScreenY;
begin
    for Y := 2 to GridTileHeight - 1 do PutXY(X, Y, '|');
end;

{ Draw a tile's frame (corners and edges). }
procedure DrawTileFrame;
begin
    DrawTileCorners;
    DrawTileVerticalEdge(1);
    DrawTileVerticalEdge(GridTileWidth);
    DrawTileHorizontalEdge(1);
    DrawTileHorizontalEdge(GridTileHeight);
end;

{ Draw a label for a tile starting at the given screen X and Y. }
procedure DrawTileLabel(S: Stage);
begin
    GotoXY(TileLabelX, TileLabelY);
    Write(StageSpecs[S].Name);
end;

{ Sets the current window to point to a tile at grid location (X, Y). }
procedure TileWindow(X: GridX; Y: GridY);
var
    Left, Right: ScreenX;
    Top, Bottom: ScreenY;
begin
    Left   := ScreenXOfGridX(X);
    Right  := Left + GridTileWidth - 1;

    Top    := ScreenYOfGridY(Y);
    Bottom := Top + GridTileHeight - 1;

    Window(Left, Top, Right, Bottom);
end;

{ Draw a tile at position (X, Y) on the grid. }
procedure DrawTile(X: GridX; Y: GridY; S: Stage);
begin
    TileWindow(X, Y);

    UseStageColour(S);
    ClrScr;
    DrawTileFrame;
    DrawTileLabel(S);

    ResetWindow;
    ParkCursor;
end;

{ Draw the current grid. }
procedure DrawGrid;
var
    X: GridX;
    Y: GridY;
begin
    for X := 1 to GridWidth do
    begin
        for Y := 1 to GridHeight do DrawTile(X, Y, TileAt(X, Y));
    end;
end;

{ Changes to the status line colour scheme. }
procedure StatusColours;
begin
    TextColor(StatusFG);
    TextBackground(StatusBG);
end;

{ Draw a status line message. }
procedure StatusMessage(Message: String);
begin
    GotoXY(1, StatusY);
    StatusColours;
    ClrEOL;
    Write('Score: ', CurrentScore, '. ', Message);
    ParkCursor;
end;

{ Initialises the (lack of) graphics. }
procedure InitialiseGraphics;
begin
    TextMode(ScreenMode);
    TextBackground(ScreenBG);
    ClrScr;
    DrawGrid;
    ParkCursor;
end;

{ Cleans up the (lack of) graphics. }
procedure CleanupGraphics;
begin
    ResetWindow;
    NormVideo;
    ClrScr;
end;

{
- Score
}

{ Announces the score via the status line. }
procedure AnnounceScore;
begin
    StatusMessage('');
end;


{
- Main logic
}

{ Handles a keypress. }
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

    StatusMessage('This is a fake/derivative and not the original 2048.');
end;

{ Displays a game over message and waits to end the game. }
procedure PostGame;
begin
    StatusMessage(GameOverMessages[CurrentState]);
    ReadKey;

    CleanupGraphics;
end;

{ And now, the main procedure. }
begin
    Initialise;
    Loop;
    PostGame;
end.
