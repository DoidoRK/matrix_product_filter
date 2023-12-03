library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_bench is
end test_bench;

architecture Behavioural of test_bench is
    constant clk_period : time := 1 ns;
    -- Common Wires.
    signal clk, SP_enable, MP_enable, PS_enable, SP_mode, PS_mode  : STD_LOGIC := '0';
    
    --Core specific wires.
    --Core 0.
    signal core_0_reset, core_0_input, core_0_output : STD_LOGIC := '0';
    signal x : STD_LOGIC_VECTOR(15 downto 0) := "0000010100000110"; --X0 = 5, X1 = 6.
    signal y : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

    --Core 1.
    signal core_1_reset, core_1_input, core_1_output  : STD_LOGIC := '0';
    signal h : STD_LOGIC_VECTOR(15 downto 0) := "0000010100000111"; --H0 = 5, H1 = 7.
    signal g : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');


    component filtering_core_0 is
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

    component filtering_core_1 is
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
    UUA: filtering_core_0
        port map (
            clk => clk,
            reset => core_0_reset,
            SP_enable => SP_enable,
            MP_enable => MP_enable,
            PS_enable => PS_enable,
            SP_mode => SP_mode,
            PS_mode => PS_mode,
            input => core_0_input,
            output => core_0_output
        );
    UUB: filtering_core_1
        port map (
            clk => clk,
            reset => core_1_reset,
            SP_enable => SP_enable,
            MP_enable => MP_enable,
            PS_enable => PS_enable,
            SP_mode => SP_mode,
            PS_mode => PS_mode,
            input => core_1_input,
            output => core_1_output
        );

    -- Clock.
    clk <= not clk after clk_period / 2;

    -- Core 0 Serial input processs.
    -- The input data comes from a shift register to better visualize the input data stream.
    process
    begin
        wait for clk_period;
        core_0_input <= x(15);
        x <= x(14 downto 0) & '0'; -- To visualize input data stream.
    end process;

    -- Core 0 Serial output processs.
    -- The output data is thrown to a shift register to better visualize the output data stream.
    process
    begin
        wait for clk_period;
        y <=  core_0_output & y(15 downto 1);-- To visualize output data stream.
    end process;

    -- Core 1 Serial input processs.
    -- The input data comes from a shift register to better visualize the input data stream.
    process
    begin
        wait for clk_period;
        core_1_input <= h(15);
        h <= h(14 downto 0) & '0'; -- To visualize input data stream.
    end process;

    -- Core 1 Serial output processs.
    -- The output data is thrown to a shift register to better visualize the output data stream.
    process
    begin
        wait for clk_period;
        g <=  core_1_output & g(15 downto 1);-- To visualize output data stream.
    end process;
    
    -- Common wires Stimulus proccess.
    process
    begin
        SP_enable <= '1';       -- Starts Serial-to-parallel converters.
        SP_mode <= '1';         -- Set to read serial inputs.
        wait for clk_period*17; -- Waits for 16 bits to be read.
        SP_mode <= '0';         -- Set to write parallel outputs.
        wait for clk_period;
        SP_enable <= '0';
        MP_enable <= '1';       -- Enables the Matrix Processors.
        wait for 3*clk_period;  -- Waits for matrix operations results to be ready.
        MP_enable <= '0';       -- Disables the matrix processors.
        PS_enable <= '1';       -- Starts Serial-to-Parallel converters.
        PS_mode <= '1';         -- Set to read parallel inputs.
        wait for clk_period;
        PS_mode <= '0';         -- Set to write serial outputs.
        wait for clk_period*16; -- Waits for 16-bits to be outputted.
        PS_enable <= '0';       -- Disables the Parallel-to-Serial converters.
        wait;
    end process;

end Behavioural;