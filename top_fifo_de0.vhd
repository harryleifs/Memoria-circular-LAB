library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_fifo_de0 is
    port (
        CLOCK_50 : in  STD_LOGIC;                      -- Reloj de 50 MHz de la tarjeta
        SW       : in  STD_LOGIC_VECTOR(9 downto 0);   -- Interruptores
        BUTTON   : in  STD_LOGIC_VECTOR(2 downto 0);   -- Pulsadores
        LEDG     : out STD_LOGIC_VECTOR(9 downto 0);   -- LEDs Verdes
        HEX0     : out STD_LOGIC_VECTOR(6 downto 0);   -- Display Dato Leído (Derecha)[cite: 1]
        HEX1     : out STD_LOGIC_VECTOR(6 downto 0);   -- Display Apuntador Lectura[cite: 1]
        HEX2     : out STD_LOGIC_VECTOR(6 downto 0);   -- Display Dato Entrada[cite: 1]
        HEX3     : out STD_LOGIC_VECTOR(6 downto 0)    -- Display Apuntador Escritura (Izquierda)[cite: 1]
    );
end top_fifo_de0;

architecture Structural of top_fifo_de0 is
    signal reset_s   : STD_LOGIC;
    signal wr_pulse  : STD_LOGIC;
    signal rd_pulse  : STD_LOGIC;
    
    signal w_data_s  : STD_LOGIC_VECTOR(3 downto 0);
    signal r_data_s  : STD_LOGIC_VECTOR(3 downto 0);
    signal w_addr_s  : STD_LOGIC_VECTOR(3 downto 0);
    signal r_addr_s  : STD_LOGIC_VECTOR(3 downto 0);
    
    signal full_s    : STD_LOGIC;
    signal empty_s   : STD_LOGIC;

begin
    
    w_data_s <= SW(9 downto 6);            
    reset_s  <= not SW(0);                 
    
   
    LEDG(8) <= full_s;                     
    LEDG(7) <= empty_s;                   
    LEDG(6 downto 0) <= (others => '0');   

    
    db_wr: entity work.debouncer
        port map (
            clk    => CLOCK_50,
            btn_in => BUTTON(1),
            pulse  => wr_pulse
        );

    
    db_rd: entity work.debouncer
        port map (
            clk    => CLOCK_50,
            btn_in => BUTTON(0),
            pulse  => rd_pulse
        );

    
    fifo_inst: entity work.fifo
        generic map (
            ADDR_WIDTH => 4,
            DATA_WIDTH => 4
        )
        port map (
            clk        => CLOCK_50,
            reset      => reset_s,
            rd         => rd_pulse,
            wr         => wr_pulse,
            w_data     => w_data_s,
            empty      => empty_s,
            full       => full_s,
            r_data     => r_data_s,
            w_addr_out => w_addr_s,
            r_addr_out => r_addr_s
        );

    
    disp_w_addr: entity work.hex7seg port map (hex => w_addr_s, display => HEX3);
    
    
    disp_w_data: entity work.hex7seg port map (hex => w_data_s, display => HEX2);
    
    
    disp_r_addr: entity work.hex7seg port map (hex => r_addr_s, display => HEX1);
    
    
    disp_r_data: entity work.hex7seg port map (hex => r_data_s, display => HEX0);

end Structural;