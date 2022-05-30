// 12.Kwi.2022

  //
  // MIT License
  //
  // Copyright (c) 2022 Jacek Mulawka
  //
  // j.mulawka@interia.pl
  //
  // https://github.com/jacek-mulawka
  //


#include <Adafruit_NeoPixel.h>

#ifdef __AVR__
 #include <avr/power.h> // Required for 16 MHz Adafruit Trinket
#endif

typedef enum { mt_Migaj, mt_Powitanie, mt_Powitanie_W_Trakcie } TMigawka_Tryb;
typedef enum { ds_Mignij, ds_Nie_Swieci, ds_Swieci, ds_Wylacz, ds_Zaswiec } TDioda_Stan;

const int pin__sygnalowy_c = 2;
const int diody_ilosc_c = 15;

Adafruit_NeoPixel pixels( diody_ilosc_c, pin__sygnalowy_c, NEO_GRB + NEO_KHZ800 );

const int czerwien_poziom_najmniejszy_c = 0;
const int czerwien_poziom_najwiekszy_c = 255;

const int predkosc_c = 75; // Prędkość zapalania kolejnych diod (jest to właściwie opóźnienie względem głównej pętli).

const int rozjasnianie_szybkosc_c = 10;
const int wygaszaniey_szybkosc_c = 5;

const int kolor__r_c = 255;
const int kolor__g_c = 0;
const int kolor__b_c = 0;
const int petla_opoznienie_milisekund_c = 5; // Przerwa pętli głównej.


boolean kierunek_w_gore_g = true; // Diody zapalają się względem indeksu na taśmie: false - malejąco; true - rosnąco.
int pozycja_swiecaca_g = 0;
int predkosc_licznik_g = 0;

int dioda__kolor_aktualny_t[ diody_ilosc_c ];
TDioda_Stan dioda__stan_t[ diody_ilosc_c ];

TMigawka_Tryb migawka_tryb_g = mt_Powitanie;


void Dioda_Kolor_Ustaw( int dioda_indeks_f, int kolor_f );

void setup()
{
  // put your setup code here, to run once:

  // These lines are specifically to support the Adafruit Trinket 5V 16 MHz.
  // Any other board, you can remove this part (but no harm leaving it):
#if defined( __AVR_ATtiny85__ ) && ( F_CPU == 16000000 )
  clock_prescale_set( clock_div_1 );
#endif
  // END of Trinket-specific code.


  randomSeed(  analogRead( A0 )  );

  kierunek_w_gore_g = random( 2 ) == 1;

  if ( !kierunek_w_gore_g )
    pozycja_swiecaca_g = diody_ilosc_c - 1;


  for ( int i = 0; i < diody_ilosc_c; i++ )
    {
      dioda__kolor_aktualny_t[ i ] = czerwien_poziom_najmniejszy_c;
      dioda__stan_t[ i ] = ds_Wylacz;
    }
  //---//for ( int i = 0; i < diody_ilosc_c; i++ )


  pinMode( LED_BUILTIN, OUTPUT );

  pixels.begin(); // INITIALIZE NeoPixel strip object (REQUIRED).
  pixels.clear(); // Set all pixel colors to 'off'.

}

