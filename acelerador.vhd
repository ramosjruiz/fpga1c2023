library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity acelerador is
    generic(
        N : natural := 16;
        P : natural := 100; -- # point sources
        B : natural := 1 -- # bloques
        Block_size : natural;
        Sigma : natural = 601; --4.7
    )
    port(
        clk : in std_logic;
        rst : in std_logic;
        enb : in std_logic;
        psx_i : in std_logic_vector(N-1 downto 0);
        psy_i : in std_logic_vector(N-1 downto 0);
        out_o : in std_logic_vector(N-1 downto 0);
        enb_o : out std_logic
    );
end entity;
architecture arch_acelerador of acelerador is
    type wire_array is array(Block_size- 1 downto 0) of signed(N-1 downto 0);
    type wire_matrix is array(Block_size- 1 downto 0) of wire_array;
    signal wire_o : matrix;
    signal countx,countx_n,county,county_n : unsigned(N-1 downto 0);
    signal ready,ready_n : unsigned(2 downto 0);
    signal dispatching,dispatching_n,enb : std_logic;

begin
        threads1: for j in 0 to (Block_size - 1) generate
        begin
            threads2: for i in 0 to (Block_size - 1) generate
                begin
                    threadj: work.thread
                        generic map(
                        N <= N,
                        P <= P,
                        B <= B,
                        Block_size <= Block_size,
                        x <= j,
                        y <= i,
                        Sigma <= Sigma
                        )
                        port map(
                            clk <= clk,
                            rst <= rst,
                            enb <= enb,
                            psx_i <= psx_i,
                            psy_i <= psy_i,
                            out_o <= wire_o(j)(i),
                            enb_o <= enb
                            
                        );
                end generate;
        end generate;
        process(clk)
            begin
                if(rising_edge(clk)) then
                    countx <= countx_n;
                    county <= county_n;
                    dispatching <= dispatching_n;
                    ready <= ready_n;
                end if;
        end process;
        
        countx_n <= (others <= '0') when countx_n = unsigned(Block_size) or dispatching = '0' else countx + 1 when dispatching = '1';
        county_n <= (others <= '0') when county_n = unsigned(Block_size) or dispatching = '0' else county + 1 when countx = unsigned(Block_size) and dispatching = '1';
        dispatching_n <=  '0' when (ready = 0 and (countx = unsigned(Block_size) and county = unsigned(Block_size))) else '1' when enb = '1' else dispatching;
        ready_n <= ready + 1 when enb = '1' else ready - 1 when (countx = unsigned(Block_size) and county = unsigned(Block_size)) else ready;

        enb_o <= dispatching;
        out_o <= wire_matrix(countx)(county);
                
end arch_acelerador; 




