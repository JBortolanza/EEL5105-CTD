library ieee;
use ieee.std_logic_1164.all;
entity pisc is port (
	D: in std_logic_vector(8 downto 0);
	Q: out std_logic_vector(8 downto 0);
	CLK: std_logic
	);
end pisc;
architecture pisca of pisc is
begin
	process(CLK)
	begin
		if (CLK'event and CLK = '1') then
		    Q <= d;
		else
		    Q <= "000000000";
        end if;
	end process;
end pisca;