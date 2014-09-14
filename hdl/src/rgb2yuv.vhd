 -- RGB2YUV
 -- transforms RGB to YUV
 -- Y = 0.299 * R + 0.587 * G + 0.114 * B
 -- U = 0.492 * (B - Y) = 0.436 * B - 0.147 * R + 0.289 * G
 -- V = 0.877 * (R - Y) = 0.615 * R - 0.515 * G + 0.100 * B
 --
 -- delay: 2 clk cycles
 -- 
 -- file: rgb2yuv.vhd
 -- author: Sebastian Weiss <dl3yc@darc.de>
 -- version: 0.1

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity rgb2yuv is
	generic(
		width		: positive;
		resolution	: positive
	);

	port (
		clk		: in std_logic;

		red		: in std_logic_vector(width-1 downto 0);
		green	: in std_logic_vector(width-1 downto 0);
		blue	: in std_logic_vector(width-1 downto 0);

		y		: out std_logic_vector(width-1 downto 0);
		u		: out std_logic_vector(width-1 downto 0);
		v		: out std_logic_vector(width-1 downto 0)
	);
end entity rgb2yuv;

architecture behavioral of rgb2yuv is
	constant exp_width : integer := width+resolution;

	signal RsY	: unsigned(exp_width-1 downto 0);
	signal GsY	: unsigned(exp_width-1 downto 0);
	signal BsY	: unsigned(exp_width-1 downto 0);
	signal Ys	: unsigned(exp_width-1 downto 0);

	signal RsU	: unsigned(exp_width-1 downto 0);
	signal GsU	: unsigned(exp_width-1 downto 0);
	signal BsU	: unsigned(exp_width-1 downto 0);
	signal Us	: unsigned(exp_width-1 downto 0);

	signal RsV	: unsigned(exp_width-1 downto 0);
	signal GsV	: unsigned(exp_width-1 downto 0);
	signal BsV	: unsigned(exp_width-1 downto 0);
	signal Vs	: unsigned(exp_width-1 downto 0);

	alias RY is RsY(exp_width-1 downto resolution);
	alias GY is GsY(exp_width-1 downto resolution);
	alias BY is BsY(exp_width-1 downto resolution);
	alias Yrs is Ys(exp_width-1 downto resolution);

	alias RU is RsU(exp_width-1 downto resolution);
	alias GU is GsU(exp_width-1 downto resolution);
	alias BU is BsU(exp_width-1 downto resolution);
	alias Urs is Us(exp_width-1 downto resolution);

	alias RV is RsV(exp_width-1 downto resolution);
	alias GV is GsV(exp_width-1 downto resolution);
	alias BV is BsV(exp_width-1 downto resolution);
	alias Vrs is Vs(exp_width-1 downto resolution);

	constant CrY	: unsigned(resolution-1 downto 0) :=
		to_unsigned(integer(round(0.299 * real(2**resolution))),resolution);
	constant CgY	: unsigned(resolution-1 downto 0) :=
		to_unsigned(integer(round(0.587 * real(2**resolution))),resolution);
	constant CbY	: unsigned(resolution-1 downto 0) :=
		to_unsigned(integer(round(0.114 * real(2**resolution))),resolution);

	constant CrU	: unsigned(resolution-1 downto 0) :=
		to_unsigned(integer(round(0.147 * real(2**resolution))),resolution);
	constant CgU	: unsigned(resolution-1 downto 0) :=
		to_unsigned(integer(round(0.289 * real(2**resolution))),resolution);
	constant CbU	: unsigned(resolution-1 downto 0) :=
		to_unsigned(integer(round(0.436 * real(2**resolution))),resolution);

	constant CrV	: unsigned(resolution-1 downto 0) :=
		to_unsigned(integer(round(0.615 * real(2**resolution))),resolution);
	constant CgV	: unsigned(resolution-1 downto 0) :=
		to_unsigned(integer(round(0.515 * real(2**resolution))),resolution);
	constant CbV	: unsigned(resolution-1 downto 0) :=
		to_unsigned(integer(round(0.100 * real(2**resolution))),resolution);
begin
	process
	begin
		wait until rising_edge(clk);
		RsY <= unsigned(red) * CrY;
		GsY <= unsigned(green) * CgY;
		BsY <= unsigned(blue) * CbY;
		Ys <= RsY + GsY + BsY;

		RsU <= unsigned(red) * CrU;
		GsU <= unsigned(green) * CgU;
		BsU <= unsigned(blue) * CbU;
		Us <= BsU - GsU - RsU;

		RsV <= unsigned(red) * CrV;
		GsV <= unsigned(green) * CgV;
		BsV <= unsigned(blue) * CbV;
		Vs <= RsV - GsV - BsV;

		if (GsU + RsU > BsU) then
			Us <= (others => '0');
		end if;
		if (GsV + BsV > RsV) then
			Vs <= (others => '0');
		end if;
	end process;
	y <= std_logic_vector(Yrs);
	u <= std_logic_vector(Urs);
	v <= std_logic_vector(Vrs);

end architecture behavioral;
