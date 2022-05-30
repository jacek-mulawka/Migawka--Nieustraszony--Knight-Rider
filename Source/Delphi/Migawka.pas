unit Migawka;

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
  Dialogs, JvExControls, JvLED, ExtCtrls;

type
  TMigawka = class
  private
    { Private declarations }
    elementy_ilo��,
    op�nienie_zmiany, // Po ilu cyklach �wiate�ko zawraca (skrajne si� �wieci). // 6.
    pozycja_�wiec�ca,
    pr�dko�� // 50.
      : integer;

    kierunek : char;

    zegar_Timer : TTimer;

    pasek_LED : array of TJvLED;

    procedure ZegarTimerTimer( Sender: TObject );
  public
    { Public declarations }
    constructor Create( rodzic_f : TWinControl; pozycja__lewo_f, pozycja__g�ra_f, elementy_ilo��_f, pr�dko��_f, op�nienie_zmiany_f : integer );
    destructor Free();

    procedure Op�nienie_Zmiany_Ustaw( op�nienie_zmiany_f : integer );
    procedure Predko��_Ustaw( pr�dko��_f : integer );
  end;

implementation

//Konstruktor klasy TMigawka.
constructor TMigawka.Create( rodzic_f : TWinControl; pozycja__lewo_f, pozycja__g�ra_f, elementy_ilo��_f, pr�dko��_f, op�nienie_zmiany_f : integer );
var
  i : integer;
begin

  //migawka := TMigawka.Create( Form1, 10, 20, 10, 50, 0 ); // Przyk�ad.

  //SetLength( Self.pasek_LED, 0 ); // Tak jakby na pocz�tku ju� by� pierwszy element.

  Self.elementy_ilo�� := elementy_ilo��_f - 1;
  Self.pozycja_�wiec�ca := 0;
  Self.kierunek := 'P';

  //Self.pr�dko�� := pr�dko��_f; // 50.
  //Self.op�nienie_zmiany := op�nienie_zmiany_f; // 6.
  Self.Op�nienie_Zmiany_Ustaw( op�nienie_zmiany_f );


  // Dodawanie elementu.
  for i := 0 to Self.elementy_ilo�� do
    begin

      SetLength( Self.pasek_LED, i + 1 );
      Self.pasek_LED[ i ] := TJvLED.Create( Application );
      Self.pasek_LED[ i ].Parent := rodzic_f;
      Self.pasek_LED[ i ].Left := pozycja__lewo_f + i * 13 {Self.pasek_LED[ i ].Width};
      Self.pasek_LED[ i ].Top := pozycja__g�ra_f;
      Self.pasek_LED[ i ].Status := false;
      Self.pasek_LED[ i ].ColorOff := clMaroon;
      Self.pasek_LED[ i ].ColorOn := clRed;

    end;
  //---//for i := 0 to Self.elementy_ilo�� do

  Self.zegar_Timer := TTimer.Create( Application );
  //Self.zegar_Timer.Interval := Self.pr�dko��;
  Self.zegar_Timer.OnTimer := ZegarTimerTimer;

  Self.Predko��_Ustaw( pr�dko��_f );

  Self.zegar_Timer.Enabled := true;

end;//---//Konstruktor klasy TMigawka.

//Destruktor klasy TMigawka.
destructor TMigawka.Free();
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

end;//---//Destruktor klasy TMigawka.

