----------------------------------------------------------------------------------
-- Company:  FE, 2015-21
-- Template developer: A. Trost
-- System developer: 
-- Create Date: 1/12/2021
-- Design Name: Predloga sistema z razsiritveno plosco, VGAvmesnik+procesor+grafika
--  clk 50 MHz
-- 
-- Revision: 3.0
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sistem is
	Port( clk : in STD_LOGIC;                  -- 50 MHz ura
		   key : in  std_logic_vector(1 downto 0);
			clkout : out STD_LOGIC; 				 -- signali V/I plošče
			addr : out STD_LOGIC_VECTOR(1 DOWNTO 0);
			data : inout STD_LOGIC_VECTOR(7 DOWNTO 0);
			led : out STD_LOGIC_VECTOR(7 DOWNTO 0)
		 );
end sistem;

architecture opis of sistem is
 -- signali za VGAvmesnik
 signal rgb: unsigned(5 downto 0);      -- barva trenutne točke
 signal x,y: unsigned(11 downto 0);     -- koordinate trenutne tocke
 signal tipke: unsigned(3 downto 0);    -- stanje tipk

 -- signali procesorja in delilnika ure
 signal rst: std_logic;                 -- reset, vezan na key (DIP2)
 signal rw: unsigned(1 downto 0);       -- 1=pisanje, 2=branje IO
 signal adr: unsigned (7 downto 0);     -- naslov IO
 signal dataProc, dataIO: unsigned(11 downto 0);
 signal stopup: std_logic;
 signal stopdn: std_logic;
 signal stopleft: std_logic;
 signal stopright: std_logic;
 
 signal d: unsigned(13 downto 0) := "00111110100000"; -- delilnik
 signal delilnik: unsigned(11 downto 0); -- delilnik
 signal ce, trk: std_logic := '0';
 
 -- signali grafične komponente
 signal x1,y1: unsigned(11 downto 0); 
 signal debug: std_logic;
 
  -- signali grafične komponente
 signal modul : unsigned(11 downto 0);
 
 
begin

 U1: entity work.VGAvmesnik port map (
		clk => clk,
		rgb => rgb,
		x => x, 
		y => y, 
		ledcnt => open,
		ledm => "00000",
		tipke => tipke,
		clkout => clkout,
		addr => addr,
		data => data  );
 
 -- delilnik ure za procesor
 -- Primer: d=0, hitro (50 MOP/s)
 --         d=100000, počasi (250 OP/s)
 p: process(clk)
 begin
  if rising_edge(clk) then 
	if d=delilnik*4 then -- delilnik
	    d <= (others=>'0'); 
		 ce <= '1';
	  else
	    d <= d + 1;
		 ce <= '0';
	  end if;
	end if;
 end process;
 
 U2: entity work.Proc port map (
		clk => clk,
		ce => ce,
		rst => rst,
		rw => rw,
		adr => adr,
      dataProc => dataProc,
	   dataIO => dataIO );
 
 rst <= not key(0);
 
 -- Grafika in IO vmesnik, dodaj priključke...
  U3: entity work.Grafika port map (
      clk => clk,
		x => x,
		y => y,
		x1 => x1,
      y1 => y1,
		rgb => rgb, 
		reset => rst, -- dodano za reset
		stopup => stopup,
	   stopdn => stopdn,
	   stopleft => stopleft,
	   stopright => stopright,
		debug => debug,
		trk => trk);
 
 U4: entity work.io port map(
     clk => clk,
	  rw => rw,
     adr => adr,
	  rst => rst,
     datin => dataProc,
	  datout => dataIO,
	  tipke => tipke,
     x1 => x1,
     y1 => y1,
	  modul => delilnik, 
	  trk => trk,
	  status => led(0),
	  stopup => stopup,
	  stopdn => stopdn,
	  stopleft => stopleft,
	  debug => debug,
	  stopright => stopright
 );

 
end opis;