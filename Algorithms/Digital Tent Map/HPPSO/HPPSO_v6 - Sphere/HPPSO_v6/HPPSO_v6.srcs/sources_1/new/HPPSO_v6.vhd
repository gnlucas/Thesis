-------------------------------------------------
-- Company:       GRACO-UnB
-- Engineer:      DANIEL MAURICIO MUÑOZ ARBOLEDA
--
-- Create Date:   06-Oct-2012
-- Design name:   HPPSO
-- Module name:   HPPSO_v6
-- Description:   main code
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

entity HPPSO_v6 is
	port (FSL_Rst :  in std_logic;
	      FSL_Clk :  in std_logic;
	      start   :  in std_logic;
	      ready   : out std_logic);
end HPPSO_v6;

architecture behavior of HPPSO_v6 is

signal s_start_eval : std_logic;
signal s_fout_p1    : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fout_p2    : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fout_p3    : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fout_p4    : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fout_p5    : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fout_p6    : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fout_p7    : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fout_p8    : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fout_p9    : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fout_p10   : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_ready_eval : std_logic;

signal s_start_inertia : std_logic;
signal s_ready_inertia : std_logic;
signal s_weight        : std_logic_vector(FP_WIDTH-1 downto 0);

signal istart    : std_logic;
signal s_start_p : std_logic;
signal s_nx1     : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_nx2     : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_nx3     : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_nx4     : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_nx5     : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_nx6     : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_nx7     : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_nx8     : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_nx9     : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_nx10    : std_logic_vector(6*FP_WIDTH-1 downto 0);

signal s_y1  : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_y2  : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_y3  : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_y4  : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_y5  : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_y6  : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_y7  : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_y8  : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_y9  : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_y10 : std_logic_vector(6*FP_WIDTH-1 downto 0);

signal s_ready_p : std_logic;

signal s_fy_p1  : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fy_p2  : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fy_p3  : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fy_p4  : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fy_p5  : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fy_p6  : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fy_p7  : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fy_p8  : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fy_p9  : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_fy_p10 : std_logic_vector(FP_WIDTH-1 downto 0);

signal s_start_cmpsc : std_logic;
signal s_ready_cmpsc : std_logic;

signal s_ys        : std_logic_vector(6*FP_WIDTH-1 downto 0);
signal s_ys1       : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_ys2       : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_ys3       : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_ys4       : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_ys5       : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_ys6       : std_logic_vector(FP_WIDTH-1 downto 0);
signal s_y_pj      : std_logic_vector(3 downto 0);
signal s_min_value : std_logic_vector(FP_WIDTH-1 downto 0) := (others => '0');
signal countIter   : integer range 1 to numIter := 1;

type   t_state is (waiting,init_x,fitness_x,compara_soc,updatep);
signal state_pso     : t_state;
signal numDim        : std_logic_vector(3 downto 0) := "0110";
signal INERTIA_SLOPE : std_logic_vector(FP_WIDTH-1 downto 0) := "101110000100001110111011111";

begin
fit_part1: particle_ula_v2_sphere
	port map (reset    => FSL_Rst,
		      clk      => FSL_Clk,
		      pstart   => s_start_p, 
		      istart   => istart,
		      init     => init_p1,
		      numDim   => numDim,
		      weight   => s_weight,
		      vpos_act => s_nx1,
		      vbest_ys => s_ys,
		      vbest_yi => s_y1,
		      vnew_pos => s_nx1,
		      pready   => s_ready_p,
		      fstart   => s_start_eval,
		      f_out    => s_fout_p1,
		      fready   => s_ready_eval);

fit_part2: particle_ula_v2_sphere
	port map (reset    => FSL_Rst,
		      clk      => FSL_Clk,
		      pstart   => s_start_p, 
		      istart   => istart,
		      init     => init_p2,
		      numDim   => numDim,
		      weight   => s_weight,
		      vpos_act => s_nx2,
		      vbest_ys => s_ys,
		      vbest_yi => s_y2,
		      vnew_pos => s_nx2,
		      pready   => open,
		      fstart   => s_start_eval,
		      fready   => open,
		      f_out    => s_fout_p2);

