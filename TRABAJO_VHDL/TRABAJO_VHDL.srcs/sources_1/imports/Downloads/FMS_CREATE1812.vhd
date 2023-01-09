library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FMS_CREATE  is
 PORT( 
 		START: IN STD_LOGIC;
       B4,B5: IN STD_LOGIC;
       RESET,CLK: IN STD_LOGIC;
       SW: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
       V:OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
       OK_CREATE: OUT STD_LOGIC
    );
end FMS_CREATE ;

architecture Behavioral of FMS_CREATE is
    TYPE STATES IS (S0,S1);
    SIGNAL CURRENT_STATE,NEXT_STATE:STATES;

      
begin

state_register:PROCESS(CLK,RESET)
    BEGIN
        IF RESET='0' THEN  --RESET NIVEL BAJO
            CURRENT_STATE<=S0;
        ELSIF CLK'EVENT AND CLK='1' THEN
        IF START = '1' THEN
        CURRENT_STATE<=NEXT_STATE;
        
         ELSIF START='0' THEN
        CURRENT_STATE<=S0;
        END IF;
        END IF;
    END PROCESS;
       
    nextstate: PROCESS(B4,B5)
 	
    BEGIN
        NEXT_STATE<=CURRENT_STATE;
        CASE CURRENT_STATE IS
        WHEN S0=>
            IF B4='1' THEN
             NEXT_STATE<=S1;
            END IF;
        WHEN S1=>
            IF B5='1' THEN
            NEXT_STATE<=S0;
            END IF;   
        WHEN OTHERS=>
            NEXT_STATE<=S0;
        END CASE;

    END PROCESS;
    
    output:PROCESS(CURRENT_STATE)
    
        begin
            CASE CURRENT_STATE is
                WHEN S0=>
                
                OK_CREATE<='0';
                WHEN S1=>
                if SW /="0000" THEN
                v<=SW;
                IF B5='1' THEN
                 OK_CREATE<='1';
                 END IF;
                end if;
                WHEN OTHERS=>
                V<="0000";
                OK_CREATE<='0';
            END CASE;
    END PROCESS;
   

end Behavioral;
