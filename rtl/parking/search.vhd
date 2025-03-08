library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package input_type is
    type TYPE_IN is array (0 to 99) of integer;
end input_type;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.input_type.all;
use IEEE.NUMERIC_STD.ALL;

entity search is
    Port (
        sPltNo   : in  integer;
        sLocNo   : in  integer;
        iPltNo   : in  std_logic_vector(16 downto 0);
        clk      : in  std_logic;
        ready    : in  std_logic;
        finish   : in  std_logic;
        light    : out std_logic_vector(5 downto 0)
    );
end search;

architecture Behavioral of search is
    type state_type is (waitt, search, sort, error, add, addfinal, done);
    signal state    : state_type;
    signal locArray : TYPE_IN := (others => 100000);
    signal pltArray : TYPE_IN := (others => 100000);
    signal iPltNo_2 : integer;

begin
    iPltNo_2 <= to_integer(unsigned(iPltNo));

    process(clk)
        variable counter_add : integer := 0;
        variable mid : integer := 1;
        variable low : integer := 0;
        variable up  : integer := 2;
        variable j   : integer;
    begin
        if rising_edge(clk) then
            case state is
                when waitt =>
                    if ready = '1' then
                        state <= search;
                        mid := 49;
                        low := 0;
                        up := 99;
                    elsif finish = '1' then
                        state <= sort;
                        counter_add := 0;
                        j := 98;
                    else
                        state <= error;
                    end if;

                when search =>
                    if iPltNo_2 = pltArray(mid) then
                        state <= done;
                    elsif iPltNo_2 > pltArray(mid) then
                        low := mid + 1;
                        mid := (up + low)/2;
                        state <= search;
                    else
                        up := mid - 1;
                        mid := (up + low)/2;
                        state <= search;
                    end if;

                when done =>
                    case locArray(mid) is
                        when 0 to 24    => light <= "101000";
                        when 25 to 49   => light <= "011000";
                        when 50 to 74   => light <= "001101";
                        when 75 to 99   => light <= "001011";
                        when others     => light <= "000000";
                    end case;
                    pltArray(mid) <= 100000;
                    state <= waitt;

                when sort =>
                    if pltArray(counter_add) > sPltNo then
                        state <= add;
                    elsif counter_add >= 100 then
                        state <= error;
                    else
                        counter_add := counter_add + 1;
                    end if;

                when error =>
                    light <= "000000";
                    state <= waitt;

                when add =>
                    if j >= counter_add then
                        pltArray(j+1) <= pltArray(j);
                        locArray(j+1) <= locArray(j);
                        j := j-1;
                        state <= add;
                    elsif j <= 0 then
                        state <= error;
                    else
                        state <= addfinal;
                    end if;

                when addfinal =>
                    pltArray(counter_add) <= sPltNo;
                    locArray(counter_add) <= sLocNo;
                    case sLocNo is
                        when 0 to 24    => light <= "101000";
                        when 25 to 49   => light <= "011000";
                        when 50 to 74   => light <= "001101";
                        when 75 to 99   => light <= "001011";
                        when others     => light <= "000000";
                    end case;
                    state <= waitt;
            end case;
        end if;
    end process;
end Behavioral;