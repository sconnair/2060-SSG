LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


ENTITY TEST_Controller IS
	PORT
	(
	
		clock			: IN STD_LOGIC ;
		clr_in		: IN STD_LOGIC ;
		blue_PB		: IN STD_LOGIC ;
		green_PB		: IN STD_LOGIC ;
		yellow_PB	: IN STD_LOGIC ;
		red_PB		: IN STD_LOGIC ;
		seq			: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		blue_LED			: OUT STD_LOGIC := '1';
		green_LED			: OUT STD_LOGIC := '1';
		yellow_LED			: OUT STD_LOGIC := '1';
		red_LED			: OUT STD_LOGIC := '1';
		clr_seq_out		: OUT STD_LOGIC ;
		clr_count_out : OUT STD_LOGIC ;
		clk_en_seq_out	: OUT STD_LOGIC := '1';
		q_out			: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
	);
END TEST_Controller;


ARCHITECTURE Behavioral OF TEST_Controller IS

-- ticks counter delay definitions

constant lockout_delay : integer := 7300;
constant eigth_second : integer := 6000;
constant quarter_second : integer := 12000;
constant sequence_delay : Integer := 17000;
constant three_eighths_second : integer := 18000;
constant half_second : integer := 24000;
constant three_quarters_second : integer := 36000;
constant one_second : integer := 48000;
constant two_and_one_quarter_second : integer := 108000;

-- Numbers assigned to pushbuttons

constant no_button : integer := 0;
constant red_button : integer := 1;
constant yellow_button : integer := 2;
constant green_button : integer := 3;
constant blue_button : integer := 4;

-- Number of states in the game sequence.  Can be changed to up to 8 states

constant win_count : integer := 5;

-- 2-bit codes from Random Generator assigned to colors here

constant BLUE : STD_LOGIC_VECTOR := "11";
constant YELLOW : STD_LOGIC_VECTOR := "01";
constant GREEN : STD_LOGIC_VECTOR := "10";
constant RED : STD_LOGIC_VECTOR := "00";

-- 3-bit MUX codes to select P-values for each setting in Audio synthesizer

constant audio_BLUE : STD_LOGIC_VECTOR := "001";
constant audio_YELLOW : STD_LOGIC_VECTOR := "010";
constant audio_GREEN : STD_LOGIC_VECTOR := "100";
constant audio_RED : STD_LOGIC_VECTOR := "011";
constant no_audio  :  STD_LOGIC_VECTOR  := "000";
constant wrong_audio  :  STD_LOGIC_VECTOR  :=  "101";
	
SIGNAL audio_value	: STD_LOGIC_VECTOR (2 DOWNTO 0):= no_audio; -- output that goes to mux select line to select sound

SIGNAL ticks      : integer := 0; -- general pause used for various pauses, once reset, sets leds and sound back to 0 once timer reaches 12000

SIGNAL ButtonFlag      : integer := 0; -- button is used to hold value until button is released

SIGNAL clk_en_seq      : STD_LOGIC := '0'; -- goes to count enable of counter in order to cycle through sequence
SIGNAL clr_seq      : STD_LOGIC := '0';		-- clears/resets the sequence in the random value generator
SIGNAL clr_count      : STD_LOGIC := '0';	-- resets the counter of the random counter
SIGNAL clr_hold      : STD_LOGIC := '0';	-- holds clear button value until released

-- Three counters --

SIGNAL sequence_state      : integer := 1;	-- keeps track of the current total number of states
SIGNAL play_counter      : integer := 0;	-- keeps track of the current number of states
SIGNAL auto_counter      : integer := 0;	-- keeps track of the sequence count for the autoplay sequence

SIGNAL button      : integer := 0;		-- holds value of state based on the key pressed

SIGNAL startFlag     : STD_LOGIC := '0';	-- flag used to extend wait duration after start of new game

TYPE STATES IS (S1, S2, S3 );
SIGNAL STATE : STATES;
	
BEGIN
-- Update output signals with  variable values
	
	q_out    <= audio_value(2 DOWNTO 0);
	clk_en_seq_out <= clk_en_seq;
	clr_seq_out <= clr_seq;
	clr_count_out <= clr_count;
	
	process(clock)
	begin
	
		if clock'event and clock = '1' then

	-- resets all clock and counter enables
		clk_en_seq <= '0';
		clr_seq <= '0';
		clr_count <= '0';
	
