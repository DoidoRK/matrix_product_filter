library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_bench_S_P is
end test_bench_S_P;

architecture Behavioural of test_bench_S_P is
    constant clk_period : time := 1 ns;
    --A receives 05, --B receives 06
    signal serial_input_register : STD_LOGIC_VECTOR(15 downto 0) := "0000011000000101";
    signal serial_output_value_register : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal reset : STD_LOGIC := '0';
    signal enable : STD_LOGIC := '0';
    signal clk  : STD_LOGIC := '0';
    signal mode  : STD_LOGIC := '0';
    signal input : STD_LOGIC := '0';   --For serial in

    component S_P
        Port (
            reset  : in STD_LOGIC;
            enable : in STD_LOGIC;
            clk : in STD_LOGIC;
            input : in STD_LOGIC;
            mode : in STD_LOGIC;
            output : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

begin
    UUT: S_P
        port map (
            reset => reset,
            enable => enable,
            clk => clk,
            input => input,
            mode => mode,
            output => serial_output_value_register
        );

    -- Clock
    clk <= not clk after clk_period / 2;

    -- Serial input processs
    -- The input data comes from a shift register to better visualize the input data stream
    process
    begin
        wait for clk_period;
        input <= serial_input_register(15);
        serial_input_register <= serial_input_register(14 downto 0) & '0'; -- To visualize input data stream
    end process;

    process
    begin
        enable <= '1';    --Starts Serial to parallel conversor enabled
        mode <= '1';  --Set to read serial input
        wait for clk_period*17;	--Waits for 16 bits
        mode <= '0';  --Set to write parallel output
        wait for clk_period;
        enable <= '0';    
        wait;
    end process;

end Behavioural;