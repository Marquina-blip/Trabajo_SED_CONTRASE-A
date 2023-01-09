----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.01.2023 17:48:30
-- Design Name: 
-- Module Name: TOP_final - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP_final is
GENERIC(N: POSITIVE:=3);
  Port (B1,B2,B3,B4,B5: IN STD_LOGIC;
       RESET,CLK: IN STD_LOGIC;
       SW_CREA: IN STD_LOGIC_VECTOR(N DOWNTO 0);
       SW_COMP: IN STD_LOGIC_VECTOR(N DOWNTO 0);
       VISUAL:OUT STD_LOGIC_VECTOR(N DOWNTO 0)
       --LEDS: OUT STD_LOGIC_VECTOR(N DOWNTO 0)
       );
end TOP_final;

architecture Behavioral of TOP_final is
COMPONENT SYNK_B PORT ( 
            CLK : in std_logic;
            ASYNC_IN : in std_logic;
             SYNC_OUT : out std_logic
             );
 END COMPONENT;
  COMPONENT EDGEDTR PORT ( 
            CLK : in std_logic;
            SYNC_IN : in std_logic;
            EDGE : out std_logic
                );
  END COMPONENT;
  COMPONENT FMS_GENERAL IS 
  GENERIC(N: POSITIVE:=3);
 PORT( 
       B1,B2,B3,B4,B5: IN STD_LOGIC;
       RESET,CLK: IN STD_LOGIC;
       SW_CREA: IN STD_LOGIC_VECTOR(N DOWNTO 0);
       SW_COMP: IN STD_LOGIC_VECTOR(N DOWNTO 0);
       VISUAL:OUT STD_LOGIC_VECTOR(N DOWNTO 0)
       );
END COMPONENT;
SIGNAL B1_SYNC,B1_EDGE: STD_LOGIC;
 SIGNAL B2_SYNC, B2_EDGE: STD_LOGIC;
 SIGNAL B3_SYNC, B3_EDGE: STD_LOGIC;
 SIGNAL B4_SYNC, B4_EDGE: STD_LOGIC;
 SIGNAL B5_SYNC, B5_EDGE: STD_LOGIC;
begin
sync_B1: SYNK_B PORT MAP (CLK, B1, B1_SYNC);
sync_B2: SYNK_B PORT MAP (CLK, B2, B2_SYNC);
sync_B3: SYNK_B PORT MAP (CLK, B3, B3_SYNC);
sync_B4: SYNK_B PORT MAP (CLK, B4, B4_SYNC);
sync_B5: SYNK_B PORT MAP (CLK, B5, B5_SYNC);

edge_B1: EDGEDTR PORT MAP (CLK, B1_SYNC, B1_EDGE);
edge_B2: EDGEDTR PORT MAP (CLK, B2_SYNC, B2_EDGE);
edge_B3: EDGEDTR PORT MAP (CLK, B3_SYNC, B3_EDGE);
edge_B4: EDGEDTR PORT MAP (CLK, B4_SYNC, B4_EDGE);
edge_B5: EDGEDTR PORT MAP (CLK, B5_SYNC, B5_EDGE);


maquina: FMS_GENERAL PORT MAP (B1_EDGE, B2_EDGE, B3_EDGE, B4_EDGE, B5_EDGE,
                            RESET, CLK, SW_CREA, SW_COMP,VISUAL);
end Behavioral;
