library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity datapath is port(

    SW: in std_logic_vector(17 downto 0);
    CLK: in std_logic;
	 Enter_left, Enter_right: in std_logic;
    R1, E1, E2, E3, E4, E5, E6: in std_logic;
	 end_game, end_sequence, end_round, end_left, end_right: out std_logic;
    HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0: out std_logic_vector(6 downto 0);
    LEDR: out std_logic_vector(17 downto 0));

end datapath;

architecture arc_data of datapath is

-- signals padronizados. Favor utilizar estes.

signal play_left, play_right: std_logic_vector(15 downto 0);
signal control_left, control_right, rst_divfreq, not_entl, not_entr: std_logic;
signal sel, X: std_logic_vector(3 downto 0);
signal seq_out_left, seq_out_right, penalty: std_logic_vector(7 downto 0);
signal T_left_BCD, T_right_BCD, T_left_out, T_right_out: std_logic_vector(7 downto 0);
signal end_time_left, end_time_right: std_logic;
signal termo: std_logic_vector(15 downto 0);
signal pisca, pn,  mx_time_left, mx_time_right, mx_sqoutl, mx_sqoutr, mx_trm: std_logic_vector(8 downto 0);
signal S: std_logic_vector(79 downto 0);

signal mx_hex7, mx_hex6, mx_hex5, mx_hex4: std_logic_vector(3 downto 0);
signal mx_1hex3, mx_2hex3, mx_1hex2, mx_2hex2, mx_1hex1, mx_2hex1, mx_1hex0, mx_2hex0: std_logic_vector(3 downto 0);
signal mxsel_msb, mxsel_lsb: std_logic_vector(3 downto 0);
signal E2_and_X0, notE1_or_R1: std_logic; 
signal saida_rom0, saida_rom1, saida_rom2, saida_rom3: std_logic_vector(79 downto 0);
signal sel_cnt, sel_mxledr: std_logic_vector(1 downto 0);
signal mux_ctrlleft, saida_load_left, mux_ctrlright, saida_load_right: std_logic_vector(7 downto 0);
signal CLK_1Hz, Sim_1Hz, enable_left, enable_right: std_logic;
signal SWleft, SWRight: std_logic_vector(15 downto 0);

signal left_penalty, right_penalty: std_logic_vector(7 downto 0);

----- components

component decoder_termometrico is port(
    
    X: in  std_logic_vector(3 downto 0);
    S: out std_Logic_vector(15 downto 0));
    
end component;

component Div_Freq_Emu is
	port (	clk: in std_logic;
			reset: in std_logic;
			CLK_1Hz: out std_logic;
			Sim_1Hz: out std_logic);
end component;

component DecBCD is port (

	input  : in  std_logic_vector(7 downto 0);
	output : out std_logic_vector(7 downto 0));

end component;

component ROM0 is port (

    address : in  std_logic_vector(3 downto 0);
    data    : out std_logic_vector(79 downto 0));
    
end component;

component ROM1 is port (

    address : in  std_logic_vector(3 downto 0);
    data    : out std_logic_vector(79 downto 0));
    
end component;

component ROM2 is port (

    address : in  std_logic_vector(3 downto 0);
    data    : out std_logic_vector(79 downto 0));
    
end component;

component ROM3 is port (

    address : in  std_logic_vector(3 downto 0);
    data    : out std_logic_vector(79 downto 0));
    
end component;

component Comparador is port(
    
    in0, in1: in  std_logic_vector(7 downto 0);
    S       : out std_logic);
    
end component;

component Mux2_1x4 is port(

    S     : in  std_logic;
    L0, L1: in  std_logic_vector(3 downto 0);
    D     : out std_logic_vector(3 downto 0));
    
end component;

component Mux2_1x8 is port(

    S     : in  std_logic;
    L0, L1: in  std_logic_vector(7 downto 0);
    D     : out std_logic_vector(7 downto 0));
    
end component;

component Mux4_1x8 is port(

    S             : in  std_logic_vector(1 downto 0);
    L0, L1, L2, L3: in  std_logic_vector(7 downto 0);
    D             : out std_logic_vector(7 downto 0));
    
end component;

component Mux4_1x9 is port(

    S: in std_logic_vector(1 downto 0);
    L0, L1, L2, L3: in std_logic_vector(8 downto 0);
    D: out std_logic_vector(8 downto 0));
    
