-------------------------------------------------
-- Company:       GRACO-UnB
-- Engineer:      DANIEL MAURICIO MUÑOZ ARBOLEDA
--
-- Create Date:   06-Oct-2012
-- Design name:   HPPSO
-- Module name:   particle_ula_v2_rosenbrock
-- Description:   Particle - Rosenbrock function
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.entities.all;
use work.fpupack.all;
use work.psopack.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity particle_ula_v2_rosenbrock is
	port (reset    :  in std_logic;
	      clk      :  in std_logic;
	      istart   :  in std_logic;
	      pstart   :  in std_logic;
	      init     :  in std_logic_vector(7 downto 0);
	      numDim   :  in std_logic_vector(3 downto 0);
	      weight   :  in std_logic_vector(FP_WIDTH-1 downto 0);
	      vpos_act :  in std_logic_vector(6*FP_WIDTH-1 downto 0);
	      vbest_ys :  in std_logic_vector(6*FP_WIDTH-1 downto 0);
	      vbest_yi :  in std_logic_vector(6*FP_WIDTH-1 downto 0);
	      vnew_pos : out std_logic_vector(6*FP_WIDTH-1 downto 0);
	      pready   : out std_logic;
	      fstart   :  in std_logic;
	      f_out    : out std_logic_vector(FP_WIDTH-1 downto 0);
	      fready   : out std_logic);
end particle_ula_v2_rosenbrock;

architecture behavior of particle_ula_v2_rosenbrock is

signal start_tent : std_logic;
signal tent_out   : std_logic_vector(FP_WIDTH-1 downto 0);
signal ready_tent : std_logic := '0';

signal opA_as   : std_logic_vector(FP_WIDTH-1 downto 0);
signal opB_as   : std_logic_vector(FP_WIDTH-1 downto 0);
signal op_as 	: std_logic;
signal start_as : std_logic;
signal out_as   : std_logic_vector(FP_WIDTH-1 downto 0);
signal ready_as : std_logic;

signal start_mul : std_logic;
signal opA_mul   : std_logic_vector(FP_WIDTH-1 downto 0);
signal opB_mul   : std_logic_vector(FP_WIDTH-1 downto 0);
signal out_mul   : std_logic_vector(FP_WIDTH-1 downto 0);
signal ready_mul : std_logic;

signal count    : std_logic_vector(3 downto 0);
signal out_mux1 : std_logic_vector(FP_WIDTH-1 downto 0);
signal out_mux2 : std_logic_vector(FP_WIDTH-1 downto 0);

signal dim : std_logic_vector(3 downto 0) := "0000";

type   matrix1D is array (0 to 5) of std_logic_vector(FP_WIDTH-1 downto 0);
signal s_lv    : matrix1D;
signal pos_act : std_logic_vector(FP_WIDTH-1 downto 0) := (others => '1');
signal best_ys : std_logic_vector(FP_WIDTH-1 downto 0) := (others => '1');
signal best_yi : std_logic_vector(FP_WIDTH-1 downto 0) := (others => '1');

signal s_inertia : std_logic_vector(FP_WIDTH-1 downto 0) := (others => '0');

type   t_state is (waiting,state2,state3,state4,state5,state6,acc,initialize,decoin,inertia,individual,social,velocity,position);
signal state : t_state;

begin
random: tent_map_prng
	port map (reset       =>  reset,
	          clk         =>  clk,
		  start       =>  start_tent,
		  init        =>  init,
		  tent_out    =>  tent_out,
		  ready       =>  ready_tent);

adsb: addsubfsm_v6
	port map (reset       => reset,
		  clk         => clk,
		  op          => op_as,
		  op_a        => opA_as,
		  op_b        => opB_as,
		  start_i     => start_as,
		  addsub_out  => out_as,
		  ready_as    => ready_as);

mul: multiplierfsm_v2
	port map (reset       => reset,
		  clk         => clk,
		  op_a        => opA_mul,
		  op_b        => opB_mul,
		  start_i     => start_mul,
		  mul_out     => out_mul,
		  ready_mul   => ready_mul);

