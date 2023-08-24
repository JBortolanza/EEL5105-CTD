library ieee;
use ieee.std_logic_1164.all;

entity toplevel is
port(
	SW: in std_logic_vector(17 downto 0);
    CLK: in std_logic;
    KEY: in std_logic_vector(3 downto 0);
    HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0: out std_logic_vector(6 downto 0);
    LEDR: out std_logic_vector(17 downto 0)
	);
end toplevel;

architecture tr of toplevel is

signal R1, E1, E2, E3, E4, E5, E6, end_game, end_sequence, end_round, end_left, end_right, enter, reset, enter_left, enter_right: std_logic;

component datapath is port(

    SW: in std_logic_vector(17 downto 0);
    CLK: in std_logic;
	Enter_left, Enter_right: in std_logic;
    R1, E1, E2, E3, E4, E5, E6: in std_logic;
	end_game, end_sequence, end_round, end_left, end_right: out std_logic;
    HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0: out std_logic_vector(6 downto 0);
    LEDR: out std_logic_vector(17 downto 0)
    );

end component;

component control is port (
   enter: in std_logic;
   reset: in std_logic;
   clock: in std_logic;
   R1, E1, E2, E3, E4, E5, E6: out std_logic;
   end_game, end_sequence, end_round, end_left, end_right: in std_logic
   );
end component;

component ButtonSync is port(

    KEY1, KEY0, CLK: in  std_logic;
    BTN1, BTN0   : out std_logic
    );

end component;

component ButtonPlay is port(

    KEY1, KEY0: in  std_logic;
    Reset, clk: in  std_Logic;
    BTN1, BTN0: out std_logic
    ); 
    
end component;

begin

BS: ButtonSync port map(KEY(1), KEY(0), CLK, enter, reset);    
BP: ButtonPlay port map(KEY(3), KEY(2), E2, CLK, enter_left, enter_right);

Data: datapath port map(SW, CLK, enter_left, enter_right, R1, E1, E2, E3, E4, E5, E6, 
                        end_game, end_sequence, end_round, end_left, end_right,
                        HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
                        LEDR);
                        
CT: control port map(enter, reset, CLK, R1, E1, E2, E3, E4, E5, E6,
                     end_game, end_sequence, end_round, end_left, end_right);
end tr;