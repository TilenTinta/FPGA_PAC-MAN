library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Logic is
 port (
   clk : in std_logic;
   datin : in unsigned(11 downto 0);
   tipke : in unsigned(3 downto 0);
   datout : out unsigned(11 downto 0);
   x1 : out unsigned(11 downto 0);
   y1 : out unsigned(11 downto 0) );
end Logic;

architecture RTL of Logic is
 signal adr : unsigned(7 downto 0) := "00000000";
 signal rw : unsigned(1 downto 0) := "00";
begin

process(clk)
begin
 if rising_edge(clk) then
  rw <= rw + 2;
  if rw = 2 then
     rw <= to_unsigned(0, 2);
     adr <= adr + 1;
     if adr = 4 then
        adr <= to_unsigned(0, 8);
     end if;
  end if;
  if (adr = 1) and (rw = 1) then
     x1 <= datin;
  elsif (adr = 2) and (rw = 1) then
     y1 <= datin;
  end if;
  if rw = 2 then
     datout <= (0 => tipke(to_integer(adr)), others => '0');
  end if;
 end if;
end process;

end RTL;