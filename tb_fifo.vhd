library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_fifo is
end tb_fifo;

architecture test of tb_fifo is
    constant ADDR_WIDTH : integer := 3; 
    constant DATA_WIDTH : integer := 4;

    signal clk        : STD_LOGIC := '0';
    signal reset      : STD_LOGIC := '0';
    signal rd         : STD_LOGIC := '0';
    signal wr         : STD_LOGIC := '0';
    signal w_data     : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
    signal empty      : STD_LOGIC;
    signal full       : STD_LOGIC;
    signal r_data     : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal w_addr_out : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal r_addr_out : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);

    constant CLK_PERIOD : time := 20 ns;

begin
   
    uut: entity work.fifo
        generic map (
            ADDR_WIDTH => ADDR_WIDTH,
            DATA_WIDTH => DATA_WIDTH
        )
        port map (
            clk        => clk,
            reset      => reset,
            rd         => rd,
            wr         => wr,
            w_data     => w_data,
            empty      => empty,
            full       => full,
            r_data     => r_data,
            w_addr_out => w_addr_out,
            r_addr_out => r_addr_out
        );

    
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

 
    stim_proc: process
    begin
        
        reset <= '1';
        wait for CLK_PERIOD*2;
        reset <= '0';
        wait for CLK_PERIOD;

       
        wr <= '1'; w_data <= "0001";
        wait for CLK_PERIOD;
        wr <= '0';
        wait for CLK_PERIOD;

        
        wr <= '1';
        w_data <= "0010"; wait for CLK_PERIOD;
        w_data <= "0011"; wait for CLK_PERIOD;
        w_data <= "0100"; wait for CLK_PERIOD;
        wr <= '0';
        wait for CLK_PERIOD;

       
        rd <= '1';
        wait for CLK_PERIOD;
        rd <= '0';
        wait for CLK_PERIOD;

       
        wr <= '1';
        w_data <= "0101"; wait for CLK_PERIOD;
        w_data <= "0110"; wait for CLK_PERIOD;
        w_data <= "0111"; wait for CLK_PERIOD;
        w_data <= "1000"; wait for CLK_PERIOD;
        wr <= '0';
        wait for CLK_PERIOD;

        
        wr <= '1'; w_data <= "1001";
        wait for CLK_PERIOD;
        wr <= '0';
        wait for CLK_PERIOD;

        
        rd <= '1';
        wait for CLK_PERIOD*2;
        rd <= '0';
        wait for CLK_PERIOD;

        
        rd <= '1';
        wait for CLK_PERIOD*5;
        rd <= '0';
        wait for CLK_PERIOD;

        
        rd <= '1';
        wait for CLK_PERIOD;
        rd <= '0';

        wait;
    end process;

end test;