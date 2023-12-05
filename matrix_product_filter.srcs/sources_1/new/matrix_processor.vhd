library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

----------------------------------------------------------------------------------
-- Matrix Processor.
-- Performs the following operation:
-- ┌           �?   ┌     �?       ┌               �?       ┌        �?
-- │  C0  C1   │   │  A  │       │ (A*C0 + B*C1) │       │  OUT0  │
-- │           │ * │     │ * K = │               │ * K = │        │
-- │  C2  C3   │   │  B  │       │ (A*C2 + B*C3) │       │  OUT1  │
-- └           ┘   └     ┘       └               ┘       └        ┘
-- Gets as input a 16 bit register, the upper byte represents A, the lower byte B
-- 1st clock: Get A and B inputs from parallel input
-- 2nd clock: Performs matrix operation
-- 3rd clock: Sends results through output channel
--  * Most significant byte is OUT0 value
--  * Least significant byte is OUT1 value
-- K = 1/sqrt(2) = 1011010100000100
----------------------------------------------------------------------------------

entity matrix_processor is
    Port (
        reset  : in STD_LOGIC;
        enable : in STD_LOGIC;
        clk :  in STD_LOGIC;
        C0 : in STD_LOGIC_VECTOR(7 downto 0);
        C1 : in STD_LOGIC_VECTOR(7 downto 0);
        C2 : in STD_LOGIC_VECTOR(7 downto 0);
        C3 : in STD_LOGIC_VECTOR(7 downto 0);
        input : in STD_LOGIC_VECTOR (15 downto 0);
        output: out STD_LOGIC_VECTOR (15 downto 0)
    );
end matrix_processor;

architecture Behavioral of matrix_processor is
    constant K : STD_LOGIC_VECTOR(15 downto 0) := "1011010100000100";   -- 1/sqrt(2)
    signal A, B : STD_LOGIC_VECTOR(7 downto 0);
    signal TEMP0, TEMP1 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal COUNTER : INTEGER range 0 to 2 := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset values on reset signal
            A <= (others => '0');
            B <= (others => '0');
            TEMP0 <= (others => '0');
            TEMP1 <= (others => '0');
            COUNTER <= 0;
        elsif enable = '1' then
            if  rising_edge(clk) then
                -- Increment the counter at each rising edge
                    COUNTER <= (COUNTER + 1) mod 3;
                -- Depending on the counter value, perform different steps
                case COUNTER is
                    when 0 =>
                        -- 1st clock: Get A and B inputs from parallel input
                        A <= input(15 downto 8);
                        B <= input(7 downto 0);
                    when 1 =>
                        -- 2nd clock: Performs matrix operation
                        TEMP1 <= K*((A*C0)+(B*C1));
                        TEMP0 <= K*((A*C2)+(B*C3));
                    when 2 =>
                        -- 3rd clock: Sends results through output channel
                        output <= TEMP0(23 downto 16) & TEMP1(23 downto 16);
                end case;
            end if;
        end if;
    end process;
end Behavioral;