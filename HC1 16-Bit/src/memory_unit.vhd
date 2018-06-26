-- ------------------------ --
--  THM CPU RA WS 2013/14   --
--                          --
--  Memory                  --
-- ------------------------ --
-- Authors: Matthias Roell, --
--          Fabian Stahl    --
-- Date:    06.02.2014      --
-- ------------------------ --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_unit is
    port(
        -- Control Input --
        clk           : in  std_logic;
        reset         : in  std_logic;
        memWrite      : in  std_logic;
        -- Data Input --
        address       : in  std_logic_vector(15 downto 0);
        accOut        : in  std_logic_vector(15 downto 0);
        -- Data Output  --
        memOut        : out std_logic_vector(15 downto 0)
    );
end memory_unit;

architecture rtl of memory_unit is

    type ram_type is array (108 downto 0) of std_logic_vector(15 downto 0);
	 
    signal ram          : ram_type;

    -- holds output address until next clk
    signal readAddress  : std_logic_vector(15 downto 0);

begin
    RAM_PROCESS : process(clk, reset)
    begin
        if reset = '1' then
		  
		  
		  -- GGT 16-Bit				
				
--				ram(0) <= "0110" & "000000000000";			-- IN A			   X
--				ram(1) <= "0010" & "000000011111";			-- STORE M(31) 	X
--				ram(2) <= "0110" & "000000000000";			-- IN A			   Y
--				ram(3) <= "0010" & "000000011110";			-- STORE M(30) 	Y
--				ram(4) <= "0001" & "000000011111";			-- LOAD M(31)		
--				ram(5) <= "0010" & "000000011101";			-- STORE M(29)	
--				ram(6) <= "0100" & "000000011110";			-- SUB A - M(30) 	X - Y
--				ram(7) <= "0111" & "000000010001";			-- JZ M(17)      (wenn X==Y out X)
--
--				ram(8) <= "1000" & "000000001101";			-- JPOS M(13)    (wenn X>Y jump 13)
--																								
--				ram(9) <= "0001" & "000000011110";			-- LOAD M(30)    (load Y)
--				ram(10) <= "0100" & "000000011111";			-- SUB A - M(31)	Y - X
--				ram(11) <= "0010" & "000000011110";			-- STORE M(30)    (save to Y)
--				ram(12) <= "1001" & "000000000100";			-- J M(4)         (jump 4)
--
--				ram(13) <= "0001" & "000000011111";			-- LOAD M(31)		(load X)
--				ram(14) <= "0100" & "000000011110";			-- SUB A - M(30)	X - Y
--				ram(15) <= "0010" & "000000011111";			-- STORE M(31)    (store as X)
--				ram(16) <= "1001" & "000000000100";			-- J M(4)         (jump 4)
--
--				ram(17) <= "0001" & "000000011101";			-- LOAD M(29)   (output X)
--				ram(18) <= "0110" & "000000000001";			-- OUT A
--				ram(19) <= "1001" & "000000000000";			-- J M(0)
--
--				ram(29) <= "0000000000000000";				-- M(29) <= 0
--				ram(30) <= "0000000000000000";				-- M(30) <= 0
--				ram(31) <= "0000000000000000";				-- M(31) <= 0
--		  
		  -- Multi 16-Bit
		  
--		  		ram(0) <= "0110" & "000000000000";		-- IN A X
--				ram(1) <= "0010" & "000000010100";		-- Store in M(20) X
--				ram(2) <= "0110" & "000000000000";		-- In A Y
--				ram(3) <= "0010" & "000000010101";		-- Store in M(21) Y
--				ram(4) <= "0111" & "000000010001";		-- Springe zur Ergebnis ausgabe wenn 0
--				ram(5) <= "0001" & "000000010110";		-- Load M(22)
--				ram(6) <= "0011" & "000000010100";		-- Addiere Acc + M(20)
--				ram(7) <= "0010" & "000000010110";		-- Store M(22)
--				ram(8) <= "0001" & "000000010101";		-- Load M(21)
--				ram(9) <= "0100" & "000000010111";		-- Sub A -M(23)
--				ram(10) <= "1001" & "000000000011",		-- Jump ram(3)
--
--
--				ram(17) <= "0001" & "000000010110";		-- Load M(22)
--				ram(18) <= "0110" & "000000000001"; 	-- Out
--				ram(20) <= "0000000000000000";			-- M(20) <= 0	X
--				ram(21) <= "0000000000000000";	 		-- M(21) <= 0	Y
--				ram(22) <= "0000000000000000"; 			-- M(22) <= 0	Ergebnis
--				ram(23) <= "0000000000000001"; 			-- M(23) <= 1	1
--		  
		  
				-- Multi 8-Bit
				
