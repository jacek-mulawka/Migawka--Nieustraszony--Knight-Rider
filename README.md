# Migawka--Nieustraszony--Knight-Rider

Wariacje na temat czerwonej migającej 'lampki' będącej na wyposażeniu samochodu K.I.T.T.

Oprócz kilku wariantów wizualizacji czysto programowej

<img src="https://github.com/jacek-mulawka/Migawka--Nieustraszony--Knight-Rider/blob/main/Gallery/LED_Test.jpg">

jest również projekt skonstruowania fizycznej migawki w oparciu o Arduino i cyfrową taśmę LED.

<img src="https://github.com/jacek-mulawka/Migawka--Nieustraszony--Knight-Rider/blob/main/Gallery/Migawka%20arduino.jpg">


Wybrałem:
* [Arduino Nano Every](https://store.arduino.cc/products/arduino-nano-every) ze względu na mały rozmiar;
* taśmę diod [Adafruit NeoPixel Digital RGB LED Strip - Black 60 LED – BLACK](https://www.adafruit.com/product/1461?length=1) (została przycięta do 15 diod).

Dodatkowo potrzeba:
* 1 kondensator (500 - 1`000 µF na 6.3V lub więcej);
* 1 opornik (300 - 500 Ohm);
* trochę przewodów.

Biblioteka do sterowania taśmą LED [Adafruit NeoPixel Library](https://github.com/adafruit/Adafruit_NeoPixel).

W przypadku mojej realizacji za obudowę posłużyła mi samochodowa trzecia lampa stop, wewnątrz której zmieścił się cały układ.

Według dokumentacji jeden segment taśmy pobiera maksymalnie 5V 60mA gdy wszystkie diody świecą pełną jasnością (I).

Arduino Nano Every na pinie +5V dostarcza moc 950 mA dla dołączanych urządzeń. W układzie znajduje się 15 LED x 60 mA = 900 mA, przy czym używam tylko koloru czerwonego i tylko na początku zapalam wszystkie diody więc nawet podczas maksymalnego obciążenia układu powinien zostać spory zapas mocy:
* 1 RGB LED = 3 x LED;
* 60 mA (1 RGB LED) = 3 x 20 mA (3 x 1 LED);
* 15 x 20 mA = __300 mA__.

<img src="https://github.com/jacek-mulawka/Migawka--Nieustraszony--Knight-Rider/blob/main/Gallery/Arduino%20Nano%20Every%20power%20tree.gif">

[Grafika pochodzi z Arduino Nano Every datasheet](https://docs.arduino.cc/resources/datasheets/ABX00028-datasheet.pdf).


Docelowo układ jest zasilany wprost z samochodowej instalacji 12V poprzez pin VIN, który akceptuje zakres napięć 7 - 21V (II).

Podczas budowy zasilałem układ poprzez USB.

Schemat układu (system diagram):

<img src="https://github.com/jacek-mulawka/Migawka--Nieustraszony--Knight-Rider/blob/main/Gallery/Migawka%20schemat.gif">

Nagranie z działania (operation recording):

<img src="https://github.com/jacek-mulawka/Migawka--Nieustraszony--Knight-Rider/blob/main/Gallery/Migawka%20arduino.gif">

Na drogach publicznych nie wolno używać takiego oświetlenia pojazdu.


## English

Variations on the theme of the red flashing 'lamp' which is the equipment of the car K.I.T.T.

Apart from a few variants of purely software visualizations

there is also a project to construct a physical shutter based on an Arduino and a digital LED strip.

I chose:
* [Arduino Nano Every](https://store.arduino.cc/products/arduino-nano-every) due to its small size;
* LED strip [Adafruit NeoPixel Digital RGB LED Strip - Black 60 LED – BLACK](https://www.adafruit.com/product/1461?length=1) (it has been trimmed to 15 LEDs).

Additionally, you need:
* 1 capacitor (500 - 1`000 µF at 6.3V or more);
* 1 resistor (300 - 500 Ohm);
* some wires.

Library to control the LED strip  [Adafruit NeoPixel Library](https://github.com/adafruit/Adafruit_NeoPixel).

In the case of my project, I used a car third stop lamp as the housing, inside which the whole system could fit.

According to the documentation, one LED strip segment consumes a maximum of 5V 60mA when all the LEDs are on full brightness (I).

Arduino Nano Every on pin +5V provides 950 mA power for attached devices. The system has 15 LEDs x 60 mA = 900 mA, but I only use the red color and only at the beginning I light all the LEDs, so even when the system use maximum power consumption, there should be a large reserve of power:
* 1 RGB LED = 3 x LED;
* 60 mA (1 RGB LED) = 3 x 20 mA (3 x 1 LED);
* 15 x 20 mA = __300 mA__.

[Graphics are from Arduino Nano Every datasheet](https://docs.arduino.cc/resources/datasheets/ABX00028-datasheet.pdf).

Ultimately, the system is powered directly from the car's 12V installation through the VIN pin, which accepts a voltage range of 7 - 21V (II).

During construction, I powered the chip via USB.

Such vehicle lighting must not be used on public roads.


## Przypisy (notes)
[(I)](https://www.adafruit.com/product/1461?length=1) Maximum 5V @ 60mA draw per 0.65" strip segment (all LEDs on full brightness.

[(II)](https://store.arduino.cc/products/arduino-nano-every) Vin: This pin can be used to power the board with a DC voltage source. If the power is fed through this pin, the USB power source is disconnected. This pin is an INPUT. Respect the voltage limits of 7-21V to assure the proper functionality of the board.
