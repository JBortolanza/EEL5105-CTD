library ieee;
use ieee.std_logic_1164.all;
entity Reg4 is port (
	D: in std_logic_vector(3 downto 0);
	Q: out std_logic_vector(3 downto 0);
	reset: in std_logic;
	en: in std_logic;
	CLK: std_logic
	);
end Reg4;
architecture reg16 of Reg4 is
begin
	process(CLK)
	begin
		if (CLK'event and CLK = '1') then
            if (reset = '1') then
                Q <= "0000";
            elsif (en = '1') then
                Q <= D;
            end if;
		end if;
	end process;
end reg16;