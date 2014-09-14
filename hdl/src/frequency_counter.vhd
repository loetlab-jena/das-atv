library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity frequency_counter is

	generic
	(
		res		: positive;
		gate	: positive
	);

	port 
	(
		clk		: in std_logic;
		cnt_in	: in std_logic;
		cnt_out	: out std_logic_vector(res-1 downto 0)
	);

end entity;

architecture rtl of frequency_counter is
	signal clk1_en	: std_logic := '0';
	signal clk1_en_s: std_logic := '0';
	signal rst		: std_logic := '0';
	signal latch	: std_logic := '0';
	signal cnt1		: unsigned(res-1 downto 0);
	signal cnt2		: unsigned(res-1 downto 0);
begin

	sync : process
	begin
		wait until rising_edge(cnt_in);
		clk1_en_s <= clk1_en;
	end process;

	output : process
	begin
		wait until rising_edge(clk);
		if latch = '1' then
			cnt_out <= std_logic_vector(cnt1);
		end if;
	end process;

	counter1 : process(rst, cnt_in)
	begin
		if rst = '1' then
			cnt1 <= (others => '0');
		elsif rising_edge(cnt_in) then
			if clk1_en_s = '1' then
			cnt1 <= cnt1 + 1;
			end if;
		end if;
	end process;

	counter2 : process
	begin
		wait until rising_edge(clk);
		if rst = '1' then
			cnt2 <= (others => '0');
		elsif clk1_en = '1' then
			cnt2 <= cnt2 + 1;
		end if;
	end process;

	process
	begin
		wait until rising_edge(clk);
		if cnt2 = 0 then
			clk1_en <= '1';
			latch <= '0';
			rst <= '0';
		elsif cnt2 = gate then
			clk1_en <= '0';
			latch <= '1';
			rst <= '0';
		elsif cnt2 = gate+1 then
			clk1_en <= '0';
			latch <= '0';
			rst <= '1';
		end if;
	end process;
end rtl;
