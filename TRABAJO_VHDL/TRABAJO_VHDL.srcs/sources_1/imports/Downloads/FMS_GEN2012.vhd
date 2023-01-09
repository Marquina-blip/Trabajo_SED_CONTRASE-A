library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity FMS_GENERAL is
generic (n: integer :=3);
 PORT( 
       B1,B2,B3,B4,B5: IN STD_LOGIC;
       RESET,CLK: IN STD_LOGIC;
       SW_CREA: IN STD_LOGIC_VECTOR(n DOWNTO 0);
       SW_COMP: IN STD_LOGIC_VECTOR(n DOWNTO 0);
       VISUAL:OUT STD_LOGIC_VECTOR(n DOWNTO 0)
    );
end FMS_GENERAL;

architecture Behavioral of FMS_GENERAL is
TYPE STATES IS (S_INI,S_COMP,S_CREA);
    SIGNAL CURRENT_STATE,NEXT_STATE:STATES;

	COMPONENT FMS_CREATE PORT( 
 		START: IN STD_LOGIC;
       B4,B5: IN STD_LOGIC;
       RESET,CLK: IN STD_LOGIC;
       SW: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
       V:OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
       OK_CREATE: OUT STD_LOGIC
    );
	END COMPONENT;

  COMPONENT FMS_COMPROBATION PORT (  START: IN STD_LOGIC;
        C:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
       B4,B5: IN STD_LOGIC;
       RESET,CLK: IN STD_LOGIC;
       SW: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
       OK_COMPROBATION: OUT STD_LOGIC
                            );
	END COMPONENT;
	


	SIGNAL START_CREA, START_COMP: STD_LOGIC;
	SIGNAL OK_COMP, OK_CREA: STD_LOGIC;
	SIGNAL V:STD_LOGIC_VECTOR(3 downto 0);

begin
	
  crea: FMS_CREATE PORT MAP(START_CREA,B4,B5,RESET,CLK,SW_CREA,V,OK_CREA);
  COMP: FMS_COMPROBATION PORT MAP(START_COMP,V,B4,B5,RESET,CLK,SW_COMP,OK_COMP);
  
state_register:PROCESS(CLK,RESET)
    BEGIN
        IF RESET='0' THEN  --RESET NIVEL BAJO
            CURRENT_STATE<=S_INI;
        ELSIF CLK'EVENT AND CLK='1' THEN
            CURRENT_STATE<=NEXT_STATE;
        END IF;
    END PROCESS;
       
    nextstate: PROCESS(B1,B2,B3,B4,B5)
 	
    BEGIN
        NEXT_STATE<=CURRENT_STATE;
        CASE CURRENT_STATE IS
        WHEN S_INI=>
            IF B1='1' THEN
             NEXT_STATE<=S_CREA;
  			ELSIF B2='1' THEN
             NEXT_STATE<=S_COMP;
            END IF;
        WHEN S_CREA=>
            IF B3='1' OR OK_CREA='1' THEN
            NEXT_STATE<=S_INI;
            END IF; 
   		WHEN S_COMP=>
            IF B3='1' OR OK_COMP='1' THEN
            NEXT_STATE<=S_INI;
            END IF; 
        WHEN OTHERS=>
            NEXT_STATE<=S_INI;
        END CASE;

    END PROCESS;
    
    output:PROCESS(CURRENT_STATE)
    
        begin
            CASE CURRENT_STATE is
               WHEN S_INI=>
                VISUAL<="0001";
               WHEN S_CREA=>
                IF OK_CREA='0' THEN
                START_CREA<='1';
          		ELSIF OK_CREA='1' THEN
          		START_CREA<='0';
                END IF;
          		VISUAL<="0010";
 			 WHEN S_COMP=>
                IF OK_COMP='0' THEN
                START_COMP<='1';
          		ELSIF OK_COMP='1' THEN
          		START_COMP<='0';
                END IF;
          		VISUAL<="0100";
               WHEN OTHERS=>
                VISUAL<="1111";
            END CASE;
    END PROCESS;
   

end Behavioral;
