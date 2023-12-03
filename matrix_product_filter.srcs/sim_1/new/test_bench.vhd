library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_bench is
end test_bench;

architecture Behavioural of test_bench is
    constant clk_period : time := 1 ns;
    signal clk, reset, input, output, SP_enable, MP_enable, PS_enable, SP_mode, PS_mode  : STD_LOGIC := '0';
    signal serial_input_register : STD_LOGIC_VECTOR(15 downto 0) := "0000010100000110"; --A = 5, B = 6
    signal serial_output_value_register : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

    component filtering_core is
        port (
            clk                     : in  STD_LOGIC;
            reset                   : in  STD_LOGIC;
            SP_enable               : in  STD_LOGIC;
            MP_enable               : in  STD_LOGIC;
            PS_enable               : in  STD_LOGIC;
            SP_mode                 : in  STD_LOGIC;
            PS_mode                 : in  STD_LOGIC;
            input                   : in  STD_LOGIC;
            output                  : out STD_LOGIC
          );
    end component;

begin
    UUT: filtering_core
        port map (
            clk => clk,
            reset => reset,
            SP_enable => SP_enable,
            MP_enable => MP_enable,
            PS_enable => PS_enable,
            SP_mode => SP_mode,
            PS_mode => PS_mode,
            input => input,
            output => output
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
    
    
    -- Filtering Core simulus process
    process
    begin
        SP_enable <= '1';    --Starts Serial to parallel conversor enabled
        SP_mode <= '1';  --Set to read serial input
        wait for clk_period*17;	--Waits for 16 bits
        SP_mode <= '0';  --Set to write parallel output
        wait for clk_period;
        SP_enable <= '0';
        --Enables PS
        PS_enable <= '1';    --Starts Serial to parallel conversor enabled
        PS_mode <= '1';  --Set to read parallel input
        wait for clk_period;
        PS_mode <= '0';  --Set to write serial output
        wait for clk_period*16;
        PS_enable <= '0';
        wait;
    end process;

    -- Serial output processs
    -- The output data is thrown to a shift register to better visualize the output data stream
    process
    begin
        wait for clk_period;
        serial_output_value_register <=  output & serial_output_value_register(15 downto 1);-- To visualize output data stream
    end process;
end Behavioural;