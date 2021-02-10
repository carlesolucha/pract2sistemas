library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Unidad_control is
    port(
        clk : in std_logic;
        reset_n : in std_logic;
        data    : in std_logic;
        paridad : in std_logic;
      --  co_medio  : in std_logic;
        en_contador : out std_logic;
        en_registro : out std_logic;
        en_paridad  : out std_logic;
		  --en_paralelo : out std_logic;
        en_serie: out std_logic;
        contar      : out std_logic_vector(3 downto 0)
        -- esta variable la utilizo solo para la simulaciÃ³n
    );
end Unidad_control;

architecture behavioral of Unidad_control is

    signal empieza,en, aux, co1bitsenyal : std_logic;
    signal cuenta : std_logic_vector(3 downto 0);

    type t_estados is (Reposo,Espera1_1, Registro, Espera1_2, Espera1_3, Paridad, Stop); 
    signal estado_act, estado_sig : t_estados;

    component DetectorFlancoBajada
    port(
		e			: in std_logic;
		reset_n	    : in std_logic;
		clk		    : in std_logic;
		s			: out std_logic
    );
    end component;

    component Contador
        port(
            reset_n : in std_logic;
            aux     : in std_logic;
            clk     : in std_logic;
            en      : in std_logic;
            salida  : out std_logic_vector(3 downto 0)
        );
    end component;
	 
	 component Contador1bit
		port(
        reset_n : in std_logic;
        clk     : in std_logic;
        en      : in std_logic;
		  co 		 : out std_logic
       -- co_medio    : out std_logic
    );
	 end component;


begin
    i1_Flanco: DetectorFlancoBajada
    port map(
        e   => data,
        reset_n => reset_n,
        clk => clk,
        s   => empieza
    );

    i1_Contador : Contador
    port map(
        reset_n => reset_n,
        aux     => aux,
        clk     => clk,
        en      => en,
        salida  => cuenta
    );
	 
	 i1_Contador1bit : contador1bit
	 port map(
			reset_n => reset_n,
			clk     => clk,
			en      => en,
			co 	  => co1bitsenyal);


    VarEstado: process(clk,reset_n)
    begin
      if reset_n = '0' then
        estado_act <= Reposo;
      elsif rising_edge(clk) then
        estado_act <= estado_sig;
      end if;
    end process VarEstado;

    TransicionEstados : process (estado_act, estado_sig,empieza,data,paridad)
    begin
        estado_sig <= estado_act;
        case estado_act is
            when Reposo =>
                if empieza = '1' then
                    estado_sig <= Espera1_1;
                end if;
            when Espera1_1 =>
               if co1bitsenyal='1' then
							estado_sig<=Registro;
					end if;
            when Registro =>
               if salida="0100" then
						estado_sig<=Espera1_3;
					else
						estado_sig<=Espera1_2;
					end if;
            when Espera1_2 =>
					if co1bitsenyal='1' then
						estado_sig <= co1bitsenyal;
					end if;
            when Espera1_3 =>
					if co1bitsenyal=>'1' then
                   estado_sig<=Paridad;
					end if;
            when Paridad =>
					if co1bitsenyal=>'1' then
                estado_sig<=Stop;
					 end if;
				when Stop =>
					if co1bitsenyal='1' then
						estado_sig<=Reposo;
					end if;
            when others =>
                estado_sig <= Reposo;
        end case;
    end process TransicionEstados;


    Salidas : process (estado_act)
    begin

        aux           	  <= '0';
        en            	  <= '0';
        en_contador1bit   <= '0';
        en_registro  	  <= '0';
        en_paridad   	  <= '0';
        en_paralelo 	     <= '0';
		  en_contador8	 	  <= '0';

        case estado_act is
            when Reposo =>
                null;
            when Espera1_1 =>
                aux <= '1';
					 en_contador1bit <= '1';
					 en<='1';
            when Registro =>
                en_registro <= '1';
					 en_contador8<='1'
					 en_paridad<='1';
            when Espera1_2 =>
					 en_contador1bit <= '1';
            when Espera1_3 =>
					 en_contador1bit <= '1';
					 aux<='1';
            when Paridad =>
                en_contador1bit<='1';
					 aux<='1';
            when Stop =>
                en_contador1bit<='1';
            when others =>
                null;
        end case;
    end process Salidas;

   contar <= cuenta;

end behavioral;