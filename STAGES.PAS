{ 2048 clone in Turbo Pascal: stages unit }

unit Stages;
interface

uses Crt;

type
    Stage = 0..11; { Tile stage; 0 is the absence of a tile. }

    { Percentage weighting, used for deciding which tile to select. }
    Percentage = 0..100;

    { Specifiers of tile 'stages' (the various values of tiles).
      This includes the name to use when labeling tiles, the score value of
      the tile, the percentage probability it will be chosen when adding a
      tile (all of these must sum to 100!), and the foreground and background
      colours. }
    StageSpec = record
        Name            : String;
        Score           : Integer;
        PlacePercentage : Percentage;
        Foreground      : Byte;
        Background      : Byte;
    end;

const
    { If at least one tile of this stage is placed, the game is won. }
    LastStage : Stage = 11 { 2048 };

    { The stages available.  If adding or removing, change Stage and EndStage
      too.  The first stage is special as it represents an empty tile. }
    StageSpecs: array[Stage] of StageSpec
    = ( ( Name            : ''
        ; Score           : 0
        ; PlacePercentage : 0
        ; Foreground      : Black
        ; Background      : Blue
        )
      , ( Name            : '2'
        ; Score           : 2
        ; PlacePercentage : 80
        ; Foreground      : Black
        ; Background      : LightGray
        )
      , ( Name            : '4'
        ; Score           : 4
        ; PlacePercentage : 20
        ; Foreground      : Black
        ; Background      : Cyan
        )
      , ( Name            : '8'
        ; Score           : 8
        ; PlacePercentage : 0
        ; Foreground      : DarkGray
        ; Background      : Cyan
        )
      , ( Name            : '16'
        ; Score           : 16
        ; PlacePercentage : 0
        ; Foreground      : DarkGray
        ; Background      : Green
        )
      , ( Name            : '32'
        ; Score           : 32
        ; PlacePercentage : 0
        ; Foreground      : DarkGray
        ; Background      : Red
        )
      , ( Name            : '64'
        ; Score           : 64
        ; PlacePercentage : 0
        ; Foreground      : LightGray
        ; Background      : Red
        )
      , ( Name            : '128'
        ; Score           : 128
        ; PlacePercentage : 0
        ; Foreground      : LightGray
        ; Background      : Magenta
        )
      , ( Name            : '256'
        ; Score           : 256
        ; PlacePercentage : 0
        ; Foreground      : LightCyan
        ; Background      : Magenta
        )
      , ( Name            : '512'
        ; Score           : 512
        ; PlacePercentage : 0
        ; Foreground      : Yellow
        ; Background      : Magenta
        )
      , ( Name            : '1024'
        ; Score           : 1024
        ; PlacePercentage : 0
        ; Foreground      : White
        ; Background      : Magenta
        )
      , ( Name            : '2048'
        ; Score           : 2048
        ; PlacePercentage : 0
        ; Foreground      : White
        ; Background      : Black
        )
      );

implementation

end.
