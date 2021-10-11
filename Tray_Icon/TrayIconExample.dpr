program TrayIconExample;

uses
  Windows, Forms,
  Main in 'Main.pas' {MainForm};

{$R *.res}
{$R WindowsXP.res}

begin
  Application.Initialize;
  Application.Title := 'Exemple TrayIcon';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
