-- DIGITAL CHAOTIC SYSTEM
-- TENT MAP
-- FIXED POINT NUMERICAL REPRESENTATION

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tent_map is
	generic(
	 width: INTEGER := 16
	-- width: INTEGER := 32
	-- width: INTEGER := 64
	);
	port(
	     clk : in std_logic;
	     rst : in std_logic;
	     sel : in std_logic;
	     xo  : in std_logic_vector((width-1) downto 0);
	     x   : out std_logic_vector((width-1) downto 0)
	    );
end entity;

architecture myarch of tent_map is
-------------------------------------------------------
signal r_aux      : std_logic_vector((width-1) downto 0);
signal aux_r_aux  : std_logic_vector((width-1) downto 0);
signal xor_result : std_logic_vector((width-1) downto 0);
signal aux        : std_logic;
signal ff_aux     : std_logic;
-------------------------------------------------------
begin

gen_xor: for I in 0 to width-2 generate
      xor_result((width-2) - I) <= r_aux(width-1) xor r_aux((width-2) - I);
end generate gen_xor;

aux <= xor_result(0) xor xor_result(1);

process(clk,rst)
	begin
		if (rst ='1') then
			aux_r_aux <= (others=>'0');
		elsif (rising_edge(clk)) then
			ff_aux <= aux;
			aux_r_aux <= std_logic_vector((unsigned(xor_result) sll 1));
		end if;
end process;

multiplexer:process(xo,aux_r_aux,sel)
begin
	case sel is
		when '0' => r_aux <= aux_r_aux((width-1) downto 1) & ff_aux;
		when others => r_aux <= xo;
	end case;
end process multiplexer;

x <= r_aux;
-------------------------------------------------------
end architecture;