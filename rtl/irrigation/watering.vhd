library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity watering is
    Port (
        clk                 : in  std_logic;
        rst                : in  std_logic;
        temperature         : in  std_logic_vector(7 downto 0);   -- Temperature input
        time_in            : in  std_logic_vector(15 downto 0);  -- Time in HH:MM format
        data               : in  std_logic_vector(6 downto 0);   -- Moisture data
        insert_command_water: in  std_logic_vector(31 downto 0); -- Control command
        status             : out std_logic                       -- 1: ON, 0: OFF
    );
end watering;

architecture Behavioral of watering is
    signal status_save : std_logic;
begin
    process(clk, rst)
    begin
        if rst = '0' then
            status_save <= '0';
        elsif rising_edge(clk) then
            if insert_command_water = x"00000000" then
                status_save <= '0';
            elsif insert_command_water = x"FFFFFFFF" then
                -- Time-based watering control
                case time_in(15 downto 8) is
                    -- Morning period (6:00-12:00)
                    when x"06" to x"0C" =>
                        if (time_in(15 downto 8) > x"06" or 
                            (time_in(15 downto 8) = x"06" and time_in(7 downto 0) >= x"01")) then
                            -- Temperature > 35°C (x"23") and moisture <= 25% (x"19")
                            if unsigned(temperature) > 35 and unsigned(data) <= 25 then
                                status_save <= '1';
                            elsif temperature(7) = '1' then  -- Temperature sensor error
                                status_save <= '1';
                            else
                                status_save <= '0';
                            end if;
                        end if;

                    -- Afternoon period (12:00-16:00)
                    when x"0C" to x"10" =>
                        if (time_in(15 downto 8) > x"0C" or 
                            (time_in(15 downto 8) = x"0C" and time_in(7 downto 0) >= x"01")) then
                            -- Temperature > 50°C (x"32") and moisture <= 20% (x"14")
                            if unsigned(temperature) > 50 and unsigned(data) <= 20 then
                                status_save <= '1';
                            elsif temperature(7) = '1' then
                                status_save <= '1';
                            else
                                status_save <= '0';
                            end if;
                        end if;

                    -- Evening period (16:00-19:00)
                    when x"10" to x"13" =>
                        if (time_in(15 downto 8) > x"10" or 
                            (time_in(15 downto 8) = x"10" and time_in(7 downto 0) >= x"01")) then
                            -- Temperature < 30°C (x"1E") and moisture <= 35% (x"23")
                            if unsigned(temperature) < 30 and unsigned(data) <= 35 then
                                status_save <= '1';
                            elsif temperature(7) = '1' then
                                status_save <= '1';
                            else
                                status_save <= '0';
                            end if;
                        end if;

                    -- Night period (19:00-6:00)
                    when others =>
                        -- Only moisture-based control at night
                        if unsigned(data) <= 70 then  -- moisture <= 70% (x"46")
                            status_save <= '1';
                        elsif temperature(7) = '1' then
                            status_save <= '1';
                        else
                            status_save <= '0';
                        end if;
                end case;
            end if;
        end if;
    end process;

    -- Output assignment
    status <= status_save;

end Behavioral;