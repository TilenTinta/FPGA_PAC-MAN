

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity grafika is
 port (
   clk  : in std_logic;
   x, y : in unsigned(11 downto 0);
	x1, y1 : in unsigned(11 downto 0);
	rgb  : out unsigned(5 downto 0);
	trk  : out std_logic;
	reset  : in std_logic;
	stopup : out std_logic := '0';
	stopdn : out std_logic := '0';
	stopleft : out std_logic := '0';
	stopright : out std_logic:= '0';
	debug  : out std_logic
 );
end grafika;

architecture RTL of grafika is
 
-- /// LABIRINT (Bloki in osnova) ///
type deklaracija is array (0 to 29, 0 to 39) of integer range 0 to 31; --(y,x)
signal Osnova: deklaracija:=(
(00,00,00,00,00,00,03,01,01,01,01,01,01,01,01,01,01,01,01,21,22,01,01,01,01,01,01,01,01,01,01,01,01,04,00,00,00,00,00,00),
(00,00,00,00,00,00,02,28,28,28,28,28,28,28,28,28,28,28,28,09,10,28,28,28,28,28,28,28,28,28,28,28,28,02,00,00,00,00,00,00),
(00,00,30,30,30,00,02,28,11,08,08,12,28,11,08,08,08,12,28,09,10,28,11,08,08,08,12,28,11,08,08,12,28,02,00,27,27,27,00,00),
(00,00,00,00,00,00,02,29,09,00,00,10,28,09,00,00,00,10,28,09,10,28,09,00,00,00,10,28,09,00,00,10,29,02,00,00,00,00,00,00),
(00,00,00,00,00,00,02,28,14,07,07,13,28,14,07,07,07,13,28,14,13,28,14,07,07,07,13,28,14,07,07,13,28,02,00,00,00,00,00,00),
(00,00,00,00,00,00,02,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,02,00,00,00,00,00,00),
(00,00,00,00,00,00,02,28,19,01,01,20,28,11,12,28,19,01,01,21,22,01,01,20,28,11,12,28,19,01,01,20,28,02,00,00,00,00,00,00),
(00,00,00,00,00,00,02,28,28,28,28,28,28,09,10,28,28,28,28,09,10,28,28,28,28,09,10,28,28,28,28,28,28,02,00,00,00,00,00,00),
(00,00,00,00,00,00,05,01,01,01,01,04,28,09,18,08,08,12,00,09,10,00,11,08,08,17,10,28,03,01,01,01,01,06,00,00,00,00,00,00),
(00,00,00,00,00,00,00,00,00,00,00,02,28,09,15,07,07,13,00,14,13,00,14,07,07,16,10,28,02,00,00,00,00,00,00,00,00,00,00,00),
(00,00,00,00,00,00,00,00,00,00,00,02,28,09,10,00,00,00,00,00,00,00,00,00,00,09,10,28,02,00,00,00,00,00,00,00,00,00,00,00),
(00,00,00,00,00,00,00,00,00,00,00,02,28,09,10,00,03,01,20,00,00,19,01,04,00,09,10,28,02,00,00,00,00,00,00,00,00,00,00,00),
(00,00,00,00,00,00,01,01,01,01,01,06,28,14,13,00,02,00,00,00,00,00,00,02,00,14,13,28,05,01,01,01,01,01,00,00,00,00,00,00),
(00,00,00,00,00,00,00,00,00,00,00,00,28,00,00,00,02,00,00,00,00,00,00,02,00,00,00,28,00,00,00,00,00,00,00,00,00,00,00,00),
(00,00,00,00,00,00,01,01,01,01,01,04,28,11,12,00,02,00,00,00,00,00,00,02,00,11,12,28,03,01,01,01,01,01,00,00,00,00,00,00),
(00,00,00,00,00,00,00,00,00,00,00,02,28,09,10,00,05,01,01,01,01,01,01,06,00,09,10,28,02,00,00,00,00,00,00,00,00,00,00,00),
(00,00,00,00,00,00,00,00,00,00,00,02,28,09,10,00,00,00,00,00,00,00,00,00,00,09,10,28,02,00,00,00,00,00,00,00,00,00,00,00),
(00,00,00,00,00,00,00,00,00,00,00,02,28,09,10,00,11,08,08,08,08,08,08,12,00,09,10,28,02,00,00,00,00,00,00,00,00,00,00,00),
(00,00,00,00,00,00,03,01,01,01,01,06,28,14,13,00,14,07,07,16,15,07,07,13,00,14,13,28,05,01,01,01,01,04,00,00,00,00,00,00),
(00,00,00,00,00,00,02,28,28,28,28,28,28,28,28,28,28,28,28,09,10,28,28,28,28,28,28,28,28,28,28,28,28,02,00,00,00,00,00,00),
(00,00,00,00,00,00,02,28,11,08,08,12,28,11,08,08,08,12,28,09,10,28,11,08,08,08,12,28,11,08,08,12,28,02,00,00,00,00,00,00),
(00,00,00,00,00,00,02,28,14,07,16,10,28,14,07,07,07,13,28,14,13,28,14,07,07,07,13,28,09,15,07,13,28,02,00,00,00,00,00,00),
(00,00,00,00,00,00,02,29,28,28,09,10,28,28,28,28,28,28,28,00,00,28,28,28,28,28,28,28,09,10,28,28,29,02,00,00,00,00,00,00),
(00,00,00,00,00,00,24,08,12,28,09,10,28,11,12,28,11,08,08,08,08,08,08,12,28,11,12,28,09,10,28,11,08,25,00,00,00,00,00,00),
(00,00,00,00,00,00,23,07,13,28,14,13,28,09,10,28,14,07,07,16,15,07,07,13,28,09,10,28,14,13,28,14,07,26,00,00,00,00,00,00),
(00,00,00,00,00,00,02,28,28,28,28,28,28,09,10,28,28,28,28,09,10,28,28,28,28,09,10,28,28,28,28,28,28,02,00,00,00,00,00,00),
(00,00,00,00,00,00,02,28,11,08,08,08,08,17,18,08,08,12,28,09,10,28,11,08,08,17,18,08,08,08,08,12,28,02,00,00,00,00,00,00),
(00,00,00,00,00,00,02,28,14,07,07,07,07,07,07,07,07,13,28,14,13,28,14,07,07,07,07,07,07,07,07,13,28,02,00,00,00,00,00,00),
(00,00,00,00,00,00,02,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,02,00,00,00,00,00,00),
(00,00,00,00,00,00,05,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,06,00,00,00,00,00,00));

-- /// Bloki za grajenje labirinta ///
constant Blok_Blank: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" & 
"00000000000000000000" &
"00000000000000000000" );

constant Blok_Lines: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"11111111111111111111" &
"11111111111111111111" &
"11111111111111111111" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"11111111111111111111" &
"11111111111111111111" & 
"11111111111111111111" &
"00000000000000000000" );

constant Blok_Line: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"11111111111111111111" &
"11111111111111111111" & 
"11111111111111111111" &
"00000000000000000000" );

constant Blok_Lines_corner: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000000111111111111" &
"00000000111111111111" &
"00000011111111111111" &
"00000011100000000000" &
"00001111000000000000" &
"00001110000000000000" &
"00111100000000000000" &
"00111000000000000000" &
"01110000000000000000" &
"01110000000000000000" &
"01110000000000000000" &
"01110000000000000000" &
"01110000000000000000" &
"01110000000000000000" &
"01110000000000000000" &
"01110000000000000001" &
"01110000000000000011" &
"01110000000000000111" &
"01110000000000001110" );

