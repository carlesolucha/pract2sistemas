library ieee;
use ieee.std_logic_1164.all;

entity DetectorFlancobajada is
	port(
		e			: in std_logic;
		reset_n	: in std_logic;
		clk		: in std_logic;
		s			: out std_logic
	);
end DetectorFlancobajada;

architecture behavioral of DetectorFlancobajada is
	type t_estado is (Esp0,Pulso,Esp1);
	
	signal estado_act,estado_sig : t_estado;
begin

TransicionEstados: process(estado_act,e)
begin
	estado_sig <=estado_act;
	
	case estado_act is
		when Esp0 =>
			if e = '0' then
				estado_sig <= Pulso;
			end if;
		when Pulso =>
			if e = '0' then
				estado_sig <= Esp1;
			end if;
			if e = '1' then
				estado_sig <= Esp0;
			end if;
		when Esp1 =>
			if e = '1' then
				estado_sig <= Esp0;
			end if;
		when others =>
			estado_sig <=Esp0;
	end case;
end process;

Salidas: process (estado_act)
begin

	s<='0';
	case estado_act is
		when Esp0 =>
			null;
		when Pulso =>
			s<='1';
		when Esp1 =>
			null;
		when others =>
			null;
	end case;
end process;

VarEstado : process(clk,reset_n)
begin
	if reset_n='0' then
		estado_act <=Esp0;
	else
		if rising_edge(clk) then
			estado_act <= estado_sig;
		end if;
	end if;
end process;
end behavioral;
