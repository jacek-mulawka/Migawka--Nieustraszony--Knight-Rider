unit LED_Test;{18.Kwi.2012}

  //
  // MIT License
  //
  // Copyright (c) 2012 Jacek Mulawka
  //
  // j.mulawka@interia.pl
  //
  // https://github.com/jacek-mulawka
  //

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvExControls, JvLED, ExtCtrls,Vcl.StdCtrls, Vcl.Samples.Spin,
  Migawka, Migawka_Klasa, Migawka_Prostokat, Migawka_Prostokat_Tabela,
  Migawka_Prostokat_Tabela_2;

type
  TLED_Test_Form = class( TForm )
    JvLED2: TJvLED;
    JvLED1: TJvLED;
    JvLED3: TJvLED;
    D�_Panel: TPanel;
    Pr�dko��_Etykieta_Label: TLabel;
    Pr�dko��_SpinEdit: TSpinEdit;
    Migawka_RadioButton: TRadioButton;
    Migawka_Prostokat_RadioButton: TRadioButton;
    Migawka_Prostokat_Tabela_RadioButton: TRadioButton;
    Migawka_Prostokat_Tabela_2_RadioButton: TRadioButton;
    Klasa_RadioButton: TRadioButton;
    Op�nienie_Zmiany_SpinEdit: TSpinEdit;
    Op�nienie_Zmiany_Etykieta_Label: TLabel;
    Utw�rz_Zwolnij_Button: TButton;
    Elementy_Ilo��__Etykieta_Label: TLabel;
    Elementy_Ilo��_SpinEdit: TSpinEdit;
    Tryb_RadioGroup: TRadioGroup;
    Tryb_Ustaw_Button: TButton;
    procedure FormCreate( Sender: TObject );
    procedure FormClose( Sender: TObject; var Action: TCloseAction );
    procedure Utw�rz_Zwolnij_ButtonClick( Sender: TObject );
    procedure Pr�dko��_SpinEditKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState );
    procedure Op�nienie_Zmiany_SpinEditKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState );
    procedure Tryb_RadioGroupClick( Sender: TObject );
  private
    { Private declarations }
    migawka__led : Migawka.TMigawka;
    migawka__klasa : Migawka_Klasa.TMigawka_Klasa;
    migawka__prostok�t : Migawka_Prostokat.TMigawka_Prostokat;
    migawka__prostok�t_tabela : Migawka_Prostokat_Tabela.TMigawka_Prostokat_Tabela;
    migawka__prostok�t_tabela_2 : Migawka_Prostokat_Tabela_2.TMigawka_Prostokat_Tabela_2;
    //ztt : array[ 1..3 ] of TJvLED;
  public
    { Public declarations }
  end;

var
  LED_Test_Form: TLED_Test_Form;

implementation

{$R *.dfm}

//FormCreate().
procedure TLED_Test_Form.FormCreate( Sender: TObject );
begin

  migawka__led := nil;
  migawka__prostok�t := nil;
  migawka__prostok�t_tabela := nil;

  Migawka_RadioButton.Checked := true;
  Utw�rz_Zwolnij_ButtonClick( Sender );

  Migawka_Prostokat_RadioButton.Checked := true;
  Utw�rz_Zwolnij_ButtonClick( Sender );

  Migawka_Prostokat_Tabela_RadioButton.Checked := true;
  Utw�rz_Zwolnij_ButtonClick( Sender );

  Migawka_Prostokat_Tabela_2_RadioButton.Checked := true;
  Utw�rz_Zwolnij_ButtonClick( Sender );

  Klasa_RadioButton.Checked := true;
  Utw�rz_Zwolnij_ButtonClick( Sender );

  Migawka_RadioButton.Checked := true;


  Tryb_RadioGroupClick( Sender );

end;//---//FormCreate().

//FormClose().
procedure TLED_Test_Form.FormClose( Sender: TObject; var Action: TCloseAction );
begin

  if migawka__led <> nil then
    begin

      migawka__led.Free();
      migawka__led := nil;

    end;
  //---//if migawka__led <> nil then

  if migawka__prostok�t <> nil then
    begin

      migawka__prostok�t.Free();
      migawka__prostok�t := nil;

    end;
  //---//if migawka__prostok�t <> nil then

  if migawka__prostok�t_tabela <> nil then
    begin

      migawka__prostok�t_tabela.Free();
      migawka__prostok�t_tabela := nil;

    end;
  //---//if migawka__prostok�t_tabela <> nil then

  if migawka__prostok�t_tabela_2 <> nil then
    begin

      migawka__prostok�t_tabela_2.Free();
      migawka__prostok�t_tabela_2 := nil;

    end;
  //---//if migawka__prostok�t_tabela_2 <> nil then

  if migawka__klasa <> nil then
    begin

      migawka__klasa.Free();
      migawka__klasa := nil;

    end;
  //---//if migawka__klasa <> nil then

end;//---//FormClose().

