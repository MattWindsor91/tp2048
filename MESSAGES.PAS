{ 2048 clone in Turbo Pascal: messages unit }

unit Messages;

interface

procedure StatusMessage(Message : String);
procedure AnnounceScore;

procedure SayHi;
procedure SayBye;

implementation

uses Graphics, State;

const
    WelcomeMessage : String = 'Hi! WASD/HJKL/arrows to move; Q/Esc to quit.';

    { Status messages to display when the game ends, for each final state. }
    GameOverMessages : array[GameState] of String
    = ( { InProgress } 'BUG: Game ended while still in progress!'
      , { Won        } 'Congraturation! You have played a great game.'
      , { Lost       } 'Game over, man, game over.'
      , { Quit       } 'Be seeing you...'
      );

{ Draw a status line message. }
procedure StatusMessage(Message: String);
begin
    PrepareStatusLine;
    Write('Score: ', CurrentScore, '. ', Message);
    FinishGraphicsOperation;
end;

{ Announces the score via the status line. }
procedure AnnounceScore;
begin
    StatusMessage('');
end;

{ Says the welcome message. }
procedure SayHi;
begin
    StatusMessage(WelcomeMessage);
end;

{ Says the appropriate end-of-game message. }
procedure SayBye;
begin
    StatusMessage(GameOverMessages[CurrentState]);
end;

end.
