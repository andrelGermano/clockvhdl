library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Clock7Segment is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           digit : out STD_LOGIC_VECTOR (3 downto 0));
end Clock7Segment;

architecture Behavioral of Clock7Segment is

    signal seconds : INTEGER range 0 to 59 := 0;
    signal minutes : INTEGER range 0 to 59 := 0;
    signal hours : INTEGER range 0 to 11 := 0;
    signal clk_div : INTEGER := 0;
    
    signal digit_select : INTEGER range 0 to 3 := 0;
    signal seg_val : STD_LOGIC_VECTOR(6 downto 0);

begin

    process(clk, reset)
    begin
        if reset = '1' then
            seconds <= 0;
            minutes <= 0;
            hours <= 0;
            clk_div <= 0;
            digit_select <= 0;
        elsif rising_edge(clk) then
            clk_div <= clk_div + 1;
            if clk_div = 50000000 then  -- Assuming a 50MHz clock for 1Hz tick
                clk_div <= 0;
                seconds <= seconds + 1;
                if seconds = 60 then
                    seconds <= 0;
                    minutes <= minutes + 1;
                    if minutes = 60 then
                        minutes <= 0;
                        hours <= hours + 1;
                        if hours = 12 then
                            hours <= 0;
                        end if;
                    end if;
                end if;
            end if;

            digit_select <= digit_select + 1;
            if digit_select = 4 then
                digit_select <= 0;
            end if;
        end if;
    end process;

    process(digit_select, hours, minutes)
    begin
        case digit_select is
            when 0 =>  -- First digit (hour tens)
                case hours/10 is
                    when 0 => seg_val <= "1111110";
                    when 1 => seg_val <= "0110000";
                    when others => seg_val <= "1111111";
                end case;
            when 1 =>  -- Second digit (hour units)
                case hours mod 10 is
                    when 0 => seg_val <= "1111110";
                    when 1 => seg_val <= "0110000";
                    when 2 => seg_val <= "1101101";
                    when 3 => seg_val <= "1111001";
                    when 4 => seg_val <= "0110011";
                    when 5 => seg_val <= "1011011";
                    when 6 => seg_val <= "1011111";
                    when 7 => seg_val <= "1110000";
                    when 8 => seg_val <= "1111111";
                    when 9 => seg_val <= "1111011";
                    when others => seg_val <= "1111111";
                end case;
            when 2 =>  -- Third digit (minute tens)
                case minutes/10 is
                    when 0 => seg_val <= "1111110";
                    when 1 => seg_val <= "0110000";
                    when 2 => seg_val <= "1101101";
                    when 3 => seg_val <= "1111001";
                    when 4 => seg_val <= "0110011";
                    when 5 => seg_val <= "1011011";
                    when others => seg_val <= "1111111";
                end case;
            when 3 =>  -- Fourth digit (minute units)
                case minutes mod 10 is
                    when 0 => seg_val <= "1111110";
                    when 1 => seg_val <= "0110000";
                    when 2 => seg_val <= "1101101";
                    when 3 => seg_val <= "1111001";
                    when 4 => seg_val <= "0110011";
                    when 5 => seg_val <= "1011011";
                    when 6 => seg_val <= "1011111";
                    when 7 => seg_val <= "1110000";
                    when 8 => seg_val <= "1111111";
                    when 9 => seg_val <= "1111011";
                    when others => seg_val <= "1111111";
                end case;
            when others => 
                seg_val <= "1111111";
        end case;
        
        digit <= "1111" when digit_select = 0 else
                 "1110" when digit_select = 1 else
                 "1101" when digit_select = 2 else
                 "1100";
        seg <= seg_val;
    end process;

end Behavioral;
