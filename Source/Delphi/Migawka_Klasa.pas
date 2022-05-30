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


const czerwieñ_poziom_najmniejszy_c : integer = 128;
const czerwieñ_poziom_najwiêkszy_c : integer = 255;

const rozjaœnianie_szybkoœæ_c : integer = 10;
const wygaszaniey_szybkoœæ_c : integer = 2;


type
  TMigawka_Klasa_Tryb = ( mkt_Migaj, mkt_Mignij, mkt_Wy³¹cz, mkt_Zaœwieæ );
  TŒwiate³ko_Stan = ( œs_Mignij, œs_Wy³¹cz, œs_Zaœwieæ );

  TŒwiate³ko = class( TPanel )
  private
    { Private declarations }
    czerwieñ_poziom : integer; // Nie mo¿e byæ byte, gdy¿ podczas zwiêkszania wartoœci gdy przekroczy zakres zmiennej automatycznie siê 'przekrêca'.
    œwiate³ko_stan : TŒwiate³ko_Stan;
    œwiate³ko_zegar_Timer : TTimer;
    procedure Œwiate³ko_ZegarTimerTimer( Sender: TObject );
  public
    { Public declarations }
    constructor Create( rodzic_f : TWinControl );
    destructor Destroy(); override;

    procedure Stan_Ustaw( œwiate³ko_stan_f : TŒwiate³ko_Stan );
  end;

  TMigawka_Klasa = class
  private
    { Private declarations }
    kierunek_w_prawo : boolean; // Diody zapalaj¹ siê wzglêdem indeksu tabeli: false - malej¹co; true - rosn¹co.

    pozycja_œwiec¹ca,
    prêdkoœæ // 100.
      : integer;

    zegar_Timer : TTimer;

    migawka_klasa_tryb : TMigawka_Klasa_Tryb;

    œwiate³ko_t : array of TŒwiate³ko;

    procedure ZegarTimerTimer( Sender: TObject );
  public
    { Public declarations }
    constructor Create( rodzic_f : TWinControl; pozycja__lewo_f, pozycja__góra_f, elementy_iloœæ_f, prêdkoœæ_f : integer );
    destructor Free();

    procedure Kierunek_Losuj();
    procedure Predkoœæ_Ustaw( prêdkoœæ_f : integer );
    procedure Tryb_Ustaw( migawka_klasa_tryb_f : TMigawka_Klasa_Tryb );
  end;

implementation

//Konstruktor klasy TŒwiate³ko.
constructor TŒwiate³ko.Create( rodzic_f : TWinControl );
begin

  inherited Create( rodzic_f );

  Self.czerwieñ_poziom := czerwieñ_poziom_najmniejszy_c; // 128. clMaroon - RGB = 128, 0, 0.
  Self.œwiate³ko_stan := œs_Wy³¹cz;

  Self.Parent := rodzic_f;
  Self.Width := 100;
  Self.Height := 100;
  Self.Caption := '';
  Self.Color := Self.czerwieñ_poziom;
  Self.ParentBackground := false;

  Self.œwiate³ko_zegar_Timer := TTimer.Create( Application );
  Self.œwiate³ko_zegar_Timer.Interval := 10;
  Self.œwiate³ko_zegar_Timer.OnTimer := Œwiate³ko_ZegarTimerTimer;

end;//---//Konstruktor klasy TŒwiate³ko.

//Destruktor klasy TŒwiate³ko.
destructor TŒwiate³ko.Destroy();
begin

  if Self.œwiate³ko_zegar_Timer.Enabled then
    Self.œwiate³ko_zegar_Timer.Enabled := false;

  Self.œwiate³ko_zegar_Timer.Free();

  inherited;

end;//---//Destruktor klasy TŒwiate³ko.

