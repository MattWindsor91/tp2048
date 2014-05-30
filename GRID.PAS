{ 2048 clone in Turbo Pascal: grid unit }

unit Grid;
interface

uses Stages;

type
    { Grid co-ordinates, measured in tiles.
      If you change these, change GridWidth and GridHeight too. }
    GridX = 1..4; { Grid X co-ordinate. 1 is the leftmost row. }
    GridY = 1..4; { Grid Y co-ordinate. 1 is the topmost column. }

const
    { Grid width and height, in tiles.
      If you change these, change GridX and GridY too. }
    GridWidth  : GridX = 4;
    GridHeight : GridY = 4;

function TileAt      (X: GridX; Y: GridY)                         : Stage;
function HasTileAt   (X: GridX; Y: GridY)                         : Boolean;
function TilesEqual  (X1: GridX; Y1: GridY; X2: GridX; Y2: GridY) : Boolean;
function TileUnlocked(X: GridX; Y: GridY)                         : Boolean;

procedure PlaceTile  (X: GridX; Y: GridY; S: Stage);
procedure LockTile   (X: GridX; Y: GridY);
procedure UnlockTile (X: GridX; Y: GridY);
procedure UnlockTiles;
procedure ZeroGrid;

implementation

type
    Lock  = (Unlocked, Locked); { Possible lock states of a tile. }

    StageGrid = array [GridX, GridY] of Stage; { Stage matrix. }
    LockGrid  = array [GridX, GridY] of Lock;  { Lock matrix. }

var
    Tiles : StageGrid; { The board representation. }
    Locks : LockGrid;  { The locking status of each tile on the grid. }

{ Gets the tile at (X, Y). }
function TileAt(X: GridX; Y: GridY) : Stage;
begin
    TileAt := Tiles[X, Y];
end;

{ Is there a tile at (X, Y)? }
function HasTileAt(X: GridX; Y: GridY) : Boolean;
begin
    HasTileAt := Tiles[X, Y] <> 0;
end;

{ Checks to see if two tiles on the grid are equal. }
function TilesEqual(X1: GridX; Y1: GridY; X2: GridX; Y2: GridY) : Boolean;
begin
    TilesEqual := Tiles[X1, Y1] = Tiles[X2, Y2];
end;

{ Checks to see if a tile on the grid is unlocked (can be merged). }
function TileUnlocked(X: GridX; Y: GridY) : Boolean;
begin
    TileUnlocked := Locks[X, Y] = Unlocked;
end;

{ Place a tile on the grid with the given co-ordinates and stage. }
procedure PlaceTile(X: GridX; Y: GridY; S: Stage);
begin
    Tiles[X, Y] := S;
end;

{ Locks a tile. }
procedure LockTile(X: GridX; Y: GridY);
begin
    Locks[X, Y] := Locked;
end;

{ Unlocks a tile. }
procedure UnlockTile(X: GridX; Y: GridY);
begin
    Locks[X, Y] := Unlocked;
end;

{ Unlocks all tiles. }
procedure UnlockTiles;
var
    X: GridX;
    Y: GridY;
begin
    for X := 1 to GridWidth do for Y := 1 to GridHeight do UnlockTile(X, Y);
end;

{ Clear the grid. }
procedure ZeroGrid;
var
    X: GridX;
    Y: GridY;
begin
    for X := 1 to GridWidth do for Y:= 1 to GridHeight do Tiles[X, Y] := 0;
end;

end.
