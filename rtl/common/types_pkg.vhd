library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package types_pkg is
    -- Parking system types
    type parking_zone_t is (ZONE_A, ZONE_B, ZONE_C, ZONE_D);
    type vehicle_array_t is array (0 to 99) of integer;
    
    -- Irrigation system types
    type moisture_level_t is range 0 to 100;
    type temperature_range_t is range -50 to 100;
    
    -- Common system constants
    constant MAX_PARKING_SPACES : integer := 100;
    constant TEMP_THRESHOLD_HIGH : integer := 35;  -- 35°C
    constant TEMP_THRESHOLD_LOW : integer := 15;   -- 15°C
    constant MOISTURE_THRESHOLD : integer := 30;   -- 30%
end package types_pkg;