//Œwiate³ko_ZegarTimerTimer().
procedure TŒwiate³ko.Œwiate³ko_ZegarTimerTimer( Sender: TObject );
begin

  if Self.œwiate³ko_stan in [ œs_Mignij, œs_Zaœwieæ ] then
    begin

      Self.czerwieñ_poziom := Self.czerwieñ_poziom + rozjaœnianie_szybkoœæ_c;

      if Self.czerwieñ_poziom > czerwieñ_poziom_najwiêkszy_c then
        Self.czerwieñ_poziom := czerwieñ_poziom_najwiêkszy_c;

      if Self.czerwieñ_poziom = czerwieñ_poziom_najwiêkszy_c then
        begin

          if Self.œwiate³ko_stan = œs_Mignij then
            Self.œwiate³ko_stan := œs_Wy³¹cz
          else//if Self.œwiate³ko_stan = œs_Mignij then
          if Self.œwiate³ko_stan = œs_Zaœwieæ then
            Self.œwiate³ko_zegar_Timer.Enabled := false;

        end;
      //---//if Self.czerwieñ_poziom = czerwieñ_poziom_najwiêkszy_c then

    end
  else//if Self.œwiate³ko_stan in [ œs_Mignij, œs_Zaœwieæ ] then
  if Self.œwiate³ko_stan = œs_Wy³¹cz then
    begin

      Self.czerwieñ_poziom := Self.czerwieñ_poziom - wygaszaniey_szybkoœæ_c;

      if Self.czerwieñ_poziom < czerwieñ_poziom_najmniejszy_c then
        Self.czerwieñ_poziom := czerwieñ_poziom_najmniejszy_c;

      if Self.czerwieñ_poziom = czerwieñ_poziom_najmniejszy_c then
        Self.œwiate³ko_zegar_Timer.Enabled := false;

    end;
  //---//if Self.œwiate³ko_stan = œs_Wy³¹cz then


  Self.Color := Self.czerwieñ_poziom;

end;//---//Funkcja Œwiate³ko_ZegarTimerTimer().

//Funkcja Stan_Ustaw().
procedure TŒwiate³ko.Stan_Ustaw( œwiate³ko_stan_f : TŒwiate³ko_Stan );
begin

  Self.œwiate³ko_stan := œwiate³ko_stan_f;

  Self.œwiate³ko_zegar_Timer.Enabled := true;

end;//---//Funkcja Stan_Ustaw().


//Konstruktor klasy TMigawka_Klasa.
constructor TMigawka_Klasa.Create( rodzic_f : TWinControl; pozycja__lewo_f, pozycja__góra_f, elementy_iloœæ_f, prêdkoœæ_f : integer );
var
  i : integer;
begin

  //migawka_klasa := TMigawka_Klasa.Create( Form1, 10, 20, 10, 50 ); // Przyk³ad.


  //Self.kierunek_w_prawo := true;
  //Self.pozycja_œwiec¹ca := 0;
  Self.migawka_klasa_tryb := mkt_Migaj;

  // Dodawanie elementu.
  for i := 0 to elementy_iloœæ_f - 1 do
    begin

      SetLength( Self.œwiate³ko_t, i + 1 );
      Self.œwiate³ko_t[ i ] := TŒwiate³ko.Create( rodzic_f );
      Self.œwiate³ko_t[ i ].Left := pozycja__lewo_f + i * Self.œwiate³ko_t[ i ].Width;
      Self.œwiate³ko_t[ i ].Top := pozycja__góra_f;

    end;
  //---//for i := 0 to elementy_iloœæ_f - 1 do


  Randomize();
  Self.Kierunek_Losuj();


  Self.zegar_Timer := TTimer.Create( Application );
  Self.zegar_Timer.OnTimer := ZegarTimerTimer;

  Self.Predkoœæ_Ustaw( prêdkoœæ_f );

  if Length( Self.œwiate³ko_t ) > 0 then
    Self.zegar_Timer.Enabled := true
  else//if Length( Self.œwiate³ko_t ) > 0 then
    Self.zegar_Timer.Enabled := false;

