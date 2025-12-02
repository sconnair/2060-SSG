Library ieee;
USE ieee.std_logic_1164.all;

Entity SevenSegment IS
	Port
	(
		X7 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		X6 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		X5 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		X4 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		X3 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		X2 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		X1 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		X0 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		H7 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		H6 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		H5 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		H4 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		H3 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		H2 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		H1 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		H0 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
	);
END SevenSegment;

ARCHITECTURE Behavioral OF SevenSegment IS

constant zero : STD_LOGIC_VECTOR := "1000000";
constant one : STD_LOGIC_VECTOR := "1111001";
constant two : STD_LOGIC_VECTOR := "0100100";
constant three : STD_LOGIC_VECTOR := "0110000";
constant none : STD_LOGIC_VECTOR := "0000000";

BEGIN

	
		H0 <= zero when X0 = "00" else
				one when X0 = "01" else
				two when X0 = "10" else
				three when X0 = "11" else
				none;
				
	
		H1 <= zero when X1 = "00" else
				one when X1 = "01" else
				two when X1 = "10" else
				three when X1 = "11" else
				none;
				
		H2 <= zero when X2 = "00" else
				one when X2 = "01" else
				two when X2 = "10" else
				three when X2 = "11" else
				none;
				
		H3 <= zero when X3 = "00" else
				one when X3 = "01" else
				two when X3 = "10" else
				three when X3 = "11" else
				none;
				
		H4 <= zero when X4 = "00" else
				one when X4 = "01" else
				two when X4 = "10" else
				three when X4 = "11" else
				none;
				
		H5 <= zero when X5 = "00" else
				one when X5 = "01" else
				two when X5 = "10" else
				three when X5 = "11" else
				none;
				
		H6 <= zero when X6 = "00" else
				one when X6 = "01" else
				two when X6 = "10" else
				three when X6 = "11" else
				none;
				
		H7 <= zero when X7 = "00" else
				one when X7 = "01" else
				two when X7 = "10" else
				three when X7 = "11" else
				none;

END Behavioral;