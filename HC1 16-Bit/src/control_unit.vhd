-- ------------------------ --
--  THM CPU RA WS 2013/14   --
--                          --
--  Control Unit            --
-- ------------------------ --
-- Authors: Matthias Roell, --
--          Fabian Stahl    --
-- Date:    06.02.2014      --
-- ------------------------ --

library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
    port(
        -- Control Input --
        clk          : in  std_logic;
        reset        : in  std_logic;
        inEnter      : in  std_logic;
        posFlag      : in  std_logic;
        zeroFlag     : in  std_logic;
		  legacySel 	: in  std_logic;

        -- Data Input --
        opCode       : in  std_logic_vector(3 downto 0);
        irOut        : in  std_logic_vector(11 downto 0);

        -- Program Counter Output  --
        pcSel        : out std_logic_vector(1 downto 0);
        pcLoad       : out std_logic;
        adrSel       : out std_logic;

        -- Instruction Register Output  --
        irLoad       : out std_logic;

        -- Accumulator Output  --
        accSel       : out std_logic_vector(2 downto 0);
        accLoad      : out std_logic;

        -- Arithmetic Logic Unit Output  --
        aluOp        : out std_logic_vector(2 downto 0);
		  
		  --Immediate Generator Output--
		  immgenCtrl   : out std_logic;

        -- Memory Output  --
        memWrite     : out std_logic;

        -- Generic Output  --
        outputEnable : out std_logic;
        ledWait      : out std_logic
    );
end control_unit;

-- -------------------------------------------- --
-- Control Flow                                 --
-- -------------------------------------------- --
--                                              --
--  1. state      <- nextState on clock         --
--  2. output     <- based on state             --
--  3.               repeat 1 & 2               --
--                                              --
--  x. nextState  <- when input gets changed    --
-- -------------------------------------------- --

architecture rtl of control_unit is
    type state_type is (
        RESET_STATE,                    -- Reset CPU

        CTRL_LOAD_IR,                   -- New Instruction from IR

        MEM_STORE,                      -- Write Memory
        ACC_MEM,                        -- Acc load Memory

        ACC_ALU_ADD,                    -- Acc load ALU with ALU-Add Operation
        ACC_ALU_SUB,                    -- Acc load ALU with ALU-Sub Operation
        ACC_ALU_NAND,                   -- Acc load ALU with ALU-Nand Operation
		  
		  ACC_ALU_DIV,							 -- Acc load ALU with ALU-Div Operation
		  ACC_ALU_MUL,							 -- Acc load ALU with ALU-Mul Operation
		  
		  ACC_ALU_ADDI,						 -- Acc load ALU with ALU-AddI Operation
		  ACC_ALU_SUBI,						 -- Acc load ALU with ALU-SubI Operation
		  
		  ACC_ALU_MOD,							 -- Acc load ALU with ALU-Mod Operation
		  
        ACC_inEnter,                    -- Acc load key_in when inEnter is set

        JUMP_PC_MEM,                    -- PC Jump to Address in Memory

        NOP_PC,                         -- Update PC
        NOP_OUT,                        -- Enable Output while not inEnter
        NOP_MEM,                        -- Update MEM
        NOP_IR                          -- Update IR
);

    signal state         : state_type := RESET_STATE;
    signal nextState     : state_type := RESET_STATE;

