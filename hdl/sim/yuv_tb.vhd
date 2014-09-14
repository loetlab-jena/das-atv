 -- RGB2YUV Testbench
 -- tests the rgb to yuv transormation
 -- 
 -- file: yuv_tb.vhd
 -- author: Sebastian Weiss <dl3yc@darc.de>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity yuv_tb is
end entity yuv_tb;

architecture sim of yuv_tb is
	signal clk	: std_logic := '0';
	signal r	: std_logic_vector(7 downto 0) := (others => '0');
	signal g	: std_logic_vector(7 downto 0) := (others => '0');
	signal b	: std_logic_vector(7 downto 0) := (others => '0');
	signal y	: std_logic_vector(7 downto 0) := (others => '0');
	signal u	: std_logic_vector(7 downto 0) := (others => '0');
	signal v	: std_logic_vector(7 downto 0) := (others => '0');
begin

	clk <= not clk after 1 ns;

	dut : entity work.rgb2yuv
	generic map (
		width		=> 8,
		resolution	=> 10
	)
	port map (
		clk		=> clk,
		red		=> r,
		green	=> g,
		blue	=> b,
		y		=> y,
		u		=> u,
		v		=> v
	);

	test : process
	begin
		wait until rising_edge(clk);

		r <= x"FF";
		g <= x"FF";
		b <= x"FF";
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		assert (y = x"FF") report "check 1: failed (y wrong)" severity failure;
		assert (u = x"00") report "check 1: failed (u wrong)" severity failure;
		assert (v = x"00") report "check 1: failed (v wrong)" severity failure;
		report "check 1: ok";

		r <= x"00";
		g <= x"00";
		b <= x"00";
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		assert (y = x"00") report "check 2: failed (y wrong)" severity failure;
		assert (u = x"00") report "check 2: failed (u wrong)" severity failure;
		assert (v = x"00") report "check 2: failed (v wrong)" severity failure;
		report "check 2: ok";

		r <= x"B2";
		g <= x"B2";
		b <= x"B2";
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		assert (y = x"B2") report "check 3: failed (y wrong)" severity failure;
		assert (u = x"00") report "check 3: failed (u wrong)" severity failure;
		assert (v = x"00") report "check 3: failed (v wrong)" severity failure;
		report "check 3: ok";

		r <= x"12";
		g <= x"A3";
		b <= x"E6";
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		assert (y = x"7F") report "check 4: failed (y wrong)" severity failure;
		assert (u = x"32") report "check 4: failed (u wrong)" severity failure;
		assert (v = x"00") report "check 4: failed (v wrong)" severity failure;
		report "check 4: ok";

		wait;

	end process test;

end architecture sim;
