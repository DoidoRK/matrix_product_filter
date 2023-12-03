library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

----------------------------------------------------------------------------------
-- 16 bit Parallel to Serial converter
-- First bit sended through serial output will be LSB
-- Last bit sended through serial output will be MSB
-- Output starts from MSB and goes down to LSB

-- INPUT
-- ┌   ┐ 
-- │ 0 │
-- │ 0 │
-- │ 0 │
-- │ 0 │
-- │ 0 │
-- │ 1 │ 
-- │ 0 │ 
-- │ 1 │          OUTPUT
-- │ 0 │ =>  00000101 00001010
-- │ 0 │
-- │ 0 │
-- │ 0 │
-- │ 1 │
-- │ 0 │
-- │ 1 │
-- │ 0 │
-- └   ┘   
----------------------------------------------------------------------------------

entity P_S is
    Port (
        reset  : in STD_LOGIC;
        enable : in STD_LOGIC;
        clk : in STD_LOGIC;
        input : in STD_LOGIC_VECTOR(15 downto 0);
        mode : in STD_LOGIC;
        output : out STD_LOGIC := '0'
    );
end P_S;

architecture Behavioral of P_S is
    signal shift_register : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset values on reset signal
            shift_register <= (others => '0');
        elsif enable = '1' then    --Enables module operation
            if rising_edge(clk) then
                if mode = '1' then -- Reads the parallel bits in parallel_input if mode is '1'
                    shift_register <= input; -- Shift the data in the shift register
                else
                    -- Outputs serial data if mode is '0'
                    output <= shift_register(0);
                    shift_register <= '0' & shift_register(15 downto 1);
                end if;
            end if;
        end if;
    end process;
end Behavioral;
