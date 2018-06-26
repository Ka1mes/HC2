-- ------------------------ --
--  THM CPU RA WS 2013/14   --
--                          --
--  Instruction Register    --
-- ------------------------ --
-- Authors: Matthias Roell, --
--          Fabian Stahl    --
-- Date:    07.02.2014      --
-- ------------------------ --

library ieee;
use ieee.std_logic_1164.all;

entity instruction_register is
    port(
        clk    : in  std_logic;
        irLoad : in  std_logic;
        memOut : in  std_logic_vector(15 downto 0);

        opCode : out std_logic_vector(3 downto 0);
        irOut  : out std_logic_vector(11 downto 0);
		  		  		  
		  legacySel : out std_logic
    );
end instruction_register;

architecture rtl of instruction_register is
begin

    -- Simple memory signal splitter. On clock signal set op_code and ir_out
    -- (memory address) from memory output
    --
    CLK_PROCESS : process(clk)
    begin
        if rising_edge(clk) then
            if irLoad = '1' then
						opCode <= memOut(15 downto 12);
						irOut  <= memOut(11 downto 0);
						
					-- Check for 8-Bit Instruction
					 if memOut(15 downto 12) = "0000" then
						opCode(2 downto 0) <= memOut(7 downto 5);
						irOut(11 downto 5) <= "0000000";						
						legacySel <= '1';				
					 else
						legacySel <= '0';
					 end if;                
            end if;
        end if;
    end process;

end;
