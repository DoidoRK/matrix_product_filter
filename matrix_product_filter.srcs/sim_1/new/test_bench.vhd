library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_bench is
end test_bench;

architecture Behavioral of test_bench is
    constant clk_period : time := 1 ns;
    signal clk, serial_in, read_write : std_logic := '0';
    signal parallel_output : STD_LOGIC_VECTOR(15 downto 0);

    component S_P
        Port (
            clk : in std_logic;
            serial_in : in std_logic;
            read_write  :   in std_logic;
            parallel_output : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

begin
    -- Adds S_P component
    UUT: S_P
        port map (
            clk => clk,
            serial_in => serial_in,
            read_write => read_write,
            parallel_output => parallel_output
        );

    --Clock proccess
    clk_process: process
    begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
    end process;

    -- S/P Stimulus proccess
    process
    begin
        wait for clk_period;
        read_write <= '1';  --Enables S/P to read serial input

        --Value for first element in vector
        --Loads 5 in X2
        wait for clk_period;
        serial_in <= '0';       --LSB
        wait for clk_period;
        serial_in <= '0';
        wait for clk_period;
        serial_in <= '0';
        wait for clk_period;
        serial_in <= '0';
        wait for clk_period;
        serial_in <= '0';
        wait for clk_period;
        serial_in <= '1';
        wait for clk_period;
        serial_in <= '0';
        wait for clk_period;
        serial_in <= '1';       --MSB

        --Value for second element in vector
        --Loads 10 in X1
        wait for clk_period;    
        serial_in <= '0';       --LSB
        wait for clk_period;
        serial_in <= '0';
        wait for clk_period;
        serial_in <= '0';
        wait for clk_period;
        serial_in <= '0';
        wait for clk_period;
        serial_in <= '1';
        wait for clk_period;
        serial_in <= '0';
        wait for clk_period;
        serial_in <= '1';
        wait for clk_period;    
        serial_in <= '0';       --MSB

        wait for clk_period;
        read_write <= '0';  --Enables S/P to write to parallel output

        wait;
    end process;


end Behavioral;