fit_part3: particle_ula_v2_sphere
	port map (reset    => FSL_Rst,
		      clk      => FSL_Clk,
		      pstart   => s_start_p, 
		      istart   => istart,
		      init     => init_p3,
		      numDim   => numDim,
		      weight   => s_weight,
		      vpos_act => s_nx3,
		      vbest_ys => s_ys,
		      vbest_yi => s_y3,
		      vnew_pos => s_nx3,
		      pready   => open,
		      fstart   => s_start_eval,
		      fready   => open,
		      f_out    => s_fout_p3);

fit_part4: particle_ula_v2_sphere
	port map (reset    => FSL_Rst,
		      clk      => FSL_Clk,
		      pstart   => s_start_p, 
		      istart   => istart,
		      init     => init_p4,
		      numDim   => numDim,
		      weight   => s_weight,
		      vpos_act => s_nx4,
		      vbest_ys => s_ys,
		      vbest_yi => s_y4,
		      vnew_pos => s_nx4,
		      pready   => open,
		      fstart   => s_start_eval,
		      fready   => open,
		      f_out    => s_fout_p4);

fit_part5: particle_ula_v2_sphere
	port map (reset    => FSL_Rst,
		      clk      => FSL_Clk,
		      pstart   => s_start_p, 
		      istart   => istart,
		      init     => init_p5,
		      numDim   => numDim,
		      weight   => s_weight,
		      vpos_act => s_nx5,
		      vbest_ys => s_ys,
		      vbest_yi => s_y5,
		      vnew_pos => s_nx5,
		      pready   => open,
		      fstart   => s_start_eval,
		      fready   => open,
		      f_out    => s_fout_p5);

fit_part6: particle_ula_v2_sphere
	port map (reset    => FSL_Rst,
		      clk      => FSL_Clk,
		      pstart   => s_start_p, 
		      istart   => istart,
		      init     => init_p6,
		      numDim   => numDim,
		      weight   => s_weight,
		      vpos_act => s_nx6,
		      vbest_ys => s_ys,
		      vbest_yi => s_y6,
		      vnew_pos => s_nx6,
		      pready   => open,
		      fstart   => s_start_eval,
		      fready   => open,
		      f_out    => s_fout_p6);

fit_part7: particle_ula_v2_sphere
	port map (reset    => FSL_Rst,
		      clk      => FSL_Clk,
		      pstart   => s_start_p, 
		      istart   => istart,
		      init     => init_p7,
		      numDim   => numDim,
		      weight   => s_weight,
		      vpos_act => s_nx7,
		      vbest_ys => s_ys,
		      vbest_yi => s_y7,
		      vnew_pos => s_nx7,
		      pready   => open,
		      fstart   => s_start_eval,
		      fready   => open,
		      f_out    => s_fout_p7);

fit_part8: particle_ula_v2_sphere
	port map (reset    => FSL_Rst,
		      clk      => FSL_Clk,
		      pstart   => s_start_p, 
		      istart   => istart,
		      init     => init_p8,
		      numDim   => numDim,
		      weight   => s_weight,
		      vpos_act => s_nx8,
		      vbest_ys => s_ys,
		      vbest_yi => s_y8,
		      vnew_pos => s_nx8,
		      pready   => open,
		      fstart   => s_start_eval,
		      fready   => open,
		      f_out    => s_fout_p8);

fit_part9: particle_ula_v2_sphere
	port map (reset    => FSL_Rst,
		      clk      => FSL_Clk,
		      pstart   => s_start_p, 
		      istart   => istart,
		      init     => init_p9,
		      numDim   => numDim,
		      weight   => s_weight,
		      vpos_act => s_nx9,
		      vbest_ys => s_ys,
		      vbest_yi => s_y9,
		      vnew_pos => s_nx9,
		      pready   => open,
		      fstart   => s_start_eval,
		      fready   => open,
		      f_out    => s_fout_p9);

fit_part10: particle_ula_v2_sphere
	port map (reset    => FSL_Rst,
		      clk      => FSL_Clk,
		      pstart   => s_start_p, 
		      istart   => istart,
		      init     => init_p10,
		      numDim   => numDim,
		      weight   => s_weight,
		      vpos_act => s_nx10,
		      vbest_ys => s_ys,
		      vbest_yi => s_y10,
		      vnew_pos => s_nx10,
		      pready   => open,
		      fstart   => s_start_eval,
		      fready   => open,
		      f_out    => s_fout_p10);

