library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity S_P is
 Port (
    clk : in std_logic;
    serial_in : in std_logic;
    read_write  :   in std_logic;   --Flag to set up operation mode.
    parallel_output : out STD_LOGIC_VECTOR(15 downto 0) --Register to hold 16 bit value
  );
end S_P;

architecture Behavioral of S_P is
    signal shift_register : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if read_write = '1' then    --When 1 reads serial input, when 0 outputs register bits in parallel
            if rising_edge(clk) then
                shift_register <= shift_register(14 downto 0) & serial_in; --Gets serial input into element 0 and shifts bits
            end if;
        else
            parallel_output <= shift_register;
        end if;
    end process;
end Behavioral;
