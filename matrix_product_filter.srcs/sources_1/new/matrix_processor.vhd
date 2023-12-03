library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

----------------------------------------------------------------------------------
-- Matrix Processor.
-- Performs the following operation:
-- ┌           ┐   ┌     ┐       ┌               ┐       ┌        ┐
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
--  C0 = 12     C1 =  6
--  C2 =  4     C2 = 15
----------------------------------------------------------------------------------

entity matrix_processor is
    Port (
        enable : in STD_LOGIC;
        clk :  in STD_LOGIC;
        input : in STD_LOGIC_VECTOR (15 downto 0);
        output: out STD_LOGIC_VECTOR (15 downto 0)
    );
end matrix_processor;

architecture Behavioral of matrix_processor is
    constant K : STD_LOGIC_VECTOR(15 downto 0) := "1011010100000100";
    constant C0 : STD_LOGIC_VECTOR(7 downto 0) := "00000001";
    constant C1 : STD_LOGIC_VECTOR(7 downto 0) := "00000010";
    constant C2 : STD_LOGIC_VECTOR(7 downto 0) := "00000011";
    constant C3 : STD_LOGIC_VECTOR(7 downto 0) := "00000100";
    signal A, B : STD_LOGIC_VECTOR(7 downto 0);
    signal TEMP0, TEMP1 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal counter : INTEGER range 0 to 2 := 0;
begin

    process(clk)
    begin
        if enable = '1' then    --Enables module operation
            if rising_edge(clk) then
                -- Increment the counter at each rising edge
                    counter <= (counter + 1) mod 3;
                -- Depending on the counter value, perform different steps
                case counter is
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