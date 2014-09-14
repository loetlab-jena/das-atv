 -- title:			Numeric Controlled Oscillator
 -- author:			Sebastian Weiss <dl3yc@darc.de>
 -- last change:	14.09.14

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nco is
	generic
	(
		A	: positive;					-- amplitude resolution
		F	: positive;					-- frequency resolution
		P	: positive;					-- phase resolution
		N	: positive;					-- number of stages
		FCW	: positive					-- frequency control word
	);

	port
	(
	clk	: in std_logic;					-- signal processing clock
	sin	: out signed(A-1 downto 0);		-- sine output
	cos	: out signed(A-1 downto 0)		-- cosine output
	);
end entity;

architecture behavioral of nco is
type q_vector is array(natural range <>) of std_logic_vector(1 downto 0);
signal cordic_phi	: unsigned(P-3 downto 0);
signal cordic_sin	: signed(A-1 downto 0);
signal cordic_cos	: signed(A-1 downto 0);
signal phi			: unsigned(P-1 downto 0) := (others => '0');
signal phase		: unsigned(P-2 downto 0);
signal q			: q_vector(N+1 downto 0) := (others => (others => '0'));
begin

	cordic : entity work.cordic
	generic map(
		A	=> A,
		P	=> P,
		N	=> N
	)
	port map(
		clk	=> clk,
		phi	=> cordic_phi,
		sin	=> cordic_sin,
		cos	=> cordic_cos
	);

	process
	begin
		wait until rising_edge(clk);
		phi <= phi + FCW;

		if phi(P-2) = '1' then
			phase <= 0 - phi(P-2 downto 0);
		else
			phase <= phi(P-2 downto 0);
		end if;

		q(0) <= phi(P-1) & phi(P-2);
		for i in 1 to N+1 loop
			q(i) <= q(i-1);
		end loop;

		if q(N+1) = "00" then
			sin <= cordic_sin;
			cos <= cordic_cos;
		elsif q(N+1) = "01" then
			sin <= cordic_sin;
			cos <= -cordic_cos;
		elsif q(N+1) = "10" then
			sin <= -cordic_sin;
			cos <= -cordic_cos;
		elsif q(N+1) = "11" then
			sin <= -cordic_sin;
			cos <= cordic_cos;
		end if;
	end process;

	cordic_phi <= phase(P-3 downto 0);
end behavioral;
