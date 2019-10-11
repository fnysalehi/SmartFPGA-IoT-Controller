library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
 Port (clk,rst : in std_logic;
 insert_command : in std_logic_vector(31 downto 0);
 ready : in std_logic;
 plateNo : in std_logic_vector(16 downto 0);
 light : out std_logic_vector(5 downto 0) );
end main;

architecture Behavioral of main is

signal finish :std_logic;
signal pltNo,locNo :integer;

component serialadd is
  Port ( clk, rst : in std_logic;
  insert_command : in std_logic_vector(31 downto 0 );
  finish : out std_logic;
  pltNo : out integer;
  locNo : out integer);
end component serialadd;

component search is
  Port (  sPltNo :  in integer;
  sLocNo : in integer;
    iPltNo : in std_logic_vector(16 downto 0);
  clk,ready,finish : in std_logic;
  light : out std_logic_vector(5 downto 0));
end component search;

begin
search_inst : search port map(pltNo,locNo,plateNo,clk,ready,finish,light);
serialadd_inst : serialadd port map( clk, rst,insert_command,finish,pltNo,locNo); 
end Behavioral;