compsoc: compare_social
	port map (reset       => FSL_Rst,
		      clk         => FSL_Clk,
		      start_cmpsc => s_start_cmpsc,
		      f_y_p1      => s_fy_p1,
		      f_y_p2      => s_fy_p2,
		      f_y_p3      => s_fy_p3,
		      f_y_p4      => s_fy_p4,
		      f_y_p5      => s_fy_p5,
		      f_y_p6      => s_fy_p6,
		      f_y_p7      => s_fy_p7,
		      f_y_p8      => s_fy_p8,
		      f_y_p9      => s_fy_p9,
		      f_y_p10     => s_fy_p10,
		      y_pj        => s_y_pj,
		      cmpsc_out   => s_min_value,
		      ready_cmpsc => s_ready_cmpsc);

calc_inertia: inertia
    port map (reset         => FSL_Rst,
		      clk           => FSL_Clk,
		      start         => s_start_inertia,
		      INERTIA_SLOPE => INERTIA_SLOPE,
		      new_weight    => s_weight,
		      ready_inerti  => s_ready_inertia);
				 
process(FSL_Clk,FSL_Rst,start)
begin
	if rising_edge(FSL_Clk) then
		if FSL_Rst = '1' then
			state_pso       <= waiting;
			s_start_eval    <= '0';
			istart          <= '0';
			s_start_inertia <= '0';
			s_start_cmpsc   <= '0';
			s_start_p       <= '0';
			ready           <= '0';
		else
			case state_pso is
				when waiting =>
					ready <= '0';
					if start = '1' then
						istart     <= '1';
						state_pso  <= init_x;
					else state_pso <= waiting;
					end if;

				when init_x =>
					istart <= '0';
					if s_ready_p = '1' then
						s_start_eval <= '1';
						state_pso    <= fitness_x;
					else state_pso   <= init_x;
					end if;

				when fitness_x =>
					s_start_eval    <= '0';
					s_start_inertia <= '0';
					if s_ready_eval = '1' then
						s_start_cmpsc <= '1';
						state_pso     <= compara_soc;
					else state_pso    <= fitness_x;
					end if;

				when compara_soc =>
					s_start_cmpsc <= '0';
					if s_ready_cmpsc = '1' then
						if countIter = numIter then
							s_start_p <= '0';
							ready     <= '1';
							state_pso <= waiting;
						else
							countIter <= countIter+1;
							s_start_p <= '1';
							ready     <= '0';
							state_pso <= updatep;
						end if;
					else state_pso <= compara_soc;
					end if;

				when updatep =>
					s_start_cmpsc <= '0';
					s_start_p     <= '0';
					if s_ready_p = '1' then
						s_start_inertia <= '1';
						s_start_eval    <= '1';
						s_start_p       <= '0';
						state_pso       <= fitness_x;
					end if;
				when others => state_pso <= waiting;
			end case;
		end if;
	end if;
end process;

process(FSL_Rst,FSL_Clk,s_ready_eval)
begin
	if rising_edge(FSL_Clk) then
		if FSL_Rst = '1' then
			s_fy_p1 <= (others => '1');
			s_y1  <= (others=>'1');
		else
			if s_ready_eval = '1' then
				if s_fout_p1 < s_fy_p1 then
					s_fy_p1 <= s_fout_p1;
					s_y1    <= s_nx1;
				end if;
			end if;
		end if;
	end if;
end process;

process(FSL_Rst,FSL_Clk,s_ready_eval)
begin
	if rising_edge(FSL_Clk) then
		if FSL_Rst = '1' then
			s_fy_p2 <= (others => '1');
			s_y2    <= (others=>'1');
		else
			if s_ready_eval = '1' then
				if s_fout_p2 < s_fy_p2 then
					s_fy_p2 <= s_fout_p2;
					s_y2    <= s_nx2;
				end if;
			end if;
		end if;
	end if;
end process;

process(FSL_Rst,FSL_Clk,s_ready_eval)
begin
	if rising_edge(FSL_Clk) then
		if FSL_Rst = '1' then
			s_fy_p3 <= (others => '1');
			s_y3    <= (others=>'1');
		else
			if s_ready_eval = '1' then
				if s_fout_p3 < s_fy_p3 then
					s_fy_p3 <= s_fout_p3;
					s_y3    <= s_nx3;
				end if;
			end if;
		end if;
	end if;
end process;

