library ieee;
use ieee.std_logic_1164.all;

entity Comprobar_paridad is
    port(
        data : in std_logic;
        paridad : out std_logic;
        clk     : in std_logic;
        reset_n : in std_logic;
        enable  : in std_logic
    );
end Comprobar_paridad;

architecture behavioral of Comprobar_paridad is
    signal b : std_logic;
begin

    process(clk,reset_n)
    begin
        if reset_n = '0' then
            b <= '0';
        elsif rising_edge(clk) then
            if enable = '1' then
                b <= data xnor b;
            end if;
        end if;
    end process;

    paridad <= b;
end behavioral;