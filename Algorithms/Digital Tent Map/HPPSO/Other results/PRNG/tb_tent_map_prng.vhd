library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.fpupack.all;

entity tb_tent_map is
end tb_tent_map;

architecture behaviour of tb_tent_map is

-- Component Declaration for the Design Under Test (DUT)

component tent_map_prng
	port (reset    :  in std_logic;
	      clk      :  in std_logic;
	      init     :  in std_logic_vector(7 downto 0);
	      tent_out : out std_logic_vector(FP_WIDTH-1 downto 0));
end component;

signal reset_tb    : std_logic;
signal clk_tb      : std_logic := '0';
signal init_tb     : std_logic_vector(7 downto 0);
signal tent_out_tb : std_logic_vector(FP_WIDTH-1 downto 0);

begin

-- Instantiate the Design Under Test (DUT)

DUT: tent_map_prng
	port map(reset    => reset_tb,
		 clk      => clk_tb,
		 init     => init_tb,
		 tent_out => tent_out_tb);

clk_tb   <= not clk_tb after 5 ns;
reset_tb <= '0', '1' after 15 ns, '0' after 25 ns;

init :  process
begin
init_tb <= "10101101";
wait;
end process init;
	
writing : process(tent_out_tb)
file      outfile  : text is out "test.txt";  --declare output file
variable  outline  : line;   --line number declaration

begin
write(outline,tent_out_tb);
writeline(outfile, outline);
end process writing;

end;