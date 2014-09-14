library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timing_gen is

	port 
	(
		clk		: in std_logic;
		de		: in std_logic;
		vs		: in std_logic;
		hs		: in std_logic;
		sync	: out std_logic;
		burst	: out std_logic
	);

end entity;

architecture rtl of timing_gen is
	signal de_d	: std_logic;
	signal vs_d	: std_logic;
	signal hs_d	: std_logic;
	signal hcnt	: unsigned(10 downto 0);
	signal vcnt	: integer range 0 to 1023;
	signal ss	: std_logic; -- short sync
	signal ns	: std_logic; -- normal sync
	signal bs	: std_logic; -- burst sync
	signal ls	: std_logic; -- long sync
begin

	counter : process
	begin
		wait until rising_edge(clk);
		vs_d <= vs;
		hs_d <= hs;
		hcnt <= hcnt + 1;
		if hs_d = '1' and hs = '0' then
			hcnt <= (others => '0');
			vcnt <= vcnt + 1;
		end if;
		if vs_d = '1' and vs = '0' and hs_d = '1' and hs = '0' then
			vcnt <= 0;
		end if;
	end process;

	sync_generator : process
	begin
		wait until rising_edge(clk);

		if hcnt = 0 then
			case vcnt is
				when 0|1|2|313|314 =>
					ls <= '1';
					bs <= '0';
				when 3|4|310|311|312|315|316|622|623|624 =>
					ss <= '1';
					bs <= '0';
				when others =>
					ns <= '1';
					bs <= '1';
			end case;
		end if;

		if hcnt = 863 then
			case vcnt is
				when 0|1|312|313|314 =>
					ls <= '1';
				when 2|3|4|310|311|315|316|622|623|624 =>
					ss <= '1';
				when others =>
			end case;
		end if;

		if hcnt = 54 or hcnt = 918 then
			ss <= '0';
		end if;
		if hcnt = 127 then
			ns <= '0';
		end if;
		if hcnt = 810 or hcnt = 1674 then
			ls <= '0';
		end if;
		if hcnt = 151 and bs = '1' then
			burst <= '1';
		end if;
		if hcnt = 212 and bs = '1' then
			burst <= '0';
		end if;
	end process;

	sync <= ss or ns or ls;

end rtl;
