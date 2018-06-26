-- ------------------------ --
--  THM CPU RA WS 2013/14   --
--                          --
--  Arithmetic Logic Unit   --
-- ------------------------ --
-- Authors: Matthias Roell, --
--          Fabian Stahl    --
-- Date:    06.02.2014      --
-- ------------------------ --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arithmetic_logic_unit is
    port(
        -- Control Input --
        aluOp      : in  std_logic_vector(2 downto 0);
        -- Data Input --
        memOut     : in  std_logic_vector(15 downto 0);
        accOut     : in  std_logic_vector(15 downto 0);
		  immgenOut  : in  std_logic_vector(15 downto 0);
		  immgenCtrl : in  std_logic;
        -- Data Output  --
        aluOut     : out std_logic_vector(15 downto 0)
    );
end arithmetic_logic_unit;

architecture rtl of arithmetic_logic_unit is
Signal aluIn: std_logic_vector(15 downto 0);
begin
	 with immgenCtrl select aluIn <=
       memOut 		when '0',
		 immgenOut 	when '1',
		 "0000000000000000" when others; 
        
                 
				
    -- Set output based on aluOp
    with aluOp select aluOut <=
        std_logic_vector(signed(aluIn) + signed(accOut)) when "000",    -- ADD
        std_logic_vector(signed(accOut) - signed(aluIn)) when "001",    -- SUB
		  std_logic_vector(signed(accOut) / signed(aluIn)) when "011",	 -- DIV
		  std_logic_vector(signed(accOut(7 downto 0)) * signed(aluIn(7 downto 0))) when "100",	 -- MUL
        not (memOut and accOut) when "010",                              -- NAND
        std_logic_vector((signed(accOut)) mod (signed(aluIn))) when "101",	 -- MOD
		  "0000000000000000" when others;                                     -- Not used operation

end;
