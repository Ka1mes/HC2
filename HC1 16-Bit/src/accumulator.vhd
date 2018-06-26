-- ------------------------ --
--  THM CPU RA WS 2013/14   --
--                          --
--  Accumulator             --
-- ------------------------ --
-- Authors: Matthias Roell, --
--          Fabian Stahl    --
-- Date:    06.02.2014      --
-- ------------------------ --

library ieee;
use ieee.std_logic_1164.all;

entity accumulator is
    port(
        -- Control Input --
        clk         : in  std_logic;
        accLoad     : in  std_logic;
        accSel      : in  std_logic_vector(2 downto 0);
        -- Data Input --
        keyIn       : in  std_logic_vector(15 downto 0);
        memOut      : in  std_logic_vector(15 downto 0);
        aluOut      : in  std_logic_vector(15 downto 0);
        -- Data Output  --
        accOut      : out std_logic_vector(15 downto 0);
        posFlag     : out std_logic;
        zeroFlag    : out std_logic
    );
end accumulator;

architecture rtl of accumulator is

    -- Register to hold the output
    signal holdAccOut : std_logic_vector(15 downto 0);

begin
    CLK_PROCESS : process(clk)
    begin
        if rising_edge(clk) then
            -- Load new input
            if accLoad = '1' then
                if accSel = "000" then          -- Load ALU
                    holdAccOut <= aluOut;
                elsif accSel = "001" then       -- Load Memory
                    holdAccOut <= memOut;
                elsif accSel = "010" then       -- Load Keyinput
                    holdAccOut <= keyIn;
					 else                        				-- Not used Value
                    holdAccOut <= "0000000000000000";
                end if;
            end if;

            -- Set Zero Flag
            if holdAccOut = "0000000000000000" then
                zeroFlag <= '1';
					 posFlag <= '0';
            else
					zeroFlag <= '0';
						if holdAccOut(15) = '0' then
							posFlag <= '1';
						else
							posFlag <= '0';
						end if;
            end if;            

            -- Set Output
            accOut <= holdAccOut;
        end if;
    end process;

end;
