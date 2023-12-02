library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity S_P is
    Port (
        serial_in : in STD_LOGIC;
        clk : in STD_LOGIC;
        read_write : in STD_LOGIC;
        parallel_output : out STD_LOGIC_VECTOR(15 downto 0)
    );
end S_P;

architecture Behavioral of S_P is
    signal shift_register : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if read_write = '1' then -- Reads the incoming bits in serian input if read_write is '1'
                shift_register <= shift_register(14 downto 0) & serial_in; -- Shift the data in the shift register
            else
                -- Output the parallel data if read_write is '0'
                parallel_output <= shift_register;
            end if;
        end if;
    end process;
end Behavioral;
