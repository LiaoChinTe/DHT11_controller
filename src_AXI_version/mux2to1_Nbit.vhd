LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY mux2to1_Nbit IS
GENERIC (N: INTEGER:=32);
PORT (A, B : IN STD_ULOGIC_VECTOR (N-1 DOWNTO 0);
      S : IN STD_ULOGIC;
      U : OUT STD_ULOGIC_VECTOR(N-1 DOWNTO 0));
END mux2to1_Nbit;

ARCHITECTURE arc OF mux2to1_Nbit IS
BEGIN
	PROCESS(S, A, B) 
	BEGIN
		IF(S = '0') THEN
			U<=A;
		ELSE
			U<=B;
		END IF;
    END PROCESS;
END arc;
