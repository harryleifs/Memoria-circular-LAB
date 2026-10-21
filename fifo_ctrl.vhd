library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo_ctrl is
    generic (
        ADDR_WIDTH : natural := 4 
    );
    port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        rd          : in  STD_LOGIC;
        wr          : in  STD_LOGIC;
        empty       : out STD_LOGIC;
        full        : out STD_LOGIC;
        w_addr      : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        r_addr      : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        r_addr_next : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0)
    );
end fifo_ctrl;

architecture arch of fifo_ctrl is
    signal w_ptr_reg, w_ptr_next, w_ptr_succ : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal r_ptr_reg, r_ptr_next, r_ptr_succ : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal full_reg, full_next               : STD_LOGIC;
    signal empty_reg, empty_next             : STD_LOGIC;
    signal wr_op                             : STD_LOGIC_VECTOR(1 downto 0);
begin
    
    process(clk, reset)
    begin
        if reset = '1' then
            w_ptr_reg <= (others => '0');
            r_ptr_reg <= (others => '0');
            full_reg  <= '0';
            empty_reg <= '1';
        elsif rising_edge(clk) then
            w_ptr_reg <= w_ptr_next;
            r_ptr_reg <= r_ptr_next;
            full_reg  <= full_next;
            empty_reg <= empty_next;
        end if;
    end process;

   
    w_ptr_succ <= STD_LOGIC_VECTOR(unsigned(w_ptr_reg) + 1);
    r_ptr_succ <= STD_LOGIC_VECTOR(unsigned(r_ptr_reg) + 1);

    
    wr_op <= wr & rd;

    process(w_ptr_reg, w_ptr_succ, r_ptr_reg, r_ptr_succ, wr_op, empty_reg, full_reg)
    begin
       
        w_ptr_next <= w_ptr_reg;
        r_ptr_next <= r_ptr_reg;
        full_next  <= full_reg;
        empty_next <= empty_reg;

        case wr_op is
            when "00" => 
                null;

            when "01" => 
                if empty_reg = '0' then 
                    r_ptr_next <= r_ptr_succ;
                    full_next  <= '0';
                    if r_ptr_succ = w_ptr_reg then
                        empty_next <= '1';
                    end if;
                end if;

            when "10" => 
                if full_reg = '0' then 
                    w_ptr_next <= w_ptr_succ;
                    empty_next <= '0';
                    if w_ptr_succ = r_ptr_reg then
                        full_next <= '1';
                    end if;
                end if;

            when others => 
                w_ptr_next <= w_ptr_succ;
                r_ptr_next <= r_ptr_succ;
        end case;
    end process;

    -- Salidas
    w_addr      <= w_ptr_reg;
    r_addr      <= r_ptr_reg;
    full        <= full_reg;
    empty       <= empty_reg;
    r_addr_next <= r_ptr_next;
end arch;