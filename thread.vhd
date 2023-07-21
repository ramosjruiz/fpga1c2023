library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity thread is
    generic(
        N : natural := 16;
        P : natural := 100; -- # point sources
        B : natural := 1 -- # bloques
        Block_size : natural;
        x : natural := 0;
        y : natural := 0; --(x,y) relativos dentro del bloque
        Sigma : natural :=  601
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
architecture arch_thread of thread is
    signal wire_enb_offset_ev,wire_enb_ev_acc : std_logic;
    signal wirex_offset,wirey_offset,wire_res_ev : std_logic_vector(N-1 downto 0);
    begin

        entity work.offset
            generic map(
                N <= N,
                P <= P,
                B <= B,
                Block_size <= Block_size,
                x <= x,
                y <= y
            )
            port map(
                clk <= clk,
                rst <= rst,
                enb <= enb,
                psx_i <= psx_i,
                psy_i <= psy_i,
                offx_o <= wirex_offset,
                offy_o <= wirey_offset,
                enb_o <= wire_enb_offset_ev
            );
        entity work.evaluador --COMPLETAR
            generic map(
                N <= N,
                Sigma <= Sigma
            )
            port map (
                clk <= clk,
                rst <= rst,
                enb <= wire_enb_offset_ev,
                offx_i <= wirex_offset,
                offy_i <= wirey_offset,
                out_o <= wire_res_ev,
                enb_o <= wire_enb_ev_acc
            );

        entity work.acumulador
            generic map(
                N <= N,
                P <= P
            )
            port map(
                clk <= clk,
                rst <= rst,
                enb <= wire_enb_ev_acc,
                off_i <= wire_res_ev,
                enb_o <= enb_o,
                out_o <= out_o
            );
end arch_thread;
