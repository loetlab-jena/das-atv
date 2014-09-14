-- DAS ATV-System Testplatform
-- Pinout:
-- 	HDMI_CLK:		GPIO_1_IN0 
-- 	HDMI_DE:		GPIO_12
-- 	HDMI_VS:		GPIO_11
-- 	HDMI_HS:		GPIO_10
-- 	HDMI_R(5:0):	GPIO_13, GPIO_14, GPIO_15, GPIO_16, GPIO_17, GPIO_18
-- 	HDMI_G(5:0):	GPIO_110, GPIO_111, GPIO_112, GPIO_113, GPIO_114, GPIO_115
-- 	HDMI_B(5:0):	GPIO_116, GPIO_117, GPIO_118, GPIO_119, GPIO_120, GPIO_121
--  DAC_CLK_I:		GPIO_125
--	DAC_CLK_Q:		GPIO_122
--	DAC_D(11:0):	GPIO_21, GPIO_22, GPIO_20, GPIO_25, GPIO_23, GPIO_24, GPIO_26,
--					GPIO_27, GPIO_28, GPIO_29, GPIO_210, GPIO_211

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hdmi2pal is

	port 
	(
		CLK50		: in std_logic;

		HDMI_CLK	: in std_logic;
		HDMI_DE		: in std_logic;
		HDMI_VS		: in std_logic;
		HDMI_HS		: in std_logic;
		HDMI_R		: in std_logic_vector(5 downto 0);
		HDMI_G		: in std_logic_vector(5 downto 0);
		HDMI_B		: in std_logic_vector(5 downto 0);

		DAC_CLK_I	: out std_logic;
		DAC_CLK_Q	: out std_logic;
		DAC_D		: out std_logic_vector(11 downto 0);

		LED			: out std_logic_vector(7 downto 0)
	);

end entity;

architecture rtl of hdmi2pal is
	function to_fcw(frequency : real) return positive is
		constant sample_rate : real := 50_000_000.0;
		constant bit_width : integer := 16;
	begin
		return integer(frequency / sample_rate * real(2**bit_width));
	end function;

	signal sync			: std_logic;
	signal burst		: std_logic;
	signal hdmi_freq	: std_logic_vector(10 downto 0);
	signal hdmi_ok		: std_logic;

	signal clk27		: std_logic;
	signal clk27_locked	: std_logic;
	signal clk27_sw		: std_logic;
	signal clk108		: std_logic;
	signal clk108_locked: std_logic;
	signal clksel		: std_logic;

	signal sin_out		: signed(11 downto 0);
begin

	pll1 : entity work.pll
	port map(
		clkswitch	=> clksel,
		inclk0		=> HDMI_CLK,
		inclk1		=> clk27,
		c0			=> clk108,
		locked		=> clk108_locked
	);

	DAC_CLK_I <= CLK50;

	pll2 : entity work.pll2
	port map(
		inclk0	=> CLK50,
		c0		=> clk27,
		locked	=> clk27_locked
	);

	clksel <= '0' when hdmi_ok = '1' else '1';

	ctrl : entity work.clkctrl
	port map(
		clkselect	=> clksel,
		ena			=> '1',
		inclk0x		=> HDMI_CLK,
		inclk1x		=> clk27,
		outclk		=> clk27_sw
	);

	hdmi_ok <= '1' when unsigned(hdmi_freq) = 270 else '0';

	fcnt : entity work.frequency_counter
	generic map(
		res		=> 11,
		gate	=> 500
	)
	port map(
		clk		=> CLK50,
		cnt_in	=> HDMI_CLK,
		cnt_out	=> hdmi_freq
	);

	tgen : entity work.timing_gen
	port map(
		clk		=> HDMI_CLK,
		vs		=> HDMI_VS,
		hs		=> HDMI_HS,
		de		=> HDMI_DE,
		sync	=> sync,
		burst	=> burst
	);

	sin_gen : entity work.nco
	generic map(
		A	=> 12,
		F	=> 16,
		P	=> 16,
		N	=> 14,
		FCW	=> to_fcw(1_000_000.0)
	)
	port map(
		clk	=> CLK50,
		sin	=> sin_out,
		cos	=> open
	);

	DAC_D <= std_logic_vector(b"1000_0000_0000" - sin_out);

	LED(7) <= sync;
	LED(6) <= HDMI_DE;
	LED(5) <= HDMI_HS;
	LED(4) <= HDMI_VS;
	LED(3) <= burst;
	LED(2) <= hdmi_ok;
	LED(1) <= clk27_locked;
	LED(0) <= clk108_locked;

end rtl;
