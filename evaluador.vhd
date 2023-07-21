library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity evaluador is
    generic ( 
        N : natural := 16;
        Sigma: natural :=601
    );
    port(
        clk in std_logic;
        rst in std_logic;
        enb in std_logic;
        offx_i out std_logic_vector(N-1 downto 0);
        offy_i out std_logic_vector(N-1 downto 0);
        out_o out std_logic_vector(N-1 downto 0);
        enb_o out std_logic
    );
end entity;

architecture arch_evaluador of evaluador is
    constant sigma : unsigned := unsigned(Sigma);
    constant INV_LOG_2 : integer := unsigned(184); 
    constant LOG_2 : integer := unsigned(88);

    signal q : unsigned(N-1 downto 0);
    signal r : unsigned(N-1 downto 0);
    signal q_floor : unsigned(N-1 downto 0);
    signal exp : unsigned(N-1 downto 0);
    
end architecture;
