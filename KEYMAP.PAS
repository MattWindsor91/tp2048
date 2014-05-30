{ 2048 clone in Turbo Pascal: keymap unit }

unit Keymap;
interface

type
    { Key-map enumeration. }
    KeyMapping = (NoKey, QuitKey, UpKey, DownKey, LeftKey, RightKey);

function GetKey : KeyMapping;
procedure PauseUntilKey;

procedure InitialiseKeyMaps;

implementation

uses Crt;

var
    NormalKeyMap, SpecialKeyMap : array [Byte] of KeyMapping;

{ Gets a keypress and returns its mapping. }
function GetKey : KeyMapping;
var
    OKey : Byte;
begin
    OKey := Ord(ReadKey);
    if OKey = 0 then GetKey := SpecialKeyMap[Ord(ReadKey)]
                else GetKey := NormalKeyMap[OKey];
end;

{ Pauses until a key is pressed. }
procedure PauseUntilKey;
begin
    ReadKey;
end;

{ Initialises the keymaps. }
procedure InitialiseKeyMaps;
var
    I: Integer;
begin
    for I := 0 to 255 do
    begin
      NormalKeyMap[I]  := NoKey;
      SpecialKeyMap[I] := NoKey;
    end;

    { WASD keys }
    NormalKeyMap[Ord('w')] := UpKey;
    NormalKeyMap[Ord('a')] := LeftKey;
    NormalKeyMap[Ord('s')] := DownKey;
    NormalKeyMap[Ord('d')] := RightKey;

    { vi keys }
    NormalKeyMap[Ord('h')] := LeftKey;
    NormalKeyMap[Ord('j')] := DownKey;
    NormalKeyMap[Ord('k')] := UpKey;
    NormalKeyMap[Ord('l')] := RightKey;

    { Arrow keys }
    SpecialKeyMap[{ Up arrow }    72] := UpKey;
    SpecialKeyMap[{ Left arrow }  75] := LeftKey;
    SpecialKeyMap[{ Right arrow } 77] := RightKey;
    SpecialKeyMap[{ Down arrow }  80] := DownKey;

    { Exiting }
    NormalKeyMap[Ord('q')]   := QuitKey;
    NormalKeyMap[{ Esc } 27] := QuitKey;
end;

end.
