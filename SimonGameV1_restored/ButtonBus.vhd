Library ieee;
USE ieee.std_logic_1164.all;

Entity ButtonBus IS
	Port
	(
		GREEN : IN STD_LOGIC;
		YELLOW : IN STD_LOGIC;
		BLUE : IN STD_LOGIC;
		RED : IN STD_LOGIC;
		Out_Bus : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
	);
END ButtonBus;

ARCHITECTURE Behavioral OF ButtonBus IS


BEGIN

	
		Out_Bus <=  "001" when BLUE = '0' else
						"010" when YELLOW = '0' else
						"100" when GREEN = '0' else
						"011" when RED = '0' else
						"000";
				
	
		
END Behavioral;