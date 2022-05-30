program LED_Test_pr;

uses
  Forms,
  LED_Test in 'LED_Test.pas' {LED_Test_Form},
  Migawka in 'Migawka.pas',
  Migawka_Klasa in 'Migawka_Klasa.pas',
  Migawka_Prostokat in 'Migawka_Prostokat.pas',
  Migawka_Prostokat_Tabela in 'Migawka_Prostokat_Tabela.pas',
  Migawka_Prostokat_Tabela_2 in 'Migawka_Prostokat_Tabela_2.pas';

{$R *.res}

begin

  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  Application.Initialize();
  Application.MainFormOnTaskbar := True;
  Application.HintHidePause := 30000;

  Application.CreateForm( TLED_Test_Form, LED_Test_Form );

  Application.Run();

end.
