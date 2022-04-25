.data
arr:.space 4000
str_sp:.asciiz " "
str_en:.asciiz "\n"
.macro getindex(%ans,%i,%j,%n)
	mult %i, %n
	mflo %ans
	add %ans, %ans, %j
	sll %ans, %ans, 2
.end_macro 
.text
	li $v0, 5
	syscall
	move $s0, $v0#n
	sra $s1, $s0, 1#n/2
	li $t0, 1#k
	li $t1, 0#i
	for:
	beq $t1, $s1, for_end
		subi $t2, $s0, 1
		sub $t2, $t2, $t1#n-i-1
		move $t3, $t1#j
		for1:
		beq $t3, $t2, for1_end
			getindex($t4, $t1, $t3, $s0)
			sw $t0, arr($t4)
			addi $t0, $t0, 1
		addi $t3, $t3, 1
		j for1
		for1_end:
		move $t3, $t1#j
		for2:
		beq $t3, $t2, for2_end
			getindex($t4, $t3, $t2, $s0)
			sw $t0, arr($t4)
			addi $t0, $t0, 1
		addi $t3, $t3, 1
		j for2
		for2_end:
		move $t3, $t2#j
		for3:
		beq $t3, $t1, for3_end
			getindex($t4, $t2, $t3, $s0)
			sw $t0, arr($t4)
			addi $t0, $t0, 1
		subi $t3, $t3, 1
		j for3
		for3_end:
		move $t3, $t2#j
		for4:
		beq $t3, $t1, for4_end
			getindex($t4, $t3, $t1, $s0)
			sw $t0, arr($t4)
			addi $t0, $t0, 1
		subi $t3, $t3, 1
		j for4
		for4_end:
	addi $t1, $t1, 1
	j for
	for_end:
	
	if:
	and $t5, $s0, 1
	beq $t5, $0, if_end
		getindex($t4, $s1, $s1, $s0)
		sw $t0, arr($t4)
	if_end:
	
	li $t1, 0
	for_out:
	beq $t1, $s0, for_out_end
	li $t3, 0
	for1_out:
	beq $t3, $s0, for1_out_end
		getindex($t4, $t1, $t3, $s0)
		lw $a0, arr($t4)
		li $v0, 1
		syscall
		la $a0, str_sp
		li $v0, 4
		syscall
	addi $t3, $t3, 1
	j for1_out
	for1_out_end:
	la $a0, str_en
	li $v0, 4
	syscall
	addi $t1, $t1, 1
	j for_out
	for_out_end:
	
	li $v0 , 10
	syscall