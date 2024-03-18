-------------------------------------------------
-- Company:       GRACO-UnB
-- Engineer:      DANIEL MAURICIO MUÑOZ ARBOLEDA
--
-- Create Date:   06-Oct-2012
-- Design name:   HPPSO
-- Module name:   inertia
-- Description:   linear weight decrease
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.entities.all;
use work.fpupack.all;
use work.psopack.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity inertia is
	port (reset         : in  std_logic;
	      clk      	   : in  std_logic;
	      start	   : in  std_logic;
	      INERTIA_SLOPE : in  std_logic_vector(FP_WIDTH-1 downto 0);
	      new_weight    : out std_logic_vector(FP_WIDTH-1 downto 0);		  
	      ready_inerti  : out std_logic);
end inertia;

architecture behavior of inertia is

signal s_op  	      : std_logic;
signal s_start_addsub : std_logic; 
signal s_op_a_add     : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_op_b_add     : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_add_out      : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_ready_add    : std_logic;
signal s_new_weight   : std_logic_vector(FP_WIDTH-1 downto 0);

type   t_state is (waiting,addition);
signal state : t_state;

begin
calc_add_inertia: addsubfsm_v6
	port map (reset      => reset,
		  clk        => clk,
		  op 	    => s_op,
		  op_a       => s_op_a_add,
		  op_b       => s_op_b_add,
		  start_i    => s_start_addsub,
		  addsub_out => s_add_out,
		  ready_as   => s_ready_add);

new_weight <= s_new_weight;

-- FSM
process(clk,reset)
begin
	if rising_edge(clk) then
		if reset = '1' then
			state 	     <= waiting;
			s_op 	     <= '0';			 		
			ready_inerti <= '0';
			s_new_weight <= INITIAL_WEIGHT;
		else
			case state is
				when waiting =>
					ready_inerti <= '0';
					if start = '1' then
						s_op_a_add     <= s_new_weight;
						s_op_b_add     <= INERTIA_SLOPE;
						s_start_addsub <= '1';
						state 	       <= addition;
					else state <= waiting;
					end if;					
				when addition =>
					s_start_addsub <= '0';
					if s_ready_add = '1' then
						s_new_weight <= s_add_out;
						ready_inerti <= '1';
						state 	     <= waiting;
					else state <= addition;
					end if;								
				when others => state <= waiting;
			end case;					
		end if;
	end if;
end process;

end behavior;