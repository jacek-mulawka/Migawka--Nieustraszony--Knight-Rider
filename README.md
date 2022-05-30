# Migawka--Nieustraszony--Knight-Rider

Wariacje na temat czerwonej migającej 'lampki' będącej na wyposażeniu samochodu K.I.T.T.

Oprócz kilku wariantów wizualizacji czysto programowej

<img src="https://github.com/jacek-mulawka/Migawka--Nieustraszony--Knight-Rider/blob/main/Gallery/LED_Test.jpg">

jest również projekt skonstruowania fizycznej migawki w oparciu o Arduino i cyfrową taśmę LED.

<img src="https://github.com/jacek-mulawka/Migawka--Nieustraszony--Knight-Rider/blob/main/Gallery/Migawka%20arduino.jpg">


Wybrałem:
* [Arduino Nano Every](https://store.arduino.cc/products/arduino-nano-every) ze względu na mały rozmiar

* taśmę diod [Adafruit NeoPixel Digital RGB LED Strip - Black 60 LED – BLACK](https://www.adafruit.com/product/1461?length=1)

Dodatkowo potrzeba:
* 1 kondensator (500 - 1`000 µF na 6.3V lub więcej);
* 1 opornik (300 - 500 Ohm);
* trochę przewodów.

Biblioteka do sterowania taśmą LED [Adafruit NeoPixel Library](https://github.com/adafruit/Adafruit_NeoPixel)

W przypadku mojej realizacji za obudowę posłużyła mi samochodowa trzecia lampa stop, wewnątrz której zmieścił się cały układ.

Według dokumentacji jeden segment taśmy pobiera maksymalnie 5V 60mA gdy wszystkie diody świecą pełną jasnością (I).

Arduino Nano Every na pinie +5V dostarcza moc 950 mA dla dołączanych urządzeń. W układzie znajduje się 15 LED x 60 mA = 900 mA, przy czym używam tylko koloru czerwonego i tylko na początku zapalam wszystkie diody więc nawet podczas maksymalnego obciążenia układu powinien zostać spory zapas mocy:
* 1 RGB LED = 3 x LED;
* 60 mA (1 RGB LED) = 3 x 20 mA (3 x 1 LED);
* 15 x 20 mA = 300 mA.

<img src="https://github.com/jacek-mulawka/Migawka--Nieustraszony--Knight-Rider/blob/main/Gallery/Arduino%20Nano%20Every%20power%20tree.gif">

[Grafika pochodzi z Arduino Nano Every datasheet](https://docs.arduino.cc/resources/datasheets/ABX00028-datasheet.pdf).


Docelowo układ jest zasilany wprost z samochodowej instalacji 12V poprzez pin VIN, który akceptuje zakres napięć 7 - 21V (II).

Podczas budowy zasilałem układ poprzez USB.

Schemat układu:

<img src="https://github.com/jacek-mulawka/Migawka--Nieustraszony--Knight-Rider/blob/main/Gallery/Migawka%20schemat.gif">

Nagranie z działania:

<img src="https://github.com/jacek-mulawka/Migawka--Nieustraszony--Knight-Rider/blob/main/Gallery/Migawka%20arduino.gif">

Na drogach publicznych nie wolno używać takiego oświetlenia pojazdu.

[(I)](https://www.adafruit.com/product/1461?length=1) Maximum 5V @ 60mA draw per 0.65" strip segment (all LEDs on full brightness.

[(II)](https://store.arduino.cc/products/arduino-nano-every) Vin: This pin can be used to power the board with a DC voltage source. If the power is fed through this pin, the USB power source is disconnected. This pin is an INPUT. Respect the voltage limits of 7-21V to assure the proper functionality of the board.
