LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


ENTITY System_Controller IS
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
END System_Controller;


ARCHITECTURE Behavioral OF System_Controller IS

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

TYPE STATES IS (WAITS, LOSE, WIN, AUTODISPLAY, GAME);
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
		
-------------------------------- WAIT STATE -----------------------
-- Occurs after a Win or Lose.  Cycles through the lights like an arcade game		

when WAITS =>


		audio_value<=no_audio;

 		
		if startFlag = '0' then	
			
				
		-- Add if statements to change active LED every 1/8 second as long as startFlag = '0'
				if ticks < eigth_second then
					-- turn the blue LED on
					-- turn the green LED off
					-- turn the yellow LED off
					-- turn the red LED off
				
				elsif ticks < quarter_second then
					-- turn the yellow LED on and turn all the other LEDS off
					
				elsif ticks < three_eighths_second then
					-- turn the green LED on and turn all the other LEDS off
					
				elsif ticks < half_second then
					-- turn the red LED on and turn all the other LEDS off
				
				elsif ticks = half_second then
					--reset ticks
					
				end if;	
		
-- This is where you exit to the AUTODISPLAY state	

		elsif startFlag = '1' and ticks = three_quarters_second then
					startFlag <= '0';
					ticks <= 0;
					sequence_state <= 1;	-- first state
					play_counter <= 0;		 
					auto_counter <= 0;
					STATE <= AUTODISPLAY;		
		end if;  
		
			
-- Exiting the WAITS State requires a button press	from Key[0]		

-- The press

			if clr_in = '0' then
				clr_hold <= '1';
				clr_seq <= '1';
				clr_count <= '1';
			end if;
			
-- The release			
			
			if clr_in = '1' and clr_hold = '1' then
				startFlag <= '1';
				clr_hold <= '0';
				ticks <= 0;
				blue_LED<='1';
				green_LED<='1';
				yellow_LED<='1';
				red_LED<='1';	
			end if;
			
					
----------------------------- AUTO DISPLAY STATE -------------------------------
					
when AUTODISPLAY =>
		
			if ticks = quarter_second then  -- buttons off, no audio
					audio_value <=no_audio;
					blue_LED<='1';
					green_LED<='1';
					yellow_LED<='1';
					red_LED<='1';
			end if;	

--  Test segment. For each case, play the audio_value and activate the LED for the time defined
--  by sequence_delayincrement the auto_counter to display the next state in the sequence
--  This needs to be done for each case			
			
			if (seq = BLUE and ticks = sequence_delay) then
					-- Set audio_value to audio_blue
					--	Trun the blue LED on
					-- Enable clk_en_seq
					-- Increment auto_counter by 1
					-- Reset ticks

			elsif (seq = GREEN and ticks = sequence_delay) then
					-- Add code here

			elsif (seq = YELLOW and ticks = sequence_delay) then
					-- Add code here				

			elsif (seq = RED and ticks = sequence_delay) then
					-- Add code here				

				
			end if;				
	
-- Resets play counter and waits for input once the sequence has been displayed	
		
			if (auto_counter = sequence_state) and ticks = quarter_second then
				auto_counter <= 0;
				clr_count <= '1';
				ticks <= 0;
				STATE <= GAME;
			end if;
			
-- Check for Key[0] reset in all states			
		
			if clr_in = '0' then
				ticks <= 0;
				STATE <= WAITS;
			end if;
							
-------------------------------------- GAME STATE -----------------------------------------

when GAME =>
		
			if ticks = lockout_delay then -- Minimum delay between button presses
					audio_value <=no_audio;
					blue_LED<='1';
					green_LED<='1';
					yellow_LED<='1';
					red_LED<='1';
			end if;

	-- For each pushbutton, test for press
	-- If pressed:

			if blue_PB = '0'  then
					-- turn on blue LED
					-- load blue audio
					-- save color in variable 'button'
					-- reset timer (ticks)					
					
			elsif green_PB = '0'  then
					-- Add code here					

			elsif yellow_PB = '0'  then
					-- Add code here					
					
			elsif red_PB = '0'  then
					-- Add code here					
				
			elsif (button /=no_button) then  -- This means a button has been pressed 
					ButtonFlag <= 1;   -- but no button is pressed currently (all released)
					
			end if;

			
-- Checks input with generated sequence after a release	

			if (ButtonFlag = 1) then
			
				if (seq = BLUE and button = blue_button) then
					-- increment play_counter
					-- Enable clk_en_seq
					-- set button to back to no_button
					
				elsif (seq = GREEN and button = green_button) then
					-- increment play_counter
					-- Enable clk_en_seq
					-- set button to back to no_button
					
				elsif (seq = YELLOW and button = yellow_button) then
					-- increment play_counter
					-- Enable clk_en_seq
					-- set button to back to no_button
					
				elsif (seq = RED and button = red_button) then
					-- increment play_counter
					-- Enable clk_en_seq
					-- set button to back to no_button
					
--	Send to LOSE state
	
				else
					ticks <= 0;
					STATE <= LOSE;
				end if;	
					ButtonFlag <= 0;	
					
			end if;

-- If sequence total reaches integer value mentioned, starts WIN state	

				if (play_counter = win_count) and ticks = half_second then
					ticks <= 0;
					STATE <= WIN;

-- Resets counter and begins next play sequence once condition is met

				elsif (play_counter = sequence_state) and ticks = one_second then
					sequence_state <= sequence_state+1;
					clr_count <= '1';
					play_counter <= 0;
					auto_counter <= 0;
					ticks <= 0;
					STATE <= AUTODISPLAY;
				end if;
				
-- Check for Key[0] reset in all states					
		
			if clr_in = '0' then
				ticks <= 0;
				STATE <= WAITS;
			end if;
							
----------------------------------- WIN STATE ----------------------------------------

when WIN =>
		
				if ticks < quarter_second then
					-- Activate BLUE LED
					-- Play Blue LED audio
				
				elsif ticks < half_second then
					-- Activate YELLOW LED
					-- Play YELLOW LED audio
				
				elsif ticks < three_quarters_second then
					-- Activate RED LED
					-- Play RED LED audio

				elsif ticks < two_and_one_quarter_second then
					-- Activate GREEN LED
					-- Play GREEN LED audio
					
				elsif ticks = two_and_one_quarter_second then
					-- reset ticks
					-- Go back to WAITS state
					
				end if;


------------------------------------ LOSE STATE -------------------------------------
				
when LOSE =>

-- Play WRONG audio for one second, then return to WAITS state

			-- set audio_value to the 'wrong' audio value here
			
			if ticks = one_second then
					-- reset ticks
					-- set button value to no_button
					-- Go back to Waits state
			end if;


		
		end case;
			
	end if;
		
end process;
	
end Behavioral;