end component;

component Mux4_1x80 is port(

    S: in std_logic_vector(1 downto 0);
    L0, L1, L2, L3: in std_logic_vector(79 downto 0);
    D: out std_logic_vector(79 downto 0));
    
end component Mux4_1x80;

component decod7seg is port (

	input  : in  std_logic_vector(3 downto 0);
	output : out std_logic_vector(6 downto 0));

end component;

------------------------completar os components que faltam------------------------------

component Reg is port (

	D: in std_logic_vector(15 downto 0);
	Q: out std_logic_vector(15 downto 0);
	reset: in std_logic;
	en: in std_logic;
	CLK: std_logic
	);
	
end component;

component Reg4 is port (
	D: in std_logic_vector(3 downto 0);
	Q: out std_logic_vector(3 downto 0);
	reset: in std_logic;
	en: in std_logic;
	CLK: std_logic
	);
end component;

component counter_time is port (
    R: in std_logic;
	E: in std_logic;
	load: in std_logic_vector(7 downto 0);
	clk: in std_logic;
	end_time: out std_logic;
	O: out std_logic_vector(7 downto 0)
    );
end component;

component counter_round is port (
    R: in std_logic;
    E: in std_logic;
	clk: in std_logic;
	end_round: out std_logic;
	X: out std_logic_vector(3 downto 0)
    );
end component;

component counter_seq is port (
    R: in std_logic;
	E: in std_logic;
	clk: in std_logic;
	end_round: out std_logic;
	X: out std_logic_vector(1 downto 0)
    );
end component;

component pisc is port (
	D: in std_logic_vector(8 downto 0);
	Q: out std_logic_vector(8 downto 0);
	CLK: std_logic
	);
end component;

begin

------ HEX ----------------------------

E2_and_X0 <= E2 and X(0);
notE1_or_R1 <= not(E1 or R1);

--usando o decod7seg fornecido, "1111" apaga os displays

--HEX7

mx_hx7: mux2_1x4 port map(notE1_or_R1, "1111", T_left_BCD(7 downto 4), mx_hex7);
d7_hx7: decod7seg port map(mx_hex7, HEX7);

--HEX6

mx_hx6: mux2_1x4 port map(notE1_or_R1, "1111", T_left_BCD(3 downto 0), mx_hex6);
d7_hx6: decod7seg port map(mx_hex6, HEX6);

--HEX5

mx_hx5: mux2_1x4 port map(E2_and_X0, "1111", Seq_out_left(7 downto 4), mx_hex5);
d7_hx5: decod7seg port map(mx_hex5, HEX5);

--HEX4

mx_hx4: mux2_1x4 port map(E2_and_X0, "1111", Seq_out_left(3 downto 0), mx_hex4);
d7_hx4: decod7seg port map(mx_hex4, HEX4);

--HEX3

mx_1hx3: mux2_1x4 port map(E1, "1111", "1100", mx_1hex3); -- 1100 eh J no decod7seg fornecido
mx_2hx3: mux2_1x4 port map(notE1_or_R1, mx_1hex3, T_right_BCD(7 downto 4), mx_2hex3);
d7_hx3: decod7seg port map(mx_2hex3, HEX3);

--HEX2

mxsel_msb <= "00" & sel(3 downto 2);
mx_1hx2: mux2_1x4 port map(E1, "1111", mxsel_msb, mx_1hex2);
mx_2hx2: mux2_1x4 port map(notE1_or_R1, mx_1hex2, T_right_BCD(3 downto 0), mx_2hex2);
d7_hx2: decod7seg port map(mx_2hex2, HEX2);

--HEX1

mx_1hx1: mux2_1x4 port map(E1, "1111", "1101", mx_1hex1); -- 1101 eh L no decod7seg fornecido
mx_2hx1: mux2_1x4 port map(E2_and_X0, mx_1hex1, Seq_out_right(7 downto 4), mx_2hex1);
d7_hx1: decod7seg port map(mx_2hex1, HEX1);

--HEX0

mxsel_lsb <= "00" & sel(1 downto 0);
mx_1hx0: mux2_1x4 port map(E1, "1111", mxsel_lsb, mx_1hex0);
mx_2hx0: mux2_1x4 port map(E2_and_X0, mx_1hex0, Seq_out_right(3 downto 0), mx_2hex0);
d7_hx0: decod7seg port map(mx_2hex0, HEX0);