constant Blok_Line_corner: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000000111111111111" &
"00000000111111111111" &
"00000011111111111111" &
"00000011100000000000" &
"00001111000000000000" &
"00001110000000000000" &
"00111100000000000000" &
"00111000000000000000" &
"01110000000000000000" &
"01110000000000000000" &
"01110000000000000000" &
"01110000000000000000" &
"01110000000000000000" &
"01110000000000000000" &
"01110000000000000000" &
"01110000000000000000" &
"01110000000000000000" & 
"01110000000000000000" &
"01110000000000000000" );

constant Blok_Line_corner_inner: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000001" &
"00000000000000000011" &
"00000000000000000111" &
"00000000000000001110" );

constant Blok_cap: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000000011111111111" &
"00000011111111111111" &
"00000111111111111111" &
"00001110000000000000" &
"00011100000000000000" &
"00011100000000000000" &
"00111000000000000000" &
"00111000000000000000" &
"01110000000000000000" &
"01110000000000000000" &
"00111000000000000000" &
"00111000000000000000" &
"00011100000000000000" &
"00011100000000000000" &
"00001110000000000000" &
"00000111111111111111" &
"00000011111111111111" & 
"00000000011111111111" &
"00000000000000000000" );

constant Blok_Lines_split: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"11111111111111111111" &
"11111111111111111111" &
"11111111111111111111" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"11000000000000000000" &
"11100000000000000000" & 
"11110000000000000000" &
"01110000000000000000" );

-- /// Pacman ///
constant Pac1: unsigned(0 to (20*20)-1) := ( 
"00000000000000000000" &
"00000001111110000000" &
"00000011111111000000" &
"00000111111111100000" &
"00001111111111110000" &
"00011111111111111000" &
"00111111111111111100" &
"01111111111111111110" &
"01111111111111111110" &
"01111111111111111110" &--
"01111111111111111110" &
"01111111111111111110" &
"01111111111111111110" &
"00111111111111111100" &
"00011111111111111000" &
"00001111111111110000" &
"00000111111111100000" &
"00000011111111000000" & 
"00000001111110000000" &
"00000000000000000000" ); 

constant Pac2: unsigned(0 to (20*20)-1) := ( 
"00000000000000000000" &
"00000001111110000000" &
"00000011111111000000" &
"00000111111111100000" &
"00001111111111110000" &
"00011111111111111000" &
"00111111111111110000" &
"01111111111111000000" &
"01111111111100000000" &
"01111111111000000000" &--
"01111111111100000000" &
"01111111111111000000" &
"01111111111111110000" &
"00111111111111111000" &
"00011111111111111000" &
"00001111111111110000" &
"00000111111111100000" &
"00000011111111000000" & 
"00000001111110000000" &
"00000000000000000000" ); 

constant Pac3: unsigned(0 to (20*20)-1) := ( 
"00000000000000000000" &
"00000001111110000000" &
"00000011111111000000" &
"00000111111111100000" &
"00001111111111110000" &
"00011111111111110000" &
"00111111111111000000" &
"01111111111100000000" &
"01111111111000000000" &
"01111111110000000000" &--
"01111111111000000000" &
"01111111111100000000" &
"01111111111110000000" &
"00111111111111000000" &
"00011111111111100000" &
"00001111111111110000" &
"00000111111111100000" &
"00000011111111000000" & 
"00000001111110000000" &
"00000000000000000000" ); 

-- /// Duhec ///
constant Duhec: unsigned(0 to (20*20)-1) := ( 
"00000000000000000000" &
"00000001111100000000" &
"00000111111111000000" &
"00011111111111110000" &
"00011111111111110000" &
"00111111111111111000" &
"01111000011000011000" &
"01111000011000011100" &
"01111100011100011100" &
"01111111111111111100" &
"01111111111111111100" &
"01111111111111111100" &
"01111111111111111100" &
"01111111111111111100" &
"01111111111111111100" &
"01111111111111111100" &
"01110111110111101100" &
"01100011100011101100" & 
"01000001000001000100" &
"00000000000000000000" );

-- /// Tocka ///
constant Tocka: unsigned(0 to (20*20)-1) := ( 
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000011000000000" &
"00000000111100000000" &--
"00000000011000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" & 
"00000000000000000000" &
"00000000000000000000" ); 

-- /// Bonus ///
constant Bonus: unsigned(0 to (20*20)-1) := ( 
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000111110000000" &
"00000011111111100000" &
"00000111111111110000" &
"00001111111111111000" &
"00011111111111111100" &
"00011111111111111100" &
"00011111111111111100" &--
"00011111111111111100" &
"00011111111111111100" &
"00001111111111111000" &
"00000111111111110000" &
"00000001111111000000" &
"00000000011100000000" &
"00000000000000000000" &
"00000000000000000000" & 
"00000000000000000000" &
"00000000000000000000" ); 

-- /// Stevilke ///
constant Stevilka_0: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000000111100000000" &
"00011111111111111000" &
"00111110000001111100" &
"01111000000000011110" &
"01110000000000001110" &
"01110000000000001110" &
"01110000000000001110" &
"01110000000000001110" &
"01110000000000001110" &
"01110000000000001110" &
"01110000000000001110" &
"01110000000000001110" &
"01110000000000001110" &
"01110000000000001110" &
"01111000000000011110" &
"00111110000001111100" &
"00011111111111111000" & 
"00000000111100000000" &
"00000000000000000000" );

constant Stevilka_1: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000000000000000000" &
"00000000011100000000" &
"00000000111100000000" &
"00000011111100000000" &
"00000111111100000000" &
"00001110111100000000" &
"00011100111100000000" &
"00000000111100000000" &
"00000000111100000000" &
"00000000111100000000" &
"00000000111100000000" &
"00000000111100000000" &
"00000000111100000000" &
"00000000111100000000" &
"00000000111100000000" &
"00001111111111110000" & 
"00001111111111110000" &
"00000000000000000000" &
"00000000000000000000" );

constant Stevilka_2: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000000011100000000" &
"00000011111111000000" &
"00000111100011100000" &
"00000111000001110000" &
"00000000000001110000" &
"00000000000011110000" &
"00000000000111100000" &
"00000000001111000000" &
"00000000011110000000" &
"00000000111100000000" &
"00000001111000000000" &
"00000011110000000000" &
"00000111100000000000" &
"00001111000000000000" &
"00011110000000000000" &
"00111111111111111100" &
"00111111111111111100" & 
"00000000000000000000" &
"00000000000000000000" );

constant Stevilka_3: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000000011100000000" &
"00000011111111000000" &
"00000111100011100000" &
"00000111000001110000" &
"00000000000001110000" &
"00000000000011110000" &
"00000000000011100000" &
"00000000000111100000" &
"00000001111110000000" &
"00000001111100000000" &
"00000000000111100000" &
"00000000000011100000" &
"00000000000011110000" &
"00000000000001110000" &
"00000111000001110000" &
"00000111100011100000" &
"00000011111111000000" & 
"00000000011100000000" &
"00000000000000000000" );

constant Stevilka_4: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000000000000000000" &
"00000000001110000000" &
"00000000011100000000" &
"00000000111000000000" &
"00000001110000000000" &
"00000011100000000000" &
"00000111000000000000" &
"00001110000000000000" &
"00011100111100000000" &
"00111000111100000000" &
"00111111111111110000" &
"00111111111111110000" &
"00000000111100000000" &
"00000000111100000000" &
"00000000111100000000" &
"00000000111100000000" & 
"00000000111100000000" &
"00000000111100000000" &
"00000000000000000000" );

