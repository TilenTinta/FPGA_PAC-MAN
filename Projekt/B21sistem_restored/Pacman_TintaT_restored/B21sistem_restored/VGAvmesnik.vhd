library IEEE;
use IEEE.std_logic_1164.all; -- definicija std_logic_vector
use IEEE.numeric_std.all;    -- def. unsigned in sestevanja


entity VGAvmesnik is
	Port(	clk : in std_logic;     
			rgb: in unsigned(5 downto 0); -- signali VGA vmesnika
			x,y: out unsigned(11 downto 0); 
			ledm: in unsigned(4 downto 0); -- ledm vrstica
			ledcnt: out unsigned(2 downto 0);
			tipke : out unsigned(3 downto 0); -- stanje tipk			
			clkout: out std_logic; -- signali razsiritvene plosce
			addr : out STD_LOGIC_VECTOR(1 DOWNTO 0);
			data : inout STD_LOGIC_VECTOR(7 DOWNTO 0)			
		 );
end VGAvmesnik;

architecture Opis of VGAvmesnik is
	signal hst, vst: unsigned(11 downto 0) :=(others=>'0');
	-- za stolpce
	constant H: integer := 1040;	-- meja counterja
	constant Hf: integer := 856;	-- zacetek sinh. pulza (Front Porch)
	constant Hs: integer := 120;	-- trajanje pulza
	
	-- za vrstice
	constant V: integer := 666;	-- meja counterja 
	constant Vf: integer := 637;	-- zacetek sinh. pulza (Front Porch)
	constant Vs: integer := 6;		-- trajanje pulza
	
	signal hsync, vsync: std_logic;
	
	signal data_led : std_logic_vector(7 downto 0);
	signal hs1, hs2: std_logic;
  
	signal par_counter : unsigned(16 downto 0):="00000000000000000";
	signal ver_counter : unsigned(2 downto 0):="000";
begin

 ------------------------------------------------------------------
 -- VGA timing
 
 p:process(clk)
 begin
	if rising_edge(clk) then
		if hst = H-1 then
			hst <= (others=>'0');
			
			if vst = V-1 then
				vst <= (others=>'0');
			else
				vst <= vst + 1;
			end if;
		else
			hst <= hst + 1;
		end if;
	end if;	
 end process;
 
 hsync <= '1' when hst>=Hf and hst<Hf+Hs else '0';
 vsync <= '1' when vst>=Vf and vst<Vf+Vs else '0';
	
 x <= hst;
 y <= vst;
 
 ------------------------------------------------------------------
 -- Logika za dostop do komponent na razširitveni plošči
 --  VGA: rgb(5:0), hsync, vsync
 --  LEDmatrika: ledm(4:0)       
 --  tipke: tipke(3:0)
 pio: process(clk)
 begin
   if rising_edge(clk) then
   hs1 <= hsync;
	hs2 <= '0';
	if hs1='1' and hsync='0' then
	  addr <= "01"; data <= "ZZZZZZZZ";
	  hs2 <= '1';
	elsif hs2='1' then
	  addr <= "10"; 
	  data<=data_led; 
	  tipke <= unsigned(data(3 downto 0));
	else
	  addr <= "00";  
	  data(7) <= hsync;
     data(6) <= vsync;
	  data(5 downto 0) <= std_logic_vector(rgb(1 downto 0) & rgb(3 downto 2) & rgb(5 downto 4));
	end if;
	end if;
 end process;

 --c_LED: ledmatrix port map (clk, data_led, on1, num);
 clkout <= clk;

	
main:process (clk)
begin
	if rising_edge(clk) then
		--*********************pararelni_stevec**************
		par_counter<=par_counter+1;
	 
		if (par_counter=1) then  --ko je stevec '1' vpišemo pridobljene podatke v (data_led)
			data_led(4)<=ledm(0);
			data_led(3)<=ledm(1);
			data_led(2)<=ledm(2);
			data_led(1)<=ledm(3);
			data_led(0)<=ledm(4);
			if(ledm=0) then  --če je vrstica prazna vpišemo v "000" kar naredi vrstico led matrike neaktivno
				data_led(7 downto 5)<="000";
			else
				data_led(7 downto 5)<= std_logic_vector(ver_counter+1);  --vpišemo katera vrstica led matrike bo aktivna glede na stevec (ver_counter)
			end if;
			
			ver_counter<=ver_counter+1;
			if(ver_counter="110") then --nastavimo (number_counter) z zelenim zankom (num), ko smo prikazali celoten znak (number)
				ver_counter<="000";
			end if;
		end if; 
	end if;                                 	  
end process;                                                                         

ledcnt <= ver_counter;

end Opis;