process(reset,clk,fstart,pstart)
variable x_power2 : std_logic_vector(FP_WIDTH-1 downto 0);
variable acc_v    : std_logic_vector(FP_WIDTH-1 downto 0);
variable vdim     : integer range 0 to 15;
begin
	if rising_edge(clk) then
		if reset = '1' then
			state      <= waiting;
			start_tent <= '0';
			start_as   <= '0';
			op_as      <= '0';
			opA_as     <= (others => '0');
			opB_as     <= (others => '0');
			start_mul  <= '0';
			opA_mul    <= (others => '0');
			opB_mul    <= (others => '0');

			f_out  <= (others => '1');
			acc_v  := (others => '0');
			count  <= (others => '0');
			fready <= '0';

			s_lv(0) <= INITIAL_VELOCI;
			s_lv(1) <= INITIAL_VELOCI;
			s_lv(2) <= INITIAL_VELOCI;
			s_lv(3) <= INITIAL_VELOCI;
			s_lv(4) <= INITIAL_VELOCI;
			s_lv(5) <= INITIAL_VELOCI;

			vdim   := 0;
			dim    <= "0000";
			pready <= '0';
		else
			case state is
				when waiting =>
					fready <= '0';
					pready <= '0';
					acc_v  := (others => '0');
					count  <= (others => '0');
					if fstart = '1' then
						opA_mul    <= out_mux1;
						opB_mul    <= out_mux1;
						start_mul  <= '1';
						op_as      <= '1';
						opA_as     <= s_one;
						opB_as     <= out_mux1;
						start_as   <= '1';
						state      <= state2;
					elsif pstart = '1' then
						state      <= decoin;
					elsif istart = '1' then
						start_tent <= '1';
						state      <= initialize;
					else state <= waiting;
					end if;

				when state2 =>
					start_mul <= '0';
					start_as  <= '0';
					if ready_mul = '1' AND ready_as = '1' then
						opA_mul   <= out_as;
						opB_mul   <= out_as;
						start_mul <= '1';
						op_as     <= '1';
						opA_as    <= out_mux2;
						opB_as    <= out_mul;
						start_as  <= '1';
						state     <= state3;
					else state <= state2;
					end if;

				when state3 =>
					start_mul <= '0';
					start_as  <= '0';
					if ready_mul = '1' AND ready_as = '1' then
						opA_mul   <= out_as;
						opB_mul   <= out_as;
						start_mul <= '1';
						x_power2  := out_mul;
						state     <= state4;
					else state <= state3;
					end if;

				when state4 =>
					start_mul <= '0';
					if ready_mul = '1' then
						opA_mul   <= s_hundred;
						opB_mul   <= out_mul;
						start_mul <= '1';
						state     <= state5;
					else state <= state4;
					end if;

				when state5 =>
					start_mul <= '0';
					if ready_mul = '1' then
						op_as     <= '0';
						opA_as    <= out_mul;
						opB_as    <= x_power2;
						start_as  <= '1';
						state     <= state6;
					else state <= state5;
					end if;

				when state6 =>
					start_as <= '0';
					if ready_as = '1' then
						op_as     <= '0';
						opA_as    <= out_as;
						opB_as    <= acc_v;
						start_as  <= '1';
						count     <= count + '1';
						state     <= acc;
					else state <= state6;
					end if;

				when acc =>
					start_as <= '0';
					if ready_as = '1' then
						if count = "0011" then
							fready <= '1';
							f_out  <= out_as;
							state  <= waiting;
						else
							acc_v     := out_as;
							opA_mul   <= out_mux1;
							opB_mul   <= out_mux1;
							start_mul <= '1';
							op_as     <= '1';
							opA_as    <= s_one;
							opB_as    <= out_mux1;
							start_as  <= '1';
							state     <= state2;
						end if;
					else state <= acc;
					end if;

-- These states update the particle's position --

				when initialize =>
					start_tent <= '0';
					if ready_tent = '1' then
						if dim = numDim-'1' then
							dim        <= "0000";
							pready     <= '1';
							start_tent <= '0';
							state      <= waiting;
						else
							dim        <= dim + '1';
							pready     <= '0';
							start_tent <= '1';
							state      <= initialize;
						end if;
					else state <= initialize;
					end if;

				when decoin =>
					op_as      <= '1';
					opA_as     <= best_yi;
					opB_as     <= pos_act;
					start_as   <= '1';
					opA_mul    <= weight;
					opB_mul    <= s_lv(vdim);
					start_mul  <= '1';
					start_tent <= '1';
					state 	   <= inertia;

				when inertia =>
					start_as   <= '0';
					start_mul  <= '0';
					start_tent <= '0';
					if ready_as = '1' AND ready_mul = '1' then
						s_inertia  <= out_mul;
						op_as      <= '1';
						opA_as     <= best_ys;
						opB_as     <= pos_act;
						start_as   <= '1';
						opA_mul    <= tent_out;
						opB_mul    <= out_as;
						start_mul  <= '1';
						start_tent <= '1';
						state      <= individual;
					else state <= inertia;
				end if;

				when individual =>
					start_as   <= '0';
					start_mul  <= '0';
					start_tent <= '0';
					if ready_as = '1' AND ready_mul = '1' then
						op_as 	  <= '0';
						opA_as 	  <= out_mul;
						opB_as 	  <= s_inertia;
						start_as  <= '1';
						opA_mul   <= tent_out;
						opB_mul   <= out_as;
						start_mul <= '1';
						state 	  <= social;
					else state <= individual;
					end if;

				when social =>
					start_as  <= '0';
					start_mul <= '0';
					if ready_as = '1' AND ready_mul = '1' then
						op_as 	 <= '0';
						opA_as 	 <= out_mul;
						opB_as 	 <= out_as;
						start_as <= '1';
						state 	 <= velocity;
					else state <= social;
					end if;

				when velocity =>
					start_as <= '0';
					if ready_as = '1' then
						if out_as(FP_WIDTH-2 downto 0) > MAX_VELOCI(FP_WIDTH-2 downto 0) then
							opA_as(FP_WIDTH-1) 	    <= out_as(FP_WIDTH-1);
							opA_as(FP_WIDTH-2 downto 0) <= MAX_VELOCI(FP_WIDTH-2 downto 0);
						else
							opA_as <= out_as;
						end if;
						op_as 	<= '0';
						opB_as 	<= pos_act;
						start_as <= '1';
						state 	<= position;
					else state <= velocity;
					end if;

				when position =>
					start_as <= '0';
					if ready_as = '1' then
						s_lv(vdim) <= opA_as;
						if dim=numDim-'1' then
							dim    <= "0000";
							vdim   := 0;
							pready <= '1';
							state  <= waiting;
						else
							dim    <= dim + '1';
							vdim   := vdim + 1;
							pready <= '0';
							state  <= decoin;
						end if;
					else state <= position;
					end if;

				when others => state <= waiting;
			end case;
		end if;
	end if;
