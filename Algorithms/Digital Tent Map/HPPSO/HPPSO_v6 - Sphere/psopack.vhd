-------------------------------------------------
-- Company:       GRACO-UnB
-- Engineer:      DANIEL MAURICIO MUÑOZ ARBOLEDA
--
-- Create Date:   06-Oct-2012
-- Design name:   HPPSO
-- Module name:   psopack
-- Description:   this package defines types, subtypes and constants
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.fpupack.all;

package psopack is

constant numIter : integer := 15000;

constant INITIAL_WEIGHT : std_logic_vector(FP_WIDTH-1 downto 0) := "001111110100110011001100110"; -- 0.8
constant INERTIA_SLOPE  : std_logic_vector(FP_WIDTH-1 downto 0) := "101110000100001110111011111"; -- -4.67e-5
constant INITIAL_VELOCI : std_logic_vector(FP_WIDTH-1 downto 0) := "001111111000000000000000000"; -- 1
constant MAX_VELOCI     : std_logic_vector(FP_WIDTH-1 downto 0) := "010000000100000000000000000"; -- 3

-- Run 1
constant init_p1  : std_logic_vector(7 downto 0) := "00111010";
constant init_p2  : std_logic_vector(7 downto 0) := "00110001";
constant init_p3  : std_logic_vector(7 downto 0) := "11011011";
constant init_p4  : std_logic_vector(7 downto 0) := "11010000";
constant init_p5  : std_logic_vector(7 downto 0) := "01101110";
constant init_p6  : std_logic_vector(7 downto 0) := "11101001";
constant init_p7  : std_logic_vector(7 downto 0) := "10111100";
constant init_p8  : std_logic_vector(7 downto 0) := "00101010";
constant init_p9  : std_logic_vector(7 downto 0) := "10110000";
constant init_p10 : std_logic_vector(7 downto 0) := "00101111";

-- Run 2
--constant init_p1  : std_logic_vector(7 downto 0) := "11000111";
--constant init_p2  : std_logic_vector(7 downto 0) := "01100100";
--constant init_p3  : std_logic_vector(7 downto 0) := "00111110";
--constant init_p4  : std_logic_vector(7 downto 0) := "01100111";
--constant init_p5  : std_logic_vector(7 downto 0) := "00011001";
--constant init_p6  : std_logic_vector(7 downto 0) := "00100010";
--constant init_p7  : std_logic_vector(7 downto 0) := "11110001";
--constant init_p8  : std_logic_vector(7 downto 0) := "11110100";
--constant init_p9  : std_logic_vector(7 downto 0) := "10010011";
--constant init_p10 : std_logic_vector(7 downto 0) := "00010000";

-- Run 3
--constant init_p1  : std_logic_vector(7 downto 0) := "00111100";
--constant init_p2  : std_logic_vector(7 downto 0) := "01011011";
--constant init_p3  : std_logic_vector(7 downto 0) := "11010010";
--constant init_p4  : std_logic_vector(7 downto 0) := "00000100";
--constant init_p5  : std_logic_vector(7 downto 0) := "00001011";
--constant init_p6  : std_logic_vector(7 downto 0) := "00101100";
--constant init_p7  : std_logic_vector(7 downto 0) := "10100110";
--constant init_p8  : std_logic_vector(7 downto 0) := "10111011";
--constant init_p9  : std_logic_vector(7 downto 0) := "10100110";
--constant init_p10 : std_logic_vector(7 downto 0) := "01110011";

-- Run 4
--constant init_p1  : std_logic_vector(7 downto 0) := "10001100";
--constant init_p2  : std_logic_vector(7 downto 0) := "01001100";
--constant init_p3  : std_logic_vector(7 downto 0) := "10111110";
--constant init_p4  : std_logic_vector(7 downto 0) := "00110001";
--constant init_p5  : std_logic_vector(7 downto 0) := "10110000";
--constant init_p6  : std_logic_vector(7 downto 0) := "00101111";
--constant init_p7  : std_logic_vector(7 downto 0) := "01011110";
--constant init_p8  : std_logic_vector(7 downto 0) := "10100000";
--constant init_p9  : std_logic_vector(7 downto 0) := "11000111";
--constant init_p10 : std_logic_vector(7 downto 0) := "00010101";

