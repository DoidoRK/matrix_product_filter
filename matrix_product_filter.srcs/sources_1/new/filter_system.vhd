----------------------------------------------------------------------------------
--  Filter System:
--  The input to this system is the same that goes to the P/S converter
--  It takes 16 clocks to read the input serial input, 3 to proccess the values, and 16 to send the serial output
--
--
--
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity filter_system is
    port (
        clk             : in  STD_LOGIC;
        enable          : in  STD_LOGIC;
        input           : in  STD_LOGIC;
        reset           : in  STD_LOGIC;
        output          : out  STD_LOGIC
      );
end filter_system;

architecture Behavioral of filter_system is
    signal counter              : INTEGER range 0 to 36 := 0;
    signal sp_enable, matrix_processor_enable, ps_enable : STD_LOGIC;
    signal sp_output, ps_input  : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal mode                 : STD_LOGIC;
    
begin
    S_P: entity work.S_P
        port map (
            reset,
            sp_enable,
            clk,
            input,
            mode,
            sp_output
        );
    matrix_processor: entity work.matrix_processor
        port map(
            reset,
            matrix_processor_enable,
            clk,
            sp_output,
            ps_input
        );
    P_S: entity work.P_S port map (
        reset,
        ps_enable,
        clk,
        ps_input,
        mode,
        output
    );
    
    process(clk)
    begin
        if reset = '1' then
            counter <= 0;
            ps_enable <= '0';
            sp_enable <= '0';
            matrix_processor_enable <= '0';
            mode <= '0';
        elsif enable = '1' then
            elsif rising_edge(clk) then
                -- Increment counter
                COUNTER <= (COUNTER + 1) mod 37;
                -- Sequential operation
            if counter > 0 and counter < 16 then
                -- 16 clocks to read input serially
                sp_enable <= '1';
                ps_enable <= '0';
                mode <= '1';
            elsif counter >= 16 and counter < 17 then
                -- 1 clock to pass S_P data to matrix operator
                mode <= '0';
            elsif counter >= 17 and counter < 19 then
                -- 3 clocks to proccess data.
                sp_enable <= '0';
                matrix_processor_enable <= '1';
            elsif counter >= 19 and counter < 20 then
                -- 1 clock to get proccessed in P_S converter.
                matrix_processor_enable <= '0';
                ps_enable <= '1';
                mode <= '1';
            elsif counter >= 21 and counter < 36 then
                -- P_S converter writes results in output serial..
                mode <= '0';
            end if;
        end if;
    end process;
end Behavioral;
