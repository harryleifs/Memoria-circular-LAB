library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex7seg is
    port (
        hex     : in  STD_LOGIC_VECTOR(3 downto 0);
        display : out STD_LOGIC_VECTOR(6 downto 0)
    );
end hex7seg;

architecture Behavioral of hex7seg is
begin
    
    process(hex)
    begin
        case hex is
            when "0000" => display <= "1000000"; -- 0
            when "0001" => display <= "1111001"; -- 1
            when "0010" => display <= "0100100"; -- 2
            when "0011" => display <= "0110000"; -- 3
            when "0100" => display <= "1001001"; -- 4
            when "0101" => display <= "0100100"; -- 5
            when "0110" => display <= "0000010"; -- 6
            when "0111" => display <= "1111000"; -- 7
            when "1000" => display <= "0000000"; -- 8
            when "1001" => display <= "0010000"; -- 9
            when "1010" => display <= "0001000"; -- A
            when "1011" => display <= "0000011"; -- b
            when "1100" => display <= "1000110"; -- C
            when "1101" => display <= "0100001"; -- d
            when "1110" => display <= "0000110"; -- E
            when "1111" => display <= "0001110"; -- F
            when others => display <= "1111111";
        end case;
    end process;
end Behavioral;