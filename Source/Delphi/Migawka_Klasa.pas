unit Migawka_Klasa;{15.Kwi.2022}

  //
  // MIT License
  //
  // Copyright (c) 2022 Jacek Mulawka
  //
  // j.mulawka@interia.pl
  //
  // https://github.com/jacek-mulawka
  //

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;


const czerwie�_poziom_najmniejszy_c : integer = 128;
const czerwie�_poziom_najwi�kszy_c : integer = 255;

const rozja�nianie_szybko��_c : integer = 10;
const wygaszaniey_szybko��_c : integer = 2;


type
  TMigawka_Klasa_Tryb = ( mkt_Migaj, mkt_Mignij, mkt_Wy��cz, mkt_Za�wie� );
  T�wiate�ko_Stan = ( �s_Mignij, �s_Wy��cz, �s_Za�wie� );

  T�wiate�ko = class( TPanel )
  private
    { Private declarations }
    czerwie�_poziom : integer; // Nie mo�e by� byte, gdy� podczas zwi�kszania warto�ci gdy przekroczy zakres zmiennej automatycznie si� 'przekr�ca'.
    �wiate�ko_stan : T�wiate�ko_Stan;
    �wiate�ko_zegar_Timer : TTimer;
    procedure �wiate�ko_ZegarTimerTimer( Sender: TObject );
  public
    { Public declarations }
    constructor Create( rodzic_f : TWinControl );
    destructor Destroy(); override;

    procedure Stan_Ustaw( �wiate�ko_stan_f : T�wiate�ko_Stan );
  end;

  TMigawka_Klasa = class
  private
    { Private declarations }
    kierunek_w_prawo : boolean; // Diody zapalaj� si� wzgl�dem indeksu tabeli: false - malej�co; true - rosn�co.

    pozycja_�wiec�ca,
    pr�dko�� // 100.
      : integer;

    zegar_Timer : TTimer;

    migawka_klasa_tryb : TMigawka_Klasa_Tryb;

    �wiate�ko_t : array of T�wiate�ko;

    procedure ZegarTimerTimer( Sender: TObject );
  public
    { Public declarations }
    constructor Create( rodzic_f : TWinControl; pozycja__lewo_f, pozycja__g�ra_f, elementy_ilo��_f, pr�dko��_f : integer );
    destructor Free();

    procedure Kierunek_Losuj();
    procedure Predko��_Ustaw( pr�dko��_f : integer );
    procedure Tryb_Ustaw( migawka_klasa_tryb_f : TMigawka_Klasa_Tryb );
  end;

implementation

//Konstruktor klasy T�wiate�ko.
constructor T�wiate�ko.Create( rodzic_f : TWinControl );
begin

  inherited Create( rodzic_f );

  Self.czerwie�_poziom := czerwie�_poziom_najmniejszy_c; // 128. clMaroon - RGB = 128, 0, 0.
  Self.�wiate�ko_stan := �s_Wy��cz;

  Self.Parent := rodzic_f;
  Self.Width := 100;
  Self.Height := 100;
  Self.Caption := '';
  Self.Color := Self.czerwie�_poziom;
  Self.ParentBackground := false;

  Self.�wiate�ko_zegar_Timer := TTimer.Create( Application );
  Self.�wiate�ko_zegar_Timer.Interval := 10;
  Self.�wiate�ko_zegar_Timer.OnTimer := �wiate�ko_ZegarTimerTimer;

end;//---//Konstruktor klasy T�wiate�ko.

//Destruktor klasy T�wiate�ko.
destructor T�wiate�ko.Destroy();
begin

  if Self.�wiate�ko_zegar_Timer.Enabled then
    Self.�wiate�ko_zegar_Timer.Enabled := false;

  Self.�wiate�ko_zegar_Timer.Free();

  inherited;

end;//---//Destruktor klasy T�wiate�ko.

