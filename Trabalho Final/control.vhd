library ieee;
use ieee.std_logic_1164.all;
entity control is port (
   enter: in std_logic;
   reset: in std_logic;
   clock: in std_logic;
   R1, E1, E2, E3, E4, E5, E6: out std_logic;
   end_game, end_sequence, end_round, end_left, end_right: in std_logic
   );
end control;
architecture controlador of control is
   type STATES is (Innit, Setup, Sequence, Play, Check, Ewait, Result);
   signal EAtual, PEstado: STATES;
begin
    REG: process(clock,reset)
    begin
        if (reset = '1') then
            EAtual <= Innit;
        elsif (clock'event AND clock = '1') then 
             EAtual <= PEstado;
        end if;
    end process;
    COMB: process(EAtual, enter,  end_game, end_sequence, end_round, end_left, end_right)
    begin
        case EAtual is
            when Innit =>
                PEstado <= Setup;
                E1 <= '0';
                E2 <= '0';
                E3 <= '0';
                E4 <= '0';
                E5 <= '0';
                E6 <= '0';
                R1 <= '1';
                
            when Setup =>
                if(enter = '1') then 
                    PEstado <= Sequence;
                end if;
                E1 <= '1';
                E2 <= '0';
                E3 <= '0';
                E4 <= '0';
                E5 <= '0';
                E6 <= '0';
                R1 <= '0';
                
            when Sequence =>
                if(end_sequence = '1') then
                    PEstado <= Play;
                end if;
                E1 <= '0';
                E2 <= '1';
                E3 <= '0';
                E4 <= '0';
                E5 <= '0';
                E6 <= '0';
                R1 <= '0';
                
            when Play => 
                if((end_left = '1') and (end_right = '1')) then
                    PEstado <= Check;
                end if;
                E1 <= '0';
                E2 <= '0';
                E3 <= '1';
                E4 <= '0';
                E5 <= '0';
                E6 <= '0';
                R1 <= '0';
                
            when Check =>
                PEstado <= Ewait;
                E1 <= '0';
                E2 <= '0';
                E3 <= '0';
                E4 <= '1';
                E5 <= '0';
                E6 <= '0';
                R1 <= '0';
                
            when Ewait =>
                if((end_game = '1') or (end_round = '1')) then
                    PEstado <= Result;
                elsif(enter = '1') then
                    PEstado <= Sequence;
                end if;
                E1 <= '0';
                E2 <= '0';
                E3 <= '0';
                E4 <= '0';
                E5 <= '1';
                E6 <= '0';
                R1 <= '0';
                
            when Result =>
                if(enter = '1') then
                    PEstado <= Innit;
                end if;
                E1 <= '0';
                E2 <= '0';
                E3 <= '0';
                E4 <= '0';
                E5 <= '0';
                E6 <= '1';
                R1 <= '0';
                
        end case;
    end process;
end controlador;