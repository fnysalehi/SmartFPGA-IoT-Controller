library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity serialadd is
    Port ( 
        clk           : in  std_logic;
        rst          : in  std_logic;
        insert_command: in  std_logic_vector(31 downto 0);
        finish       : out std_logic;
        pltNo        : out integer;
        locNo        : out integer
    );
end serialadd;

architecture Behavioral of serialadd is
    type state_type is (waitt, read_loc, read_plt, fin);
    signal state     : state_type;
    type plt_state   is array (4 downto 0) of integer;
    signal plt       : plt_state;
    type lct_state   is array (1 downto 0) of integer;
    signal loc       : lct_state := (others => 0);
    signal flag_old  : std_logic := '1';
    signal input_com : std_logic_vector(7 downto 0);

begin
    input_com <= insert_command(8 downto 1);
    
    process(clk)
        variable counter_plt, counter_loc, loc_val, plt_val : integer := 0;
    begin
        if rst = '0' then
            counter_plt := 0;
            counter_loc := 0;
            plt_val := 0;
            loc_val := 0;
            state <= waitt;
        elsif rising_edge(clk) then
            case state is
                when waitt =>
                    finish <= '0';
                    if flag_old = not insert_command(0) then
                        state <= read_loc;
                        flag_old <= not flag_old;
                    end if;

                when read_loc =>
                    case input_com is
                        when "00101010" => -- '*'
                            state <= read_plt;
                        when "00110000" to "00111001" => -- '0' to '9'
                            state <= read_loc;
                            loc(counter_loc) <= to_integer(unsigned(input_com)) - 48;
                            counter_loc := counter_loc + 1;
                        when others =>
                            state <= read_plt;
                    end case;

                when read_plt =>
                    case input_com is
                        when "00100011" => -- '#'
                            state <= fin;
                            -- Calculate final values
                            for i in 4 downto 0 loop
                                plt_val := (plt_val * 10) + plt(i);
                            end loop;
                            for j in 1 downto 0 loop
                                loc_val := (loc_val * 10) + loc(j);
                            end loop;
                        when "00110000" to "00111001" => -- '0' to '9'
                            state <= read_plt;
                            plt(counter_plt) <= to_integer(unsigned(input_com)) - 48;
                            counter_plt := counter_plt + 1;
                        when others =>
                            state <= read_plt;
                    end case;

                when fin =>
                    finish <= '1';
                    pltNo <= plt_val;
                    locNo <= loc_val;
                    state <= waitt;
            end case;
        end if;
    end process;
end Behavioral;