-- Run 5
--constant init_p1  : std_logic_vector(7 downto 0) := "11101101";
--constant init_p2  : std_logic_vector(7 downto 0) := "11000110";
--constant init_p3  : std_logic_vector(7 downto 0) := "01111101";
--constant init_p4  : std_logic_vector(7 downto 0) := "01110000";
--constant init_p5  : std_logic_vector(7 downto 0) := "01110010";
--constant init_p6  : std_logic_vector(7 downto 0) := "01001111";
--constant init_p7  : std_logic_vector(7 downto 0) := "10000010";
--constant init_p8  : std_logic_vector(7 downto 0) := "10000011";
--constant init_p9  : std_logic_vector(7 downto 0) := "11010001";
--constant init_p10 : std_logic_vector(7 downto 0) := "11001011";

-- Run 6
--constant init_p1  : std_logic_vector(7 downto 0) := "10100101";
--constant init_p2  : std_logic_vector(7 downto 0) := "01100001";
--constant init_p3  : std_logic_vector(7 downto 0) := "11001111";
--constant init_p4  : std_logic_vector(7 downto 0) := "10001000";
--constant init_p5  : std_logic_vector(7 downto 0) := "01011010";
--constant init_p6  : std_logic_vector(7 downto 0) := "11110000";
--constant init_p7  : std_logic_vector(7 downto 0) := "11100000";
--constant init_p8  : std_logic_vector(7 downto 0) := "10001101";
--constant init_p9  : std_logic_vector(7 downto 0) := "10011111";
--constant init_p10 : std_logic_vector(7 downto 0) := "10010110";

-- Run 7
--constant init_p1  : std_logic_vector(7 downto 0) := "00110101";
--constant init_p2  : std_logic_vector(7 downto 0) := "01001101";
--constant init_p3  : std_logic_vector(7 downto 0) := "01111001";
--constant init_p4  : std_logic_vector(7 downto 0) := "00111011";
--constant init_p5  : std_logic_vector(7 downto 0) := "11011000";
--constant init_p6  : std_logic_vector(7 downto 0) := "00110010";
--constant init_p7  : std_logic_vector(7 downto 0) := "00111010";
--constant init_p8  : std_logic_vector(7 downto 0) := "00101100";
--constant init_p9  : std_logic_vector(7 downto 0) := "00111011";
--constant init_p10 : std_logic_vector(7 downto 0) := "01110000";

-- Run 8
--constant init_p1  : std_logic_vector(7 downto 0) := "01010000";
--constant init_p2  : std_logic_vector(7 downto 0) := "11101100";
--constant init_p3  : std_logic_vector(7 downto 0) := "01101110";
--constant init_p4  : std_logic_vector(7 downto 0) := "00110000";
--constant init_p5  : std_logic_vector(7 downto 0) := "11100111";
--constant init_p6  : std_logic_vector(7 downto 0) := "11111010";
--constant init_p7  : std_logic_vector(7 downto 0) := "01110000";
--constant init_p8  : std_logic_vector(7 downto 0) := "00011101";
--constant init_p9  : std_logic_vector(7 downto 0) := "01000010";
--constant init_p10 : std_logic_vector(7 downto 0) := "01101001";

-- Run 9
--constant init_p1  : std_logic_vector(7 downto 0) := "10011000";
--constant init_p2  : std_logic_vector(7 downto 0) := "01000011";
--constant init_p3  : std_logic_vector(7 downto 0) := "10011010";
--constant init_p4  : std_logic_vector(7 downto 0) := "10110110";
--constant init_p5  : std_logic_vector(7 downto 0) := "00111001";
--constant init_p6  : std_logic_vector(7 downto 0) := "00011110";
--constant init_p7  : std_logic_vector(7 downto 0) := "01001100";
--constant init_p8  : std_logic_vector(7 downto 0) := "01010010";
--constant init_p9  : std_logic_vector(7 downto 0) := "01101101";
--constant init_p10 : std_logic_vector(7 downto 0) := "10000010";

-- Run 10
--constant init_p1  : std_logic_vector(7 downto 0) := "00010110";
--constant init_p2  : std_logic_vector(7 downto 0) := "01000011";
--constant init_p3  : std_logic_vector(7 downto 0) := "11001101";
--constant init_p4  : std_logic_vector(7 downto 0) := "00001000";
--constant init_p5  : std_logic_vector(7 downto 0) := "11101101";
--constant init_p6  : std_logic_vector(7 downto 0) := "10111011";
--constant init_p7  : std_logic_vector(7 downto 0) := "01111101";
--constant init_p8  : std_logic_vector(7 downto 0) := "10010100";
--constant init_p9  : std_logic_vector(7 downto 0) := "00111101";
--constant init_p10 : std_logic_vector(7 downto 0) := "01110110";

