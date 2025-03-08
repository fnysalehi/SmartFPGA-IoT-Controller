library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.types_pkg.all;

entity irrigation_core is
    Port (
        -- System signals
        clk             : in  std_logic;
        rst_n           : in  std_logic;
        
        -- Sensor inputs
        temperature     : in  std_logic_vector(7 downto 0);  -- Temperature sensor input
        moisture_level  : in  std_logic_vector(6 downto 0);  -- Moisture sensor input
        current_time    : in  std_logic_vector(15 downto 0); -- Time in HH:MM format
        
        -- Control interface
        control_cmd     : in  std_logic_vector(31 downto 0); -- Control commands
        
        -- Status outputs
        watering_active : out std_logic;                     -- Irrigation status
        emergency_stop  : out std_logic;                     -- Emergency shutdown status
        system_status   : out std_logic_vector(3 downto 0)   -- General system status
    );
end irrigation_core;

architecture rtl of irrigation_core is
    -- Internal signals
    signal water_enable    : std_logic;
    signal system_enabled  : std_logic;
    signal temp_threshold  : std_logic;
    signal moisture_ok     : std_logic;
    signal time_window_ok  : std_logic;
    
begin
    -- Instantiate water control system
    water_ctrl: entity work.watering
        port map (
            clk                => clk,
            rst               => rst_n,
            temperature        => temperature,
            time_in           => current_time,
            data             => moisture_level,
            insert_command_water => control_cmd,
            status           => water_enable
        );

    -- Time window check process
    process(current_time)
        variable hours : integer;
    begin
        hours := to_integer(unsigned(current_time(15 downto 8)));
        -- Enable during 6:00-19:00
        if (hours >= 6 and hours < 19) then
            time_window_ok <= '1';
        else
            time_window_ok <= '0';
        end if;
    end process;

    -- Emergency stop conditions
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            emergency_stop <= '0';
            system_status <= "0000";
        elsif rising_edge(clk) then
            -- Check for emergency conditions
            if temperature(7) = '1' or  -- Temperature error bit
               unsigned(moisture_level) > 100 or  -- Invalid moisture reading
               control_cmd = x"FFFFFFFF" then     -- Emergency stop command
                emergency_stop <= '1';
                system_status <= "1111";  -- Error state
            else
                emergency_stop <= '0';
                system_status <= "0001" when water_enable = '1' else "0000";
            end if;
        end if;
    end process;

    -- Final watering status
    watering_active <= water_enable and not emergency_stop and system_enabled;

    -- System enable logic
    system_enabled <= '1' when control_cmd /= x"00000000" else '0';

end rtl;