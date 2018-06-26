library ieee;
use ieee.std_logic_1164.all;


entity immgen is PORT(
immgenIn: IN std_logic_vector(11 downto 0);
immgenOut: OUT std_logic_vector(15 downto 0)
);
end immgen;

architecture rtl1 of Immgen is
Begin
immgenOut <= "0000" & immgenIn;
end;