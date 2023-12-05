----------------------------------------------------------------------------------
--  Filtering core:
--  Gets a 16-bit input, performs the filtering based on matricial operations
--  Then returns the filtered 16-bit input through a serial output.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity filtering_core is
    port (
        clk                     : in  STD_LOGIC;
        reset                   : in  STD_LOGIC;
        SP_enable               : in  STD_LOGIC;
        MP_enable               : in  STD_LOGIC;
        PS_enable               : in  STD_LOGIC;
        SP_mode                 : in  STD_LOGIC;
        PS_mode                 : in  STD_LOGIC;
        c0                      : in STD_LOGIC_VECTOR(7 downto 0);
        c1                      : in STD_LOGIC_VECTOR(7 downto 0);
        c2                      : in STD_LOGIC_VECTOR(7 downto 0);
        c3                      : in STD_LOGIC_VECTOR(7 downto 0);
        input                   : in  STD_LOGIC;
        output                  : out STD_LOGIC
      );
end filtering_core;

architecture Behavioral of filtering_core is
    signal SP_output, MP_output : std_logic_vector(15 downto 0) := (others => '0');

begin
    S_P: entity work.S_P
    port map (
        reset,
        SP_enable,
        clk,
        input,
        SP_mode,
        SP_output
    );

    M_P: entity work.matrix_processor
    port map (
        reset,
        MP_enable,
        clk,
        c0,
        c1,
        c2,
        c3,
        SP_output,
        MP_output
    );

    P_S: entity work.P_S
    port map (
        reset,
        PS_enable,
        clk,
        MP_output,
        PS_mode,
        output
    );

end Behavioral;