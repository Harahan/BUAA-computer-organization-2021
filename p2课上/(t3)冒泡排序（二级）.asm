.data
arr:.space 2000
buf:.space 2000
sp: .asciiz " "
en: .asciiz "\n"

.macro read_num(%n)
	li $v0, 5
	syscall
	move %n, $v0
.end_macro

.macro end()
	li $v0, 10
	syscall
.end_macro

.text
	read_num($s0)#n
	li $t0, 0
	for_in:
	beq $t0, $s0, for_in_end
		sll $t1, $t0, 2
		read_num($v0)
		sw $v0, arr($t1)
		read_num($v0)
		sw $v0, buf($t1)
	addi $t0, $t0, 1
	j for_in
	for_in_end:
	
	jal sort
	
	li $t0, 0
	for_out:
	beq $t0, $s0, for_out_end
		sll $t1, $t0, 2
		lw $a0, arr($t1)
		li $v0, 1
		syscall
		la $a0, sp
		li $v0, 4
		syscall
		lw $a0, buf($t1)
		li $v0, 1
		syscall
		la $a0, en
		li $v0, 4
		syscall
	addi $t0, $t0, 1
	j for_out
	for_out_end:
	li $v0, 10
	syscall
	
	sort:
		li $t0, 0
		subi $s1, $s0, 1
		for1:
		beq $t0, $s1, for1_end
			li $t2, 0
			sub $t1, $s1, $t0
			for2:
			beq $t2, $t1, for2_end
				addi $t3, $t2, 1
				sll $t3, $t3, 2
				sll $t4, $t2, 2
				lw $t5, arr($t3)
				lw $t6, arr($t4)
				if1:
				bge $t6, $t5, if1_end
					sw $t5, arr($t4)
					sw $t6, arr($t3)
					lw $t7, buf($t3)
					lw $t8, buf($t4)
					sw $t7, buf($t4)
					sw $t8, buf($t3)
					j if2_end
				if1_end:
				if2:
				bne $t6, $t5, if2_end
					lw $t7, buf($t3)
					lw $t8, buf($t4)
					bge $t8, $t7, if2_end
					sw $t7, buf($t4)
					sw $t8, buf($t3)
				if2_end:
			addi $t2, $t2, 1
			j for2
			for2_end:
		addi $t0, $t0, 1
		j for1
		for1_end:
		jr $ra
		
	
