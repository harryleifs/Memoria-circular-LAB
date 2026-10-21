library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo is
    generic (
        ADDR_WIDTH : integer := 4; 
        DATA_WIDTH : integer := 4  
    );
    port (
        clk    : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        rd     : in  STD_LOGIC;
        wr     : in  STD_LOGIC;
        w_data : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        empty  : out STD_LOGIC;
        full   : out STD_LOGIC;
        r_data : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        w_addr_out : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        r_addr_out : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0)
    );
end fifo;

architecture structural of fifo is
    signal full_s   : STD_LOGIC;
    signal wr_en_s  : STD_LOGIC;
    signal w_addr_s : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal r_addr_s : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
begin
    
    wr_en_s <= wr and (not full_s);
    full    <= full_s;

    
    w_addr_out <= w_addr_s;
    r_addr_out <= r_addr_s;

    
    ctrl_unit : entity work.fifo_ctrl
        generic map (
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            clk         => clk,
            reset       => reset,
            rd          => rd,
            wr          => wr,
            empty       => empty,
            full        => full_s,
            w_addr      => w_addr_s,
            r_addr      => r_addr_s,
            r_addr_next => open
        );

    
    reg_file_unit : entity work.register_file
        generic map (
            ADDR_WIDTH => ADDR_WIDTH,
            DATA_WIDTH => DATA_WIDTH
        )
        port map (
            clk    => clk,
            w_addr => w_addr_s,
            r_addr => r_addr_s,
            w_data => w_data,
            r_data => r_data,
            wr_en  => wr_en_s
        );
end structural;