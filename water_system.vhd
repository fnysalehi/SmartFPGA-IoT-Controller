
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity watering is
 Port (clk,rst : in std_logic;
 temprature : in std_logic_vector(7 downto 0);
 time_in : in std_logic_vector(15 downto 0);
 data : in std_logic_vector(6 downto 0) ;
 insert_command_water : in std_logic_vector(31 downto 0);
 status : out std_logic--1:on ||--0:off
  );
end watering;

architecture Behavioral of watering is 
signal status_save : std_logic;
 begin
 process(clk,rst)
 begin
 if(rst = '0' ) then
  status_save <= '0';
 elsif(rising_edge(clk)) then
    if(insert_command_water = "00000000000000000000000000000000")then--
        status_save <= '0';
    elsif(insert_command_water = "11111111111111111111111111111111") then
        if((time_in(15 downto 8)>"000110" and time_in(15 downto 8)<="001100") or
        (time_in(15 downto 8)="000110" and time_in(7 downto 0)>="000001"))then      --12 to 6  
            
            if(temprature > "00100011" and data <= "0011001") then
                  status_save <= '1';                  
            elsif(temprature(7) ='1') then
                status_save <= '1';
            else
                status_save <= '0';
        end if;
    elsif((time_in(15 downto 8)<="010000" and time_in(15 downto 8)>"001100") or(time_in(15 downto 8)="001100" and time_in(7 downto 0)>="000001") )then--12-16 
        if(temprature > "00110010" and data <= "0010100") then
            status_save <= '1';
        elsif(temprature(7) ='1') then
            status_save <= '1';
        else
            status_save <= '0';
        end if; 
    elsif((time_in(15 downto 8)<="010011" and time_in(15 downto 8)>"010000") or(time_in(15 downto 8)="010000" and time_in(7 downto 0)>="000001")) then--16 19
        if(temprature <"00011110" and data <= "0100011") then
            status_save <='1';
        elsif(temprature(7) ='1') then
            status_save <= '1';
        else
            status_save <='0';
        end if;
    elsif((time_in(15 downto 8)<="010111" and time_in(15 downto 8)>"010011") or(time_in(15 downto 8)="010011"
     and time_in(7 downto 0)>="000001")--19 6
    or(time_in(15 downto 8)<="000110" and time_in(15 downto 8)>="000000") ) then
        if( data<="1000110") then
            status_save <= '1';
        elsif(temprature(7) ='1') then
             status_save <= '1';
         else
            status_save <= '0';
         end if;
    else
       status <= status_save; 
    end if;
   end if;
  end if;
   status <= status_save;
  end process;
end behavioral;