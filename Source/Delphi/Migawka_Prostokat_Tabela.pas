unit Migawka_Prostokat_Tabela;{13.Kwi.2022}

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

type
  TMigawka_Prostokat_Tabela = class
  private
    { Private declarations }
    kierunek_w_prawo : boolean; // Diody zapalaj¹ siê wzglêdem indeksu tabeli: false - malej¹co; true - rosn¹co.

    elementy__iloœæ,
    pozycja_œwiec¹ca,
    prêdkoœæ // 50.
      : integer;

    elementy__wygaszanie_etap_t : array of array of integer;

    zegar_Timer : TTimer;

    pasek_LED : array of TPanel;

    procedure ZegarTimerTimer( Sender: TObject );
  public
    { Public declarations }
    constructor Create( rodzic_f : TWinControl; pozycja__lewo_f, pozycja__góra_f, elementy_iloœæ_f, prêdkoœæ_f : integer );
    destructor Free();

    procedure Predkoœæ_Ustaw( prêdkoœæ_f : integer );
  end;

implementation

//Konstruktor klasy TMigawka_Prostokat_Tabela.
constructor TMigawka_Prostokat_Tabela.Create( rodzic_f : TWinControl; pozycja__lewo_f, pozycja__góra_f, elementy_iloœæ_f, prêdkoœæ_f : integer );
var
  i : integer;
begin

  //migawka_prostok¹t_tabela := TMigawka_Prostokat_Tabela.Create( Form1, 10, 20, 10, 50 ); // Przyk³ad.


  Self.kierunek_w_prawo := true;
  Self.elementy__iloœæ := elementy_iloœæ_f;
  Self.pozycja_œwiec¹ca := 0;

  SetLength( Self.elementy__wygaszanie_etap_t, 2, Self.elementy__iloœæ );

  // Dodawanie elementu.
  for i := 0 to Self.elementy__iloœæ - 1 do
    begin

      SetLength( Self.pasek_LED, i + 1 );
      Self.pasek_LED[ i ] := TPanel.Create( Application );
      Self.pasek_LED[ i ].Parent := rodzic_f;
      Self.pasek_LED[ i ].Width := 10;
      Self.pasek_LED[ i ].Height := 10;
      Self.pasek_LED[ i ].Left := pozycja__lewo_f + i * Self.pasek_LED[ i ].Width;
      Self.pasek_LED[ i ].Top := pozycja__góra_f;
      Self.pasek_LED[ i ].Caption := '';
      Self.pasek_LED[ i ].Color := clMaroon;
      Self.pasek_LED[ i ].ParentBackground := false;

      Self.elementy__wygaszanie_etap_t[ 0 ][ i ] := 0;
      Self.elementy__wygaszanie_etap_t[ 1 ][ i ] := 0;

    end;
  //---//for i := 0 to Self.elementy__iloœæ - 1 do

  Self.zegar_Timer := TTimer.Create( Application );
  Self.zegar_Timer.OnTimer := ZegarTimerTimer;

  Self.Predkoœæ_Ustaw( prêdkoœæ_f );

  if Length( Self.pasek_LED ) > 0 then
    Self.zegar_Timer.Enabled := true
  else//if Length( Self.pasek_LED ) > 0 then
    Self.zegar_Timer.Enabled := false;

end;//---//Konstruktor klasy TMigawka_Prostokat_Tabela.

//Destruktor klasy TMigawka_Prostokat_Tabela.
destructor TMigawka_Prostokat_Tabela.Free();
var
  i : integer;
begin

  SetLength( Self.elementy__wygaszanie_etap_t, 0, 0 );

  // Zwalnianie elementu.
  for i := 0 to Length( Self.pasek_LED ) - 1 do
    begin

      Self.pasek_LED[ i ].Free();
      Self.pasek_LED[ i ] := nil;

    end;
  //---//for i := 0 to Length( Self.pasek_LED ) - 1 do

  SetLength( Self.pasek_LED, 0 );

  Self.zegar_Timer.Free();

