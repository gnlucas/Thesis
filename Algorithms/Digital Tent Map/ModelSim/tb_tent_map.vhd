library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_tent_map is
end tb_tent_map;

architecture behaviour of tb_tent_map is

  -- Component Declaration for the Design Under Test (DUT)

component tent_map
port(
	clk : in std_logic;
	rst : in std_logic;
	sel : in std_logic;
	xo  : in std_logic_vector(15 downto 0);
	x   : out std_logic_vector(15 downto 0)
	);
end component;

   signal clk_tb : std_logic;
   signal rst_tb : std_logic;
   signal sel_tb : std_logic;
   signal xo_tb  : std_logic_vector(15 downto 0);
   signal x_tb   : std_logic_vector(15 downto 0);

  --  signal read_data_in1   : std_logic:='0';
  --  file   inputs_data_in1 : text open read_mode  is "Data_A.txt";

  -- Clock period definitions
   constant period     : time := 20 ns;
   constant duty_cicle : real := 0.5;
   constant offset     : time := 5 ns;

	begin

	-- Instantiate the Design Under Test (DUT)

   DUT: tent_map
   port map(clk => clk_tb,
            rst => rst_tb,
	    sel => sel_tb,
	    xo  => xo_tb,
            x   => x_tb
            );
	
   ------------------------------------------------------------------------------------
   ---------------------------- Clock generation --------------------------------------
   ------------------------------------------------------------------------------------		
     process
     begin
          clk_tb <= '0';
          wait for offset;
          clock_loop : loop
              clk_tb <= '0';
              wait for (period - (period * duty_cicle));
              clk_tb <= '1';
              wait for (period * duty_cicle);
          end loop clock_loop;
      end process;
   ------------------------------------------------------------------------------------
   -------------------------- Initial condition generation (xo) -----------------------

		xo :  process
		begin
			xo_tb <= "1010110110101101";
			--xo_tb <= "1010110110101110";
			--xo_tb <= "10101101101011010000000000000000";
			--xo_tb <= "10101101101011010000000000000001";
			--xo_tb <= "1010110110101101000000000000000000000000000000000000000000000000";
			--xo_tb <= "1010110110101101000000000000000000000000000000000000000000000001";	
			wait;
		end process xo;

   ---------------------------Reset-----------------------------------------------------
	rst :  process
	begin
		rst_tb <= '0';
		wait;
	end process rst;

	sel :  process
	begin
		sel_tb <= '0';
		wait for (period + offset);
		sel_tb <= '1';
		wait for period;	
		sel_tb <= '0';
		wait;
	end process sel;

	writing : process(x_tb)

    	file      outfile  : text is out "2_16.txt";  --declare output file
    	variable  outline  : line;   --line number declaration

	begin
	--write(linenumber,value(real type),justified(side),field(width),digits(natural));
	write(outline,x_tb);
	-- write line to external file.
	writeline(outfile, outline);

	end process writing;
end;