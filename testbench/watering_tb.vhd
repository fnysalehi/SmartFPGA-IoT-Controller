library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity watering_tb is
end watering_tb;

architecture Behavioral of watering_tb is
    -- Component declaration
    component watering
        Port (
            clk                 : in  std_logic;
            rst                : in  std_logic;
            temperature         : in  std_logic_vector(7 downto 0);
            time_in            : in  std_logic_vector(15 downto 0);
            data               : in  std_logic_vector(6 downto 0);
            insert_command_water: in  std_logic_vector(31 downto 0);
            status             : out std_logic
        );
    end component;

    -- Test signals
    signal clk_tb      : std_logic := '0';
    signal rst_tb      : std_logic := '0';
    signal temp_tb     : std_logic_vector(7 downto 0) := (others => '0');
    signal time_tb     : std_logic_vector(15 downto 0) := (others => '0');
    signal data_tb     : std_logic_vector(6 downto 0) := (others => '0');
    signal cmd_tb      : std_logic_vector(31 downto 0) := (others => '0');
    signal status_tb   : std_logic;

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: watering port map (
        clk                 => clk_tb,
        rst                => rst_tb,
        temperature         => temp_tb,
        time_in            => time_tb,
        data               => data_tb,
        insert_command_water=> cmd_tb,
        status             => status_tb
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
        rst_tb <= '0';
        wait for CLK_PERIOD*2;
        rst_tb <= '1';
        wait for CLK_PERIOD*2;

        -- Enable system
        cmd_tb <= x"FFFFFFFF";
        wait for CLK_PERIOD*2;

        -- Test case 1: Morning watering (6:00-12:00)
        time_tb <= x"0700";  -- 7:00 AM
        temp_tb <= std_logic_vector(to_unsigned(40, 8));  -- 40°C
        data_tb <= std_logic_vector(to_unsigned(20, 7));  -- 20% moisture
        wait for CLK_PERIOD*10;

        -- Test case 2: Afternoon watering (12:00-16:00)
        time_tb <= x"0E00";  -- 14:00 PM
        temp_tb <= std_logic_vector(to_unsigned(55, 8));  -- 55°C
        data_tb <= std_logic_vector(to_unsigned(15, 7));  -- 15% moisture
        wait for CLK_PERIOD*10;

        -- Test case 3: Evening watering (16:00-19:00)
        time_tb <= x"1100";  -- 17:00 PM
        temp_tb <= std_logic_vector(to_unsigned(25, 8));  -- 25°C
        data_tb <= std_logic_vector(to_unsigned(30, 7));  -- 30% moisture
        wait for CLK_PERIOD*10;

        -- Test case 4: Night watering (19:00-6:00)
        time_tb <= x"1500";  -- 21:00 PM
        temp_tb <= std_logic_vector(to_unsigned(20, 8));  -- 20°C
        data_tb <= std_logic_vector(to_unsigned(65, 7));  -- 65% moisture
        wait for CLK_PERIOD*10;

        -- Test case 5: System disable
        cmd_tb <= x"00000000";
        wait for CLK_PERIOD*10;

        -- Test case 6: Temperature sensor error
        cmd_tb <= x"FFFFFFFF";
        temp_tb <= "10000000";  -- Temperature sensor error bit set
        wait for CLK_PERIOD*10;

        wait;
    end process;

end Behavioral;