-- Run 11
--constant init_p1  : std_logic_vector(7 downto 0) := "11110110";
--constant init_p2  : std_logic_vector(7 downto 0) := "10001100";
--constant init_p3  : std_logic_vector(7 downto 0) := "10000101";
--constant init_p4  : std_logic_vector(7 downto 0) := "00111100";
--constant init_p5  : std_logic_vector(7 downto 0) := "01111101";
--constant init_p6  : std_logic_vector(7 downto 0) := "10100000";
--constant init_p7  : std_logic_vector(7 downto 0) := "10101110";
--constant init_p8  : std_logic_vector(7 downto 0) := "01100101";
--constant init_p9  : std_logic_vector(7 downto 0) := "01011110";
--constant init_p10 : std_logic_vector(7 downto 0) := "11111100";

-- Run 12
--constant init_p1  : std_logic_vector(7 downto 0) := "00001010";
--constant init_p2  : std_logic_vector(7 downto 0) := "11100010";
--constant init_p3  : std_logic_vector(7 downto 0) := "11101001";
--constant init_p4  : std_logic_vector(7 downto 0) := "11001100";
--constant init_p5  : std_logic_vector(7 downto 0) := "00011010";
--constant init_p6  : std_logic_vector(7 downto 0) := "01000011";
--constant init_p7  : std_logic_vector(7 downto 0) := "01010110";
--constant init_p8  : std_logic_vector(7 downto 0) := "10101110";
--constant init_p9  : std_logic_vector(7 downto 0) := "00100011";
--constant init_p10 : std_logic_vector(7 downto 0) := "10111000";

-- Run 13
--constant init_p1  : std_logic_vector(7 downto 0) := "00011100";
--constant init_p2  : std_logic_vector(7 downto 0) := "10100111";
--constant init_p3  : std_logic_vector(7 downto 0) := "01111111";
--constant init_p4  : std_logic_vector(7 downto 0) := "11000111";
--constant init_p5  : std_logic_vector(7 downto 0) := "10110111";
--constant init_p6  : std_logic_vector(7 downto 0) := "11100111";
--constant init_p7  : std_logic_vector(7 downto 0) := "11100100";
--constant init_p8  : std_logic_vector(7 downto 0) := "01010110";
--constant init_p9  : std_logic_vector(7 downto 0) := "10110011";
--constant init_p10 : std_logic_vector(7 downto 0) := "00110011";

-- Run 14
--constant init_p1  : std_logic_vector(7 downto 0) := "00001000";
--constant init_p2  : std_logic_vector(7 downto 0) := "10111110";
--constant init_p3  : std_logic_vector(7 downto 0) := "10000000";
--constant init_p4  : std_logic_vector(7 downto 0) := "01111011";
--constant init_p5  : std_logic_vector(7 downto 0) := "11100111";
--constant init_p6  : std_logic_vector(7 downto 0) := "10011100";
--constant init_p7  : std_logic_vector(7 downto 0) := "10011110";
--constant init_p8  : std_logic_vector(7 downto 0) := "11011100";
--constant init_p9  : std_logic_vector(7 downto 0) := "11001110";
--constant init_p10 : std_logic_vector(7 downto 0) := "10010100";

-- Run 15
--constant init_p1  : std_logic_vector(7 downto 0) := "00101111";
--constant init_p2  : std_logic_vector(7 downto 0) := "00111110";
--constant init_p3  : std_logic_vector(7 downto 0) := "11100011";
--constant init_p4  : std_logic_vector(7 downto 0) := "00001000";
--constant init_p5  : std_logic_vector(7 downto 0) := "01111101";
--constant init_p6  : std_logic_vector(7 downto 0) := "00101011";
--constant init_p7  : std_logic_vector(7 downto 0) := "11111010";
--constant init_p8  : std_logic_vector(7 downto 0) := "10110110";
--constant init_p9  : std_logic_vector(7 downto 0) := "10000000";
--constant init_p10 : std_logic_vector(7 downto 0) := "01111001";

-- Run 16
--constant init_p1  : std_logic_vector(7 downto 0) := "00010000";
--constant init_p2  : std_logic_vector(7 downto 0) := "10101110";
--constant init_p3  : std_logic_vector(7 downto 0) := "00001011";
--constant init_p4  : std_logic_vector(7 downto 0) := "00010011";
--constant init_p5  : std_logic_vector(7 downto 0) := "10000110";
--constant init_p6  : std_logic_vector(7 downto 0) := "00011001";
--constant init_p7  : std_logic_vector(7 downto 0) := "11010001";
--constant init_p8  : std_logic_vector(7 downto 0) := "11010001";
--constant init_p9  : std_logic_vector(7 downto 0) := "10111001";
--constant init_p10 : std_logic_vector(7 downto 0) := "00100111";

end psopack;
