library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity digital_filter is
    port (
        clk                     : in  STD_LOGIC;
        core_0_reset            : in  STD_LOGIC;
        core_1_reset            : in  STD_LOGIC;
        SP_enable               : in  STD_LOGIC;
        MP_enable               : in  STD_LOGIC;
        PS_enable               : in  STD_LOGIC;
        SP_mode                 : in  STD_LOGIC;
        PS_mode                 : in  STD_LOGIC;
        a0                      : in STD_LOGIC_VECTOR(7 downto 0);
        a1                      : in STD_LOGIC_VECTOR(7 downto 0);
        a2                      : in STD_LOGIC_VECTOR(7 downto 0);
        a3                      : in STD_LOGIC_VECTOR(7 downto 0);
        b0                      : in STD_LOGIC_VECTOR(7 downto 0);
        b1                      : in STD_LOGIC_VECTOR(7 downto 0);
        b2                      : in STD_LOGIC_VECTOR(7 downto 0);
        b3                      : in STD_LOGIC_VECTOR(7 downto 0);
        core_0_input            : in  STD_LOGIC;
        core_0_output           : out STD_LOGIC;
        core_1_input            : in  STD_LOGIC;
        core_1_output           : out STD_LOGIC
      );
end digital_filter;

architecture Behavioral of digital_filter is

begin
    CORE_0: entity work.filtering_core
    port map (
        clk,
        core_0_reset,
        SP_enable,
        MP_enable,
        PS_enable,
        SP_mode,
        PS_mode,
        a0,
        a1,
        a2,
        a3,
        core_0_input,
        core_0_output
    );

    CORE_1: entity work.filtering_core
    port map (
        clk,
        core_1_reset,
        SP_enable,
        MP_enable,
        PS_enable,
        SP_mode,
        PS_mode,
        b0,
        b1,
        b2,
        b3,
        core_1_input,
        core_1_output
    );

end Behavioral;
