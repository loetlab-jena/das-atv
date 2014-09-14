 -- title:			Coordinate Rotator
 -- author:			Sebastian Weiss <dl3yc@darc.de>
 -- last change:	22.10.13

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity cordic is
	generic
	(
		A	: natural;	-- amplitude resolution
		P	: natural;	-- phase resolution
		N	: natural		-- number of stages
	);

	port
	(
		clk	: in std_logic;					-- signal processing clock
		phi	: in unsigned(P-3 downto 0);	-- phase input (0° - 90°)
		sin	: out signed(A-1 downto 0);		-- sine output
		cos	: out signed(A-1 downto 0)		-- cosine output
	);
end entity;

architecture behavioral of cordic is
	type alpha_t	is array(0 to N-1)			of signed(P  downto 0);
	type xy_vector	is array(natural range <>)	of signed(A-1 downto 0);
	type z_vector	is array(natural range <>)	of signed(P downto 0);
	constant init	: signed(A-1 downto 0)		:= to_signed(integer(0.60725*2**(A-1)),A);

	signal alpha	: alpha_t;
	signal x,y		: xy_vector(N downto 0)	:= (others => (others => '0'));
	signal z		: z_vector(N downto 0)	:= (others => (others => '0'));
begin

	table: for i in 0 to N-1 generate
		alpha(i) <= to_signed(integer( arctan(1.0/real(2**i)) / (2.0*math_pi) * real(2**P) ),P+1);
	end generate;

	process begin
		wait until rising_edge(clk);
		x(0) <= init;
		y(0) <= (others => '0');
		z(0) <= signed("000" & phi); -- 0..90° -> +- 0..360*
		for i in 1 to N loop
			if z(i-1) >= 0 then
				x(i) <= x(i-1) - y(i-1) / 2**(i-1);
				y(i) <= y(i-1) + x(i-1) / 2**(i-1);
				z(i) <= z(i-1) - alpha(i-1);
			else
				x(i) <= x(i-1) + y(i-1) / 2**(i-1);
				y(i) <= y(i-1) - x(i-1) / 2**(i-1);
				z(i) <= z(i-1) + alpha(i-1);
			end if;
		end loop;
	end process;

	sin <= y(N);
	cos <= x(N);

end behavioral;