void loop()
{
  // put your main code here, to run repeatedly:

  int i = 0;


  if ( migawka_tryb_g == mt_Migaj )
    {

      predkosc_licznik_g = predkosc_licznik_g + petla_opoznienie_milisekund_c;

      if ( predkosc_licznik_g >= predkosc_c )
        {

          digitalWrite(  LED_BUILTIN, !digitalRead( LED_BUILTIN )  );


          predkosc_licznik_g = 0;

          dioda__stan_t[ pozycja_swiecaca_g ] = ds_Mignij;


          if ( kierunek_w_gore_g )
            {

              if ( pozycja_swiecaca_g >= diody_ilosc_c - 1 )
                {

                  // Zmiana kierunku.

                  kierunek_w_gore_g = false;

                  pozycja_swiecaca_g--; // Skrajny element już się świeci i nie jest po raz kolejny rozświetlany.

                }
              else//if ( pozycja_swiecaca_g >= diody_ilosc_c - 1 )
                pozycja_swiecaca_g++;

            }
          else//if ( kierunek_w_gore_g )
            {

              if ( pozycja_swiecaca_g <= 0 )
                {

                  // Zmiana kierunku.

                  kierunek_w_gore_g = true;

                  pozycja_swiecaca_g++; // Skrajny element już się świeci i nie jest po raz kolejny rozświetlany.

                }
              else//if ( pozycja_swiecaca_g <= 0 )
                pozycja_swiecaca_g--;

            }
          //---//if ( kierunek_w_gore_g )

        }
      //---/if ( predkosc_licznik_g >= predkosc_c )

    }
  else//if ( migawka_tryb_g == mt_Migaj )
  if (
          ( migawka_tryb_g == mt_Powitanie )
       //|| ( migawka_tryb_g == ds_Zaswiec )
     )
    {

      for ( i = 0; i < diody_ilosc_c; i++ )
        switch ( migawka_tryb_g )
            {
              case mt_Powitanie :
                dioda__stan_t[ i ] = ds_Mignij;
                break;
              //case mt_Wylacz :
              //  dioda__stan_t[ i ] = ds_Wylacz;
              //  break;
              //case mt_Zaswiec :
              //  dioda__stan_t[ i ] = ds_Zaswiec;
              //  break;
            }
        //---//switch ( migawka_tryb_g )


      if ( migawka_tryb_g == mt_Powitanie )
        migawka_tryb_g = mt_Powitanie_W_Trakcie;

    }
  else//if ( kierunek_w_gore_g )
  if( migawka_tryb_g == mt_Powitanie_W_Trakcie )
    {

      digitalWrite(  LED_BUILTIN, !digitalRead( LED_BUILTIN )  );


      predkosc_licznik_g = 0; // Tutaj tymczasowo sprawdza czy wszystkie diody zgasły.

      for ( i = 0; i < diody_ilosc_c; i++ )
        if ( dioda__stan_t[ i ] != ds_Nie_Swieci )
          {

            predkosc_licznik_g = 1;
            break;

          }
        //---//if ( dioda__stan_t[ i ] != ds_Nie_Swieci )


      if ( predkosc_licznik_g == 0 )
        {

          migawka_tryb_g = mt_Migaj;

          delay( 1500 ); // Przerwa między trybem powitania a przejściem do trybu migania.

        }
      else//if ( predkosc_licznik_g == 0 )
        {

          predkosc_licznik_g = 0;

          delay( petla_opoznienie_milisekund_c * 10 ); // Spowalnia rozjaśnianie i wygaszanie diod w trybie mt_Powitanie_W_Trakcie.

        }
      //---//if ( predkosc_licznik_g == 0 )

    }
  //---//if( migawka_tryb_g == mt_Powitanie_W_Trakcie )


  // Steruje jasnością diod.
  for ( i = 0; i < diody_ilosc_c; i++ )
    {

      if (
              ( dioda__stan_t[ i ] == ds_Mignij )
           || ( dioda__stan_t[ i ] == ds_Zaswiec )
         )
        {

          if ( dioda__kolor_aktualny_t[ i ] < czerwien_poziom_najwiekszy_c )
            dioda__kolor_aktualny_t[ i ] = dioda__kolor_aktualny_t[ i ] + rozjasnianie_szybkosc_c;

          if ( dioda__kolor_aktualny_t[ i ] > czerwien_poziom_najwiekszy_c )
            dioda__kolor_aktualny_t[ i ] = czerwien_poziom_najwiekszy_c;

          if ( dioda__kolor_aktualny_t[ i ] == czerwien_poziom_najwiekszy_c )
            {

              if ( dioda__stan_t[ i ] == ds_Mignij )
                dioda__stan_t[ i ] = ds_Wylacz;
              else//if ( dioda__stan_t[ i ] == ds_Mignij )
              if ( dioda__stan_t[ i ] == ds_Zaswiec )
                dioda__stan_t[ i ] = ds_Swieci;

            }
          //---//if ( dioda__kolor_aktualny_t[ i ] == czerwien_poziom_najwiekszy_c )

        }
      else//if ( (...)
      if ( dioda__stan_t[ i ] == ds_Wylacz )
        {

          if ( dioda__kolor_aktualny_t[ i ] > czerwien_poziom_najmniejszy_c )
            dioda__kolor_aktualny_t[ i ] = dioda__kolor_aktualny_t[ i ] - wygaszaniey_szybkosc_c;

          if ( dioda__kolor_aktualny_t[ i ] < czerwien_poziom_najmniejszy_c )
            dioda__kolor_aktualny_t[ i ] = czerwien_poziom_najmniejszy_c;

          if ( dioda__kolor_aktualny_t[ i ] == czerwien_poziom_najmniejszy_c )
            dioda__stan_t[ i ] = ds_Nie_Swieci;

        }
      //---//if ( dioda__stan_t[ i ] == ds_Wylacz )


      Dioda_Kolor_Ustaw( i, dioda__kolor_aktualny_t[ i ] );

    }
  //---//for ( i = 0; i < diody_ilosc_c; i++ )
  //---// Steruje jasnością diod.


  pixels.show(); // Send the updated pixel colors to the hardware.


  delay( petla_opoznienie_milisekund_c );

}

void Dioda_Kolor_Ustaw( int dioda_indeks_f, int kolor_f )
{

  //
  // Funkcja ustawia kolor diody.
  //
  // Parametry:
  //   dioda_indeks_f - indeks diody
  //   kolor_f - jasność koloru
  //

  if (
          ( dioda_indeks_f < 0 )
       || ( dioda_indeks_f > diody_ilosc_c - 1 )
     )
    return;


  if ( kolor_f > 255 )
    kolor_f = 255;
  else//if ( kolor_f > 255 )
  if ( kolor_f < 0 )
    kolor_f = 0;


  pixels.setPixelColor(  dioda_indeks_f, pixels.Color( kolor_f, kolor__g_c, kolor__b_c )  );

}