constant Stevilka_5: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000011111111100000" &
"00000011111111100000" &
"00000011100000000000" &
"00000011100000000000" &
"00000011100000000000" &
"00000011100000000000" &
"00000011100000000000" &
"00000011111111000000" &
"00000000000011100000" &
"00000000000001110000" &
"00000000000001111000" &
"00000000000001111000" &
"00000111000001110000" &
"00000111100011100000" &
"00000011111111000000" & 
"00000000011100000000" &
"00000000000000000000" );

constant Stevilka_6: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000000000000000000" &
"00000000000000000000" &
"00000000111111000000" &
"00000011100011100000" &
"00000111000001110000" &
"00001110000000000000" &
"00001110000000000000" &
"00001110000000000000" &
"00001111100000000000" &
"00001111111111000000" &
"00001110000011100000" &
"00001110000001110000" &
"00001110000001111000" &
"00001110000001111000" &
"00000111000001110000" &
"00000111100011100000" &
"00000011111111000000" & 
"00000000011100000000" &
"00000000000000000000" );

constant Stevilka_7: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000011111111111100" &
"00000011111111111100" &
"00000011111111111100" &
"00000000000001111100" &
"00000000000001111000" &
"00000000000011110000" &
"00000000000111100000" &
"00000000001111000000" &
"00000000011110000000" &
"00000000111100000000" &
"00000001111000000000" &
"00000011110000000000" &
"00000111100000000000" &
"00001111000000000000" &
"00011110000000000000" &
"00011110000000000000" &
"00000000000000000000" & 
"00000000000000000000" &
"00000000000000000000" );

constant Stevilka_8: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000000111100000000" &
"00000011111111000000" &
"00000111100011100000" &
"00000111000001110000" &
"00000111000001110000" &
"00000111000001110000" &
"00000111000001100000" &
"00000011100111100000" &
"00000001111110000000" &
"00000001111100000000" &
"00000011100011100000" &
"00000111000001110000" &
"00000111000001100000" &
"00000111000001110000" &
"00000111000001110000" &
"00000111100011100000" &
"00000011111111000000" & 
"00000000111100000000" &
"00000000000000000000" );

constant Stevilka_9: unsigned(0 to(20*20)-1) := ( 
"00000000000000000000" &
"00000000111100000000" &
"00000011111111000000" &
"00000111100011100000" &
"00000111000001110000" &
"00000111000001110000" &
"00000111000001110000" &
"00000111000001110000" &
"00000011100001110000" &
"00000000111111110000" &
"00000000000111110000" &
"00000000000011110000" &
"00000000000001110000" &
"00000000000001100000" &
"00000000000001110000" &
"00000111000001110000" &
"00000111100011100000" &
"00000011111111000000" & 
"00000000111100000000" &
"00000000000000000000" );


 -- Igra
 signal d : unsigned(23 downto 0);
 signal cnt : unsigned(5 downto 0);
 signal lives : unsigned(1 downto 0);
 signal tocke : unsigned(7 downto 0) := (others => '0');
 signal enice : unsigned(7 downto 0) := (others => '0');
 signal desetice : unsigned(7 downto 0) := (others => '0');
 signal stotice : unsigned(7 downto 0) := (others => '0');
 signal tocke_izpis : unsigned(7 downto 0) := (others => '0');
 signal tocke_data : std_logic;
 signal start : std_logic;
 signal trk_init : std_logic;
 signal ponastavi : std_logic := '0';
 signal rst_x, rst_y : unsigned(5 downto 0);
 signal combo : unsigned(2 downto 0):= "001"; -- usak duhec, ki ga pojes plus 1
 
 -- Pacman
 signal data : std_logic := '0';
 signal xt, yt: unsigned(11 downto 0);
 signal x1_old, y1_old: unsigned(11 downto 0);
 signal smer: unsigned(1 downto 0):= "00";  --Pacman: 0 = desno, 1 = levo, 2 = gor, 3 = dol
 signal cntMounth : unsigned(31 downto 0);
 signal cntMan : unsigned(2 downto 0);
 signal x_pac_maze_cnt, y_pac_maze_cnt : unsigned(5 downto 0); -- lokacija v labirintu 
 signal x_pac_block_cnt, y_pac_block_cnt : unsigned(4 downto 0); -- counter za premik v drugo lokacijo
 signal x_pac_maze_locator, y_pac_maze_locator : unsigned(5 downto 0); -- za dolocanje lokacije v labirintu

 -- Labirint
 signal x_block_cnt : unsigned(4 downto 0);
 signal y_block_cnt : unsigned(4 downto 0);
 signal x_maze_location : unsigned(5 downto 0);
 signal y_maze_location : unsigned(4 downto 0);
 signal data_block : std_logic;
 signal data_labirint : integer range 0 to 32;
 signal Pac_stop_right : std_logic; -- blokade ob kriziscih
 signal Pac_stop_left : std_logic;
 signal Pac_stop_up : std_logic;
 signal Pac_stop_down : std_logic;
 
 -- Duhci
 signal Duhec1_alive : std_logic := '1'; -- ce ga pojes je 0
 signal Duhec2_alive : std_logic := '1';
 signal Duhec3_alive : std_logic := '1';
 signal Duhec4_alive : std_logic := '1';
 signal Duhec1_xt, Duhec1_yt: unsigned(11 downto 0); -- translacija duhca
 signal Duhec2_xt, Duhec2_yt: unsigned(11 downto 0);
 signal Duhec3_xt, Duhec3_yt: unsigned(11 downto 0);
 signal Duhec4_xt, Duhec4_yt: unsigned(11 downto 0);
 signal D1_x, D1_y: unsigned(11 downto 0); -- lokacija duhca po x in y
 signal D2_x, D2_y: unsigned(11 downto 0);
 signal D3_x, D3_y: unsigned(11 downto 0);
 signal D4_x, D4_y: unsigned(11 downto 0);
 signal Duhec1_data : std_logic;
 signal Duhec2_data : std_logic;
 signal Duhec3_data : std_logic;
 signal Duhec4_data : std_logic;
 signal Duhec_bonus : std_logic; -- dobljen bonus je 1
 signal Duhec_bonus_cnt : unsigned(31 downto 0);
 signal Duhec1_smer: unsigned(1 downto 0); -- v katero smer se duhec premika (zaporedno smeri)
 signal Duhec2_smer: unsigned(1 downto 0);
 signal Duhec3_smer: unsigned(1 downto 0);
 signal Duhec4_smer: unsigned(1 downto 0);
 signal D1_x_maze, D1_y_maze : unsigned(5 downto 0); -- Lokacija duhca v labirintu za premikanje
 signal D2_x_maze, D2_y_maze : unsigned(5 downto 0); -- Lokacija duhca v labirintu za premikanje
 signal D3_x_maze, D3_y_maze : unsigned(5 downto 0); -- Lokacija duhca v labirintu za premikanje
 signal D4_x_maze, D4_y_maze : unsigned(5 downto 0); -- Lokacija duhca v labirintu za premikanje
 signal D1_x_cnt, D1_y_cnt : unsigned(4 downto 0); -- vrednost v enem bloku
 signal D2_x_cnt, D2_y_cnt : unsigned(4 downto 0); -- vrednost v enem bloku
 signal D3_x_cnt, D3_y_cnt : unsigned(4 downto 0); -- vrednost v enem bloku
 signal D4_x_cnt, D4_y_cnt : unsigned(4 downto 0); -- vrednost v enem bloku
 signal Duhec_move_cnt : unsigned(4 downto 0); -- univerzalni cnt za pomikanje duhcev
 signal Duhci_izhod : std_logic;
 
 
