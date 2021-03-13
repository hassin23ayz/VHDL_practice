library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Entity declaration describes the external view of the entity : the input and output signal names 
entity halfAdder is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           SUM : out  STD_LOGIC;
           CARRY : out  STD_LOGIC
	       );
end halfAdder;

--The structural representation for the half adder does not say anything about it's functionality
--The structural style of modelling describes only and interconnection of components without implying any behavior 
architecture HA_STRUCTURE of halfAdder is
--declarative part = component declaration
	component XOR_U
	Port( X: in  STD_LOGIC;
	      Y: in  STD_LOGIC;
			Z: out STD_LOGIC
	    );
   end component;
	component AND_U
	Port( L: in  STD_LOGIC;
	      M: in  STD_LOGIC;
			N: out STD_LOGIC
	    );
   end component;
--statement part = component instantiation
--The Declared components above are instantiated in the statement part of the architecture body
--X1 A1 are the component labels for these component instantiations
--component instantiation is a concurrent statement , order of these statements are not important 
begin
	X1:XOR_U port map(A,B,SUM);   --positional association 
	A1:AND_U port map(A,B,CARRY); --positional association 
end HA_STRUCTURE;

--flow of data through the entity is expressed using concurrent signal assignment statements , order not important 
--target_signal <= expression 
--A concurrent signal assignment statement is executed only when any signal used in the expression value changes 
--delay information is included using after clauses 
--with no after clause a default delay of 0 ns is assumed and this is also known as delta delay[infinitesimally a small delay] 
architecture HA_CONCURRENT of halfAdder is
begin
	SUM <= A xor B after 8 ns;
	CARRY <= A and B after 4 ns;
end HA_CONCURRENT;

--behavioral style of modeling : A set of statements that are executed sequentially in the spcified order 
--this style does not specify the structure of the entity but merely its functionality 
--sequential statements are inside a process statement 
--process statement is a concurrent statement 
--process statement also has a declarative part 
--process statements are executed sequentially when there is a change in list of the signals declared at process declaration 
--variable is different from signal , := is used 
--variables declared within a process have their scope limited to that process 
--variable declared outside of a process is called shared variable and can be read by more than one process 
--signals cannot be declared within a process 
--when execution reaches the end of the process , the process suspends itself and waits for another event (signals within sensitivity list) 
--A process never terminates it is always either executing or in a suspended state 