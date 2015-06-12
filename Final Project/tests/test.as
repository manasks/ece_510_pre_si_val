/ Program : Add01.pal
/ Date : March 3, 2002
/
/ Desc : This program computes c = a + b
/
/-------------------------------------------
/
/ Code Section
/
*0200			/ start at address 0200
Main, 	cla cll 	/ clear AC and Link
		tad A 		/ add A to Accumulator
		tad B 		/ add B
		dca C 		/ store sum at C
		cla cll
		tad X
		tad Y
		dca Z
		hlt
		jmp next
		cla cll
		tad X
		tad Y
		dca Z
		hlt
		tad A
		cla cll
next,	tad X
		tad Y
		and D
		dca F
Sub,	cla cll
		dca H
		and G
		dca G
		tad G
		isz A
		jmp sample
		isz A
sample,	tad G
		dca G
		cla cll
		jms Sub
		tad B
check,	dca A
		tad F
		dca B
		and D
		dca F
		and G
		isz G
		jms check
		cla cll
		dca I
		tad Y
		and K
		jms next
		jmp final
		tad A
final,	cla cll
		tad H
		
		hlt 		/ Halt program
		jmp Main	/ To continue - goto Main

/
/ Data Section
/
*0250 			/ place data at address 0250
X, 	45 		/ A equals 2
Y, 	7 		/ B equals 3
Z, 	31
A, 	2 		/ A equals 2
B, 	3 		/ B equals 3
C, 	0

*350
D,	65
E,	123
F,	214
G,	167
H,	423
I,	65
K,	21

*400
L,	72
M,	50
N,	3
O,	20
P,	23
Q,	57

*650
R,	13
S,	11
The,	666
U,	777
V,	0
W,	33

*700
SubAddr, 205 
iszdata, 77

$Main 			/ End of Program; Main is entry point
