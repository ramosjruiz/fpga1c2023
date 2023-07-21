library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity acumulador is
    generic(
        N : natural := 16;
        P : natural := 100; -- # point sources
   
    )
    port(
        clk : in std_logic;
        rst : in std_logic;
        enb : in std_logic;
        off_i : in std_logic_vector(N-1 downto 0);
        out_o : out std_logic_vector(N-1 downto 0);
        enb_o : out std_logic
    );
    end entity;
architecture arch_acumulador of acumulador is
    constant P : signed := unsigned(P);
    signal count : signed(N-1 downto 0);
    signal acc : signed(N-1 downto 0);
    signal res : signed(N-1 downto 0);
    signal count_n : signed(N-1 downto 0);
    signal acc_n : signed(N-1 downto 0);
    signal res_n : signed(N-1 downto 0);
begin
    process(clk)
    begin
        
        if(rst) then
            enb_o <= '0';
            count <= ( others => 'O' );
            acc <= ( others => 'O' );
            res <= ( others => 'O' );
        else
            if(rising_edge(clk) and enb = '1') then
                count <= count_n;
                acc <= acc_n;
                res <= res_n;
            end if;
        end if;
    end process;
    
    count_n <= (others => '0') when count = (P) else
    count + 1;
    acc_n <= (others => '0') when count = (P) else
    acc + signed(off_i);
    res_n <= acc when count = (P) else
    res;


    out_o <= std_logic_vector(res);
    enb_o <= '1' when count = (P) else '0'; -- flag para avisar que ya se lleno el pipeline y se puede comenzar a despachar datos

    end arch_acumulador;


    