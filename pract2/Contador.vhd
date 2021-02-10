library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Contador is
    port(
        reset_n : in std_logic;
        aux     : in std_logic;
        clk     : in std_logic;
        en      : in std_logic;
        salida   : out std_logic_vector(3 downto 0)
    );
end Contador;

architecture behavioral of Contador is
    signal contador : unsigned(3 downto 0);

begin

    process(reset_n,clk)
    begin
        if reset_n = '0' then
            contador <= (others => '0');
        elsif aux = '1' then 
            contador <= (others => '0');
        else
            if rising_edge(clk) then
                if en='1' then
                    if contador= 9 then
                        contador <= (others => '0');
                    else
                        contador <= contador + 1;
                    end if;
                end if;
            end if; 
        end if;
    end process;

    salida <= std_logic_vector(contador);

end behavioral;