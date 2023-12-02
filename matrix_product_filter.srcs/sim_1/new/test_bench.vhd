library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_bench is
end test_bench;

architecture Behavioural of test_bench is
    constant clk_period : time := 1 ns;
    signal clk, x_serial_in, x_read_write : std_logic := '0';
    signal X_S_P_output : STD_LOGIC_VECTOR(15 downto 0);
    

    component S_P
        Port (
            clk : in std_logic;
            serial_in : in std_logic;
            read_write  :   in std_logic;
            parallel_output : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

begin
    -- Instantiate the S/P component
    UUT: S_P
        port map (
            clk => clk,
            serial_in => x_serial_in,
            read_write => x_read_write,
            parallel_output => X_S_P_output
        );

    -- Clock
    clk <= not clk after clk_period / 2;

    -- S/P Stimulus process
    process
    begin
        wait for clk_period;
        x_read_write <= '1';  --Enables S/P to read serial input

        --Value for first element in vector
        --Loads 5 in X2
        wait for clk_period;
        x_serial_in <= '0';       --LSB
        wait for clk_period;
        x_serial_in <= '0';
        wait for clk_period;
        x_serial_in <= '0';
        wait for clk_period;
        x_serial_in <= '0';
        wait for clk_period;
        x_serial_in <= '0';
        wait for clk_period;
        x_serial_in <= '1';
        wait for clk_period;
        x_serial_in <= '0';
        wait for clk_period;
        x_serial_in <= '1';       --MSB

        --Value for second element in vector
        --Loads 10 in X1
        wait for clk_period;    
        x_serial_in <= '0';       --LSB
        wait for clk_period;
        x_serial_in <= '0';
        wait for clk_period;
        x_serial_in <= '0';
        wait for clk_period;
        x_serial_in <= '0';
        wait for clk_period;
        x_serial_in <= '1';
        wait for clk_period;
        x_serial_in <= '0';
        wait for clk_period;
        x_serial_in <= '1';
        wait for clk_period;    
        x_serial_in <= '0';       --MSB

        wait for clk_period;
        x_read_write <= '0';  --Enables S/P to write to parallel output
        wait;
    end process;

end Behavioural;
