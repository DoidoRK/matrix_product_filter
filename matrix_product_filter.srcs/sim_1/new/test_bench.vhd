library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_bench is
end test_bench;

architecture Behavioural of test_bench is
    constant clk_period : time := 1 ns;
    signal clk  : std_logic := '0';
    signal x_serial_in, x_mode, x_enable : std_logic := '0';
    signal y_serial_out, y_mode, y_enable : std_logic := '0';
    signal X0_X1 : STD_LOGIC_VECTOR(15 downto 0);
    

    component S_P
        Port (
            enable : in STD_LOGIC;
            clk : in STD_LOGIC;
            input : in STD_LOGIC;
            mode : in STD_LOGIC;
            output : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    component P_S is
        Port (
            enable : in STD_LOGIC;
            clk : in STD_LOGIC;
            input : in STD_LOGIC_VECTOR(15 downto 0);
            mode : in STD_LOGIC;
            output : out STD_LOGIC
        );
    end component;

begin
    -- Instantiate the S/P component
    X_IN: S_P
        port map (
            enable => x_enable,
            clk => clk,
            input => x_serial_in,
            mode => x_mode,
            output => X0_X1
        );

    Y_OUT: P_S
        port map (
            enable => y_enable,
            clk => clk,
            input => X0_X1,
            mode => y_mode,
            output => y_serial_out
        );

    -- Clock
    clk <= not clk after clk_period / 2;

    -- X vector input process
    process
    begin
        wait for clk_period;
        x_enable <= '1';    --Starts Serial to parallel conversor enabled
        x_mode <= '1';  --Set to read serial input
        y_enable <= '0'; --Starts Parallel to Serial conversor disabled
        y_mode <= '0';  --Set to write serial output

        --Value for first element in vector
        --Loads 5 in X0
        wait for clk_period;    --MSB
        x_serial_in <= '0';       
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
        wait for clk_period;    --LSB
        x_serial_in <= '1';

        --Value for second element in vector
        --Loads 10 in X1
        wait for clk_period;    --MSB
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
        x_serial_in <= '1';
        wait for clk_period;    --LSB
        x_serial_in <= '0';

        --Expected X0_X1 value:
        --050A

        wait for clk_period;
        x_mode <= '0';  --Sets to write parallel output
        
        wait for clk_period;
        y_enable <= '1'; --Enables P/S
        y_mode <= '1';  --Sets to reading parallel input data.
        x_enable <= '0';    --Disables S/P

        wait for clk_period;
        y_mode <= '0';  --Sets S/P to writing serial output data.

        --Expected y_serial_out pattern
        --0101000010100000
        wait for clk_period*16;
        y_enable <= '0';  --Disables S/P.
        wait;
    end process;

end Behavioural; 