library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_bench is
end test_bench;

architecture Behavioural of test_bench is
    constant clk_period : time := 1 ns;
    signal clk, SP_enable, MP_enable, PS_enable, SP_mode, PS_mode  : STD_LOGIC := '0';
    
    -- Core 0 wires
    signal core_0_reset, core_0_input, core_0_output : STD_LOGIC := '0';
    signal x : STD_LOGIC_VECTOR(15 downto 0) := "0000010100000110"; --X0 = 5, X1 = 6
    signal y : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal a0 :STD_LOGIC_VECTOR(7 downto 0) := "00000001";
    signal a1 :STD_LOGIC_VECTOR(7 downto 0) := "00000010";
    signal a2 :STD_LOGIC_VECTOR(7 downto 0) := "00000011";
    signal a3 :STD_LOGIC_VECTOR(7 downto 0) := "00000100";

    -- Core 1 wires
    signal core_1_reset, core_1_input, core_1_output : STD_LOGIC := '0';
    signal h : STD_LOGIC_VECTOR(15 downto 0) := "0000010100000110"; --H0 = 5, H1 = 6
    signal g : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal b0 :STD_LOGIC_VECTOR(7 downto 0) := "00000001";
    signal b1 :STD_LOGIC_VECTOR(7 downto 0) := "00000010";
    signal b2 :STD_LOGIC_VECTOR(7 downto 0) := "00000011";
    signal b3 :STD_LOGIC_VECTOR(7 downto 0) := "00000100";

    component digital_filter is
        port (
            clk                     : in    STD_LOGIC;
            core_0_reset            : in    STD_LOGIC;
            core_1_reset            : in    STD_LOGIC;
            SP_enable               : in    STD_LOGIC;
            MP_enable               : in    STD_LOGIC;
            PS_enable               : in    STD_LOGIC;
            SP_mode                 : in    STD_LOGIC;
            PS_mode                 : in    STD_LOGIC;
            a0                      : in    STD_LOGIC_VECTOR(7 downto 0);
            a1                      : in    STD_LOGIC_VECTOR(7 downto 0);
            a2                      : in    STD_LOGIC_VECTOR(7 downto 0);
            a3                      : in    STD_LOGIC_VECTOR(7 downto 0);
            b0                      : in    STD_LOGIC_VECTOR(7 downto 0);
            b1                      : in    STD_LOGIC_VECTOR(7 downto 0);
            b2                      : in    STD_LOGIC_VECTOR(7 downto 0);
            b3                      : in    STD_LOGIC_VECTOR(7 downto 0);
            core_0_input            : in    STD_LOGIC;
            core_0_output           : out   STD_LOGIC;
            core_1_input            : in    STD_LOGIC;
            core_1_output           : out   STD_LOGIC
          );
    end component;

begin
    filter: digital_filter
        port map (
            clk => clk,
            core_0_reset => core_0_reset,
            core_1_reset => core_1_reset,
            SP_enable => SP_enable,
            MP_enable => MP_enable,
            PS_enable => PS_enable,
            SP_mode => SP_mode,
            PS_mode => PS_mode,
            a0 => a0,
            a1 => a1,
            a2 => a2,
            a3 => a3,
            b0 => b0,
            b1 => b1,
            b2 => b2,
            b3 => b3,
            core_0_input => x,
            core_0_output => y,
            core_1_input => h,
            core_1_output => g
        );

    -- Clock
    clk <= not clk after clk_period / 2;

    -- Core 0 Serial input process
    -- The input data comes from a shift register to better visualize the input data stream
    process
    begin
        wait for clk_period;
        core_0_input <= x(15);
        x <= x(14 downto 0) & '0'; -- To visualize input data stream
    end process;

    -- Core 0 Serial output process
    -- The output data is thrown to a shift register to better visualize the output data stream
    process
    begin
        wait for clk_period;
        y <=  core_0_output & y(15 downto 1);-- To visualize output data stream
    end process;
    
    -- Core 1 Serial input process
    -- The input data comes from a shift register to better visualize the input data stream
    process
    begin
        wait for clk_period;
        core_1_input <= h(15);
        h <= h(14 downto 0) & '0'; -- To visualize input data stream
    end process;

    -- Core 1 Serial output process
    -- The output data is thrown to a shift register to better visualize the output data stream
    process
    begin
        wait for clk_period;
        g <=  core_1_output & g(15 downto 1);-- To visualize output data stream
    end process;
    
    
    -- Filtering Core simulus process
    process
    begin
        SP_enable <= '1';       -- Starts Serial-to-parallel conversor
        SP_mode <= '1';         -- Set to read serial input
        wait for clk_period*17; -- Waits for 16 bits
        SP_mode <= '0';         -- Set to write parallel output
        wait for clk_period;
        SP_enable <= '0';
        MP_enable <= '1';       -- Enables the Matrix Processor
        wait for 3*clk_period;  -- Waits for matrix operations results to be ready
        MP_enable <= '0';       -- Disables the matrix processor
        PS_enable <= '1';       -- Starts Serial-to-Parallel conversor
        PS_mode <= '1';         -- Set to read parallel input
        wait for clk_period;
        PS_mode <= '0';         -- Set to write serial output
        wait for clk_period*16; -- Waits for 16-bits to be outputted.
        PS_enable <= '0';       -- Disables the Parallel-to-Serial converter
        wait;
    end process;

    -- Serial output processs
    -- The output data is thrown to a shift register to better visualize the output data stream
    process
    begin
        wait for clk_period;
        y <=  core_0_output & y(15 downto 1);-- To visualize output data stream
    end process;
end Behavioural;