begin
    CLOCK_PROCESS : process(clk, reset)
    begin
        if reset = '1' then
            state <= RESET_STATE;
        elsif rising_edge(clk) then
            state <= nextState;
        end if;
    end process;

    -- This process updates the next state based on the incoming signals
    --
    INPUT_STATE_PROCESS : process(state, inEnter, opCode, irOut, zeroFlag, posFlag)
    begin
        nextState <= state;     -- prevents inferred latches,
                                -- because nextState needs to be set even if
                                -- the following case is going to set it

        case (state) is

            -- On reset pc is set to address 0x00 so no nop_pc is needed
            when RESET_STATE =>
                nextState <= NOP_MEM;

            -- Next State depends on inputs
            when CTRL_LOAD_IR =>
                
					 -- Check for 8-Bit 
					 if legacySel = '1' then
						
					  -- Going through opCodes
					 case (opCode(2 downto 0)) is
                    when "000" =>       -- LOAD
                        nextState <= ACC_MEM;
                    when "001" =>
                        nextState <= MEM_STORE;
                    when "010" =>       -- ADD
                        nextState <= ACC_ALU_ADD;
                    when "011" =>       -- SUB
                        nextState <= ACC_ALU_SUB;

                    when "100" =>                       -- NAND, IN, OUT						  
						  
								case(irOut(4 downto 0)) is
									when "00000" =>
										nextState <= ACC_inEnter;
									when "00001" =>
										nextState <= NOP_OUT;
									when others =>
										nextState <= ACC_ALU_NAND;
								end case;								

                    when "101" =>       -- JUMP ZERO
                        if zeroFlag = '1' then
                            nextState <= JUMP_PC_MEM;
                        else
                            nextState <= NOP_PC;
                        end if;
                    when "110" =>       -- JUMP POSITIVE
                        if posFlag = '1' then
                            nextState <= JUMP_PC_MEM;
                        else
                            nextState <= NOP_PC;
                        end if;
                    when others =>      -- JUMP ALWAYS
                        nextState <= JUMP_PC_MEM;
                end case;
					 
					 -- 16-Bit opCodes
					 else					 
						case (opCode) is
                    when "0001" =>       -- LOAD
                        nextState <= ACC_MEM;
                    when "0010" =>		  -- STORE
                        nextState <= MEM_STORE;
                    when "0011" =>       -- ADD
                        nextState <= ACC_ALU_ADD;
                    when "0100" =>       -- SUB
                        nextState <= ACC_ALU_SUB;
                    when "0101" =>       -- NAND						  
								nextState <= ACC_ALU_NAND;
						  when "0110" =>		  -- IN and OUT
								if irOut(0) = '0' then
									nextState <= ACC_inEnter; -- IN
								else
									nextState <= NOP_OUT;	  -- OUT
								end if;								

                    when "0111" =>       -- JUMP ZERO
                        if zeroFlag = '1' then
                            nextState <= JUMP_PC_MEM;
                        else
                            nextState <= NOP_PC;
                        end if;
                    when "1000" =>       -- JUMP POSITIVE
                        if posFlag = '1' then
                            nextState <= JUMP_PC_MEM;
                        else
                            nextState <= NOP_PC;
                        end if;
						  when "1010" =>     --DIV
									 nextState <= ACC_ALU_DIV;
						  when "1011" =>     --MUL
									 nextState<=ACC_ALU_MUL;
						  when "1100" =>     --DIV
									 nextState <= ACC_ALU_ADDI;
						  when "1101" =>     --MUL
									 nextState<=ACC_ALU_SUBI;
						 when "1110" =>     --MOD
									 nextState<=ACC_ALU_MOD;			 
                    when others =>      -- JUMP ALWAYS
                        nextState <= JUMP_PC_MEM;
                end case;	
					 
					 end if;
					 
	            when ACC_inEnter | NOP_OUT =>
                 if inEnter = '1' then
                    nextState <= NOP_PC;
                 else
                    nextState <= state;
                 end if;

            when NOP_PC =>
                nextState <= NOP_MEM;
            -- JUMP_PC_MEM skips NOP_PC and NOP_MEM
            when JUMP_PC_MEM | NOP_MEM =>
                nextState <= NOP_IR;
            when NOP_IR =>
                nextState <= CTRL_LOAD_IR;

            -- Next State is always NOP_PC
            when others =>
                nextState <= NOP_PC;

        end case;
    end process;

    -- This process sets the output based on the current state
    --
    STATE_OUTPUT_PROCESS : process(state)
    begin
        case (state) is
            when RESET_STATE =>         -- Reset CPU
                -- PC
                pcSel        <= "10";
                pcLoad       <= '1';
                adrSel       <= '0';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "000";
                accLoad      <= '0';
                -- ALU
                aluOp        <= "000";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';

            when CTRL_LOAD_IR =>        -- New Instruction from IR
                -- PC
                pcSel        <= "00";
                pcLoad       <= '0';
                adrSel       <= '1';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "000";
                accLoad      <= '0';
                -- ALU
                aluOp        <= "000";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';

            when MEM_STORE =>           -- Write Memory In
                -- PC
                pcSel        <= "00";
                pcLoad       <= '0';
                adrSel       <= '1';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "ZZZ";
                accLoad      <= '0';
                -- ALU
                aluOp        <= "000";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '1';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';

            when ACC_MEM =>             -- Acc load Memory
                -- PC
                pcSel        <= "00";
                pcLoad       <= '0';
                adrSel       <= '0';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "001";
                accLoad      <= '1';
                -- ALU
                aluOp        <= "000";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';
					 
            when ACC_ALU_ADD =>         -- Acc load ALU with ALU-Add Operation
                -- PC
                pcSel        <= "00";
                pcLoad       <= '0';
                adrSel       <= '0';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "000";
                accLoad      <= '1';
                -- ALU
                aluOp        <= "000";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';

            when ACC_ALU_SUB =>         -- Acc load ALU with ALU-Sub Operation
                -- PC
                pcSel        <= "00";
                pcLoad       <= '0';
                adrSel       <= '0';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "000";
                accLoad      <= '1';
                -- ALU
                aluOp        <= "001";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';

            when ACC_ALU_NAND =>        -- Acc load ALU with ALU-Nand Operation
                -- PC
                pcSel        <= "00";
                pcLoad       <= '0';
                adrSel       <= '0';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "000";
                accLoad      <= '1';
                -- ALU
                aluOp        <= "010";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';

            when ACC_inEnter =>        -- Acc load key_in when inEnter
                -- PC
                pcSel        <= "00";
                pcLoad       <= '0';
                adrSel       <= '0';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "010";
                accLoad      <= '1';
                -- ALU
                aluOp        <= "000";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '1';

            when JUMP_PC_MEM =>         -- PC Jump to Address
                -- PC
                pcSel        <= "01";
                pcLoad       <= '1';
                adrSel       <= '1';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "000";
                accLoad      <= '0';
                -- ALU
                aluOp        <= "000";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';

            when NOP_PC =>              -- Update PC
                -- PC
                pcSel        <= "00";
                pcLoad       <= '1';
                adrSel       <= '0';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "000";
                accLoad      <= '0';
                -- ALU
                aluOp        <= "000";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';

            when NOP_OUT =>             -- Enable Output
                -- PC
                pcSel        <= "00";
                pcLoad       <= '0';
                adrSel       <= '0';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "000";
                accLoad      <= '0';
                -- ALU
                aluOp        <= "000";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '0';
                -- GEN
                -- GEN
                outputEnable <= '1';
                ledWait      <= '1';

            when NOP_MEM =>             -- Update MEM
                -- PC
                pcSel        <= "00";
                pcLoad       <= '0';
                adrSel       <= '0';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "000";
                accLoad      <= '0';
                -- ALU
                aluOp        <= "000";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';
					 
            when ACC_ALU_DIV =>         -- Acc load ALU with ALU-Div Operation
                -- PC
                pcSel        <= "00";
                pcLoad       <= '0';
                adrSel       <= '0';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "000";
                accLoad      <= '1';
                -- ALU
                aluOp        <= "011";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';
					 
            when ACC_ALU_MUL =>         -- Acc load ALU with ALU-Mul Operation
                -- PC
                pcSel        <= "00";
                pcLoad       <= '0';
                adrSel       <= '0';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "000";
                accLoad      <= '1';
                -- ALU
                aluOp        <= "100";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';
					 
            when ACC_ALU_ADDI =>         -- Acc load ALU with ALU-AddI Operation
                -- PC
                pcSel        <= "00";
                pcLoad       <= '0';
                adrSel       <= '0';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "000";
                accLoad      <= '1';
                -- ALU
                aluOp        <= "000";
					 --IMMGEN
					 immgenCtrl   <='1';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';
					 
				when ACC_ALU_SUBI =>         -- Acc load ALU with ALU-SubI Operation
                -- PC
                pcSel        <= "00";
                pcLoad       <= '0';
                adrSel       <= '0';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "000";
                accLoad      <= '1';
                -- ALU
                aluOp        <= "001";
					 --IMMGEN
					 immgenCtrl   <='1';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';
					 
				when ACC_ALU_MOD =>         -- Acc load ALU with ALU-Mod Operation
                -- PC
                pcSel        <= "00";
                pcLoad       <= '0';
                adrSel       <= '0';
                -- IR
                irLoad       <= '0';
                -- ACC
                accSel       <= "000";
                accLoad      <= '1';
                -- ALU
                aluOp        <= "101";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';	 
            when others =>              -- Update IR (NOP_IR)
                -- PC
                pcSel        <= "00";
                pcLoad       <= '0';
                adrSel       <= '0';
                -- IR
                irLoad       <= '1';
                -- ACC
                accSel       <= "000";
                accLoad      <= '0';
                -- ALU
                aluOp        <= "000";
					 --IMMGEN
					 immgenCtrl   <='0';
                -- MEM
                memWrite     <= '0';
                -- GEN
                outputEnable <= '0';
                ledWait      <= '0';
        end case;
    end process;

end;