begin
 
 D1_x <= D1_x_maze * "010100" + D1_x_cnt; -- X koordinata duhca
 D1_y <= D1_y_maze * "010100" + D1_y_cnt; -- Y koordinata duhca
 Duhec1_xt <= x - D1_x;
 Duhec1_yt <= y - D1_y;
 
 D2_x <= D2_x_maze * "010100" + D2_x_cnt; -- X koordinata duhca
 D2_y <= D2_y_maze * "010100" + D2_y_cnt; -- Y koordinata duhca
 Duhec2_xt <= x - D2_x;
 Duhec2_yt <= y - D2_y;
 
 D3_x <= D3_x_maze * "010100" + D3_x_cnt; -- X koordinata duhca
 D3_y <= D3_y_maze * "010100" + D3_y_cnt; -- Y koordinata duhca
 Duhec3_xt <= x - D3_x;
 Duhec3_yt <= y - D3_y;
 
 D4_x <= x_pac_maze_cnt * "010100" + "00000"; -- X koordinata duhca
 D4_y <= y_pac_maze_cnt * "010100" + "00000"; -- Y koordinata duhca
 Duhec4_xt <= x - D4_x;
 Duhec4_yt <= y - D4_y;

 
 -- Opombe:
 -- Duhec1: rdec
 -- Duhec2: roza
 -- Duhec3: zelen
 -- Duhec4: svetlo moder
 
 
  --// Premikanje pacmana //
 p_Pac_premikanje: process(clk, x, y, x1, y1, lives, x_pac_maze_locator, y_pac_maze_locator)--  
 begin
 if rising_edge(clk) then
	if lives /= "00" then
		xt <= x-x1; -- premik pacmana po X - tipke
		yt <= y-y1; -- premik pacmana po Y - tipke
	else
		xt <= x-380; 
		yt <= y-440; 
	end if;
	
	
--	if start = '1' then
--		if (x_pac_maze_locator * "10100") < x1 and ((x_pac_maze_locator + 1) * "10100") > x1 then
--			x_pac_maze_cnt <= x_pac_maze_locator;
--			x_pac_block_cnt <= resize((x1 - x_pac_maze_cnt * "10100"),5);
--		else
--			x_pac_maze_locator <= x_pac_maze_locator + 1;
--		end if;
--	
--		if (y_pac_maze_locator * "10100") < y1 and ((y_pac_maze_locator + 1) * "10100") > y1 then
--			y_pac_maze_cnt <= y_pac_maze_locator;
--			y_pac_block_cnt <= resize((y1 - y_pac_maze_cnt * "10100"),5);
--		else
--			y_pac_maze_locator <= y_pac_maze_locator + 1;
--		end if;
--	else
--		x_pac_maze_cnt <= "010011";
--		y_pac_maze_cnt <= "010110";
--		x_pac_block_cnt <= "00000";
--		y_pac_block_cnt <= "00000";
--	end if;
	
 end if;	
 end process p_Pac_premikanje;
 
 
  --// Premikanje Duhca - stevec //
 p_Premikanje_duhca: process(clk) 
 begin 
	if rising_edge(clk) then 
--		if start = '1' then
--			if d=2000000 then 
--				d <= (others=>'0');
--				Duhec_move_cnt <= Duhec_move_cnt + 1;
--				if to_integer(Duhec_move_cnt) > 19 then
--					Duhec_move_cnt <= (others => '0');
--				end if;
--			else 
--				d <= d + 1; 
--			end if;
--		else
--			Duhec_move_cnt <= (others => '0');
--		end if; 
	end if;
 end process p_Premikanje_duhca;
  
 
 --//// Data za tocke ////
 p_Tocke_data: process(y_block_cnt, x_block_cnt,y_maze_location, x_maze_location, enice, desetice, stotice, tocke_izpis) 
 begin
 
	if to_integer(y_maze_location) = 2 and to_integer(x_maze_location) = 4 then	-- Tocke: Enice
		tocke_izpis <= enice;
	elsif to_integer(y_maze_location) = 2 and to_integer(x_maze_location) = 3 then	-- Tocke: Desetice
		tocke_izpis <= desetice;
	elsif to_integer(y_maze_location) = 2 and to_integer(x_maze_location) = 2 then	-- Tocke: Stotice
		tocke_izpis <= stotice;
	else 
		tocke_izpis <= "00000000";
	end if;
			
	case to_integer(tocke_izpis) is
		when 0 =>
			tocke_data <= Stevilka_0(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0)));
		when 1 =>
			tocke_data <= Stevilka_1(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0)));
		when 2 =>
			tocke_data <= Stevilka_2(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0)));	
		when 3 =>
			tocke_data <= Stevilka_3(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0)));
		when 4 =>
			tocke_data <= Stevilka_4(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0)));
		when 5 =>
			tocke_data <= Stevilka_5(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0)));
		when 6 =>
			tocke_data <= Stevilka_6(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0)));
		when 7 =>
			tocke_data <= Stevilka_7(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0)));
		when 8 =>
			tocke_data <= Stevilka_8(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0)));
		when 9 =>
			tocke_data <= Stevilka_9(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0)));
		when others => 
			tocke_data <= Stevilka_0(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0)));
		end case;		
 end process p_Tocke_data;
 
 
--//// Obračanje Pacmana in animacija ust //// 
 p_Pac_data: process(cntMan, xt, yt, smer) 
 begin
 	if to_integer(smer) = 0 then -- smer: desno
		case to_integer(cntMan) is
			when 0 =>
				data <= Pac1(to_integer(yt(4 downto 0) * "10100" + xt(4 downto 0)));
			when 1 =>
				data <= Pac2(to_integer(yt(4 downto 0) * "10100" + xt(4 downto 0)));
			when 2 =>
				data <= Pac3(to_integer(yt(4 downto 0) * "10100" + xt(4 downto 0)));	
			when 3 =>
				data <= Pac2(to_integer(yt(4 downto 0) * "10100" + xt(4 downto 0)));	
			when others => 
				data <= '0';
		end case;
	elsif to_integer(smer) = 1 then -- smer: levo
		case to_integer(cntMan) is
			when 0 =>
				data <= Pac1(to_integer(yt(4 downto 0) * "10100" + ("10011" - xt(4 downto 0))));
			when 1 =>
				data <= Pac2(to_integer(yt(4 downto 0) * "10100" + ("10011" - xt(4 downto 0))));
			when 2 =>
				data <= Pac3(to_integer(yt(4 downto 0) * "10100" + ("10011" - xt(4 downto 0))));	
			when 3 =>
				data <= Pac2(to_integer(yt(4 downto 0) * "10100" + ("10011" - xt(4 downto 0))));	
			when others => 
				data <= '0';
		end case;
	elsif to_integer(smer) = 2 then -- smer: gor
		case to_integer(cntMan) is
			when 0 =>
				data <= Pac1(to_integer(xt(4 downto 0) * "10100" + ("10011" - yt(4 downto 0))));
			when 1 =>
				data <= Pac2(to_integer(xt(4 downto 0) * "10100" + ("10011" - yt(4 downto 0))));
			when 2 =>
				data <= Pac3(to_integer(xt(4 downto 0) * "10100" + ("10011" -  yt(4 downto 0))));	
			when 3 =>
				data <= Pac2(to_integer(xt(4 downto 0) * "10100" + ("10011" -  yt(4 downto 0))));	
			when others => 
				data <= '0';
		end case;
	elsif to_integer(smer) = 3 then -- smer: dol
		case to_integer(cntMan) is
			when 0 =>
				data <= Pac1(to_integer(xt(4 downto 0) * "10100" + yt(4 downto 0)));
			when 1 =>
				data <= Pac2(to_integer(xt(4 downto 0) * "10100" + yt(4 downto 0)));
			when 2 =>
				data <= Pac3(to_integer(xt(4 downto 0) * "10100" + yt(4 downto 0)));	
			when 3 =>
				data <= Pac2(to_integer(xt(4 downto 0) * "10100" + yt(4 downto 0)));	
			when others => 
				data <= '0';
		end case;
	end if;	
 end process p_Pac_data;


