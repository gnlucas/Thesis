-------------------------------------------------
-- Company:       GRACO-UnB
-- Engineer:      DANIEL MAURICIO MU�OZ ARBOLEDA
--
-- Create Date:   06-Oct-2012 
-- Design name:   HPPSO
-- Module name:   entities
-- Description:   package defining IO of the components
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.fpupack.all;

package entities is

component tent_map_prng is
	port (reset    :  in std_logic;
	      clk      :  in std_logic;
	      start    :  in std_logic;
	      init     :  in std_logic_vector(7 downto 0);
	      tent_out : out std_logic_vector(FP_WIDTH-1 downto 0);
	      ready    : out std_logic);
end component;

component addsubfsm_v6 is
	port (reset      :  in std_logic;
	      clk        :  in std_logic;
	      op         :  in std_logic;
	      op_a    	 :  in std_logic_vector(FP_WIDTH-1 downto 0);
	      op_b    	 :  in std_logic_vector(FP_WIDTH-1 downto 0);
	      start_i	 :  in std_logic;
	      addsub_out : out std_logic_vector(FP_WIDTH-1 downto 0);
	      ready_as   : out std_logic);
end component;

component multiplierfsm_v2 is
	port (reset     :  in std_logic;
	      clk       :  in std_logic;
	      op_a    	:  in std_logic_vector(FP_WIDTH-1 downto 0);
	      op_b    	:  in std_logic_vector(FP_WIDTH-1 downto 0);
	      start_i	:  in std_logic;
	      mul_out   : out std_logic_vector(FP_WIDTH-1 downto 0);
	      ready_mul : out std_logic);
end component;

component particle_ula_v2_sphere is
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
end component;

component particle_ula_v2_rosenbrock is
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
end component;

component inertia is
	port (reset         :  in std_logic;
	      clk           :  in std_logic;
	      start         :  in std_logic;
	      INERTIA_SLOPE :  in std_logic_vector(FP_WIDTH-1 downto 0);
	      new_weight    : out std_logic_vector(FP_WIDTH-1 downto 0);
              ready_inerti  : out std_logic);
end component;

component compare_social is
	port (reset       :  in std_logic;
	      clk         :  in std_logic;
	      start_cmpsc :  in std_logic;
	      f_y_p1      :  in std_logic_vector(FP_WIDTH-1 downto 0);
	      f_y_p2      :  in std_logic_vector(FP_WIDTH-1 downto 0);
	      f_y_p3      :  in std_logic_vector(FP_WIDTH-1 downto 0);
	      f_y_p4      :  in std_logic_vector(FP_WIDTH-1 downto 0);
	      f_y_p5      :  in std_logic_vector(FP_WIDTH-1 downto 0);
	      f_y_p6      :  in std_logic_vector(FP_WIDTH-1 downto 0);
	      f_y_p7      :  in std_logic_vector(FP_WIDTH-1 downto 0);
	      f_y_p8      :  in std_logic_vector(FP_WIDTH-1 downto 0);
	      f_y_p9      :  in std_logic_vector(FP_WIDTH-1 downto 0);
	      f_y_p10     :  in std_logic_vector(FP_WIDTH-1 downto 0);
	      y_pj        : out std_logic_vector(3 downto 0);
	      cmpsc_out   : out std_logic_vector(FP_WIDTH-1 downto 0);
	      ready_cmpsc : out std_logic);
end component;

end entities;