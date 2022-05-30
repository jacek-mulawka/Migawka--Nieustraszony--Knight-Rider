unit Migawka_Prostokat_Tabela_2;{15.Kwi.2022}

  //
  // MIT License
  //
  // Copyright (c) 2022 Jacek Mulawka
  //
  // j.mulawka@interia.pl
  //
  // https://github.com/jacek-mulawka
  //

  // Chyba nie nad¹¿a z obliczeniami za pozosta³ymi rodzajami migawek.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;


const czerwieñ_poziom_najmniejszy_c : integer = 128;
const czerwieñ_poziom_najwiêkszy_c : integer = 255;

const rozjaœnianie_szybkoœæ_c : integer = 10;
const wygaszaniey_szybkoœæ_c : integer = 2;


type
  TMigawka_Prostokat_Tabela_2_Tryb = ( mpt2_Brak, mpt2_Migaj, mpt2_Mignij, mpt2_Wy³¹cz, mpt2_Zaœwieæ );
  TŒwiate³ko_Stan = ( œs_Mignij, œs_Nie_Œwieci, œs_Œwieci, œs_Wy³¹cz, œs_Zaœwieæ );

  TMigawka_Prostokat_Tabela_2 = class
  private
    { Private declarations }
    kierunek_w_prawo : boolean; // Diody zapalaj¹ siê wzglêdem indeksu tabeli: false - malej¹co; true - rosn¹co.

    pozycja_œwiec¹ca,
    prêdkoœæ, // 100.
    prêdkoœæ_licznik
      : integer;

    œwiate³ko_panel__kolor_aktualny_t : array of integer;
    œwiate³ko_panel__stan_t : array of TŒwiate³ko_Stan;

    migawka_prostokat_tabela_2_tryb : TMigawka_Prostokat_Tabela_2_Tryb;

    zegar_Timer : TTimer;

    œwiate³ko_panel_t : array of TPanel;

    procedure ZegarTimerTimer( Sender: TObject );
  public
    { Public declarations }
    constructor Create( rodzic_f : TWinControl; pozycja__lewo_f, pozycja__góra_f, elementy_iloœæ_f, prêdkoœæ_f : integer );
    destructor Free();

    procedure Kierunek_Losuj();
    procedure Predkoœæ_Ustaw( prêdkoœæ_f : integer );
    procedure Tryb_Ustaw( migawka_prostokat_tabela_2_tryb_f : TMigawka_Prostokat_Tabela_2_Tryb );
  end;

implementation

//Konstruktor klasy TMigawka_Prostokat_Tabela_2.
constructor TMigawka_Prostokat_Tabela_2.Create( rodzic_f : TWinControl; pozycja__lewo_f, pozycja__góra_f, elementy_iloœæ_f, prêdkoœæ_f : integer );
var
  i : integer;
begin

  //migawka_prostok¹t_tabela := TMigawka_Prostokat_Tabela_2.Create( Form1, 10, 20, 10, 50 ); // Przyk³ad.


  //Self.kierunek_w_prawo := true;
  //Self.pozycja_œwiec¹ca := 0;
  //Self.prêdkoœæ_licznik := 0;
  Self.migawka_prostokat_tabela_2_tryb := mpt2_Migaj;

  SetLength( Self.œwiate³ko_panel__kolor_aktualny_t, elementy_iloœæ_f );
  SetLength( Self.œwiate³ko_panel__stan_t, elementy_iloœæ_f );

  // Dodawanie elementu.
  for i := 0 to elementy_iloœæ_f - 1 do
    begin

      SetLength( Self.œwiate³ko_panel_t, i + 1 );
      Self.œwiate³ko_panel_t[ i ] := TPanel.Create( Application );
      Self.œwiate³ko_panel_t[ i ].Parent := rodzic_f;
      Self.œwiate³ko_panel_t[ i ].Width := 100;
      Self.œwiate³ko_panel_t[ i ].Height := 100;
      Self.œwiate³ko_panel_t[ i ].Left := pozycja__lewo_f + i * Self.œwiate³ko_panel_t[ i ].Width;
      Self.œwiate³ko_panel_t[ i ].Top := pozycja__góra_f;
      Self.œwiate³ko_panel_t[ i ].Caption := '';
      Self.œwiate³ko_panel_t[ i ].Color := czerwieñ_poziom_najmniejszy_c;
      Self.œwiate³ko_panel_t[ i ].ParentBackground := false;

      Self.œwiate³ko_panel__kolor_aktualny_t[ i ] := czerwieñ_poziom_najmniejszy_c;
      //Self.œwiate³ko_panel__stan_t[ i ] := 0;
      Self.œwiate³ko_panel__stan_t[ i ] := œs_Wy³¹cz;

    end;
  //---//for i := 0 to elementy_iloœæ_f - 1 do


  Randomize();
  Self.Kierunek_Losuj();


  Self.zegar_Timer := TTimer.Create( Application );
  Self.zegar_Timer.Interval := 10;
  Self.zegar_Timer.OnTimer := ZegarTimerTimer;

  Self.Predkoœæ_Ustaw( prêdkoœæ_f );

  if Length( Self.œwiate³ko_panel_t ) > 0 then
    Self.zegar_Timer.Enabled := true
  else//if Length( Self.œwiate³ko_panel_t ) > 0 then
    Self.zegar_Timer.Enabled := false;