process(FSL_Rst,FSL_Clk,s_ready_eval)
begin
	if rising_edge(FSL_Clk) then
		if FSL_Rst = '1' then
			s_fy_p4 <= (others => '1');
			s_y4  <= (others=>'1');
		else
			if s_ready_eval = '1' then
				if s_fout_p4 < s_fy_p4 then
					s_fy_p4 <= s_fout_p4;
					s_y4    <= s_nx4;
				end if;
			end if;
		end if;
	end if;
end process;

process(FSL_Rst,FSL_Clk,s_ready_eval)
begin
	if rising_edge(FSL_Clk) then
		if FSL_Rst = '1' then
			s_fy_p5 <= (others => '1');
			s_y5  <= (others=>'1');
		else
			if s_ready_eval = '1' then
				if s_fout_p5 < s_fy_p5 then
					s_fy_p5 <= s_fout_p5;
					s_y5    <= s_nx5;
				end if;
			end if;
		end if;
	end if;
end process;

process(FSL_Rst,FSL_Clk,s_ready_eval)
begin
	if rising_edge(FSL_Clk) then
		if FSL_Rst = '1' then
			s_fy_p6 <= (others => '1');
			s_y6  <= (others=>'1');
		else
			if s_ready_eval = '1' then
				if s_fout_p6 < s_fy_p6 then
					s_fy_p6 <= s_fout_p6;
					s_y6    <= s_nx6;
				end if;
			end if;
		end if;
	end if;
end process;

process(FSL_Rst,FSL_Clk,s_ready_eval)
begin
	if rising_edge(FSL_Clk) then
		if FSL_Rst = '1' then
			s_fy_p7 <= (others => '1');
			s_y7  <= (others=>'1');
		else
			if s_ready_eval = '1' then
				if s_fout_p7 < s_fy_p7 then
					s_fy_p7 <= s_fout_p7;
					s_y7    <= s_nx7;
				end if;
			end if;
		end if;
	end if;
end process;

process(FSL_Rst,FSL_Clk,s_ready_eval)
begin
	if rising_edge(FSL_Clk) then
		if FSL_Rst = '1' then
			s_fy_p8 <= (others => '1');
			s_y8  <= (others=>'1');
		else
			if s_ready_eval = '1' then
				if s_fout_p8 < s_fy_p8 then
					s_fy_p8 <= s_fout_p8;
					s_y8    <= s_nx8;
				end if;
			end if;
		end if;
	end if;
end process;

process(FSL_Rst,FSL_Clk,s_ready_eval)
begin
	if rising_edge(FSL_Clk) then
		if FSL_Rst = '1' then
			s_fy_p9 <= (others => '1');
			s_y9  <= (others=>'1');
		else
			if s_ready_eval = '1' then
				if s_fout_p9 < s_fy_p9 then
					s_fy_p9 <= s_fout_p9;
					s_y9    <= s_nx9;
				end if;
			end if;
		end if;
	end if;
end process;

process(FSL_Rst,FSL_Clk,s_ready_eval)
begin
	if rising_edge(FSL_Clk) then
		if FSL_Rst = '1' then
			s_fy_p10 <= (others => '1');
			s_y10  <= (others=>'1');
		else
			if s_ready_eval = '1' then
				if s_fout_p10 < s_fy_p10 then
					s_fy_p10 <= s_fout_p10;
					s_y10    <= s_nx10;
				end if;
			end if;
		end if;
	end if;
end process;

process(s_ready_cmpsc)
begin
	case s_y_pj is
		when "0000" => s_ys <= s_y1;
		when "0001" => s_ys <= s_y2;
		when "0010" => s_ys <= s_y3;
		when "0011" => s_ys <= s_y4;
		when "0100" => s_ys <= s_y5;
		when "0101" => s_ys <= s_y6;
		when "0110" => s_ys <= s_y7;
		when "0111" => s_ys <= s_y8;
		when "1000" => s_ys <= s_y9;
		when "1001" => s_ys <= s_y10;
		when others => s_ys <= s_y1;
	end case;
end process;

s_ys1 <= s_ys(26 downto 0);
s_ys2 <= s_ys(53 downto 27);
s_ys3 <= s_ys(80 downto 54);
s_ys4 <= s_ys(107 downto 81);
s_ys5 <= s_ys(134 downto 108);
s_ys6 <= s_ys(161 downto 135);
						
end behavior;