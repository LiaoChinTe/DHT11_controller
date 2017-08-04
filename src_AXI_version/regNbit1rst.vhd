LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY regNbit1rst IS
GENERIC(N : INTEGER := 32);
PORT (CLK, RSTN, LE : IN STD_ULOGIC;
      A : IN std_ulogic_vector (N-1 DOWNTO 0);
	  B : OUT std_ulogic_vector (N-1 DOWNTO 0));
END regNbit1rst;

ARCHITECTURE arc OF regNbit1rst IS
BEGIN

process(CLK, RSTN)
BEGIN
	IF(RSTN = '0') THEN
		B<=(OTHERS=>'1');
	ELSIF(CLK'EVENT AND CLK = '1') THEN
		IF(LE = '1') THEN
			B <= A;
		END IF;
     END IF;
END PROCESS;
END arc;
