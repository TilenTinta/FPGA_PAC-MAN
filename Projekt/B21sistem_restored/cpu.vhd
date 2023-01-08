library ieee,work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.procpak.all;

entity CPU is
port ( clk, ce: in std_logic; 
       rst: in std_logic; 
       data : in unsigned(11 downto 0);        
		 pin: in unsigned(11 downto 0);       
       addr:  out	unsigned(7 downto 0);
	    wren: out std_logic;
       pout:  out	unsigned(11 downto 0);
       wr, rd: out std_logic 
	  );
end CPU;

architecture opis of CPU is
 signal code: unsigned(3 downto 0);
 signal pc, pc1: unsigned(7 downto 0) := x"00";
 signal adr, adrs: unsigned(7 downto 0) := x"00";
 signal akum, ak1: unsigned(11 downto 0);
 signal carry: std_logic := '0';
 type stanje is (reset, zajemi, izvedi);
 signal st: stanje;
begin
  
 addr <= adrs; -- naslovni signal 
 adrs <=  x"00" when st=reset else               -- reset
			 pc1 when st=izvedi and code=ret else   -- dodatek za return
          pc when st=izvedi else                 -- naslednji ukaz
			 data(7 downto 0);                      -- parameter
  
P: process(clk, ce, rst)
 variable rez: unsigned(12 downto 0); -- delni rezultat vsote/razlike
begin    
 if rst = '1' then    
    st <= reset;
	 pc <= x"00";    
 elsif rising_edge(clk) and ce='1' then        
  adr <= adrs;
  --rd <= '0';
  if st = reset then      -- stanje reset
    adr <= x"00";
	 akum <= x"000";
    st <= zajemi;
  elsif st = zajemi then  -- stanje zajemi
    code <= data(11 downto 8);
    pc <= adr + 1;             
    if data(11 downto 8)=jmp or  -- pogoj za izvedbo skoka
	   (data(11 downto 8)=jze and akum = "000") or
	   (data(11 downto 8)=jcs and carry = '1') then
      st <= zajemi;
    elsif (data(11 downto 8)=call) then -- skok na podprogram
	   st <= zajemi;
		pc1 <= adr + 1; -- shrani naslednji pc(tj. adr+1) in akumulator
		ak1 <= akum;
	 else
      st <= izvedi;
    end if;
  else                    -- stanje izvedi
    case code is		
		when lda =>
			akum <= data;
			carry <= '0';
      when inp =>
			akum <= pin;
			carry <= '0';
			--rd <= '1';
      when add =>
		   rez := ('0' & akum) + ('0' & data);			
			akum <= rez(11 downto 0);
			carry <= rez(12);
		when sbt =>
		   rez := ('0' & akum) - ('0' & data);			
			akum <= rez(11 downto 0);
			carry <= rez(12);
		when nota =>
			akum <= not akum;
			carry <= '0';
		when anda =>
			akum <= akum and data;
			carry <= '0';
		when ora =>
			akum <= akum or data;
			carry <= '0';
		when shl =>
			akum <= akum sll 1;
			carry <= akum(11);
		when shr =>
			akum <= akum srl 1;
			carry <= akum(0);
		when ret =>
			akum <= ak1;
		when others =>
		   null; 
	 end case;
              
    st <= zajemi;
  end if;
end if;
end process;

wren   <= '1' when st = zajemi and data(11 downto 8) = sta else '0';
wr <= '1' when st = zajemi and data(11 downto 8) = outp else '0';
rd <= '1' when st = zajemi and data(11 downto 8) = inp else '0';

pout <= akum;

end opis;