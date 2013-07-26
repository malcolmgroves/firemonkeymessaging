program FMXMessaging;

uses
  FMX.Forms,
  fMain in 'fMain.pas' {Form11};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm11, Form11);
  Application.Run;
end.
