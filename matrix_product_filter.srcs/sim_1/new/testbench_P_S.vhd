library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_bench_P_S is
end test_bench_P_S;

architecture Behavioural of test_bench_P_S is
    constant clk_period : time := 1 ns;
    --A receives 05, --B receives 06
    signal serial_input_register : STD_LOGIC_VECTOR(15 downto 0) := "0000011000000101";
    signal serial_output_value_register : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal reset : STD_LOGIC := '0';
    signal enable : STD_LOGIC := '0';
    signal clk  : STD_LOGIC := '0';
    signal mode  : STD_LOGIC := '0';
    signal output : STD_LOGIC := '0';  --For serial out

    component P_S is
        Port (
            reset  : in STD_LOGIC;
            enable : in STD_LOGIC;
            clk : in STD_LOGIC;
            input : in STD_LOGIC_VECTOR(15 downto 0);
            mode : in STD_LOGIC;
            output : out STD_LOGIC
        );
    end component;

begin
    UUT: P_S
        port map (
            reset => reset,
            enable => enable,
            clk => clk,
            input => serial_input_register,
            mode => mode,
            output => output
        );

    -- Clock
    clk <= not clk after clk_period / 2;

    -- Serial output processs
    -- The output data is thrown to a shift register to better visualize the output data stream
    process
    begin
        wait for clk_period;
        serial_output_value_register <=  output & serial_output_value_register(15 downto 1);-- To visualize output data stream
    end process;

    process
    begin
        enable <= '1';    --Starts Serial to parallel conversor enabled
        mode <= '1';  --Set to read parallel input
        wait for clk_period;
        mode <= '0';  --Set to write serial output
        wait for clk_period*16;
        enable <= '0';
        wait;
    end process;

end Behavioural;