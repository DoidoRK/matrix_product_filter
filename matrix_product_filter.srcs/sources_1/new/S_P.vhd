library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

----------------------------------------------------------------------------------
-- 16 bit Serial to Parallel converter
-- First bit coming through serial input will be in MSB
-- Last bit coming through serial input will be in LSB

--                          OUTPUT
--                          ┌   ┐
--                          │ 0 │
--                          │ 0 │
--                          │ 0 │
--                          │ 0 │
--                          │ 0 │
--                          │ 1 │
--        INPUT             │ 0 │
--  0101000010100000   =>   │ 1 │
--                          │ 0 │
--                          │ 0 │
--                          │ 0 │
--                          │ 0 │
--                          │ 1 │
--                          │ 0 │
--                          │ 1 │
--                          │ 0 │
--                          └   ┘
----------------------------------------------------------------------------------

entity S_P is
    Port (
        reset  : in STD_LOGIC;
        enable : in STD_LOGIC;
        clk : in STD_LOGIC;
        input : in STD_LOGIC;
        mode : in STD_LOGIC;
        output : out STD_LOGIC_VECTOR(15 downto 0)
    );
end S_P;

architecture Behavioral of S_P is
    signal shift_register : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if reset = '1' then
            -- Reset values on reset signal
            shift_register <= (others => '0');
        elsif enable = '1' then    --Enables module operation
            if rising_edge(clk) then
                if mode = '1' then -- Reads the incoming bits in serial input if mode is '1'
                    shift_register <= shift_register(14 downto 0) & input; -- Shift the data in the shift register
                else
                    -- Output the parallel data if mode is '0'
                    output <= shift_register;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
