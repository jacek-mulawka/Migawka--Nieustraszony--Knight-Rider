unit Migawka_Prostokat;

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
  TMigawka_Prostokat = class
  private
    { Private declarations }
    elementy_iloœæ,
    opóŸnienie_zmiany, // Po ilu cyklach œwiate³ko zawraca (skrajne siê nie œwieci). // 6.
    pozycja_œwiec¹ca,
    prêdkoœæ // 50.
      : integer;

    kierunek : char;

    zegar_Timer : TTimer;

    pasek_LED : array of TPanel;

    procedure ZegarTimerTimer( Sender: TObject );
  public
    { Public declarations }
    constructor Create( rodzic_f : TWinControl; pozycja__lewo_f, pozycja__góra_f, elementy_iloœæ_f, prêdkoœæ_f, opóŸnienie_zmiany_f : integer );
    destructor Free();

    procedure OpóŸnienie_Zmiany_Ustaw( opóŸnienie_zmiany_f : integer );
    procedure Predkoœæ_Ustaw( prêdkoœæ_f : integer );
  end;

implementation

//Konstruktor klasy TMigawka_Prostokat.
constructor TMigawka_Prostokat.Create( rodzic_f : TWinControl; pozycja__lewo_f, pozycja__góra_f, elementy_iloœæ_f, prêdkoœæ_f, opóŸnienie_zmiany_f : integer );
var
  i : integer;
begin

  //migawka_prostok¹t := TMigawka_Prostokat.Create( Form1, 10, 20, 10, 50, 0 ); // Przyk³ad.

  //SetLength( Self.pasek_LED, 0 ); // Tak jakby na pocz¹tku ju¿ by³ pierwszy element.

  Self.elementy_iloœæ := elementy_iloœæ_f - 1;
  Self.pozycja_œwiec¹ca := 0;
  Self.kierunek := 'P';

  //Self.prêdkoœæ := prêdkoœæ_f; // 50.
  //Self.opóŸnienie_zmiany := opóŸnienie_zmiany_f; // 6.
  Self.OpóŸnienie_Zmiany_Ustaw( opóŸnienie_zmiany_f );


  // Dodawanie elementu.
  for i := 0 to Self.elementy_iloœæ do
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

    end;
  //---//for i := 0 to Self.elementy_iloœæ do

  Self.zegar_Timer := TTimer.Create( Application );
  //Self.zegar_Timer.Interval := Self.prêdkoœæ;
  Self.zegar_Timer.OnTimer := ZegarTimerTimer;

  Self.Predkoœæ_Ustaw( prêdkoœæ_f );

  Self.zegar_Timer.Enabled := true;

end;//---//Konstruktor klasy TMigawka_Prostokat.

//Destruktor klasy TMigawka_Prostokat.
destructor TMigawka_Prostokat.Free();
var
  i : integer;
begin

  // Zwalnianie elementu.
  for i := 0 to Length( Self.pasek_LED ) - 1 do
    begin

      //SetLength( Self.pasek_LED, i + 1 );
      Self.pasek_LED[ i ].Free();
      Self.pasek_LED[ i ] := nil;

    end;
  //---//for i := 0 to Length( Self.pasek_LED ) - 1 do

  SetLength( Self.pasek_LED, 0 );

  Self.zegar_Timer.Free();

end;//---//Destruktor klasy TMigawka_Prostokat.