//ZegarTimerTimer().
procedure TMigawka.ZegarTimerTimer( Sender: TObject );
begin

  Self.zegar_Timer.Enabled := false;

  if Self.kierunek = 'P' then
    begin

      inc( Self.pozycja_�wiec�ca );

      if Self.pozycja_�wiec�ca <= Self.elementy_ilo�� then
        Self.pasek_LED[ Self.pozycja_�wiec�ca ].Status := true;

      if Self.pozycja_�wiec�ca <= Self.elementy_ilo�� then
        Self.pasek_LED[ Self.pozycja_�wiec�ca - 1 ].Status := false; // Skrajna nie ga�nie podczas odbijania (wygasza).

      // Wygaszanie.
      if    ( Self.pozycja_�wiec�ca >= 1 )
        and ( Self.pozycja_�wiec�ca <= Self.elementy_ilo�� + 1 ) then
        Self.pasek_LED[ Self.pozycja_�wiec�ca - 1 ].ColorOff := $000000E0;

      if    ( Self.pozycja_�wiec�ca >= 2 )
        and ( Self.pozycja_�wiec�ca <= Self.elementy_ilo�� + 2 ) then
        Self.pasek_LED[ Self.pozycja_�wiec�ca - 2 ].ColorOff := $000000C0;

      if    ( Self.pozycja_�wiec�ca >= 3 )
        and ( Self.pozycja_�wiec�ca <= Self.elementy_ilo�� + 3 ) then
        Self.pasek_LED[ Self.pozycja_�wiec�ca - 3 ].ColorOff := $000000A0;

     if    ( Self.pozycja_�wiec�ca >= 4 )
       and ( Self.pozycja_�wiec�ca <= Self.elementy_ilo�� + 4 ) then
        Self.pasek_LED[ Self.pozycja_�wiec�ca - 4 ].ColorOff := clMaroon;
     //---// Wygaszanie.

    end;
  //---//if Self.kierunek = 'P' then


  if Self.kierunek = 'L' then
    begin

      dec( Self.pozycja_�wiec�ca );

      if Self.pozycja_�wiec�ca >= 0 then
        Self.pasek_LED[ Self.pozycja_�wiec�ca ].Status := true;

      if Self.pozycja_�wiec�ca >= 0 then
        Self.pasek_LED[ Self.pozycja_�wiec�ca + 1 ].Status := false; // Skrajna nie ga�nie podczas odbijania (wygasza).

      // Wygaszanie.
      if    ( Self.pozycja_�wiec�ca <= Self.elementy_ilo�� - 1 )
        and ( Self.pozycja_�wiec�ca >= - 1 ) then
        Self.pasek_LED[ Self.pozycja_�wiec�ca + 1 ].ColorOff := $000000E0;

      if    ( Self.pozycja_�wiec�ca <= Self.elementy_ilo�� - 2 )
        and ( Self.pozycja_�wiec�ca >= - 2 ) then
        Self.pasek_LED[ Self.pozycja_�wiec�ca + 2 ].ColorOff := $000000C0;

      if    ( Self.pozycja_�wiec�ca <= Self.elementy_ilo�� - 3 )
        and ( Self.pozycja_�wiec�ca >= - 3 ) then
        Self.pasek_LED[ Self.pozycja_�wiec�ca + 3 ].ColorOff := $000000A0;

      if    ( Self.pozycja_�wiec�ca <= Self.elementy_ilo�� - 4 )
        and ( Self.pozycja_�wiec�ca >= - 4 ) then
        Self.pasek_LED[ Self.pozycja_�wiec�ca + 4 ].ColorOff := clMaroon;
     //---// Wygaszanie.

    end;
  //---//if Self.kierunek = 'P' then


  // Zmiana kierunku.
  if Self.pozycja_�wiec�ca = Self.elementy_ilo�� + Self.op�nienie_zmiany then
    begin

      Self.pozycja_�wiec�ca := Self.elementy_ilo��;
      Self.kierunek := 'L';

    end;
  //---//if Self.pozycja_�wiec�ca = Self.elementy_ilo�� + Self.op�nienie_zmiany then

  if Self.pozycja_�wiec�ca = -Self.op�nienie_zmiany then
    begin

      Self.pozycja_�wiec�ca := 0;
      Self.kierunek := 'P';

    end;
  //---//if Self.pozycja_�wiec�ca = -Self.op�nienie_zmiany then
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

//Op�nienie_Zmiany_Ustaw().
procedure TMigawka.Op�nienie_Zmiany_Ustaw( op�nienie_zmiany_f : integer );
begin

  if op�nienie_zmiany_f < 0 then
    op�nienie_zmiany_f := 0;

  Self.op�nienie_zmiany := op�nienie_zmiany_f;

end;//---//Op�nienie_Zmiany_Ustaw().

//Predko��_Ustaw().
procedure TMigawka.Predko��_Ustaw( pr�dko��_f : integer );
begin

  if pr�dko��_f < 1 then
    pr�dko��_f := 1;

  Self.pr�dko�� := pr�dko��_f;

  Self.zegar_Timer.Interval := Self.pr�dko��;

end;//---//Predko��_Ustaw().

end.