--				ram(0) <= "00000000" & "100" & "00000";		-- IN A X
--				ram(1) <= "00000000" & "001" & "10100";		-- Store in M(20)
--				ram(2) <= "00000000" & "100" & "00000";		-- IN A Y
--				ram(3) <= "00000000" & "100" & "10101";		-- Store in M(21)
--				ram(4) <= "00000000" & "101" & "10001";		-- JZ 17
--				ram(5) <= "00000000" & "000" & "10110";		-- Load M(22)
--				ram(6) <= "00000000" & "010" & "10100";		-- Add Acc + M(20)
--				ram(7) <= "00000000" & "001" & "10110";		-- Store in M(22)
--				ram(8) <= "00000000" & "000" & "10101";		-- Load M(21)
--				ram(9) <= "00000000" & "011" & "10111";		-- Sub Acc- M(23)
--				ram(10) <= "00000000" & "111" & "00011";		-- Jum ram(3)
--
--				ram(17) <= "00000000" & "000" & "10110";		-- Load M(22)
--				ram(18) <= "00000000" & "100" & "00001";		-- Out
--				ram(20) <= "00000000" & "000" & "00000";		-- M(20) = 0
--				ram(21) <= "00000000" & "000" & "00000";		-- M(21) = 0
--				ram(22) <= "00000000" & "000" & "00000";		-- M(22) = 0
--				ram(23) <= "00000000" & "000" & "00001";		-- M(23) = 1		  
		  
		  
		  		-- GGT 8-Bit
				
--				ram(0) <= "00000000" & "100" & "00000";	-- IN A			X
--				ram(1) <= "00000000" & "001" & "11111";	-- STORE M(31) 	X
--				ram(2) <= "00000000" & "100" & "00000";	-- IN A			Y
--				ram(3) <= "00000000" & "001" & "11110";	-- STORE M(30) 	Y
--				ram(4) <= "00000000" & "000" & "11111";	-- LOAD M(31)		
--				ram(5) <= "00000000" & "001" & "11101";	-- STORE M(29)	
--				ram(6) <= "00000000" & "011" & "11110";	-- SUB A - M(30) 	X - Y
--				ram(7) <= "00000000" & "101" & "10001";	-- JZ M(17)
--				ram(8) <= "00000000" & "110" & "01101";	-- JPOS M(13)
--				ram(9) <= "00000000" & "000" & "11110";	-- LOAD M(30)
--				ram(10) <= "00000000" & "011" & "11111";	-- SUB A - M(31)	Y - X
--				ram(11) <= "00000000" & "001" & "11110";	-- STORE M(30)
--				ram(12) <= "00000000" & "111" & "00100";	-- J M(4)
--				ram(13) <= "00000000" & "000" & "11111";	-- LOAD M(31)
--				ram(14) <= "00000000" & "011" & "11110";	-- SUB A - M(30)	X - Y
--				ram(15) <= "00000000" & "001" & "11111";	-- STORE M(31)
--				ram(16) <= "00000000" & "111" & "00100";	-- J M(4)
--				ram(17) <= "00000000" & "000" & "11101";	-- LOAD M(29)
--				ram(18) <= "00000000" & "100" & "00001";	-- OUT A
--				ram(19) <= "00000000" & "111" & "00000";	-- J M(0)
--
--				ram(29) <= "0000000000000000";				-- M(29) <= 0
--				ram(30) <= "0000000000000000";				-- M(30) <= 0
--				ram(31) <= "0000000000000000";				-- M(31) <= 0
				
				--Division Test
--				ram(0) <= "0110" & "000000000000";			-- IN A			   X
--			   ram(1) <= "0010" & "000000011111";			-- STORE M(31) 	X
--				ram(2) <= "0110" & "000000000000";			-- IN A			   Y
--				ram(3) <= "0010" & "000000011110";			-- STORE M(30) 	Y
--				ram(4) <= "0001" & "000000011111";			-- LOAD M(31)
--				ram(5) <= "1010" & "000000011110";			-- DIV X/Y
--				ram(6) <= "0110" & "000000000001";			-- OUT A
--				ram(7) <= "1001" & "000000000000";			-- J M(0)

            --Multiplikation Test
--				ram(0) <= "0110" & "000000000000";			-- IN A			   X
--			   ram(1) <= "0010" & "000000011111";			-- STORE M(31) 	X
--				ram(2) <= "0110" & "000000000000";			-- IN A			   Y
--				ram(3) <= "0010" & "000000011110";			-- STORE M(30) 	Y
--				ram(4) <= "0001" & "000000011111";			-- LOAD M(31)
--				ram(5) <= "1011" & "000000011110";			-- MUL X/Y
--				ram(6) <= "0110" & "000000000001";			-- OUT A
--				ram(7) <= "1001" & "000000000000";			-- J M(0)
				
				-- AddI Test;
          