end process;

process(clk)
begin
	if rising_edge(clk) then
		case state is
			when initialize =>
				if ready_tent='1' then
					case dim is
						when "0000" => vnew_pos(26 downto 0)    <= tent_out;
                        			when "0001" => vnew_pos(53 downto 27)   <= tent_out;
                        			when "0010" => vnew_pos(80 downto 54)   <= tent_out;
                        			when "0011" => vnew_pos(107 downto 81)  <= tent_out;
                        			when "0100" => vnew_pos(134 downto 108) <= tent_out;
                        			when "0101" => vnew_pos(161 downto 135) <= tent_out;
                        			when others => vnew_pos(26 downto 0)    <= tent_out;
					end case;
				end if;
			when position =>
				if ready_as ='1' then
					case dim is
						when "0000" => vnew_pos(26 downto 0)    <= out_as;
						when "0001" => vnew_pos(53 downto 27)   <= out_as;
						when "0010" => vnew_pos(80 downto 54)   <= out_as;
						when "0011" => vnew_pos(107 downto 81)  <= out_as;
						when "0100" => vnew_pos(134 downto 108) <= out_as;
						when "0101" => vnew_pos(161 downto 135) <= out_as;
						when others => vnew_pos(26 downto 0)    <= out_as;
					end case; 
				end if;
			when others => null;
		end case;
	end if;
end process;

process(dim)
begin
	case dim is
		when "0000" => pos_act <= vpos_act(26 downto 0);
		when "0001" => pos_act <= vpos_act(53 downto 27);
		when "0010" => pos_act <= vpos_act(80 downto 54);
		when "0011" => pos_act <= vpos_act(107 downto 81);
		when "0100" => pos_act <= vpos_act(134 downto 108);
		when "0101" => pos_act <= vpos_act(161 downto 135);
		when others => pos_act <= vpos_act(26 downto 0);
	end case;
end process;

process(dim,pstart)
begin
	case dim is
		when "0000" => best_ys <= vbest_ys(26 downto 0);
		when "0001" => best_ys <= vbest_ys(53 downto 27);
		when "0010" => best_ys <= vbest_ys(80 downto 54);
		when "0011" => best_ys <= vbest_ys(107 downto 81);
		when "0100" => best_ys <= vbest_ys(134 downto 108);
		when "0101" => best_ys <= vbest_ys(161 downto 135);
		when others => best_ys <= vbest_ys(26 downto 0);
	end case;
end process;

process(dim,pstart)
begin
	case dim is
		when "0000" => best_yi <= vbest_yi(26 downto 0);
		when "0001" => best_yi <= vbest_yi(53 downto 27);
		when "0010" => best_yi <= vbest_yi(80 downto 54);
		when "0011" => best_yi <= vbest_yi(107 downto 81);
		when "0100" => best_yi <= vbest_yi(134 downto 108);
		when "0101" => best_yi <= vbest_yi(161 downto 135);
		when others => best_yi <= vbest_yi(26 downto 0);
	end case;
end process;

process(clk,count)
begin
	case count is
		when "0000" => out_mux1 <= vpos_act(26 downto 0);
		when "0001" => out_mux1 <= vpos_act(80 downto 54);
		when "0010" => out_mux1 <= vpos_act(134 downto 108);
		when others => out_mux1 <= vpos_act(26 downto 0);
	end case;
end process;

process(clk,count)
begin
	case count is
		when "0000" => out_mux2 <= vpos_act(53 downto 27);
		when "0001" => out_mux2 <= vpos_act(107 downto 81);
		when "0010" => out_mux2 <= vpos_act(161 downto 135);
		when others => out_mux2 <= vpos_act(53 downto 27);
	end case;
end process;
 
end behavior;