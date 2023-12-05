library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_bench_matrix_processor is
end test_bench_matrix_processor;

architecture Behavioural of test_bench_matrix_processor is
    constant clk_period : time := 1 ns;
    signal clk  : std_logic := '0';
    signal reset  : std_logic := '0';
    signal enable : std_logic := '0';
    signal input  : std_logic_vector(15 downto 0) := (others => '0');
    signal output : std_logic_vector(15 downto 0);
    signal a0 : STD_LOGIC_VECTOR(7 downto 0) := "00000001";
    signal a1 : STD_LOGIC_VECTOR(7 downto 0) := "00000010";
    signal a2 : STD_LOGIC_VECTOR(7 downto 0) := "00000011";
    signal a3 : STD_LOGIC_VECTOR(7 downto 0) := "00000100";

    component matrix_processor
        Port (
            reset  : in STD_LOGIC;
            enable : in STD_LOGIC;
            clk :  in STD_LOGIC;
            C0 : in STD_LOGIC_VECTOR(7 downto 0);
            C1 : in STD_LOGIC_VECTOR(7 downto 0);
            C2 : in STD_LOGIC_VECTOR(7 downto 0);
            C3 : in STD_LOGIC_VECTOR(7 downto 0);
            input : in STD_LOGIC_VECTOR (15 downto 0);
            output: out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

begin
    UUT: matrix_processor
        port map (
            reset => reset,
            enable => enable,
            C0 => a0,
            C1 => a1,
            C2 => a2,
            C3 => a3,
            clk => clk,
            input => input,
            output => output
        );

    -- Clock
    clk <= not clk after clk_period / 2;


    -- Stimulus process
    process
    begin
        enable <= '1';  -- Enable the matrix processor
        -- Loads Values into A and B
        input(15 downto 8) <= "00000101";  -- A = 5
        input(7 downto 0) <=  "00000110";  -- B = 6
        -- Wait for the simulation to finish
        wait for 3*clk_period;
        enable <= '0';  -- Disable the matrix processor
        wait;
    end process;

end Behavioural;