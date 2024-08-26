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
    signal fast_clk : STD_LOGIC := '0';  -- Novo sinal para clock acelerado (não usado aqui)
    signal digit_select : INTEGER range 0 to 3 := 0;
    signal seg_val : STD_LOGIC_VECTOR(6 downto 0);

    constant clk_frequency : integer := 50_000_000;  -- Frequência do clock original
    constant ACCELERATION_FACTOR : integer := 1;     -- Fator de aceleração definido como 1 para tempo real

begin

    -- Divisor de Clock para gerar o clock acelerado (não usado aqui)
    process(clk)
    begin
        if rising_edge(clk) then
            if clk_div = (clk_frequency / ACCELERATION_FACTOR) - 1 then
                clk_div <= 0;
                fast_clk <= not fast_clk;
            else
                clk_div <= clk_div + 1;
            end if;
        end if;
    end process;

    -- Processo de Incremento de Tempo com Reset (usando o clock original)
    process(clk, reset)
    begin
        if reset = '1' then
            seconds <= 0;
            minutes <= 0;
            hours <= 0;
            digit_select <= 0;
        elsif rising_edge(clk) then
            -- Incremento de segundos, minutos, e horas
            if seconds = 59 then
                seconds <= 0;
                if minutes = 59 then
                    minutes <= 0;
                    if hours = 11 then
                        hours <= 0;
                    else
                        hours <= hours + 1;
                    end if;
                else
                    minutes <= minutes + 1;
                end if;
            else
                seconds <= seconds + 1;
            end if;

            -- Atualizar o dígito para exibir
            digit_select <= digit_select + 1;
            if digit_select = 4 then
                digit_select <= 0;
            end if;
        end if;
    end process;

    -- Controle dos Segmentos do Display
    process(digit_select, hours, minutes)
    begin
        case digit_select is
            when 0 =>  -- Primeiro dígito (dezena das horas)
                case hours/10 is
                    when 0 => seg_val <= "1111110";
                    when 1 => seg_val <= "0110000";
                    when others => seg_val <= "1111111";
                end case;
            when 1 =>  -- Segundo dígito (unidade das horas)
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
            when 2 =>  -- Terceiro dígito (dezena dos minutos)
                case minutes/10 is
                    when 0 => seg_val <= "1111110";
                    when 1 => seg_val <= "0110000";
                    when 2 => seg_val <= "1101101";
                    when 3 => seg_val <= "1111001";
                    when 4 => seg_val <= "0110011";
                    when 5 => seg_val <= "1011011";
                    when others => seg_val <= "1111111";
                end case;
            when 3 =>  -- Quarto dígito (unidade dos minutos)
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
