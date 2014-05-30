{ 2048 clone in Turbo Pascal: add-tile unit }

unit AddTile;

interface

procedure AddRandomTile;
procedure AddInitialTiles;

implementation

uses Grid, Stages;

const
    { Number of tiles to place initially. Must be between 1 and GridX*GridY. }
    NumInitialTiles : Integer = 2;

{ Place a random tile with the given stage. }
procedure PlaceRandom(S: Stage);
var
    X: GridX;
    Y: GridY;
    Placed: Boolean;
begin
    Placed := False;

    while (Placed = False) do
    begin
        X := Random(GridWidth) + 1;
        Y := Random(GridHeight) + 1;
        if not HasTileAt(X, Y) then
        begin
            Placed := True;
            PlaceTile(X, Y, S);
        end;
    end;
end;

{ Choose a weighted random tile stage. }
function RandomStage: Stage;
var
    RandomPercent : Percentage;
    Cumulative    : Percentage;
    ChosenStage   : Stage;
begin
    Cumulative    := 0;
    ChosenStage   := 0;
    RandomPercent := Random(100) + 1;

    while (Cumulative < RandomPercent) do
    begin
        Cumulative  := Cumulative + StageSpecs[ChosenStage].PlacePercentage;
        ChosenStage := ChosenStage + 1;
    end;

    RandomStage := ChosenStage - 1;
end;

{ Introduces a new tile into the game.
  As this may cause the game to be lost, we check for that here too. }
procedure AddRandomTile;
begin
    PlaceRandom(RandomStage);
end;

{ Adds the initial set of tiles. }
procedure AddInitialTiles;
var
    I: Integer;
begin
    for I := 1 to NumInitialTiles do AddRandomTile;
end;

end.
