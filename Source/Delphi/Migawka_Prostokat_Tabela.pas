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
    kierunek_w_prawo : boolean; // Diody zapalaj� si� wzgl�dem indeksu tabeli: false - malej�co; true - rosn�co.

    elementy__ilo��,
    pozycja_�wiec�ca,
    pr�dko�� // 50.
      : integer;

    elementy__wygaszanie_etap_t : array of array of integer;

    zegar_Timer : TTimer;

    pasek_LED : array of TPanel;

    procedure ZegarTimerTimer( Sender: TObject );
  public
    { Public declarations }
    constructor Create( rodzic_f : TWinControl; pozycja__lewo_f, pozycja__g�ra_f, elementy_ilo��_f, pr�dko��_f : integer );
    destructor Free();

    procedure Predko��_Ustaw( pr�dko��_f : integer );
  end;

implementation

//Konstruktor klasy TMigawka_Prostokat_Tabela.
constructor TMigawka_Prostokat_Tabela.Create( rodzic_f : TWinControl; pozycja__lewo_f, pozycja__g�ra_f, elementy_ilo��_f, pr�dko��_f : integer );
var
  i : integer;
begin

  //migawka_prostok�t_tabela := TMigawka_Prostokat_Tabela.Create( Form1, 10, 20, 10, 50 ); // Przyk�ad.


  Self.kierunek_w_prawo := true;
  Self.elementy__ilo�� := elementy_ilo��_f;
  Self.pozycja_�wiec�ca := 0;

  SetLength( Self.elementy__wygaszanie_etap_t, 2, Self.elementy__ilo�� );

  // Dodawanie elementu.
  for i := 0 to Self.elementy__ilo�� - 1 do
    begin

      SetLength( Self.pasek_LED, i + 1 );
      Self.pasek_LED[ i ] := TPanel.Create( Application );
      Self.pasek_LED[ i ].Parent := rodzic_f;
      Self.pasek_LED[ i ].Width := 10;
      Self.pasek_LED[ i ].Height := 10;
      Self.pasek_LED[ i ].Left := pozycja__lewo_f + i * Self.pasek_LED[ i ].Width;
      Self.pasek_LED[ i ].Top := pozycja__g�ra_f;
      Self.pasek_LED[ i ].Caption := '';
      Self.pasek_LED[ i ].Color := clMaroon;
      Self.pasek_LED[ i ].ParentBackground := false;

      Self.elementy__wygaszanie_etap_t[ 0 ][ i ] := 0;
      Self.elementy__wygaszanie_etap_t[ 1 ][ i ] := 0;

    end;
  //---//for i := 0 to Self.elementy__ilo�� - 1 do

  Self.zegar_Timer := TTimer.Create( Application );
  Self.zegar_Timer.OnTimer := ZegarTimerTimer;

  Self.Predko��_Ustaw( pr�dko��_f );

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
  //     -2 - �wieci normalnie.
  //     < 0 - kolejny etap rozja�niania (im mniejsza warto�� tym bardziej rozja�nia).
  //     0 - nie �wieci.
  //     > 0 - kolejny etap wygaszania (im wi�ksza warto�� tym bardziej wygasza).
  //

  for i := 0 to Length( Self.pasek_LED ) - 1 do
    begin

      if Self.elementy__wygaszanie_etap_t[ 0 ][ i ] <= -2 then // Ilo�� etap�w roz�wietlania.
        Self.elementy__wygaszanie_etap_t[ 0 ][ i ] := 1
      else
      if Self.elementy__wygaszanie_etap_t[ 0 ][ i ] < 0 then
        dec( Self.elementy__wygaszanie_etap_t[ 0 ][ i ] )
      else
      if Self.elementy__wygaszanie_etap_t[ 0 ][ i ] >= 3 then // Ilo�� etap�w wygaszania.
        Self.elementy__wygaszanie_etap_t[ 0 ][ i ] := 0
      else
      if Self.elementy__wygaszanie_etap_t[ 0 ][ i ] > 0 then
        inc( Self.elementy__wygaszanie_etap_t[ 0 ][ i ] );

    end;
  //---//for i := 0 to Length( Self.pasek_LED ) - 1 do
  //---// Wygaszanie.


  Self.elementy__wygaszanie_etap_t[ 0 ][ Self.pozycja_�wiec�ca ] := -1;


  if Self.kierunek_w_prawo then
    begin

      if Self.pozycja_�wiec�ca >= Self.elementy__ilo�� - 1 then
        begin

          // Zmiana kierunku.

          Self.kierunek_w_prawo := false;

          if Self.pozycja_�wiec�ca > 0 then
            dec( Self.pozycja_�wiec�ca ); // Skrajny element ju� si� �wieci i nie jest po raz kolejny roz�wietlany.

        end
      else//if Self.pozycja_�wiec�ca >= Self.elementy__ilo�� - 1 then
        inc( Self.pozycja_�wiec�ca );

    end
  else//if Self.kierunek_w_prawo then
    begin

      if Self.pozycja_�wiec�ca <= 0 then
        begin

          // Zmiana kierunku.

          Self.kierunek_w_prawo := true;

          if Length( Self.pasek_LED ) > 1 then
            inc( Self.pozycja_�wiec�ca ); // Skrajny element ju� si� �wieci i nie jest po raz kolejny roz�wietlany.

        end
      else//if Self.pozycja_�wiec�ca <= 0 then
        dec( Self.pozycja_�wiec�ca );

    end;
  //---//if Self.kierunek_w_prawo then


  //// Ustawia kolor elementu.
  //for i := 0 to Length( Self.pasek_LED ) - 1 do
  //  begin
  //
  //    case Self.elementy__wygaszanie_etap_t[ 0 ][ i ] of
  //        -2 :  Self.pasek_LED[ i ].Color := clRed; // �wieci normalnie.
  //        -1 :  Self.pasek_LED[ i ].Color := 230; // Ilo�� etap�w roz�wietlania.
  //        0 : Self.pasek_LED[ i ].Color := clMaroon; // Nie �wieci.
  //        1 : Self.pasek_LED[ i ].Color := 224; // Kolejne etapy wygaszania (im wi�ksza warto�� tym bardziej wygasza).
  //        2 : Self.pasek_LED[ i ].Color := 192;
  //        3 : Self.pasek_LED[ i ].Color := 160; // Ilo�� etap�w wygaszania.
  //      end;
  //    //---//case Self.elementy__wygaszanie_etap_t[ 0 ][ i ] of
  //
  //  end;
  ////---//for i := 0 to Length( Self.pasek_LED ) - 1 do
  ////---// Ustawia kolor elementu.


  // Ustawia kolor elementu w kolejno�ci najpierw roz�wietla, potem najbardziej wygaszone.
  for i := 0 to Length( Self.pasek_LED ) - 1 do
    Self.elementy__wygaszanie_etap_t[ 1 ][ i ] := Self.elementy__wygaszanie_etap_t[ 0 ][ i ];

  // Najpierw roz�wietla.
  for i := 0 to Length( Self.pasek_LED ) - 1 do
    case Self.elementy__wygaszanie_etap_t[ 1 ][ i ] of
        -1 : Self.pasek_LED[ i ].Color := 230; // Kolejne etapy wygaszania (im wi�ksza warto�� tym bardziej wygasza).
        -2 : Self.pasek_LED[ i ].Color := clRed; // �wieci normalnie. // Ilo�� etap�w roz�wietlania.
      end;
    //---//case Self.elementy__wygaszanie_etap_t[ 1 ][ i ] of

  // Wygasza nie�wiec�ce elementy.
  for i := 0 to Length( Self.pasek_LED ) - 1 do
    if Self.elementy__wygaszanie_etap_t[ 1 ][ i ] = 0 then
      Self.pasek_LED[ i ].Color := clMaroon; // Nie �wieci.

  // Wygasza w kolejno�ci od najbardziej wygaszonych element�w.
  zti := 1; // Aby wej�� w p�tl�.

  while zti > 0 do
    begin

      zti := 0;

      // Wyszykuje warto�� najwi�kszego wygaszenia.
      for i := 0 to Length( Self.pasek_LED ) - 1 do
        if    ( Self.elementy__wygaszanie_etap_t[ 1 ][ i ] > 0 )
          and ( zti < Self.elementy__wygaszanie_etap_t[ 1 ][ i ] ) then
          zti := Self.elementy__wygaszanie_etap_t[ 1 ][ i ];

      if zti > 0 then
        for i := 0 to Length( Self.pasek_LED ) - 1 do
          if  Self.elementy__wygaszanie_etap_t[ 1 ][ i ] = zti then
            begin

              case Self.elementy__wygaszanie_etap_t[ 1 ][ i ] of
                  1 : Self.pasek_LED[ i ].Color := 224; // Kolejne etapy wygaszania (im wi�ksza warto�� tym bardziej wygasza).
                  2 : Self.pasek_LED[ i ].Color := 192;
                  3 : Self.pasek_LED[ i ].Color := 160; // Ilo�� etap�w wygaszania.
                end;
              //---//case Self.elementy__wygaszanie_etap_t[ 1 ][ i ] of

              Self.elementy__wygaszanie_etap_t[ 1 ][ i ] := -2;

            end;
          //---//if  Self.elementy__wygaszanie_etap_t[ 1 ][ i ] = zti then

    end;
  //---//while zti > 0 do
  //---// Wygasza w kolejno�ci od najbardziej wygaszonych element�w.
  //---// Ustawia kolor elementu w kolejno�ci najpierw roz�wietla, potem najbardziej wygaszone.


  Self.zegar_Timer.Enabled := true;

end;//---//ZegarTimerTimer().

//Predko��_Ustaw().
procedure TMigawka_Prostokat_Tabela.Predko��_Ustaw( pr�dko��_f : integer );
begin

  if pr�dko��_f < 1 then
    pr�dko��_f := 1;

  Self.pr�dko�� := pr�dko��_f;

  Self.zegar_Timer.Interval := Self.pr�dko��;

end;//---//Predko��_Ustaw().

end.
