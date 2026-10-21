library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    generic (
        DATA_WIDTH : integer := 4; 
        ADDR_WIDTH : integer := 4  
    );
    port (
        clk     : in  STD_LOGIC;
        wr_en   : in  STD_LOGIC;
        w_addr  : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        r_addr  : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        w_data  : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        r_data  : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
    );
end register_file;

architecture rtl of register_file is
    type mem_2d_type is array (0 to (2**ADDR_WIDTH)-1) of STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal array_reg : mem_2d_type;
begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            if wr_en = '1' then
                array_reg(to_integer(unsigned(w_addr))) <= w_data;
            end if;
        end if;
    end process;

    
    r_data <= array_reg(to_integer(unsigned(r_addr)));
end rtl;