--	Counters
		ticks <= ticks+1;
		

		case STATE is


when S1 =>

		audio_value<=no_audio;
 		
		if startFlag = '0' then	
			
				if ticks < eigth_second then
					blue_LED<='0';
					green_LED<='1';
					yellow_LED<='1';
					red_LED<='1';
				
				elsif ticks < quarter_second then
					blue_LED<='1';
					green_LED<='1';
					yellow_LED<='0';
					red_LED<='1';
					
				elsif ticks < three_eighths_second then
					blue_LED<='1';
					green_LED<='0';
					yellow_LED<='1';
					red_LED<='1';
					
				elsif ticks < half_second then
					blue_LED<='1';
					green_LED<='1';
					yellow_LED<='1';
					red_LED<='0';
				
				elsif ticks = half_second then
					ticks <= 0;
					
				end if;	

		elsif startFlag = '1' and ticks = three_quarters_second then
					startFlag <= '0';
					ticks <= 0;
					sequence_state <= 1;
					play_counter <= 0;		 
					auto_counter <= 0;
					STATE <= S2;		
		end if;  
		
			if clr_in = '0' then
				clr_hold <= '1';
				clr_seq <= '1';
				clr_count <= '1';
			end if;
			
		
			
			if clr_in = '1' and clr_hold = '1' then
				startFlag <= '1';
				clr_hold <= '0';
				ticks <= 0;
				blue_LED<='1';
				green_LED<='1';
				yellow_LED<='1';
				red_LED<='1';	
			end if;			
					
when S2 =>
		
			if ticks = quarter_second then
					audio_value <=no_audio;
					blue_LED<='1';
					green_LED<='1';
					yellow_LED<='1';
					red_LED<='1';
			end if;			
			
			if (seq = BLUE and ticks = sequence_delay) then
					audio_value <=audio_BLUE;
					blue_LED <='0';
					clk_en_seq <= '1';
					auto_counter <= auto_counter+1;
					ticks <= 0;

			elsif (seq = GREEN and ticks = sequence_delay) then
					audio_value <= audio_GREEN;
					green_LED<='0';
					clk_en_seq <= '1';
					auto_counter <= auto_counter+1;
					ticks <= 0;
					
			elsif (seq = YELLOW and ticks = sequence_delay) then
					audio_value <= audio_YELLOW;
					yellow_LED<='0';
					clk_en_seq <= '1';
					auto_counter <= auto_counter+1;
					ticks <= 0;			

			elsif (seq = RED and ticks = sequence_delay) then
					audio_value <= audio_RED;
					red_LED<='0';
					clk_en_seq <= '1';
					auto_counter <= auto_counter+1;
					ticks <= 0;			
				
			end if;				
			
			if (auto_counter = win_count) and ticks = quarter_second then
				auto_counter <= 0;
				clr_count <= '1';
				ticks <= 0;
				STATE <= S3;
			end if;
			
		
		
			if clr_in = '0' then
				ticks <= 0;
				STATE <= S1;
			end if;
							
when S3 =>
		
			if ticks = lockout_delay then 
					audio_value <=no_audio;
					blue_LED<='1';
					green_LED<='1';
					yellow_LED<='1';
					red_LED<='1';
			end if;

			if blue_PB = '0'  then
					audio_value <=audio_BLUE;
					blue_LED<='0';
					button <= blue_button;
					ticks <= 0;				
					
			elsif green_PB = '0'  then
					audio_value <= audio_GREEN;
					green_LED<='0';
					button <= green_button;
					ticks <= 0;			

			elsif yellow_PB = '0'  then
					audio_value <= audio_YELLOW;
					yellow_LED<='0';
					button <= yellow_button;
					ticks <= 0;				
					
			elsif red_PB = '0'  then
					audio_value <= audio_RED;
					red_LED<='0';
					button <= red_button;
					ticks <= 0;					
				
--			elsif (button /=no_button) then 
--					ButtonFlag <= 1;  
					
			end if;

					STATE <= S3;				
		
			if clr_in = '0' then
				ticks <= 0;
				STATE <= S1;
			end if;							

		end case;
			
	end if;
		
end process;
	
end Behavioral;