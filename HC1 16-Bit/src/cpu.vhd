-- ------------------------ --
--  THM CPU RA WS 2013/14   --
--                          --
--  Central Processing Unit --
-- ------------------------ --
-- Authors: Matthias Roell, --
--          Fabian Stahl    --
-- Date:    06.02.2014      --
-- ------------------------ --

library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity cpu is
    port(
        clk              : in  std_logic;                    -- Clock input
        reset            : in  std_logic;                    -- Reset input

        inEnter          : in  std_logic;                    -- Enter key
        keyIn            : in  std_logic_vector(15 downto 0); -- Value input

        ledWait          : out std_logic;                    -- Wait for enter
        ledOut           : out std_logic_vector(15 downto 0); -- Value output ooes to seven segment
			
		  flagOut 			 : out std_logic_vector(7 downto 0); -- Test Flags
		  
        resetOut         : out std_logic;                    -- Reset indicator
        clkOut           : out std_logic                     -- Clock indicator
    );
end cpu;

architecture rtl of cpu is

Component immgen is PORT(
immgenIn: IN std_logic_vector(11 downto 0);
immgenOut: OUT std_logic_vector(15 downto 0)
);
end Component;

    -- Data Wires
    signal address : std_logic_vector(15 downto 0);       -- PC to MEM
    signal memOut : std_logic_vector(15 downto 0);        -- MEM to IR, ALU & ACC
    signal accOut : std_logic_vector(15 downto 0);        -- ACC to MEM, ALU & OUT_LEDS
    signal opCode : std_logic_vector(3 downto 0);        -- IR to CTRL
    signal irOut  : std_logic_vector(11 downto 0);        -- IR to CTRL & PC
    signal aluOut : std_logic_vector(15 downto 0);        -- ALU to ACC
	 signal immgenOut: std_logic_vector(15 downto 0);      --Immgen to Alu
    -- Control Wires
    signal pcSel  : std_logic_vector(1 downto 0);        -- PC input address selection
    signal pcLoad : std_logic;                           -- PC enable
    signal adrSel : std_logic;                           -- PC output address selection

    signal irLoad : std_logic;                           -- IR enable

    signal accSel   : std_logic_vector(2 downto 0);      -- ACC input data selection
    signal accLoad  : std_logic;                         -- ACC enable
    signal posFlag  : std_logic;                         -- ACC data is positive flag
    signal zeroFlag : std_logic;                         -- ACC data is zero flag
	 signal immgenCtrl: std_logic;                        --Ctrl to alu
    signal aluOp : std_logic_vector(2 downto 0);         -- ALU operation selection
    signal memWrite : std_logic;                         -- MEM write enable
    signal outputEnable : std_logic;                     -- LED output enable

	 signal legacySel : std_Logic;								--	8-Bit Code Signal
begin

    -- The following commands connecting the signals, inputs & outputs between
    -- all single components of the cpu
    --
    CTRL : control_unit port map(clk, reset, inEnter, posFlag, zeroFlag ,legacySel, opCode,
                                 irOut, pcSel, pcLoad, adrSel, irLoad, accSel,
                                 accLoad, aluOp, immgenCtrl, memWrite, outputEnable, ledWait);											
    MEM  : memory_unit port map(clk, reset, memWrite, address, accOut, memOut);
    ALU  : arithmetic_logic_unit port map(aluOp, memOut, accOut, immgenOut, immgenCtrl, aluOut);
	 IGN  : immgen port map(irOut, immgenOut);
    ACC  : accumulator port map(clk, accLoad, accSel, keyIn, memOut, aluOut,
                                accOut, posFlag, zeroFlag);
    IR   : instruction_register port map(clk, irLoad, memOut, opCode, irOut,legacySel);
    PC   : program_counter port map(clk, pcLoad, pcSel, adrSel, irOut, address);

    -- Setting the value output if output is enabled
    --
    ledOut(0) <= accOut(0) and outputEnable;
    ledOut(1) <= accOut(1) and outputEnable;
    ledOut(2) <= accOut(2) and outputEnable;
    ledOut(3) <= accOut(3) and outputEnable;

    ledOut(4) <= accOut(4) and outputEnable;
    ledOut(5) <= accOut(5) and outputEnable;
    ledOut(6) <= accOut(6) and outputEnable;
    ledOut(7) <= accOut(7) and outputEnable;
	 
	 ledOut(8) <= accOut(8) and outputEnable;
    ledOut(9) <= accOut(9) and outputEnable;
    ledOut(10) <= accOut(10) and outputEnable;
    ledOut(11) <= accOut(11) and outputEnable;
	 
	 ledOut(12) <= accOut(12) and outputEnable;
    ledOut(13) <= accOut(13) and outputEnable;
    ledOut(14) <= accOut(14) and outputEnable;
    ledOut(15) <= accOut(15) and outputEnable;

	 flagOut(0) <= posFlag;
	 flagOut(7) <= zeroFlag;
	 
    -- Setting the clock and reset indicators (added for debugging)
    --
    resetOut <= reset;
    clkOut <= clk;

end;
