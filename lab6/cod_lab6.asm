.text
main:
	lw $s0,_mask_a
	lw $s1,_mask_b
	lw $s2,_mask_c
	
	Input:
		lw $t0,512($0)#这里不用考虑它的地址，并且后续过程中�?要根据情况进行修�?
		and $t8,$t0,$s0
		bne $t8,$s0,Input#对￥t0寄存器中的�?�进行判�?
	SwMem:
		sw $t0,65280($0)
		j Input
	#ToReg:
	#	and $t1,$t0,$s1 #pixel data to store in the memory
	#	and $t2,$t0,$s2 #writting address
	#ToMem:
	#	sw $t1,($t2)
	#	j Input
.data
	_mask_a:0x80000000
	_mask_b:0x0fff0000
	_mask_c:0x0000ffff