//�wiate�ko_ZegarTimerTimer().
procedure T�wiate�ko.�wiate�ko_ZegarTimerTimer( Sender: TObject );
begin

  if Self.�wiate�ko_stan in [ �s_Mignij, �s_Za�wie� ] then
    begin

      Self.czerwie�_poziom := Self.czerwie�_poziom + rozja�nianie_szybko��_c;

      if Self.czerwie�_poziom > czerwie�_poziom_najwi�kszy_c then
        Self.czerwie�_poziom := czerwie�_poziom_najwi�kszy_c;

      if Self.czerwie�_poziom = czerwie�_poziom_najwi�kszy_c then
        begin

          if Self.�wiate�ko_stan = �s_Mignij then
            Self.�wiate�ko_stan := �s_Wy��cz
          else//if Self.�wiate�ko_stan = �s_Mignij then
          if Self.�wiate�ko_stan = �s_Za�wie� then
            Self.�wiate�ko_zegar_Timer.Enabled := false;

        end;
      //---//if Self.czerwie�_poziom = czerwie�_poziom_najwi�kszy_c then

    end
  else//if Self.�wiate�ko_stan in [ �s_Mignij, �s_Za�wie� ] then
  if Self.�wiate�ko_stan = �s_Wy��cz then
    begin

      Self.czerwie�_poziom := Self.czerwie�_poziom - wygaszaniey_szybko��_c;

      if Self.czerwie�_poziom < czerwie�_poziom_najmniejszy_c then
        Self.czerwie�_poziom := czerwie�_poziom_najmniejszy_c;

      if Self.czerwie�_poziom = czerwie�_poziom_najmniejszy_c then
        Self.�wiate�ko_zegar_Timer.Enabled := false;

    end;
  //---//if Self.�wiate�ko_stan = �s_Wy��cz then


  Self.Color := Self.czerwie�_poziom;

end;//---//Funkcja �wiate�ko_ZegarTimerTimer().

//Funkcja Stan_Ustaw().
procedure T�wiate�ko.Stan_Ustaw( �wiate�ko_stan_f : T�wiate�ko_Stan );
begin

  Self.�wiate�ko_stan := �wiate�ko_stan_f;

  Self.�wiate�ko_zegar_Timer.Enabled := true;

end;//---//Funkcja Stan_Ustaw().


//Konstruktor klasy TMigawka_Klasa.
constructor TMigawka_Klasa.Create( rodzic_f : TWinControl; pozycja__lewo_f, pozycja__g�ra_f, elementy_ilo��_f, pr�dko��_f : integer );
var
  i : integer;
begin

  //migawka_klasa := TMigawka_Klasa.Create( Form1, 10, 20, 10, 50 ); // Przyk�ad.


  //Self.kierunek_w_prawo := true;
  //Self.pozycja_�wiec�ca := 0;
  Self.migawka_klasa_tryb := mkt_Migaj;

  // Dodawanie elementu.
  for i := 0 to elementy_ilo��_f - 1 do
    begin

      SetLength( Self.�wiate�ko_t, i + 1 );
      Self.�wiate�ko_t[ i ] := T�wiate�ko.Create( rodzic_f );
      Self.�wiate�ko_t[ i ].Left := pozycja__lewo_f + i * Self.�wiate�ko_t[ i ].Width;
      Self.�wiate�ko_t[ i ].Top := pozycja__g�ra_f;

    end;
  //---//for i := 0 to elementy_ilo��_f - 1 do


  Randomize();
  Self.Kierunek_Losuj();


  Self.zegar_Timer := TTimer.Create( Application );
  Self.zegar_Timer.OnTimer := ZegarTimerTimer;

  Self.Predko��_Ustaw( pr�dko��_f );

  if Length( Self.�wiate�ko_t ) > 0 then
    Self.zegar_Timer.Enabled := true
  else//if Length( Self.�wiate�ko_t ) > 0 then
    Self.zegar_Timer.Enabled := false;

end;//---//Konstruktor klasy TMigawka_Klasa.

//Destruktor klasy TMigawka_Klasa.
destructor TMigawka_Klasa.Free();
var
  i : integer;
begin

  // Zwalnianie elementu.
  for i := 0 to Length( Self.�wiate�ko_t ) - 1 do
    FreeAndNil( Self.�wiate�ko_t[ i ] );

  SetLength( Self.�wiate�ko_t, 0 );


  Self.zegar_Timer.Free();

end;//---//Destruktor klasy TMigawka_Klasa.

//ZegarTimerTimer().
procedure TMigawka_Klasa.ZegarTimerTimer( Sender: TObject );
var
  i : integer;
