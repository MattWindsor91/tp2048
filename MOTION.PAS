{ 2048 clone in Turbo Pascal: motion unit }

unit Motion;
interface

uses Grid;

function MoveUp    : Boolean;
function MoveLeft  : Boolean;
function MoveRight : Boolean;
function MoveDown  : Boolean;

function CanMergeTile(X: GridX; Y: GridY; DX: Integer; DY: Integer) : Boolean;

implementation

uses Stages, State;

{ Checks to see if a move will place a tile out of bounds. }
function InBounds(X: GridX; Y: GridY; DX: Integer; DY: Integer) : Boolean;
var
    InXBounds : Boolean;
    InYBounds : Boolean;
begin
    InXBounds := (X + DX) in [1.. GridWidth];
    InYBounds := (Y + DY) in [1..GridHeight];
    InBounds  := InXBounds and InYBounds;
end;

{ Checks a possible tile move to see if it is valid. }
function CanMoveTile(X: GridX; Y: GridY; DX: Integer; DY: Integer) : Boolean;
begin
    CanMoveTile := False;
    if InBounds(X, Y, DX, DY) and HasTileAt(X, Y) then
    begin
        CanMoveTile := not (HasTileAt(X + DX, Y + DY));
    end;
end;

{ Checks a possible tile merge to see if it is valid. }
function CanMergeTile(X: GridX; Y: GridY; DX: Integer; DY: Integer) : Boolean;
var
    DestX: GridX;
    DestY: GridY;
begin
    CanMergeTile := False;
    if InBounds(X, Y, DX, DY) and (HasTileAt(X, Y)) then
    begin
        DestX := X + DX;
        DestY := Y + DY;

        CanMergeTile := TileUnlocked(DestX, DestY)
                        and TilesEqual(X, Y, DestX, DestY)
    end;
end;

{ Moves the tile (X, Y) to an empty space DX rightwards and DY down, replacing
  the original tile with T.
  The move must have already been checked for validity. }
procedure MoveAndReplaceTile(X: GridX; Y: GridY; DX, DY: Integer; T: Stage);
begin
    PlaceTile(X + DX, Y + DY, T);
    PlaceTile(X, Y, 0);
end;

{ Moves the tile (X, Y) to an empty space DX rightwards and DY down.
  The move must have already been checked for validity. }
procedure MoveTile(X: GridX; Y: GridY; DX, DY: Integer);
begin
    MoveAndReplaceTile(X, Y, DX, DY, TileAt(X, Y));
end;

{ Merges the tile (X, Y) with an identical tile DX rightwards and DY down.
  The move must have already been checked for validity.
  As this can cause the game to be won, we check for that here.
}
procedure MergeTile(X: GridX; Y: GridY; DX, DY: Integer);
var
    NewStage : Stage;
begin
    NewStage := Succ(TileAt(X, Y));

    if NewStage = LastStage then WinGame;

    AddScore(StageSpecs[NewStage].Score);

    MoveAndReplaceTile(X, Y, DX, DY, NewStage);
    LockTile(X + DX, Y + DY);
end;

{ Moves the tile in the given direction until it can move no longer.
  Returns True if the tile is not empty and has moved successfully. }
function MoveAcross(X: GridX; Y: GridY; DX: Integer; DY: Integer) : Boolean;
var
    TX : Integer;
    TY : Integer;
begin
    TX := X;
    TY := Y;
    MoveAcross := False;

    while CanMoveTile(TX, TY, DX, DY) do
    begin
        MoveTile(TX, TY, DX, DY);
        TX := TX + DX;
        TY := TY + DY;
        MoveAcross := True;
    end;
    if CanMergeTile(TX, TY, DX, DY) then
    begin
        MergeTile(TX, TY, DX, DY);
        MoveAcross := True;
    end;
end;

{
- Grid movement
}

{ Moves the grid up and returns True if the move succeeded. }
function MoveUp : Boolean;
var
    X: GridX;
    Y: GridY;
begin
    MoveUp := False;

    for X := 1 to GridWidth do
    begin
        for Y := 2 to GridHeight do
        begin
            if MoveAcross(X, Y, 0, -1) then MoveUp := True;
        end;
    end;
end;

{ Moves the grid left and returns True if the move succeeded. }
function MoveLeft : Boolean;
var
    X: GridX;
    Y: GridY;
begin
    MoveLeft := False;

    for Y := 1 to GridHeight do
    begin
        for X := 2 to GridWidth do
        begin
            if MoveAcross(X, Y, -1, 0) then MoveLeft := True;
        end;
    end;
end;

{ Moves the grid right. }
function MoveRight : Boolean;
var
    X: GridX;
    Y: GridY;
begin
    MoveRight := False;

    for Y := 1 to GridHeight do
    begin
        for X := GridWidth - 1 downto 1 do
        begin
            if MoveAcross(X, Y, 1, 0) then MoveRight := True;
        end;
    end;
end;

{ Moves the grid down. }
function MoveDown : Boolean;
var
    X: GridX;
    Y: GridY;
begin
    MoveDown := False;

    for X := 1 to GridWidth do
    begin
        for Y := GridHeight - 1 downto 1 do
        begin
            if MoveAcross(X, Y, 0, 1) then MoveDown := True;
        end;
    end;
end;

end.
