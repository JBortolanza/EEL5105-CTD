library ieee;
use ieee.std_logic_1164.all;

entity comparador is
port(
	in0, in1: in std_logic_vector(7 downto 0);
	S: out std_logic
	);
end comparador;

architecture comp of comparador is
begin

    S <= '1' when in0 = in1 else
         '0';
end comp;