begin

  Self.zegar_Timer.Enabled := false;


  if Self.migawka_klasa_tryb = mkt_Migaj then
    begin

      {$region 'mkt_Mignij.'}
      //Self.zegar_Timer.Enabled := false;


      Self.�wiate�ko_t[ Self.pozycja_�wiec�ca ].Stan_Ustaw( �s_Mignij );


      if Self.kierunek_w_prawo then
        begin

          if Self.pozycja_�wiec�ca >= Length( Self.�wiate�ko_t ) - 1 then
            begin

              // Zmiana kierunku.

              Self.kierunek_w_prawo := false;

              if Self.pozycja_�wiec�ca > 0 then
                dec( Self.pozycja_�wiec�ca ); // Skrajny element ju� si� �wieci i nie jest po raz kolejny roz�wietlany.

            end
          else//if Self.pozycja_�wiec�ca >= Length( Self.�wiate�ko_t ) - 1 then
            inc( Self.pozycja_�wiec�ca );

        end
      else//if Self.kierunek_w_prawo then
        begin

          if Self.pozycja_�wiec�ca <= 0 then
            begin

              // Zmiana kierunku.

              Self.kierunek_w_prawo := true;

              if Length( Self.�wiate�ko_t ) > 1 then
                inc( Self.pozycja_�wiec�ca ); // Skrajny element ju� si� �wieci i nie jest po raz kolejny roz�wietlany.

            end
          else//if Self.pozycja_�wiec�ca <= 0 then
            dec( Self.pozycja_�wiec�ca );

        end;
      //---//if Self.kierunek_w_prawo then


      Self.zegar_Timer.Enabled := true;
      {$endregion 'mkt_Mignij.'}

    end
  else//if Self.migawka_klasa_tryb = mkt_Migaj then
  if Self.migawka_klasa_tryb in [ mkt_Mignij, mkt_Wy��cz, mkt_Za�wie� ] then
    begin

      for i := 0 to Length( Self.�wiate�ko_t ) - 1 do
        case Self.migawka_klasa_tryb of
            mkt_Mignij : Self.�wiate�ko_t[ i ].Stan_Ustaw( �s_Mignij );
            mkt_Wy��cz : Self.�wiate�ko_t[ i ].Stan_Ustaw( �s_Wy��cz );
            mkt_Za�wie� : Self.�wiate�ko_t[ i ].Stan_Ustaw( �s_Za�wie� );
          end;
        //---//case Self.migawka_klasa_tryb of

    end;
  //---//if Self.migawka_klasa_tryb in [ mkt_Mignij, mkt_Wy��cz, mkt_Za�wie� ] then

end;//---//ZegarTimerTimer().

//Kierunek_Losuj().
procedure TMigawka_Klasa.Kierunek_Losuj();
begin

  Self.kierunek_w_prawo := Random( 2 ) = 1;

  if Self.kierunek_w_prawo then
    Self.pozycja_�wiec�ca := 0
  else//if Self.kierunek_w_prawo then
    Self.pozycja_�wiec�ca := Length( Self.�wiate�ko_t ) - 1;

end;//---//Kierunek_Losuj().

//Predko��_Ustaw().
procedure TMigawka_Klasa.Predko��_Ustaw( pr�dko��_f : integer );
begin

  if pr�dko��_f < 1 then
    pr�dko��_f := 1;

  Self.pr�dko�� := pr�dko��_f;

  Self.zegar_Timer.Interval := Self.pr�dko��;

end;//---//Predko��_Ustaw().

//Tryb_Ustaw().
procedure TMigawka_Klasa.Tryb_Ustaw( migawka_klasa_tryb_f : TMigawka_Klasa_Tryb );
begin

  if    ( migawka_klasa_tryb_f <> mkt_Mignij )
    and ( Self.migawka_klasa_tryb = migawka_klasa_tryb_f ) then
    Exit;


  if    ( migawka_klasa_tryb_f = mkt_Migaj )
    and ( Self.migawka_klasa_tryb <> mkt_Migaj ) then
    Self.Kierunek_Losuj();


  Self.migawka_klasa_tryb := migawka_klasa_tryb_f;

  Self.ZegarTimerTimer( nil );

end;//---//Tryb_Ustaw().

end.
