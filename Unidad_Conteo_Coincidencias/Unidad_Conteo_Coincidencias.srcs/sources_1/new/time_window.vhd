----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.09.2019 10:03:31
-- Design Name: 
-- Module Name: time_window - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity time_window is
Port ( 
        CLK100MHZ	: in STD_LOGIC;
        rst		  	: in std_logic;
        
        ciclos_tiempo      :in integer;  -- es el entero que representa el numero de CICLOS DE RELOJ 
        escala      :in integer; --es un entero que tepresenta el numero de veces que se repite el ciclo de tiempo
        
        win_on	:out STD_LOGIC;
        
        Do_windows_time		: in STD_LOGIC;
        Done_windows_time 	: out STD_LOGIC
      );
end time_window;

architecture Behavioral of time_window is

-- signal
signal contador_tiempo: integer :=0;
signal contador_escala: integer:= 0;

--STATE MACHINE
type estado_windows_time is (S0,S1,S2,S3);
signal est_windows_time:estado_windows_time:= S0;


begin

wt:Process(CLK100MHZ,rst)
begin
	if rst = '1' then
		est_windows_time <= S0;
		elsif rising_edge(CLK100MHZ) then

		  case est_windows_time is
		
			   when S0 =>
					Done_windows_time <= '0';
					contador_tiempo	<= 0;
					contador_escala	<= 0;
					win_on  <= '0';
					if Do_windows_time = '1' then
						est_windows_time <=S1;
					end if;
			   
			   when S1 =>
					if (contador_escala >= escala) then
					    contador_escala <= 0;
					    win_on <= '0';
						est_windows_time <= S3;
					 else 
						contador_escala <= contador_escala + 1;
						win_on <= '1';
						est_windows_time <= S2;
					end if;
			   
				when S2 =>
					if(contador_tiempo >= ciclos_tiempo) then
						est_windows_time  <= S1;
						contador_tiempo   <= 0;						
					 else
					    contador_tiempo <= contador_tiempo + 1;	
						est_windows_time  <= S2;
					end if;


									
				when S3 =>
					Done_windows_time <= '1';
					if(Do_windows_time = '0')then 
						est_windows_time <=S0;
					end if;
					
				when others =>
					est_windows_time <= S0;
		end case;
	end if;
end process;

end Behavioral;