end;//---//Destruktor klasy TMigawka_Prostokat_Tabela.

//ZegarTimerTimer().
procedure TMigawka_Prostokat_Tabela.ZegarTimerTimer( Sender: TObject );
var
  i,
  zti
    : integer;
begin

  Self.zegar_Timer.Enabled := false;


  // Wygaszanie.
  //   wygaszanie_etap_f:
  //     -2 - œwieci normalnie.
  //     < 0 - kolejny etap rozjaœniania (im mniejsza wartoœæ tym bardziej rozjaœnia).
  //     0 - nie œwieci.
  //     > 0 - kolejny etap wygaszania (im wiêksza wartoœæ tym bardziej wygasza).
  //

  for i := 0 to Length( Self.pasek_LED ) - 1 do
    begin

      if Self.elementy__wygaszanie_etap_t[ 0 ][ i ] <= -2 then // Iloœæ etapów rozœwietlania.
        Self.elementy__wygaszanie_etap_t[ 0 ][ i ] := 1
      else
      if Self.elementy__wygaszanie_etap_t[ 0 ][ i ] < 0 then
        dec( Self.elementy__wygaszanie_etap_t[ 0 ][ i ] )
      else
      if Self.elementy__wygaszanie_etap_t[ 0 ][ i ] >= 3 then // Iloœæ etapów wygaszania.
        Self.elementy__wygaszanie_etap_t[ 0 ][ i ] := 0
      else
      if Self.elementy__wygaszanie_etap_t[ 0 ][ i ] > 0 then
        inc( Self.elementy__wygaszanie_etap_t[ 0 ][ i ] );

    end;
  //---//for i := 0 to Length( Self.pasek_LED ) - 1 do
  //---// Wygaszanie.


  Self.elementy__wygaszanie_etap_t[ 0 ][ Self.pozycja_œwiec¹ca ] := -1;


  if Self.kierunek_w_prawo then
    begin

      if Self.pozycja_œwiec¹ca >= Self.elementy__iloœæ - 1 then
        begin

          // Zmiana kierunku.

          Self.kierunek_w_prawo := false;

          if Self.pozycja_œwiec¹ca > 0 then
            dec( Self.pozycja_œwiec¹ca ); // Skrajny element ju¿ siê œwieci i nie jest po raz kolejny rozœwietlany.

        end
      else//if Self.pozycja_œwiec¹ca >= Self.elementy__iloœæ - 1 then
        inc( Self.pozycja_œwiec¹ca );

    end
  else//if Self.kierunek_w_prawo then
    begin

      if Self.pozycja_œwiec¹ca <= 0 then
        begin

          // Zmiana kierunku.

          Self.kierunek_w_prawo := true;

          if Length( Self.pasek_LED ) > 1 then
            inc( Self.pozycja_œwiec¹ca ); // Skrajny element ju¿ siê œwieci i nie jest po raz kolejny rozœwietlany.

        end
      else//if Self.pozycja_œwiec¹ca <= 0 then
        dec( Self.pozycja_œwiec¹ca );

    end;
  //---//if Self.kierunek_w_prawo then


  //// Ustawia kolor elementu.
  //for i := 0 to Length( Self.pasek_LED ) - 1 do
  //  begin
  //
  //    case Self.elementy__wygaszanie_etap_t[ 0 ][ i ] of
  //        -2 :  Self.pasek_LED[ i ].Color := clRed; // Œwieci normalnie.
  //        -1 :  Self.pasek_LED[ i ].Color := 230; // Iloœæ etapów rozœwietlania.
  //        0 : Self.pasek_LED[ i ].Color := clMaroon; // Nie œwieci.
  //        1 : Self.pasek_LED[ i ].Color := 224; // Kolejne etapy wygaszania (im wiêksza wartoœæ tym bardziej wygasza).
  //        2 : Self.pasek_LED[ i ].Color := 192;
  //        3 : Self.pasek_LED[ i ].Color := 160; // Iloœæ etapów wygaszania.
  //      end;
  //    //---//case Self.elementy__wygaszanie_etap_t[ 0 ][ i ] of
  //
  //  end;
  ////---//for i := 0 to Length( Self.pasek_LED ) - 1 do
  ////---// Ustawia kolor elementu.


  // Ustawia kolor elementu w kolejnoœci najpierw rozœwietla, potem najbardziej wygaszone.
  for i := 0 to Length( Self.pasek_LED ) - 1 do
    Self.elementy__wygaszanie_etap_t[ 1 ][ i ] := Self.elementy__wygaszanie_etap_t[ 0 ][ i ];

  // Najpierw rozœwietla.
  for i := 0 to Length( Self.pasek_LED ) - 1 do
    case Self.elementy__wygaszanie_etap_t[ 1 ][ i ] of
        -1 : Self.pasek_LED[ i ].Color := 230; // Kolejne etapy wygaszania (im wiêksza wartoœæ tym bardziej wygasza).
        -2 : Self.pasek_LED[ i ].Color := clRed; // Œwieci normalnie. // Iloœæ etapów rozœwietlania.
      end;
    //---//case Self.elementy__wygaszanie_etap_t[ 1 ][ i ] of

  // Wygasza nieœwiec¹ce elementy.
  for i := 0 to Length( Self.pasek_LED ) - 1 do
    if Self.elementy__wygaszanie_etap_t[ 1 ][ i ] = 0 then
      Self.pasek_LED[ i ].Color := clMaroon; // Nie œwieci.

  // Wygasza w kolejnoœci od najbardziej wygaszonych elementów.
  zti := 1; // Aby wejœæ w pêtlê.

  while zti > 0 do
    begin

      zti := 0;

      // Wyszykuje wartoœæ najwiêkszego wygaszenia.
      for i := 0 to Length( Self.pasek_LED ) - 1 do
        if    ( Self.elementy__wygaszanie_etap_t[ 1 ][ i ] > 0 )
          and ( zti < Self.elementy__wygaszanie_etap_t[ 1 ][ i ] ) then
          zti := Self.elementy__wygaszanie_etap_t[ 1 ][ i ];

      if zti > 0 then
        for i := 0 to Length( Self.pasek_LED ) - 1 do
          if  Self.elementy__wygaszanie_etap_t[ 1 ][ i ] = zti then
            begin

              case Self.elementy__wygaszanie_etap_t[ 1 ][ i ] of
                  1 : Self.pasek_LED[ i ].Color := 224; // Kolejne etapy wygaszania (im wiêksza wartoœæ tym bardziej wygasza).
                  2 : Self.pasek_LED[ i ].Color := 192;
                  3 : Self.pasek_LED[ i ].Color := 160; // Iloœæ etapów wygaszania.
                end;
              //---//case Self.elementy__wygaszanie_etap_t[ 1 ][ i ] of

              Self.elementy__wygaszanie_etap_t[ 1 ][ i ] := -2;

            end;
          //---//if  Self.elementy__wygaszanie_etap_t[ 1 ][ i ] = zti then

    end;
  //---//while zti > 0 do
  //---// Wygasza w kolejnoœci od najbardziej wygaszonych elementów.
  //---// Ustawia kolor elementu w kolejnoœci najpierw rozœwietla, potem najbardziej wygaszone.


  Self.zegar_Timer.Enabled := true;

end;//---//ZegarTimerTimer().

//Predkoœæ_Ustaw().
procedure TMigawka_Prostokat_Tabela.Predkoœæ_Ustaw( prêdkoœæ_f : integer );
begin

  if prêdkoœæ_f < 1 then
    prêdkoœæ_f := 1;

  Self.prêdkoœæ := prêdkoœæ_f;

  Self.zegar_Timer.Interval := Self.prêdkoœæ;

end;//---//Predkoœæ_Ustaw().

end.
