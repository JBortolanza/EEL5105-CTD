library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counter_round is 
port(R: in std_logic;
	  E: in std_logic;
	  clk: in std_logic;
	  end_round: out std_logic;
	  X: out std_logic_vector(3 downto 0)
 );
end counter_round;

architecture counter2 of counter_round is
signal cont: std_logic_vector (3 downto 0);
begin
process (clk, R, E, cont)
begin
	if R = '1' then
	    cont <= "1111";
    	end_round <= '0';
	elsif clk'event and clk = '1' then
	    if E = '1' then
		cont <= cont - 1;
	    end if;
		if cont = "0000" then
		    end_round <= '1';
		else
		    end_round <= '0';
		end if;
    end if;
		X <= cont;
end process;
end counter2;

