library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_bench is
end test_bench;

architecture Behavioural of test_bench is
    constant clk_period : time := 1 ns;
    --A receives 05, --B receives 06
    signal serial_input_register : STD_LOGIC_VECTOR(15 downto 0) := "0000011000000101";
    signal serial_output_value_register : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal reset : STD_LOGIC := '0';
    signal clk  : STD_LOGIC := '0';
    signal enable: STD_LOGIC := '0';
    signal input : STD_LOGIC := '0';   --For serial in
    signal output : STD_LOGIC := '0';  --For serial out

    component filter_system
        Port (
            clk     : in STD_LOGIC;
            enable  : in STD_LOGIC;
            input   : in STD_LOGIC;
            reset   : in STD_LOGIC;
            output  : out STD_LOGIC
        );
    end component;

begin
    UUT: filter_system
        port map (
            clk => clk,
            enable => enable,
            input => input,
            reset => reset,
            output => output
        );
        
    -- Clock
    clk <= not clk after clk_period / 2;

    -- Serial input proccesss
    process
    begin
        -- wait for 2*clk_period;
        wait for clk_period;
        input <= serial_input_register(15);
        serial_input_register <= serial_input_register(14 downto 0) & '0'; -- To visualize input data stream
    end process;

    -- Filter System flags proccess
    process
    begin
        wait for clk_period;
        reset <= '1';   --Starts reseting the filter.
        wait for clk_period;
        reset <= '0';   --Disables reset.
        enable <= '1';  --Enables filtering system.
        wait for 36*clk_period;
        enable <= '0';
    end process;

    -- Serial output proccesss
    process
    begin
        -- wait for 2*clk_period; --Waits for 23 clocks
        wait for clk_period;
        serial_output_value_register <=  serial_output_value_register(14 downto 0) & output;-- To visualize output data stream
    end process;

end Behavioural;