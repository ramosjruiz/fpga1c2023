library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity offset is
    generic(
        N : natural := 16;
        P : natural := 100; -- # point sources
        B : natural := 1 -- # bloques
        Block_size : natural;
        x : natural := 0;
        y : natural := 0; --(x,y) relativos dentro del bloque 
    )
    port(
    clk : in std_logic;
    rst : in std_logic;
    enb : in std_logic;
    psx_i : in std_logic_vector(N-1 downto 0);
    psy_i : in std_logic_vector(N-1 downto 0);
    offx_o : out std_logic_vector(N-1 downto 0);
    offy_o : out std_logic_vector(N-1 downto 0);
    enb_o : out std_logic
    );
    end entity;
architecture arch_offset of offset is

    signal count : signed(N-1 downto 0);
    signal block_count : signed(N-1 downto 0);
    signal xs : unsigned(N-1 downto 0);
    signal ys : unsigned(N-1 downto 0);
    signal count_n : signed(N-1 downto 0);
    signal block_count_n : signed(N-1 downto 0);
    signal xs_n : signed(N-1 downto 0);
    signal ys_n : signed(N-1 downto 0);


    process(clk)
    begin
        if(rst) then
            count <= (others => '0');
            block_count <= (others => '0');
            xs <= unsigned(x);
            ys <= unsigned(y);
        else
        if(rising_edge(clk) and enb) then
            count <= count_n;
            block_count <= block_count_n;
            xs <= xs_n;
            ys <= ys_n;

            
            end if;
        end if;
    end process;
    offx_o <= xs - psx_i;
    offy_o <= ys - psy_i;
    count_n <= (others => '0') when count = unsigned(P-1) else
    count + 1;
    block_count_n <= block_count_n + 1 when count = unsigned(P-1) else block_count_n;
    xs_n <= unsigned(x) when block_count - 1 = unsigned(B) else xs + unsigned(Block_size);
    ys_n <= ys + unsigned(Block_size) when block_count - 1 = unsigned(B) else ys;
end arch_offset;