--				ram(0) <= "0110" & "000000000000";			-- IN A			   X				
--				ram(1) <= "1100" & "000000000011";        -- IN 1
--				ram(2) <= "0110" & "000000000001";

				--GGT Modulo
				
				ram(0) <= "0110" & "000000000000"; -- IN A zahl1			Hauptprogramm:
				ram(1) <= "0010" & "000001101001"; -- STORE in M(105) zahl1
				ram(2) <= "0110" & "000000000000"; -- IN A zahl2
				ram(3) <= "0010" & "000001101000"; -- STORE in M(104) zahl2
				ram(4) <= "1000" & "000000001000"; -- JPOS zu ram(8)
				ram(5) <= "0001" & "000001100100"; -- LOAD M(100) ggt
				ram(6) <= "0110" & "000000000001"; -- OUT A ggt
				ram(7) <= "1001" & "000000000000"; -- J zu ram(0)

									
				   --					Unterprogramm:
				ram(8) <= "0001" & "000001101000"; -- LOAD M(104) zahl2		   	zahl1 zur größeren zahl machen
				ram(9) <= "0100" & "000001101001"; -- SUB A - M(105) zahl1
				ram(10)<= "1000" & "000000010001"; -- JPOS zu ram(17) 			wenn zahl1 bereits größer als zahl2 ist
				ram(11)<= "0001" & "000001101001"; -- LOAD M(105) zahl1
				ram(12)<= "0010" & "000001100111"; -- STORE in M(103) zahl3
				ram(13)<= "0001" & "000001101000"; -- LOAD M(104) zahl2
				ram(14)<= "0010" & "000001101001"; -- STORE in M(105) zahl1
				ram(15)<= "0001" & "000001100111"; -- LOAD M(103) zahl3
				ram(16)<= "0010" & "000001101000"; -- STORE in M(104) zahl2

				ram(17)<= "0001" & "000001101001"; -- LOAD M(105) zahl1
				ram(18)<= "0010" & "000001100110"; -- STORE in M(102) gröZahl
				ram(19)<= "0001" & "000001101000"; -- LOAD M(105) zahl2
				ram(20)<= "0010" & "000001100100"; -- STORE in M(100) ggt

				ram(21)<= "1001" & "000001101010"; -- J zu ram(106)                   	for Schleife: i initialisieren
				ram(22)<= "0001" & "000001100110"; -- LOAD M(102) größZahl	
				ram(23)<= "0100" & "000001101010"; -- SUB A - M(106) i			gröZahl - i
				ram(24)<= "0111" & "000000100011"; -- JPZ zu ram(35)			falls 0  , springe zu ram(35)
				ram(25)<= "1000" & "000000100011"; -- JPOS zu ram(35)			falls gröZahl - i > 0, springe zu ram(35)
				ram(26)<= "1001" & "000000000101"; -- J zu ram(5)  return von ggt

				ram(35)<= "0001" & "000001101001"; -- LOAD M(105) zahl1			GGT Algorithmus
				ram(36)<= "1110" & "000001101000"; -- A MOD M(104) zahl2
				ram(37)<= "0010" & "000001100101"; -- STORE in M(101) berechnung
				ram(38)<= "0001" & "000001100101"; -- LOAD M(101) berechnung
				ram(39)<= "0111" & "000000000101"; -- JPZ zu ram(5) return von ggt	falls berechnung = 0, springe zu ram(5)
				ram(40)<= "0010" & "000001100100"; -- STORE in M(100) ggt
				ram(41)<= "0001" & "000001101000"; -- LOAD M(104) zahl2
				ram(42)<= "0010" & "000001101001"; -- STORE in M(105) zahl1
				ram(43)<= "0001" & "000001100101"; -- LOAD M(101) berechnung
				ram(44)<= "0010" & "000001101000"; -- STORE in M(104) zahl2
				ram(45)<= "0001" & "000001101010"; -- LOAD M(106) i			i um 1 erhöhen
				ram(46)<= "1100" & "000000000001"; -- ADDI A + 1
				ram(47)<= "0010" & "000001101010"; -- STORE in M(106) i
				ram(48)<= "1001" & "000000010110"; -- J zu ram(22)



				ram(106)<= "0000000000000000"; 	    -- M(106) <= 0
				ram(107)<= "1001" & "000000010110"; -- J zu ram(22)
				
				
		  elsif rising_edge(clk) then
            -- Write data to memory
            if memWrite = '1' then
                ram(to_integer(unsigned(address))) <= accOut;
            end if;
            -- Store output adress
            readAddress <= address;
        end if;
    end process;

    -- Set output (updates on RAM_PROCESS through readAddress signal)
    memOut <= ram(to_integer(unsigned(readAddress)));

end;
