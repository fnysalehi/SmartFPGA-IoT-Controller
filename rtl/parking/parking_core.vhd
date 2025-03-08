library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.types_pkg.all;

entity parking_core is
    Port (
        -- System signals
        clk         : in  std_logic;
        rst_n       : in  std_logic;
        
        -- Command interface
        cmd_valid   : in  std_logic;
        cmd_data    : in  std_logic_vector(31 downto 0);
        cmd_ready   : out std_logic;
        
        -- Status outputs
        zone_status : out std_logic_vector(3 downto 0);
        space_count : out std_logic_vector(7 downto 0);
        
        -- LED control
        led_output  : out std_logic_vector(5 downto 0)
    );
end parking_core;

architecture rtl of parking_core is
    signal finish      : std_logic;
    signal plate_num   : integer;
    signal location_num: integer;
    
begin
    -- Instantiate serial command processor
    serial_inst: entity work.serialadd
        port map (
            clk           => clk,
            rst          => rst_n,
            insert_command=> cmd_data,
            finish       => finish,
            pltNo        => plate_num,
            locNo        => location_num
        );

    -- Instantiate search module
    search_inst: entity work.search
        port map (
            sPltNo       => plate_num,
            sLocNo       => location_num,
            iPltNo       => cmd_data(16 downto 0),
            clk          => clk,
            ready        => cmd_valid,
            finish       => finish,
            light        => led_output
        );

    -- Command ready signal
    cmd_ready <= not finish;

    -- Zone status based on occupied spaces
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            zone_status <= (others => '0');
            space_count <= (others => '0');
        elsif rising_edge(clk) then
            -- Update zone status and space count logic here
            -- This will be based on the search module's internal state
        end if;
    end process;

end rtl;