---- ROM's

ROM_0: ROM0 port map(X, saida_rom0);
ROM_1: ROM1 port map(X, saida_rom1);
ROM_2: ROM2 port map(X, saida_rom2);
ROM_3: ROM3 port map(X, saida_rom3);

---- Muxes LEDR

sel_mxledr <= (E5 or E6) & ((E2 and not(X(0))) or E6);
mx_time_left <= pisca when end_time_left = '0' else "000000000";
mx_time_right <= pisca when end_time_right = '0' else "000000000";


mx_sqoutl <= seq_out_left & '0';
mx_sqoutr <= '0' & seq_out_right;
mx_trm <= "00" & termo(15 downto 9);
mxlrmsb: Mux4_1x9 port map(sel_mxledr, "000000000", mx_sqoutl, mx_trm, mx_time_left, LEDR(17 downto 9));
mxlrlsb: Mux4_1x9 port map(sel_mxledr, "000000000", mx_sqoutr, termo(8 downto 0), mx_time_right, LEDR(8 downto 0));


---- Sinais/Entradas logicas

end_left <= Enter_left;   --como entradas e saidas nao podem ter o mesmo nome, foram chamadas de "end_left" e "end_right",
end_right <= Enter_right; --mas no resto do projeto continuam sendo Enter_left e Enter_right.



------------------------------------ FAZER ----------------------------------------

CompL: Comparador port map(Play_left(7 downto 0), Play_left(15 downto 8), Control_left);
CompR: Comparador port map(Play_right(7 downto 0), Play_right(15 downto 8), Control_right);

PenaltyMUX: Mux4_1x8 port map(SEL(1 downto 0), "00000010", "00000100", "00000110", "00001000", Penalty);

LoadLeftMUX0: Mux2_1x8 port map(Control_left, Penalty, "00000000", mux_ctrlleft);
LoadLeftMUX1: Mux2_1x8 port map(E4, "00000001", mux_ctrlleft, saida_load_left);

LoadRightMUX0: Mux2_1x8 port map(Control_Right, Penalty, "00000000", mux_ctrlright);
LoadRightMUX1: Mux2_1x8 port map(E4, "00000001", mux_ctrlright, saida_load_right);

RomMux:  Mux4_1x80 port map(SEL(3 downto 2), saida_rom0, saida_rom1, saida_rom2, saida_rom3, S);

SeqOutLeftMUX: Mux4_1x8 port map(sel_cnt, S(47 downto 40), S(55 downto 48), S(63 downto 56), S(71 downto 64), seq_out_left);
SeqOutRighttMUX: Mux4_1x8 port map(sel_cnt, S(7 downto 0), S(15 downto 8), S(23 downto 16), S(31 downto 24), seq_out_right);


SWleft <= SW(17 downto 10 )& S(79 downto 72);
SWright <= SW(7 downto 0 )& S(39 downto 32);
not_entl <= not enter_left;
not_entr <= not enter_right;
PlayREGLeft: reg port map(SWleft, play_left, R1, not_entl, CLK);
PlayREGRight: reg port map(SWright, play_right, R1, not_entr, CLK);
SelREG4: reg4 port map(SW(3 downto 0), SEL, R1, E1, CLK);

enable_left <= (((E3 and CLK_1Hz) and not_entl) or E4);
CTimeLeft: Counter_time port map(R1, enable_left, saida_load_left, CLK, end_time_left, T_left_out);

enable_right <= (((E3 and CLK_1Hz) and not_entr) or E4);
CTimeRight: Counter_time port map(R1, enable_right, saida_load_right, CLK, end_time_right, T_right_out);

end_game <= (end_time_left or end_time_right);

CRound: counter_round port map(R1, E4, CLK, end_round, X);
CSeq: counter_seq port map(R1, E2, CLK_1Hz, end_sequence, sel_cnt);


rst_divfreq <= (E1 or E5);
DIVFREQ: Div_Freq_Emu port map(CLK, rst_divfreq, CLK_1Hz, Sim_1Hz);

DecodBCDL: DecBCD port map(T_left_out, T_left_BCD);
DecodBCDR: DecBCD port map(T_right_out, T_right_BCD);

DecTerm: decoder_termometrico port map(X, Termo);

pn <= "111111111";
P: pisc port map(pn,pisca,Sim_1Hz);


end arc_Data;
