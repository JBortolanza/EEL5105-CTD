library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counter_time is port (
    R: in std_logic;
	E: in std_logic;
	load: in std_logic_vector(7 downto 0);
	clk: in std_logic;
	end_time: out std_logic;
	O: out std_logic_vector(7 downto 0)
    );
end counter_time;

architecture counter of counter_time is
signal cont: std_logic_vector (7 downto 0);
signal end_timee: std_logic;
begin
process (clk, R, E, cont)
begin
	if R = '1' then
	    cont <= "01100011";
	    end_timee <= '0';
	elsif clk'event and clk = '1' and (cont /= "00000000" or cont < "01100100") then
	    if E = '1' then
		cont <= cont - load;
		end if;
	elsif cont > "01100011" then
	    end_timee <= '1';
		cont <= "00000000";
	end if;
	    O <= cont;
	    end_time <= end_timee;
	end process;
end counter;