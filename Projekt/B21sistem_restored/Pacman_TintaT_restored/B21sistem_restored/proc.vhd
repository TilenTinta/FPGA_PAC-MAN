library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity proc is
  Port ( clk, ce : in STD_LOGIC;
         rst : in STD_LOGIC;
			rw: out unsigned(1 downto 0);
			adr: out unsigned (7 downto 0);
			dataIO: in unsigned(11 downto 0);
         dataProc: out unsigned(11 downto 0)
		 );
end proc;

architecture Opis of proc is  
 signal data, dataout: unsigned(11 downto 0);
 signal adrsig: unsigned (7 downto 0);
 signal we, rd, wr: std_logic;
 
 signal address: std_logic_vector(7 downto 0); -- naslovni signal
 signal dataram, datacpu: std_logic_vector(11 downto 0);
begin

 address <= std_logic_vector(adrsig);
 datacpu <= std_logic_vector(dataout);
 data <= unsigned(dataram);
 
 v0: entity work.program port map (
   address=>address, 
	clken=>ce,
	clock=>clk,
	data=>datacpu, 
	wren=>we, 
	q=>dataram);
	
 v1: entity work.CPU port map (
  clk=>clk, 
  ce=>ce, 
  rst=>rst, 
  data=>data, 
  pin=>dataIO, 
  addr=>adrsig, 
  wren=>we, 
  pout=>dataout, 
  wr=>wr, 
  rd=>rd
  );
   
 adr <= adrsig;
 -- nastavi kombiniran wr, ki je aktiven le en cikel ure
 rw <= (rd and ce) & (wr and ce);
 dataProc <= dataout;
 
end Opis;