end;//---//Konstruktor klasy TMigawka_Prostokat_Tabela_2.

//Destruktor klasy TMigawka_Prostokat_Tabela_2.
destructor TMigawka_Prostokat_Tabela_2.Free();
var
  i : integer;
begin

  SetLength( Self.œwiate³ko_panel__kolor_aktualny_t, 0 );
  SetLength( Self.œwiate³ko_panel__stan_t, 0 );

  // Zwalnianie elementu.
  for i := 0 to Length( Self.œwiate³ko_panel_t ) - 1 do
    begin

      Self.œwiate³ko_panel_t[ i ].Free();
      Self.œwiate³ko_panel_t[ i ] := nil;

    end;
  //---//for i := 0 to Length( Self.œwiate³ko_panel_t ) - 1 do

  SetLength( Self.œwiate³ko_panel_t, 0 );

  Self.zegar_Timer.Free();

end;//---//Destruktor klasy TMigawka_Prostokat_Tabela_2.

//ZegarTimerTimer().
procedure TMigawka_Prostokat_Tabela_2.ZegarTimerTimer( Sender: TObject );
var
  i : integer;
begin

  Self.zegar_Timer.Enabled := false;


  if Self.migawka_prostokat_tabela_2_tryb = mpt2_Migaj then
    begin

      {$region 'mpt2_Migaj.'}
      Self.prêdkoœæ_licznik := Self.prêdkoœæ_licznik + Self.zegar_Timer.Interval;

      if Self.prêdkoœæ_licznik >= Self.prêdkoœæ then
        begin

          Self.prêdkoœæ_licznik := 0;


          Self.œwiate³ko_panel__stan_t[ Self.pozycja_œwiec¹ca ] := œs_Mignij;


          if Self.kierunek_w_prawo then
            begin

              if Self.pozycja_œwiec¹ca >= Length( Self.œwiate³ko_panel_t ) - 1 then
                begin

                  // Zmiana kierunku.

                  Self.kierunek_w_prawo := false;

                  dec( Self.pozycja_œwiec¹ca ); // Skrajny element ju¿ siê œwieci i nie jest po raz kolejny rozœwietlany.

                end
              else//if Self.pozycja_œwiec¹ca >= Length( Self.œwiate³ko_panel_t ) - 1 then
                inc( Self.pozycja_œwiec¹ca );

            end
          else//if Self.kierunek_w_prawo then
            begin

              if Self.pozycja_œwiec¹ca <= 0 then
                begin

                  // Zmiana kierunku.

                  Self.kierunek_w_prawo := true;

                  inc( Self.pozycja_œwiec¹ca ); // Skrajny element ju¿ siê œwieci i nie jest po raz kolejny rozœwietlany.

                end
              else//if Self.pozycja_œwiec¹ca <= 0 then
                dec( Self.pozycja_œwiec¹ca );

            end;
          //---//if Self.kierunek_w_prawo then

        end;
      //---//if Self.prêdkoœæ_licznik >= Self.prêdkoœæ then
      {$endregion 'mpt2_Migaj.'}

    end
  else//if Self.migawka_prostokat_tabela_2_tryb = mpt2_Migaj then
  if Self.migawka_prostokat_tabela_2_tryb in [ mpt2_Mignij, mpt2_Wy³¹cz, mpt2_Zaœwieæ ] then
    begin

      for i := 0 to Length( Self.œwiate³ko_panel__stan_t ) - 1 do
        case Self.migawka_prostokat_tabela_2_tryb of
            mpt2_Mignij : Self.œwiate³ko_panel__stan_t[ i ] := œs_Mignij;
            mpt2_Wy³¹cz : Self.œwiate³ko_panel__stan_t[ i ] := œs_Wy³¹cz;
            mpt2_Zaœwieæ : Self.œwiate³ko_panel__stan_t[ i ] := œs_Zaœwieæ;
          end;
        //---//case Self.migawka_prostokat_tabela_2_tryb of


      if Self.migawka_prostokat_tabela_2_tryb = mpt2_Mignij then
        Self.migawka_prostokat_tabela_2_tryb := mpt2_Brak;

    end;
  //---//if Self.migawka_prostokat_tabela_2_tryb in [ mpt2_Mignij, mpt2_Wy³¹cz, mpt2_Zaœwieæ ] then


  for i := 0 to Length( Self.œwiate³ko_panel_t ) - 1 do
    begin

      if Self.œwiate³ko_panel__stan_t[ i ] in [ œs_Mignij, œs_Zaœwieæ ] then
        begin

          if Self.œwiate³ko_panel__kolor_aktualny_t[ i ] < czerwieñ_poziom_najwiêkszy_c then
            Self.œwiate³ko_panel__kolor_aktualny_t[ i ] := Self.œwiate³ko_panel__kolor_aktualny_t[ i ] + rozjaœnianie_szybkoœæ_c;

          if Self.œwiate³ko_panel__kolor_aktualny_t[ i ] > czerwieñ_poziom_najwiêkszy_c then
            Self.œwiate³ko_panel__kolor_aktualny_t[ i ] := czerwieñ_poziom_najwiêkszy_c;

          if Self.œwiate³ko_panel__kolor_aktualny_t[ i ] = czerwieñ_poziom_najwiêkszy_c then
            begin

              if Self.œwiate³ko_panel__stan_t[ i ] = œs_Mignij then
                Self.œwiate³ko_panel__stan_t[ i ] := œs_Wy³¹cz
              else//if Self.œwiate³ko_panel__stan_t[ i ] = œs_Mignij then
              if Self.œwiate³ko_panel__stan_t[ i ] = œs_Zaœwieæ then
                Self.œwiate³ko_panel__stan_t[ i ] := œs_Œwieci;

            end;
          //---//if Self.œwiate³ko_panel__kolor_aktualny_t[ i ] = czerwieñ_poziom_najwiêkszy_c then

        end
      else//if Self.œwiate³ko_panel__stan_t[ i ] in [ œs_Mignij, œs_Zaœwieæ ] then
      if Self.œwiate³ko_panel__stan_t[ i ] = œs_Wy³¹cz then
        begin

          if Self.œwiate³ko_panel__kolor_aktualny_t[ i ] > czerwieñ_poziom_najmniejszy_c then
            Self.œwiate³ko_panel__kolor_aktualny_t[ i ] := Self.œwiate³ko_panel__kolor_aktualny_t[ i ] - wygaszaniey_szybkoœæ_c;

          if Self.œwiate³ko_panel__kolor_aktualny_t[ i ] < czerwieñ_poziom_najmniejszy_c then
            Self.œwiate³ko_panel__kolor_aktualny_t[ i ] := czerwieñ_poziom_najmniejszy_c;

          if Self.œwiate³ko_panel__kolor_aktualny_t[ i ] = czerwieñ_poziom_najmniejszy_c then
            Self.œwiate³ko_panel__stan_t[ i ] := œs_Nie_Œwieci;

        end;
      //---//if Self.œwiate³ko_panel__stan_t[ i ] = œs_Wy³¹cz then


      Self.œwiate³ko_panel_t[ i ].Color := Self.œwiate³ko_panel__kolor_aktualny_t[ i ];

    end;
  //---//for i := 0 to Length( Self.œwiate³ko_panel_t ) - 1 do


  Self.zegar_Timer.Enabled := true;

