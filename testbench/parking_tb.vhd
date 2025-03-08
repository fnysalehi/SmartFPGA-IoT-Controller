library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity parking_tb is
end parking_tb;

architecture Behavioral of parking_tb is
    -- Component declarations
    component main
        Port (
            clk, rst : in std_logic;
            insert_command : in std_logic_vector(31 downto 0);
            ready : in std_logic;
            plateNo : in std_logic_vector(16 downto 0);
            light : out std_logic_vector(5 downto 0)
        );
    end component;

    -- Test signals
    signal clk_tb : std_logic := '0';
    signal rst_tb : std_logic := '0';
    signal insert_command_tb : std_logic_vector(31 downto 0) := (others => '0');
    signal ready_tb : std_logic := '0';
    signal plateNo_tb : std_logic_vector(16 downto 0) := (others => '0');
    signal light_tb : std_logic_vector(5 downto 0);

    -- Clock period definitions
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: main port map (
        clk => clk_tb,
        rst => rst_tb,
        insert_command => insert_command_tb,
        ready => ready_tb,
        plateNo => plateNo_tb,
        light => light_tb
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

        -- Test case 1: Add vehicle to parking spot
        insert_command_tb <= x"32352A31323334352300"; -- "25*12345#"
        wait for CLK_PERIOD*10;

        -- Test case 2: Search for vehicle
        ready_tb <= '1';
        plateNo_tb <= std_logic_vector(to_unsigned(12345, 17));
        wait for CLK_PERIOD*5;
        ready_tb <= '0';

        -- Add more test cases here

        wait;
    end process;

end Behavioral;