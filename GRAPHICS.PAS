{ 2048 clone in Turbo Pascal: graphics unit }

unit Graphics;

interface

procedure PrepareStatusLine;
procedure FinishGraphicsOperation;

procedure InitialiseGraphics;
procedure CleanupGraphics;

procedure DrawGrid;

implementation

uses Crt, Grid, Stages;

type
    { Screen co-ordinates, measured in characters.
      Change ScreenW/ScreenH if you change these. }
    ScreenX = 1..80; { Screen X co-ordinate. 1 is the leftmost row. }
    ScreenY = 1..25; { Screen Y co-ordinate. 1 is the topmost column. }

const
    { Change ScreenX/ScreenY if you change these. }
    ScreenW : ScreenX = 80; { Screen width, in characters. }
    ScreenH : ScreenY = 25; { Screen height, in characters. }

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

    { Screen mode.  Change ScreenW/H/X/Y if you change this. }
    ScreenMode : Byte = CO80;


{ Changes to the status line colour scheme. }
procedure StatusColours;
begin
    TextColor(StatusFG);
    TextBackground(StatusBG);
end;

{ Prepares for a status message. }
procedure PrepareStatusLine;
begin
    Window(1, StatusY, ScreenW, StatusY);
    StatusColours;
    ClrScr;
end;

{ Resets the window to cover the entire screen. }
procedure ResetWindow;
begin
    Window(1, 1, ScreenW, ScreenH);
end;

{ Parks the cursor in an inoffensive location. }
procedure ParkCursor;
begin
    GotoXY(1, 1);
end;

{ Cleans up after drawing some graphics. }
procedure FinishGraphicsOperation;
begin
    ResetWindow;
    ParkCursor;
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

{ Draw a tile at position (X, Y) on the grid.
  This changes the current window, but does not change it back.
  Use FinishGraphicsOperation afterwards to do so. }
procedure DrawTile(X: GridX; Y: GridY; S: Stage);
begin
    TileWindow(X, Y);

    UseStageColour(S);
    ClrScr;
    DrawTileFrame;
    DrawTileLabel(S);
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

    FinishGraphicsOperation;
end;

{ Initialises the (lack of) graphics. }
procedure InitialiseGraphics;
begin
    TextMode(ScreenMode);
    TextBackground(ScreenBG);
    ClrScr;
    DrawGrid;
    CursorOff;
end;

{ Cleans up the (lack of) graphics. }
procedure CleanupGraphics;
begin
    ResetWindow;
    NormVideo;
    ClrScr;
end;

end.
