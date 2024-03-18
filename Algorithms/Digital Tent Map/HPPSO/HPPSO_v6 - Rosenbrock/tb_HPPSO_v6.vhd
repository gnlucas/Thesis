-------------------------------------------------
-- Company:       GRACO-UnB
-- Engineer:      DANIEL MAURICIO MUÑOZ ARBOLEDA
--
-- Create Date:   06-Oct-2012
-- Design name:   HPPSO
-- Module name:   tb_HPPSO_v6
-- Description:   testbench
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_HPPSO_v6 is
end tb_HPPSO_v6;

architecture behavior of tb_HPPSO_v6 is

-- Component Declaration for the Unit Under Test (UUT)
component HPPSO_v6
	port (FSL_Rst : in  std_logic;
	      FSL_Clk : in  std_logic;
	      start   : in  std_logic;
	      ready   : out  std_logic);
end component;

-- Inputs
signal FSL_Rst : std_logic := '0';
signal FSL_Clk : std_logic := '0';
signal start   : std_logic := '0';

-- Outputs
signal ready : std_logic;

begin
-- Instantiate the Unit Under Test (UUT)
uut: HPPSO_v6
	port map (FSL_Rst => FSL_Rst,
		  FSL_Clk => FSL_Clk,
		  start   => start,
		  ready   => ready);

FSL_Clk <= not FSL_Clk after 5 ns;
FSL_Rst <= '0', '1' after 15 ns, '0' after 25 ns;
start   <= '0', '1' after 65 ns, '0' after 75 ns;

end;