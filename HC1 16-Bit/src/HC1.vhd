-- ------------------------ --
--  THM CPU RA WS 2013/14   --
--                          --
--  HC1 Mapping             --
-- ------------------------ --
-- Authors: Matthias Roell, --
-- Date:    07.12.2014      --
-- ------------------------ --

library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity HC1 is
    port(
        SW          : in  std_logic_vector(17 downto 0);

        LEDR        : out std_logic_vector(17 downto 0);
        LEDG        : out std_logic_vector(7 downto 0);

        CLOCK_50    : in std_logic;

        HEX0        : out std_logic_vector(0 to 6);
        HEX1        : out std_logic_vector(0 to 6);
        HEX2        : out std_logic_vector(0 to 6);
        HEX3        : out std_logic_vector(0 to 6);

        HEX4        : out std_logic_vector(0 to 6);
        HEX5        : out std_logic_vector(0 to 6);
        HEX6        : out std_logic_vector(0 to 6);
        HEX7        : out std_logic_vector(0 to 6);

        KEY         : in  std_logic_vector(3 downto 0)
    );
end HC1;

architecture rtl of HC1 is
    signal divided_clock : std_logic;
    signal output_storage : std_logic_vector(15 downto 0);
	 signal flagOut_storage: std_logic_vector(7 downto 0);
begin
    CLOCK:  clock_divider port map(not KEY(3), CLOCK_50, divided_clock);
    CPUNIT: cpu port map(divided_clock, not KEY(3), not KEY(0), SW(15 downto 0), LEDR(0), output_storage,flagOut_storage, LEDR(17), LEDR(16));

    InputDisp0: seven_segment port map (SW(3 downto 0), HEX0);
    InputDisp1: seven_segment port map (SW(7 downto 4), HEX1);
	 InputDisp2: seven_segment port map (SW(11 downto 8), HEX2);
    InputDisp3: seven_segment port map (SW(15 downto 12), HEX3);

    OutputDisp0: seven_segment port map (output_storage(3 downto 0), HEX4);
    OutputDisp1: seven_segment port map (output_storage(7 downto 4), HEX5);
	 OutputDisp2: seven_segment port map (output_storage(11 downto 8), HEX6);
    OutputDisp3: seven_segment port map (output_storage(15 downto 12), HEX7);

    LEDG <= flagOut_storage(7 downto 0);
end;