--//// Data za labirint ////
 p_Block_data: process(y_maze_location, x_maze_location, y_block_cnt, x_block_cnt, data_labirint, Osnova, tocke_data, ponastavi) 
 begin
 
	data_labirint <= Osnova(to_integer(y_maze_location), to_integer(x_maze_location)); -- Lokacija labirinta

	case data_labirint is
		when 0 =>
			data_block <= Blok_Blank(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0))); -- Crno / prazno
		when 1 =>
			data_block <= Blok_Lines(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0))); -- Horizontalno dve crti
		when 2 =>
			data_block <= Blok_Lines(to_integer(x_block_cnt(4 downto 0) * "10100" + y_block_cnt(4 downto 0))); -- Vertikalno dve crti
		when 3 =>
			data_block <= Blok_Lines_corner(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0))); -- Vogal: zgoraj levi 
		when 4 =>
			data_block <= Blok_Lines_corner(to_integer(y_block_cnt(4 downto 0) * "10100" + ("10011" - x_block_cnt(4 downto 0)))); -- Vogal: zgoraj desni 
		when 5 =>
			data_block <= Blok_Lines_corner(to_integer(x_block_cnt(4 downto 0) * "10100" + ("10011" - y_block_cnt(4 downto 0)))); -- Vogal: spodaj desni 
		when 6 =>
			data_block <= Blok_Lines_corner(to_integer(("10011" - y_block_cnt(4 downto 0)) * "10100" + ("10011" - x_block_cnt(4 downto 0)))); -- Vogal: spodaj levi 
		when 7 => 
			data_block <= Blok_Line(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0))); -- Ena crta: spodaj
		when 8 => 
			data_block <= Blok_Line(to_integer(("10011" - y_block_cnt(4 downto 0)) * "10100" + x_block_cnt(4 downto 0))); -- Ena crta: zgoraj
		when 9 => 
			data_block <= Blok_Line(to_integer(("10011" - x_block_cnt(4 downto 0)) * "10100" + y_block_cnt(4 downto 0))); -- Ena crta: levo
		when 10 => 
			data_block <= Blok_Line(to_integer(x_block_cnt(4 downto 0) * "10100" + y_block_cnt(4 downto 0))); -- Ena crta: desno 
		when 11 => 
			data_block <= Blok_Line_corner(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0))); -- Vogal ena crta: zgoraj levo 
		when 12 => 
			data_block <= Blok_Line_corner(to_integer(y_block_cnt(4 downto 0) * "10100" + ("10011" - x_block_cnt(4 downto 0)))); -- Vogal ena crta: zgoraj desno
		when 13 => 
			data_block <= Blok_Line_corner(to_integer(("10011" - y_block_cnt(4 downto 0)) * "10100" + ("10011" - x_block_cnt(4 downto 0)))); -- Vogal ena crta: spodaj levo 
		when 14 => 
			data_block <= Blok_Line_corner(to_integer(x_block_cnt(4 downto 0) * "10100" + ("10011" - y_block_cnt(4 downto 0)))); -- Vogal ena crta: spodaj desno
		when 15 => 
			data_block <= Blok_Line_corner_inner(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0))); -- Vogal notranji: spodaj desno 
		when 16 => 
			data_block <= Blok_Line_corner_inner(to_integer(y_block_cnt(4 downto 0) * "10100" + ("10011" - x_block_cnt(4 downto 0)))); -- Vogal notranji: spodaj levo
		when 17 => 
			data_block <= Blok_Line_corner_inner(to_integer(("10011" - y_block_cnt(4 downto 0)) * "10100" + ("10011" - x_block_cnt(4 downto 0)))); -- Vogal notranji: zgoraj levo
		when 18 => 
			data_block <= Blok_Line_corner_inner(to_integer(x_block_cnt(4 downto 0) * "10100" + ("10011" - y_block_cnt(4 downto 0)))); -- Vogal notranji: zgoraj desno
		when 19 => 
			data_block <= Blok_cap(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0))); -- Koncni cep: levi
		when 20 => 
			data_block <= Blok_cap(to_integer(y_block_cnt(4 downto 0) * "10100" + ("10011" - x_block_cnt(4 downto 0)))); -- Koncni cep: levi
		when 21 =>
			data_block <= Blok_Lines_split(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0))); -- Kotnik: Spodaj levo (crta zgoraj)
		when 22 =>
			data_block <= Blok_Lines_split(to_integer(y_block_cnt(4 downto 0) * "10100" + ("10011" - x_block_cnt(4 downto 0)))); -- Kotnik: Spodaj desno (crta zgoraj)
		when 23 =>
			data_block <= Blok_Lines_split(to_integer(x_block_cnt(4 downto 0) * "10100" + ("10011" - y_block_cnt(4 downto 0)))); -- Kotnik: spodaj desno (crta levo)
		when 24 =>
			data_block <= Blok_Lines_split(to_integer(x_block_cnt(4 downto 0) * "10100" + y_block_cnt(4 downto 0))); -- Kotnik: zgoraj desno (crta levo)
		when 25 =>
			data_block <= Blok_Lines_split(to_integer(("10011" - x_block_cnt(4 downto 0)) * "10100" + y_block_cnt(4 downto 0))); -- Kotnik: spodaj levo (crta desno)
		when 26 =>
			data_block <= Blok_Lines_split(to_integer(("10011" - x_block_cnt(4 downto 0)) * "10100" + ("10011" - y_block_cnt(4 downto 0)))); -- Kotnik: zgoraj levo (crta desno)
		when 27 => 
			data_block <= Pac3(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0))); -- Pacman zivljenja
		when 28 =>
			--if ponastavi /= '1' then
				data_block <= Tocka(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0))); -- Tocka -> 31
			--end if;
		when 29 =>
			--if ponastavi /= '1' then
				data_block <= Bonus(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0))); -- Bonus -> 32
			--end if;
		when 30 =>
			data_block <= tocke_data;-- Stevilo: tocke
		when 31 =>
			--if ponastavi = '1' then
				data_block <= Blok_Blank(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0))); -- Crno / prazno (tocke)
			--end if;
		when 32 =>
			--if ponastavi = '1' then 
				data_block <= Blok_Blank(to_integer(y_block_cnt(4 downto 0) * "10100" + x_block_cnt(4 downto 0))); -- Crno / prazno (bonus)
			--end if;
		when others => 
			data_block <= '0';
	end case;	
 end process p_Block_data;


 --//// Data za duhce ////
 p_Duhec_data: process(Duhec1_xt, Duhec1_yt, Duhec2_xt, Duhec2_yt, Duhec3_xt, Duhec3_yt, Duhec4_xt, Duhec4_yt) 
 begin
 
	Duhec1_data <= Duhec(to_integer(Duhec1_yt(4 downto 0) * "10100" + Duhec1_xt(4 downto 0)));
	Duhec2_data <= Duhec(to_integer(Duhec2_yt(4 downto 0) * "10100" + Duhec2_xt(4 downto 0)));
	Duhec3_data <= Duhec(to_integer(Duhec3_yt(4 downto 0) * "10100" + Duhec3_xt(4 downto 0)));
	Duhec4_data <= Duhec(to_integer(Duhec4_yt(4 downto 0) * "10100" + Duhec4_xt(4 downto 0)));
 
 end process p_Duhec_data;
 
 
 --//// Main Process ////
 process(clk)
  begin
  if rising_edge(clk) then
  
	if reset = '1' then
		ponastavi <= '1';
	end if;
  
   trk <= '0';
	trk_init <= '0';
  	stopup <= '0';
	stopdn <= '0';
	stopleft <= '0';
	stopright <= '0';
  
	-- ** Reset (tipka) **
	if ponastavi = '1' then
		lives <= "11";
		smer <= "00";
		start <= '0';
		Duhec_bonus <= '0';
		Duhec1_alive <= '1';
		Duhec2_alive <= '1';
		Duhec3_alive <= '1';
		Duhec4_alive <= '1';
		
		-- tocke
		tocke <= (others => '0');
		enice <= (others => '0');
		desetice <= (others => '0');
		stotice <= (others => '0');
	
		Duhci_izhod <= '1';
		
		-- lokacije		
		D1_x_maze <= "010001";
		D1_y_maze <= "001100";
		D1_x_cnt <= (others => '0');
		D1_y_cnt <= (others => '0');
		
		D2_x_maze <= "010001";
		D2_y_maze <= "001110";
		D2_x_cnt <= (others => '0');
		D2_y_cnt <= (others => '0');
		
		D3_x_maze <= "010110";
		D3_y_maze <= "001100";
		D3_x_cnt <= (others => '0');
		D3_y_cnt <= (others => '0');
		
		D4_x_maze <= "010110";
		D4_y_maze <= "001110";
		D4_x_cnt <= (others => '0');
		D4_y_cnt <= (others => '0');
		
		-- sledenje lokaciji Pacmana po labirintu-osnova
		x_pac_maze_cnt <= "010011";
		y_pac_maze_cnt <= "010110";
		x_pac_block_cnt <= "00000";
		y_pac_block_cnt <= "00000";
		
		ponastavi <= '0';
	end if;
	


	-- ** Animacija pacmana (usta) **
	cntMounth <= cntMounth + 1;
	if (cntMounth = 10000000) then
		cntMounth <= (others=>'0');
			if cntMan < 3 then
				cntMan <= cntMan + 1;
			else
				cntMan <= (others=>'0');
			end if;	
	end if;
	
	-- ** Obracanje pacmana in sledenje za stene **
	if x1 /= x1_old or y1 /= y1_old then
		start <= '1';		
		
		if x1 > x1_old then -- desno
			smer <= "00"; 
			if x_pac_block_cnt > 18 then
				x_pac_block_cnt <= (others =>'0');
				x_pac_maze_cnt <= x_pac_maze_cnt + 1;
			else
				x_pac_block_cnt <= x_pac_block_cnt + 1;
			end if;
		elsif x1 < x1_old then -- levo
			smer <= "01"; 
			if x_pac_block_cnt > 18 then
				x_pac_block_cnt <= "10010";
				x_pac_maze_cnt <= x_pac_maze_cnt - 1;
			else
				x_pac_block_cnt <= x_pac_block_cnt - 1;
			end if;		
		elsif y1 > y1_old then -- dol
			smer <= "11"; 
			if y_pac_block_cnt > 18 then
				y_pac_block_cnt <= (others =>'0');
				y_pac_maze_cnt <= y_pac_maze_cnt + 1;
			else
				y_pac_block_cnt <= y_pac_block_cnt + 1;
			end if;
		elsif y1 < y1_old then -- gor
			smer <= "10"; 
			if y_pac_block_cnt > 18 then
				y_pac_block_cnt <= "10010";
				y_pac_maze_cnt <= y_pac_maze_cnt - 1;
			else
				y_pac_block_cnt <= y_pac_block_cnt - 1;
			end if;
		end if;
		x1_old <= x1;
		y1_old <= y1;
	end if;
	
	-- ** Reset cnt-jev **	
	if y = 0 and x = 0 then
		x_block_cnt <= (others => '0');
		x_maze_location <= (others => '0');
		y_block_cnt <=  (others => '0');
		y_maze_location <= (others => '0');
	end if;

	
	-- ** Prikaz zivljenj na ekranu (spreminjanje tabele) **
	if lives = "11" then
		Osnova(2,37) <= 27;
		Osnova(2,36) <= 27;
		Osnova(2,35) <= 27;
	elsif lives = "10" then
		Osnova(2,37) <= 0;
		Osnova(2,36) <= 27;
		Osnova(2,35) <= 27;
	elsif lives = "01" then
		Osnova(2,37) <= 0;
		Osnova(2,36) <= 0;
		Osnova(2,35) <= 27;
	elsif lives = "00" then
		Osnova(2,37) <= 0;
		Osnova(2,36) <= 0;
		Osnova(2,35) <= 0;
	end if;
	
	
	-- ** Bonus (da lahko poje duhca) in Tocke **
	if data_labirint = 28 or data_labirint = 29 then
		if (x1 >= (to_integer(x_maze_location) * 20) and x1 < ((to_integer(x_maze_location)*20) + 19)) or ((x1 + 19) >= (to_integer(x_maze_location) * 20) and ((x1 + 19) < (to_integer(x_maze_location) * 20) + 19)) then --20
			if (y1 >= (to_integer(y_maze_location) * 20) and y1 < ((to_integer(y_maze_location)*20) + 19)) or ((y1 + 19) >= (to_integer(y_maze_location) * 20) and ((y1 + 19) < (to_integer(y_maze_location) * 20) + 19)) then	--20
				if data_labirint = 28 then -- tocka
					tocke <= tocke + 1 * combo;
					Osnova(to_integer(y_maze_location),to_integer(x_maze_location)) <= 31; -- brisanje tocke iz labirinta
				elsif data_labirint = 29 then --bonus
					--tocke <= tocke + 10;
					desetice <= desetice + 1; -- resitev overflowa (dela ni pa najboljsi)
					Duhec_bonus <= '1';
					Osnova(to_integer(y_maze_location),to_integer(x_maze_location)) <= 32; -- brisanje bonusa iz labirinta
				else
					tocke <= tocke;
				end if;
			end if;
		end if;
	end if;
	
	if Duhec_bonus = '1' then -- Timer za reset bonusa
		Duhec_bonus_cnt <= Duhec_bonus_cnt + 1;
		if Duhec_bonus_cnt = 200000000 then
			Duhec_bonus <= '0';
			Duhec_bonus_cnt <=  (others => '0');
		end if;
	end if;
	
	-- ** Preracun tock za izpis **
	enice <= "00000000" + tocke(3 downto 0);
	if to_integer(enice) = 10 then
		enice <= (others => '0');
		tocke <= (others => '0'); -- reset tock pri 10 (drugace tezave ob prikazu)
		desetice <= desetice + 1;
	elsif to_integer(desetice) = 10 then
		desetice <= (others => '0');
		stotice <= stotice + 1;
	elsif to_integer(stotice) = 10 then
		stotice <= (others => '0');
	end if;
	
	-- ** Zalet v duhca **
	if (x1 >= to_integer(D1_x) and x1 < (to_integer(D1_x) + 19)) or ((x1 + 19) >= to_integer(D1_x) and ((x1 + 19) < to_integer(D1_x) + 19)) then 
		if (y1 >= to_integer(D1_y) and y1 < (to_integer(D1_y) + 19)) or ((y1 + 19) >= to_integer(D1_y) and ((y1 + 19) < to_integer(D1_y) + 19)) then	
			if Duhec1_alive = '1' then
				if Duhec_bonus = '1' then
					Duhec1_alive <= '0';
					combo <= combo + 1; -- dodatne točke
				else
					trk <= '1';
				end if;
			end if;
		end if;
	end if;
	
	if (x1 >= to_integer(D2_x) and x1 < (to_integer(D2_x) + 19)) or ((x1 + 19) >= to_integer(D2_x) and ((x1 + 19) < to_integer(D2_x) + 19)) then 
		if (y1 >= to_integer(D2_y) and y1 < (to_integer(D2_y) + 19)) or ((y1 + 19) >= to_integer(D2_y) and ((y1 + 19) < to_integer(D2_y) + 19)) then	
			if Duhec2_alive = '1' then
				if Duhec_bonus = '1' then
					Duhec2_alive <= '0';
					combo <= combo + 1; -- dodatne točke
				else
					trk <= '1';
				end if;
			end if;
		end if;
	end if;
	
	if (x1 >= to_integer(D3_x) and x1 < (to_integer(D3_x) + 19)) or ((x1 + 19) >= to_integer(D3_x) and ((x1 + 19) < to_integer(D3_x) + 19)) then 
		if (y1 >= to_integer(D3_y) and y1 < (to_integer(D3_y) + 19)) or ((y1 + 19) >= to_integer(D3_y) and ((y1 + 19) < to_integer(D3_y) + 19)) then	
			if Duhec3_alive = '1' then
				if Duhec_bonus = '1' then
					Duhec3_alive <= '0';
					combo <= combo + 1; -- dodatne točke
				else
					trk <= '1';
				end if;
			end if;
		end if;
	end if;
	
	if (x1 >= to_integer(D4_x) and x1 < (to_integer(D4_x) + 19)) or ((x1 + 19) >= to_integer(D4_x) and ((x1 + 19) < to_integer(D4_x) + 19)) then 
		if (y1 >= to_integer(D4_y) and y1 < (to_integer(D4_y) + 19)) or ((y1 + 19) >= to_integer(D4_y) and ((y1 + 19) < to_integer(D4_y) + 19)) then	
			if Duhec4_alive = '1' then
				if Duhec_bonus = '1' then
					Duhec4_alive <= '0';
					combo <= combo + 1; -- dodatne točke
				else
					--trk <= '1';
				end if;
			end if;
		end if;
	end if;
	
	if trk = '1' then
		trk_init <= '1';
	end if;
	
	if trk_init = '1' then -- Dogodek ob trku (v duhca)
		trk_init <= '0';
		combo <= "001";
		smer <= "00";
		start <= '0';
		if desetice >= 1 then
			desetice <= desetice - 1;
			--tocke <= (others => '0');
		else
			enice <= (others => '0');
		end if;

		Duhci_izhod <= '1';
		
		lives <= lives - 1; --??????
		
		-- lokacije
		Duhec1_alive <= '1';
		D1_x_maze <= "010001";
		D1_y_maze <= "001100";
		D1_x_cnt <= (others => '0');
		D1_y_cnt <= (others => '0');
		
		Duhec2_alive <= '1';
		D2_x_maze <= "010001";
		D2_y_maze <= "001110";
		D2_x_cnt <= (others => '0');
		D2_y_cnt <= (others => '0');
		
		Duhec3_alive <= '1';
		D3_x_maze <= "010110";
		D3_y_maze <= "001100";
		D3_x_cnt <= (others => '0');
		D3_y_cnt <= (others => '0');
		
		Duhec4_alive <= '1';
		D4_x_maze <= "010110";
		D4_y_maze <= "001110";
		D4_x_cnt <= (others => '0');
		D4_y_cnt <= (others => '0');
		
		-- sledenje lokaciji Pacmana po labirintu-osnova
		x_pac_maze_cnt <= "010011";
		y_pac_maze_cnt <= "010110";
		x_pac_block_cnt <= "00001";
		y_pac_block_cnt <= "00001";
		
		
		
	end if;
	
	-- ** Zidovi (stop) ** !!!
	if (Osnova(to_integer(y_pac_maze_cnt),to_integer(x_pac_maze_cnt + 1)) /= 00) and (Osnova(to_integer(y_pac_maze_cnt),to_integer(x_pac_maze_cnt + 1)) /= 28) and (Osnova(to_integer(y_pac_maze_cnt),to_integer(x_pac_maze_cnt + 1)) /= 29) and (Osnova(to_integer(y_pac_maze_cnt),to_integer(x_pac_maze_cnt + 1)) /= 31) and (Osnova(to_integer(y_pac_maze_cnt),to_integer(x_pac_maze_cnt + 1)) /= 32) then 
		Pac_stop_right <= '1';
		if (x_pac_block_cnt = "00000") then
			stopright <= '1';
		end if;
	else
		Pac_stop_right <= '0';
	end if;
	if (Osnova(to_integer(y_pac_maze_cnt),to_integer(x_pac_maze_cnt - 1)) /= 00) and (Osnova(to_integer(y_pac_maze_cnt),to_integer(x_pac_maze_cnt - 1)) /= 28) and (Osnova(to_integer(y_pac_maze_cnt),to_integer(x_pac_maze_cnt - 1)) /= 29) and (Osnova(to_integer(y_pac_maze_cnt),to_integer(x_pac_maze_cnt - 1)) /= 31) and (Osnova(to_integer(y_pac_maze_cnt),to_integer(x_pac_maze_cnt - 1)) /= 32) then
		Pac_stop_left <= '1';
		if (x_pac_block_cnt = "00000") then
			stopleft <= '1';
		end if;
	else
		Pac_stop_left <= '0';
	end if;
	if (Osnova(to_integer(y_pac_maze_cnt - 1),to_integer(x_pac_maze_cnt)) /= 00) and (Osnova(to_integer(y_pac_maze_cnt - 1),to_integer(x_pac_maze_cnt)) /= 28) and (Osnova(to_integer(y_pac_maze_cnt - 1),to_integer(x_pac_maze_cnt)) /= 29) and (Osnova(to_integer(y_pac_maze_cnt - 1),to_integer(x_pac_maze_cnt)) /= 31) and (Osnova(to_integer(y_pac_maze_cnt - 1),to_integer(x_pac_maze_cnt)) /= 32) then
		Pac_stop_up <= '1';
		if (y_pac_block_cnt = "00000") then
			stopup <= '1';
		end if;
	else
		Pac_stop_up <= '0';
	end if;
	if (Osnova(to_integer(y_pac_maze_cnt + 1),to_integer(x_pac_maze_cnt)) /= 00) and (Osnova(to_integer(y_pac_maze_cnt + 1),to_integer(x_pac_maze_cnt)) /= 28) and (Osnova(to_integer(y_pac_maze_cnt + 1),to_integer(x_pac_maze_cnt)) /= 29) and (Osnova(to_integer(y_pac_maze_cnt + 1),to_integer(x_pac_maze_cnt)) /= 31) and (Osnova(to_integer(y_pac_maze_cnt + 1),to_integer(x_pac_maze_cnt)) /= 32) then	
		Pac_stop_down <= '1';
		if (y_pac_block_cnt = "00000") then
			stopdn <= '1';
		end if;
	else
		Pac_stop_down <= '0';
	end if;
	
	-- polovicne blokade smeri (ce pacman ni do konca v polju)
	if Pac_stop_up = '0' then
		if (x_pac_block_cnt > "00000") then
			stopup <= '1';
		end if;
	end if;
	
	if Pac_stop_down = '0' then
		if (x_pac_block_cnt > "00000") then
			stopdn <= '1';
		end if;
	end if;
	
	if Pac_stop_left = '0' then
		if (y_pac_block_cnt > "00000") then
			stopleft <= '1';
		end if;
	end if;
	
	if Pac_stop_right = '0' then
		if (y_pac_block_cnt > "00000") then
			stopright <= '1';
		end if;
	end if;	
	
	
	-- ** Premikanje duhcev - samodejno **
	
	if start = '1' then
		if d=2000000 then 
			d <= (others=>'0');
			if to_integer(Duhec_move_cnt) > 18 then
				Duhec_move_cnt <= (others => '0');
				
				-- Duhec 1
				if Duhec1_smer = "00" then
					D1_x_maze <= D1_x_maze + 1;
				elsif Duhec1_smer = "01" then
					D1_y_maze <= D1_y_maze - 1;
				elsif Duhec1_smer = "10" then
					D1_x_maze <= D1_x_maze - 1;
				elsif Duhec1_smer = "11" then
					D1_y_maze <= D1_y_maze + 1;
				else
					D1_x_maze <= D1_x_maze; 
					D1_y_maze <= D1_y_maze; 
				end if;
				
				-- Duhec 2
				
				-- Duhec 3
				
				-- Duhec 4
				
				
			else
				Duhec_move_cnt <= Duhec_move_cnt + 1; -- premikanje duhca v bloku
			end if;
		else 
			d <= d + 1; 
		end if;
	else
		Duhec_move_cnt <= (others => '0');
	end if;
	
		-- Izhod iz startne cone
	
	if Duhci_izhod = '1' then -- izhodna sekvenca
		if D1_x_maze /= "010010" and D1_y_maze /= "001010" then -- 
			Duhec1_smer <= "00";
			D1_x_cnt <= Duhec_move_cnt;
		end if;
			
		if D1_x_maze = "010011" and D1_y_maze /= "001010" then
			Duhec1_smer <= "01";
			D1_y_cnt <= 19 - Duhec_move_cnt;
		end if;

		if D1_x_maze = "010011" and D1_y_maze = "001010" then
			Duhec1_smer <= "10";
			Duhci_izhod <= '0';
		end if;
		
	else							-- logika premikanja
	
		if Duhec1_smer = "00" then
			D1_x_cnt <= Duhec_move_cnt;
		end if;
		
		if Duhec1_smer = "01" then
			D1_y_cnt <= 19 - Duhec_move_cnt;
		end if;
		
		if Duhec1_smer = "10" then
			D1_x_cnt <= 19 - Duhec_move_cnt;
		end if;
		
		if Duhec1_smer = "11" then
			D1_y_cnt <= Duhec_move_cnt;
		end if;
	end if;
	
	
	if (Osnova(to_integer(D1_x_maze),to_integer(D1_x_maze + 1)) /= 00) and (Osnova(to_integer(D1_x_maze),to_integer(D1_x_maze + 1)) /= 28) and (Osnova(to_integer(D1_x_maze),to_integer(D1_x_maze + 1)) /= 29) and (Osnova(to_integer(D1_x_maze),to_integer(D1_x_maze + 1)) /= 31) and (Osnova(to_integer(D1_x_maze),to_integer(D1_x_maze + 1)) /= 32) then 
		if (D1_x_maze = "00000") then
			--stopright <= '1';
		end if;
	end if;
	


	


		

	

	

	
	
	
	

				
	-- ** Vidni del slike **
	if x<800 and y<600 then  
		
		-- Risanje
		if xt<20 and yt<20 then -- Izris pacmana
			if data = '1' then						
				rgb <= "111100";
			elsif data = '0' then
				rgb <= "000000";
			end if;
		
		elsif Duhec1_xt<20 and Duhec1_yt<20 then -- Izris Duhca_1
			if Duhec1_alive = '1' then -- ziv / pojedli
				if Duhec1_data = '1' then	
					if Duhec_bonus = '1' then -- pobran bonus
						rgb <= "111111";
					else
						rgb <= "110000";
					end if;
				elsif Duhec1_data = '0' then
					rgb <= "000000";
				end if;
			end if;
		elsif Duhec2_xt<20 and Duhec2_yt<20 then -- Izris Duhca_2
			if Duhec2_alive = '1' then -- ziv / pojedli
				if Duhec2_data = '1' then	
					if Duhec_bonus = '1' then -- pobran bonus
						rgb <= "111111";
					else
						rgb <= "001100";
					end if;
				elsif Duhec2_data = '0' then
					rgb <= "000000";
				end if;
			end if;
		elsif Duhec3_xt<20 and Duhec3_yt<20 then -- Izris Duhca_3
			if Duhec3_alive = '1' then -- ziv / pojedli
				if Duhec3_data = '1' then	
					if Duhec_bonus = '1' then -- pobran bonus
						rgb <= "111111";
					else
						rgb <= "001111";
					end if;
				elsif Duhec3_data = '0' then
					rgb <= "000000";
				end if;
			end if;
		elsif Duhec4_xt<20 and Duhec4_yt<20 then -- Izris Duhca_4
			if Duhec4_alive = '1' then -- ziv / pojedli
				if Duhec4_data = '1' then	
					if Duhec_bonus = '1' then -- pobran bonus
						rgb <= "111111";
					else
						rgb <= "110011";
					end if;
				elsif Duhec4_data = '0' then
					rgb <= "000000";
				end if;
			end if;
		elsif data_block = '1' then -- Izris labirinta
			if data_labirint = 27 then -- Zivljenja 
				rgb <= "111100";
			elsif data_labirint = 28 or data_labirint = 29 or data_labirint = 30 then -- Bonusi in tocke
				rgb <= "111111";
			else
				rgb <= "000011"; -- Zidovi
			end if;
			--obj <= '1'; -- zid - stop
		elsif data_block = '0' then
			rgb <= "000000";
		end if;
			

		-- ** Ozadje (labirint)	- logika **
		if x_block_cnt = 19 then -- reset x blok stevca
			x_block_cnt <= (others=>'0');
			if x_maze_location = 39 then -- konec vrstice (labirint)
				x_maze_location <= (others=>'0'); -- reset vrstice
				if y_block_cnt = 19 then
					y_block_cnt <= (others=>'0');
					if y_maze_location = 29 then
						y_maze_location <= (others=>'0'); -- reset y
					else
						y_maze_location <= y_maze_location + 1;
					end if;
				else
					y_block_cnt <= y_block_cnt + 1;
				end if;
			else
				x_maze_location <= x_maze_location + 1; -- zamik na naslednjo x lokacijo labirinta
			end if;		
		else
			x_block_cnt <= x_block_cnt + 1; -- x premikanje po bloku
		end if;
		
		else -- zatemnjen del slike (izven našega ekrana)
			rgb <= "000000";
		end if;
	end if;
 end process; -- Main
 
end RTL;