end;//---//ZegarTimerTimer().

//Kierunek_Losuj().
procedure TMigawka_Prostokat_Tabela_2.Kierunek_Losuj();
begin

  Self.kierunek_w_prawo := Random( 2 ) = 1;
  Self.prêdkoœæ_licznik := 0;

  if Self.kierunek_w_prawo then
    Self.pozycja_œwiec¹ca := 0
  else//if Self.kierunek_w_prawo then
    Self.pozycja_œwiec¹ca := Length( Self.œwiate³ko_panel_t ) - 1;

end;//---//Kierunek_Losuj().

//Predkoœæ_Ustaw().
procedure TMigawka_Prostokat_Tabela_2.Predkoœæ_Ustaw( prêdkoœæ_f : integer );
begin

  if prêdkoœæ_f < Self.zegar_Timer.Interval then
    prêdkoœæ_f := Self.zegar_Timer.Interval;

  Self.prêdkoœæ := prêdkoœæ_f;

end;//---//Predkoœæ_Ustaw().

//Tryb_Ustaw().
procedure TMigawka_Prostokat_Tabela_2.Tryb_Ustaw( migawka_prostokat_tabela_2_tryb_f : TMigawka_Prostokat_Tabela_2_Tryb );
begin

  if    ( migawka_prostokat_tabela_2_tryb_f <> mpt2_Mignij )
    and ( Self.migawka_prostokat_tabela_2_tryb = migawka_prostokat_tabela_2_tryb_f ) then
    Exit;


  if    ( migawka_prostokat_tabela_2_tryb_f = mpt2_Migaj )
    and ( Self.migawka_prostokat_tabela_2_tryb <> mpt2_Migaj ) then
    Self.Kierunek_Losuj();


  Self.migawka_prostokat_tabela_2_tryb := migawka_prostokat_tabela_2_tryb_f;

  Self.ZegarTimerTimer( nil );

end;//---//Tryb_Ustaw().

end.
