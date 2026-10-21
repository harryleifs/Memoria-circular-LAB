library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncer is
    port (
        clk     : in  STD_LOGIC;
        btn_in  : in  STD_LOGIC;
        pulse   : out STD_LOGIC
    );
end debouncer;

architecture Behavioral of debouncer is
    signal btn_sync : STD_LOGIC_VECTOR(1 downto 0) := "11";
    signal count    : unsigned(18 downto 0) := (others => '0');
    signal btn_state: STD_LOGIC := '1';
    signal btn_prev : STD_LOGIC := '1';
begin
    process(clk)
    begin
        if rising_edge(clk) then
          
            btn_sync <= btn_sync(0) & btn_in;
            
           
            if btn_sync(1) /= btn_state then
                count <= count + 1;
                if count = 500000 then 
                    btn_state <= btn_sync(1);
                    count <= (others => '0');
                end if;
            else
                count <= (others => '0');
            end if;

            btn_prev <= btn_state;
            pulse <= (not btn_state) and btn_prev;
        end if;
            
    end process;
end Behavioral;