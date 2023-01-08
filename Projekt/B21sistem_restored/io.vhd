library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity io is
 port (
   clk : in std_logic;
	rst : in std_logic;
   rw : in unsigned(1 downto 0);
   adr : in unsigned(7 downto 0);
   datin : in unsigned(11 downto 0);
	tipke : in unsigned(3 downto 0);
	datout : out unsigned(11 downto 0);
	modul : out unsigned(11 downto 0);
   x1,y1 : out unsigned(11 downto 0);
	trk : in std_logic;
	stopup : in std_logic; -- Dodano stop gor
	stopdn : in std_logic; -- Dodano stop dol
	stopleft : in std_logic; -- Dodano stop levo
	stopright : in std_logic; -- Dodano stop desno
	status : out std_logic; -- LED
	debug : in std_logic
	
    );
end io;

architecture RTL of io is
	signal int : std_logic;
	signal stop_up : std_logic;
	signal stop_dn : std_logic;
	signal stop_left : std_logic;
	signal stop_right : std_logic;
	
begin

  status <= debug;
  
process(clk)
begin

 if rising_edge(clk) then
	if trk = '1' then
		int <= '1';
	end if;
	
	if stopup = '1' then
		stop_up <= '1';
	end if;
	
	if stopdn = '1' then
		stop_dn <= '1';
	end if;
	
	if stopleft = '1' then
		stop_left <= '1';
	end if;
	
	if stopright = '1' then
		stop_right <= '1';
	end if;
	
	
 if rst = '1' then
	modul <= "111111111111";
 end if;	
  
  if (adr = 1) and (rw = 1) then
     x1 <= datin;
  elsif (adr = 2) and (rw = 1) then
     y1 <= datin;
  elsif (adr = 3) and (rw = 1) then
     modul <= datin;
  elsif (adr = 5) and (rw = 2) then -- trk
	  datout <= (0 => int, others => '0');	
	  int <= '0';
  elsif (adr = 6) and (rw = 2) then -- dodano za stop na gor
	  datout <= (0 => not(stop_up), others => '0');	
	  stop_up <= '0';
  elsif (adr = 7) and (rw = 2) then -- dodano za stop na dol
	  datout <= (0 => not(stop_dn), others => '0');	
	  stop_dn <= '0';
  elsif (adr = 8) and (rw = 2) then -- dodano za stop na levo
	  datout <= (0 => not(stop_left), others => '0');	
	  stop_left <= '0';
  elsif (adr = 9) and (rw = 2) then -- dodano za stop na desno
	  datout <= (0 => not(stop_right), others => '0');	
	  stop_right <= '0';
  elsif rw = 2 then
     datout <= (0 => tipke(to_integer(adr)), others => '0');
  end if;
  
 end if; --clk
end process;

end RTL;


