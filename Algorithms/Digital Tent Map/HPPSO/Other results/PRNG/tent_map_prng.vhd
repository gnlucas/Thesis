-------------------------------------------------
-- Company:       UFMG
-- Engineer:      LUCAS GIOVANI NARDO
--
-- Create Date:   25-Oct-2021
-- Design name:   HPPSO
-- Module name:   tent_map_prng
-- Description:   pseudorandom number generator
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fpupack.all;

entity tent_map_prng is
	port(reset    : in  std_logic;
	     clk      : in  std_logic;
	     init     : in std_logic_vector(7 downto 0);
	     tent_out : out std_logic_vector(FP_WIDTH-1 downto 0));
end tent_map_prng;

architecture behavior of tent_map_prng is

signal exp_man : std_logic_vector(22 downto 0) := (others => '0');

function tent_map (DATA:std_logic_vector) return std_logic_vector is

variable result     :std_logic_vector (DATA'length-1 downto 0);
variable xor_result :std_logic_vector (DATA'length-2 downto 0);
variable aux        : std_logic;

begin
gen_xor: for I in 0 to (DATA'length-2) loop
	xor_result((DATA'length-2) - I) := DATA(DATA'length-1) xor DATA((DATA'length-2) - I);
end loop gen_xor;

aux       := xor_result(0) xor xor_result(1);
result(0) := aux;
result(DATA'length-1 downto 1) := xor_result(DATA'length-2 downto 0);
return result;

end function;

function fixtofloat(input: std_logic_vector) return std_logic_vector is

variable exp    : std_logic_vector(3 downto 0)  := "1110";
variable man    : std_logic_vector(18 downto 0) := (others => '0');
variable idx    : integer range 0 to 19 := 0;
variable output : std_logic_vector(19+4-1 downto 0);

begin
man := (others=>'0');
idx := 0;
	if input(19) = '1' then
		exp := "1110";
		man(18 downto 0) := input(18 downto 0);
		idx := 0;
	else
		for i in 18 downto 0 loop
			exp := exp - '1';
			if input(i) = '1' then
				idx := i;
			exit;
			else
				idx := 1;
			end if;
 		end loop;
		if idx = 1 then
			man(18) := input(0);
		elsif idx = 2 then
			man(18 downto 17) := input(1 downto 0);
		elsif idx = 3 then
			man(18 downto 16) := input(2 downto 0);
		elsif idx = 4 then
			man(18 downto 15) := input(3 downto 0);
		elsif idx = 5 then
			man(18 downto 14) := input(4 downto 0);
		elsif idx = 6 then
			man(18 downto 13) := input(5 downto 0);
		elsif idx = 7 then
			man(18 downto 12) := input(6 downto 0);
		elsif idx = 8 then
			man(18 downto 11) := input(7 downto 0);
		elsif idx = 9 then
			man(18 downto 10) := input(8 downto 0);
		elsif idx = 10 then
			man(18 downto 9)  := input(9 downto 0);
		elsif idx = 11 then
			man(18 downto 8)  := input(10 downto 0);
		elsif idx = 12 then
			man(18 downto 7)  := input(11 downto 0);
		elsif idx = 13 then
			man(18 downto 6)  := input(12 downto 0);
		elsif idx = 14 then
			man(18 downto 5)  := input(13 downto 0);
		elsif idx = 15 then
			man(18 downto 4)  := input(14 downto 0);
		elsif idx = 16 then
			man(18 downto 3)  := input(15 downto 0);
		elsif idx = 17 then
			man(18 downto 2)  := input(16 downto 0);
		elsif idx = 18 then
			man(18 downto 1)  := input(17 downto 0);
		else
			man(18 downto 0)  := input(18 downto 0);
		end if;
	end if;
output(22 downto 19) := exp;
output(18 downto 0)  := man;
return output;

end function;

begin
process (clk,reset)
variable tent : std_logic_vector(19 downto 0) := init & init & "0000";
begin
	if reset = '1' then
		tent    := init & init & "0000";
		exp_man <= (others => '0');
	elsif (rising_edge(clk)) then
		tent    := tent_map(tent);
		exp_man <= fixtofloat(tent);
	end if;
end process;

tent_out(FP_WIDTH-1) <= '0';
tent_out(FP_WIDTH-2 downto FRAC_WIDTH+4) <= "0111";
tent_out(FRAC_WIDTH+3 downto 0) <= exp_man(22 downto 1);

end behavior;