//Utw�rz_Zwolnij_ButtonClick().
procedure TLED_Test_Form.Utw�rz_Zwolnij_ButtonClick( Sender: TObject );
begin

  if Pr�dko��_SpinEdit.Value < 0 then
    Pr�dko��_SpinEdit.Value := 0;

  if Elementy_Ilo��_SpinEdit.Value < 0 then
    Elementy_Ilo��_SpinEdit.Value := 0;


  if Migawka_RadioButton.Checked then
    begin

      if migawka__led <> nil then
        begin

          migawka__led.Free();
          migawka__led := nil;

        end
      else//if migawka__led <> nil then
        migawka__led := TMigawka.Create( Self, 10, 20, Elementy_Ilo��_SpinEdit.Value, Pr�dko��_SpinEdit.Value, Op�nienie_Zmiany_SpinEdit.Value ); // pr�dko��_f = 50, op�nienie_zmiany_f = 0.

    end;
  //---//if Migawka_RadioButton.Checked then

  if Migawka_Prostokat_RadioButton.Checked then
    begin

      if migawka__prostok�t <> nil then
        begin

          migawka__prostok�t.Free();
          migawka__prostok�t := nil;

        end
      else//if migawka__prostok�t <> nil then
        migawka__prostok�t := TMigawka_Prostokat.Create( Self, 20, 40, Elementy_Ilo��_SpinEdit.Value, Pr�dko��_SpinEdit.Value, Op�nienie_Zmiany_SpinEdit.Value ); // pr�dko��_f = 50, op�nienie_zmiany_f = 0.

    end;
  //---//if Migawka_Prostokat_RadioButton.Checked then

  if Migawka_Prostokat_Tabela_RadioButton.Checked then
    begin

      if migawka__prostok�t_tabela <> nil then
        begin

          migawka__prostok�t_tabela.Free();
          migawka__prostok�t_tabela := nil;

        end
      else//if migawka__prostok�t_tabela <> nil then
        migawka__prostok�t_tabela := TMigawka_Prostokat_Tabela.Create( Self, 20, 60, Elementy_Ilo��_SpinEdit.Value, Pr�dko��_SpinEdit.Value );

    end;
  //---//if Migawka_Prostokat_Tabela_RadioButton.Checked then

  if Migawka_Prostokat_Tabela_2_RadioButton.Checked then
    begin

      if migawka__prostok�t_tabela_2 <> nil then
        begin

          migawka__prostok�t_tabela_2.Free();
          migawka__prostok�t_tabela_2 := nil;

        end
      else//if migawka__prostok�t_tabela_2 <> nil then
        migawka__prostok�t_tabela_2 := TMigawka_Prostokat_Tabela_2.Create( Self, 20, 80, Elementy_Ilo��_SpinEdit.Value, Pr�dko��_SpinEdit.Value );

    end;
  //---//if Migawka_Prostokat_Tabela_2_RadioButton.Checked then

  if Klasa_RadioButton.Checked then
    begin

      if migawka__klasa <> nil then
        begin

          migawka__klasa.Free();
          migawka__klasa := nil;

        end
      else//if migawka__klasa <> nil then
        migawka__klasa := TMigawka_Klasa.Create( Self, 20, 200, Elementy_Ilo��_SpinEdit.Value, Pr�dko��_SpinEdit.Value );

    end;
  //---//if Klasa_RadioButton.Checked then


  Tryb_RadioGroupClick( Sender );

end;//--//Utw�rz_Zwolnij_ButtonClick().

//Pr�dko��_SpinEditKeyDown().
procedure TLED_Test_Form.Pr�dko��_SpinEditKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState );
begin

  // Enter.
  if Key = 13 then
    begin

      Key := 0;

      if Pr�dko��_SpinEdit.Value < 0 then
        Pr�dko��_SpinEdit.Value := 0;


      if migawka__led <> nil then
        migawka__led.Predko��_Ustaw( Pr�dko��_SpinEdit.Value );

      if migawka__prostok�t <> nil then
        migawka__prostok�t.Predko��_Ustaw( Pr�dko��_SpinEdit.Value );

      if migawka__prostok�t_tabela <> nil then
        migawka__prostok�t_tabela.Predko��_Ustaw( Pr�dko��_SpinEdit.Value );

      if migawka__prostok�t_tabela_2 <> nil then
        migawka__prostok�t_tabela_2.Predko��_Ustaw( Pr�dko��_SpinEdit.Value );

      if migawka__klasa <> nil then
        migawka__klasa.Predko��_Ustaw( Pr�dko��_SpinEdit.Value );

    end;
  //---//if Key = 13 then

end;//---//Pr�dko��_SpinEditKeyDown().

//Op�nienie_Zmiany_SpinEditKeyDown().
procedure TLED_Test_Form.Op�nienie_Zmiany_SpinEditKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState );
begin

  // Enter.
  if Key = 13 then
    begin

      Key := 0;

      if Op�nienie_Zmiany_SpinEdit.Value < 0 then
        Op�nienie_Zmiany_SpinEdit.Value := 0;


      if migawka__led <> nil then
        migawka__led.Op�nienie_Zmiany_Ustaw( Op�nienie_Zmiany_SpinEdit.Value );

      if migawka__prostok�t <> nil then
        migawka__prostok�t.Op�nienie_Zmiany_Ustaw( Op�nienie_Zmiany_SpinEdit.Value );

    end;
  //---//if Key = 13 then

end;//---//Op�nienie_Zmiany_SpinEditKeyDown().

//Tryb_RadioGroupClick().
procedure TLED_Test_Form.Tryb_RadioGroupClick( Sender: TObject );
begin

  if migawka__prostok�t_tabela_2 <> nil then
    migawka__prostok�t_tabela_2.Tryb_Ustaw( Migawka_Prostokat_Tabela_2.TMigawka_Prostokat_Tabela_2_Tryb(Tryb_RadioGroup.ItemIndex + 1) );

  if migawka__klasa <> nil then
    migawka__klasa.Tryb_Ustaw( Migawka_Klasa.TMigawka_Klasa_Tryb(Tryb_RadioGroup.ItemIndex) );

end;//---//Tryb_RadioGroupClick().

end.