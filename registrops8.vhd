library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrops8 is
	port(
		clk : in std_logic;
		reset_n : in std_logic;
		c_d : in std_logic;
		enable : in std_logic;
		e_p : in std_logic_vector(7 downto 0);
		s_s : out std_logic);
end registrops8;

architecture behavioral of registrops8 is
	signal registro : std_logic_vector(7 downto 0);
begin
	process(clk,reset_n,enable)
	begin
		if reset_n ='0' then
			registro<=(others=>'0');
		else
			if enable='1' then
				if rising_edge(clk) then
					if c_d='0' then
						registro<=e_p;
					else 
						registro(7)<='0';
						registro(6 downto 0)<=registro(7 downto 1);
					end if;
				end if;
			end if;
		end if;
	end process;
	s_s<=registro(0);
end behavioral;