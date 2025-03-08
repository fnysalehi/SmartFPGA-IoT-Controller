library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.types_pkg.all;

entity irrigation_core_tb is
end irrigation_core_tb;

architecture Behavioral of irrigation_core_tb is
    -- Component declaration
    component irrigation_core
        Port (
            clk             : in  std_logic;
            rst_n           : in  std_logic;
            temperature     : in  std_logic_vector(7 downto 0);
            moisture_level  : in  std_logic_vector(6 downto 0);
            current_time    : in  std_logic_vector(15 downto 0);
            control_cmd     : in  std_logic_vector(31 downto 0);
            watering_active : out std_logic;
            emergency_stop  : out std_logic;
            system_status   : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Test signals
    signal clk_tb          : std_logic := '0';
    signal rst_n_tb        : std_logic := '0';
    signal temp_tb         : std_logic_vector(7 downto 0) := (others => '0');
    signal moisture_tb     : std_logic_vector(6 downto 0) := (others => '0');
    signal time_tb         : std_logic_vector(15 downto 0) := (others => '0');
    signal cmd_tb          : std_logic_vector(31 downto 0) := (others => '0');
    signal watering_tb     : std_logic;
    signal emergency_tb    : std_logic;
    signal status_tb       : std_logic_vector(3 downto 0);

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: irrigation_core port map (
        clk             => clk_tb,
        rst_n           => rst_n_tb,
        temperature     => temp_tb,
        moisture_level  => moisture_tb,
        current_time    => time_tb,
        control_cmd     => cmd_tb,
        watering_active => watering_tb,
        emergency_stop  => emergency_tb,
        system_status   => status_tb
    );

    -- Clock process
    clk_process: process
    begin
        clk_tb <= '0';
        wait for CLK_PERIOD/2;
        clk_tb <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset initialization
        rst_n_tb <= '0';
        wait for CLK_PERIOD*2;
        rst_n_tb <= '1';
        wait for CLK_PERIOD*2;

        -- Test case 1: Normal operation (Morning)
        time_tb <= x"0800";  -- 8:00 AM
        temp_tb <= std_logic_vector(to_unsigned(36, 8));  -- 36°C
        moisture_tb <= std_logic_vector(to_unsigned(20, 7));  -- 20%
        cmd_tb <= x"FFFFFFFF";  -- System enabled
        wait for CLK_PERIOD*10;

        -- Test case 2: Emergency stop condition
        temp_tb <= "10000000";  -- Temperature sensor error
        wait for CLK_PERIOD*10;

        -- Test case 3: Night operation
        time_tb <= x"1400";  -- 20:00 PM
        temp_tb <= std_logic_vector(to_unsigned(25, 8));  -- 25°C
        moisture_tb <= std_logic_vector(to_unsigned(65, 7));  -- 65%
        wait for CLK_PERIOD*10;

        -- Test case 4: System disabled
        cmd_tb <= x"00000000";  -- System disabled
        wait for CLK_PERIOD*10;

        wait;
    end process;

end Behavioral;