//ZegarTimerTimer().
procedure TMigawka_Prostokat.ZegarTimerTimer( Sender: TObject );
begin

  Self.zegar_Timer.Enabled := false;

  if Self.kierunek = 'P' then
    begin

      inc( Self.pozycja_œwiec¹ca );

      if Self.pozycja_œwiec¹ca <= Self.elementy_iloœæ then
        Self.pasek_LED[ Self.pozycja_œwiec¹ca ].Color := clRed;

      //if Self.pozycja_œwiec¹ca <= Self.elementy_iloœæ then
      //  Self.pasek_LED[ Self.pozycja_œwiec¹ca - 1 ].Color := clMaroon; // Skrajna nie gaœnie podczas odbijania (wygasza).

      // Wygaszanie.
      if    ( Self.pozycja_œwiec¹ca >= 1 )
        and ( Self.pozycja_œwiec¹ca <= Self.elementy_iloœæ + 1 ) then
        Self.pasek_LED[ Self.pozycja_œwiec¹ca - 1 ].Color := $000000E0;

      if    ( Self.pozycja_œwiec¹ca >= 2 )
        and ( Self.pozycja_œwiec¹ca <= Self.elementy_iloœæ + 2 ) then
        Self.pasek_LED[ Self.pozycja_œwiec¹ca - 2 ].Color := $000000C0;

      if    ( Self.pozycja_œwiec¹ca >= 3 )
        and ( Self.pozycja_œwiec¹ca <= Self.elementy_iloœæ + 3 ) then
        Self.pasek_LED[ Self.pozycja_œwiec¹ca - 3 ].Color := $000000A0;

     if    ( Self.pozycja_œwiec¹ca >= 4 )
       and ( Self.pozycja_œwiec¹ca <= Self.elementy_iloœæ + 4 ) then
        Self.pasek_LED[ Self.pozycja_œwiec¹ca - 4 ].Color := clMaroon;
     //---// Wygaszanie.

    end;
  //---//if Self.kierunek = 'P' then


  if Self.kierunek = 'L' then
    begin

      dec( Self.pozycja_œwiec¹ca );

      if Self.pozycja_œwiec¹ca >= 0 then
        Self.pasek_LED[ Self.pozycja_œwiec¹ca ].Color := clRed;

      //if Self.pozycja_œwiec¹ca >= 0 then
      //  Self.pasek_LED[ Self.pozycja_œwiec¹ca + 1 ].Color := clMaroon; // Skrajna nie gaœnie podczas odbijania (wygasza).

      // Wygaszanie.
      if    ( Self.pozycja_œwiec¹ca <= Self.elementy_iloœæ - 1 )
        and ( Self.pozycja_œwiec¹ca >= - 1 ) then
        Self.pasek_LED[ Self.pozycja_œwiec¹ca + 1 ].Color := $000000E0;

      if    ( Self.pozycja_œwiec¹ca <= Self.elementy_iloœæ - 2 )
        and ( Self.pozycja_œwiec¹ca >= - 2 ) then
        Self.pasek_LED[ Self.pozycja_œwiec¹ca + 2 ].Color := $000000C0;

      if    ( Self.pozycja_œwiec¹ca <= Self.elementy_iloœæ - 3 )
        and ( Self.pozycja_œwiec¹ca >= - 3 ) then
        Self.pasek_LED[ Self.pozycja_œwiec¹ca + 3 ].Color := $000000A0;

      if    ( Self.pozycja_œwiec¹ca <= Self.elementy_iloœæ - 4 )
        and ( Self.pozycja_œwiec¹ca >= - 4 ) then
        Self.pasek_LED[ Self.pozycja_œwiec¹ca + 4 ].Color := clMaroon;
     //---// Wygaszanie.

    end;
  //---//if Self.kierunek = 'P' then


  // Zmiana kierunku.
  if Self.pozycja_œwiec¹ca = Self.elementy_iloœæ + Self.opóŸnienie_zmiany then
    begin

      if Self.pozycja_œwiec¹ca <> Self.elementy_iloœæ then
        Self.pozycja_œwiec¹ca := Self.elementy_iloœæ;

      Self.kierunek := 'L';

    end;
  //---//if Self.pozycja_œwiec¹ca = Self.elementy_iloœæ + Self.opóŸnienie_zmiany then

  if Self.pozycja_œwiec¹ca = -Self.opóŸnienie_zmiany then
    begin

      if Self.pozycja_œwiec¹ca <> 0 then
        Self.pozycja_œwiec¹ca := 0;

      Self.kierunek := 'P';

    end;
  //---//if Self.pozycja_œwiec¹ca = -Self.opóŸnienie_zmiany then
  //---// Zmiana kierunku.

  Self.zegar_Timer.Enabled := true;

  {
  clRed
  $000000E0
  $000000C0
  $000000A0
  clMaroon
  }
end;//---//ZegarTimerTimer().

//OpóŸnienie_Zmiany_Ustaw().
procedure TMigawka_Prostokat.OpóŸnienie_Zmiany_Ustaw( opóŸnienie_zmiany_f : integer );
begin

  if opóŸnienie_zmiany_f < 0 then
    opóŸnienie_zmiany_f := 0;

  Self.opóŸnienie_zmiany := opóŸnienie_zmiany_f;

end;//---//OpóŸnienie_Zmiany_Ustaw().

//Predkoœæ_Ustaw().
procedure TMigawka_Prostokat.Predkoœæ_Ustaw( prêdkoœæ_f : integer );
begin

  if prêdkoœæ_f < 1 then
    prêdkoœæ_f := 1;

  Self.prêdkoœæ := prêdkoœæ_f;

  Self.zegar_Timer.Interval := Self.prêdkoœæ;

end;//---//Predkoœæ_Ustaw().

end.