end;//---//Konstruktor klasy TMigawka_Klasa.

//Destruktor klasy TMigawka_Klasa.
destructor TMigawka_Klasa.Free();
var
  i : integer;
begin

  // Zwalnianie elementu.
  for i := 0 to Length( Self.œwiate³ko_t ) - 1 do
    FreeAndNil( Self.œwiate³ko_t[ i ] );

  SetLength( Self.œwiate³ko_t, 0 );


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


      Self.œwiate³ko_t[ Self.pozycja_œwiec¹ca ].Stan_Ustaw( œs_Mignij );


      if Self.kierunek_w_prawo then
        begin

          if Self.pozycja_œwiec¹ca >= Length( Self.œwiate³ko_t ) - 1 then
            begin

              // Zmiana kierunku.

              Self.kierunek_w_prawo := false;

              if Self.pozycja_œwiec¹ca > 0 then
                dec( Self.pozycja_œwiec¹ca ); // Skrajny element ju¿ siê œwieci i nie jest po raz kolejny rozœwietlany.

            end
          else//if Self.pozycja_œwiec¹ca >= Length( Self.œwiate³ko_t ) - 1 then
            inc( Self.pozycja_œwiec¹ca );

        end
      else//if Self.kierunek_w_prawo then
        begin

          if Self.pozycja_œwiec¹ca <= 0 then
            begin

              // Zmiana kierunku.

              Self.kierunek_w_prawo := true;

              if Length( Self.œwiate³ko_t ) > 1 then
                inc( Self.pozycja_œwiec¹ca ); // Skrajny element ju¿ siê œwieci i nie jest po raz kolejny rozœwietlany.

            end
          else//if Self.pozycja_œwiec¹ca <= 0 then
            dec( Self.pozycja_œwiec¹ca );

        end;
      //---//if Self.kierunek_w_prawo then


      Self.zegar_Timer.Enabled := true;
      {$endregion 'mkt_Mignij.'}

    end
  else//if Self.migawka_klasa_tryb = mkt_Migaj then
  if Self.migawka_klasa_tryb in [ mkt_Mignij, mkt_Wy³¹cz, mkt_Zaœwieæ ] then
    begin

      for i := 0 to Length( Self.œwiate³ko_t ) - 1 do
        case Self.migawka_klasa_tryb of
            mkt_Mignij : Self.œwiate³ko_t[ i ].Stan_Ustaw( œs_Mignij );
            mkt_Wy³¹cz : Self.œwiate³ko_t[ i ].Stan_Ustaw( œs_Wy³¹cz );
            mkt_Zaœwieæ : Self.œwiate³ko_t[ i ].Stan_Ustaw( œs_Zaœwieæ );
          end;
        //---//case Self.migawka_klasa_tryb of

    end;
  //---//if Self.migawka_klasa_tryb in [ mkt_Mignij, mkt_Wy³¹cz, mkt_Zaœwieæ ] then

end;//---//ZegarTimerTimer().

//Kierunek_Losuj().
procedure TMigawka_Klasa.Kierunek_Losuj();
begin

  Self.kierunek_w_prawo := Random( 2 ) = 1;

  if Self.kierunek_w_prawo then
    Self.pozycja_œwiec¹ca := 0
  else//if Self.kierunek_w_prawo then
    Self.pozycja_œwiec¹ca := Length( Self.œwiate³ko_t ) - 1;

end;//---//Kierunek_Losuj().

//Predkoœæ_Ustaw().
procedure TMigawka_Klasa.Predkoœæ_Ustaw( prêdkoœæ_f : integer );
begin

  if prêdkoœæ_f < 1 then
    prêdkoœæ_f := 1;

  Self.prêdkoœæ := prêdkoœæ_f;

  Self.zegar_Timer.Interval := Self.prêdkoœæ;

end;//---//Predkoœæ_Ustaw().

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
