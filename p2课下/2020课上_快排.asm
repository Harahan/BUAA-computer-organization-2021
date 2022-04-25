.data
arr:.space 4000
space:.asciiz " "
.text
li $v0, 5
syscall
move $s0, $v0#n

li $t0, 0
loop_in:
beq $t0, $s0, loop_in_end
	li $v0, 5
	syscall
	sll $t1, $t0, 2
	sw $v0, arr($t1)
addi $t0, $t0, 1
j loop_in
loop_in_end:

li $a0, 0
subi $t0, $s0, 1
move $a1, $t0
jal qsort

li $t0, 0
loop_out:
beq $t0, $s0, loop_out_end
	sll $t1, $t0, 2
	lw $a0, arr($t1)
	li $v0, 1
	syscall
	la $a0, space
	li $v0, 4
	syscall
addi $t0, $t0, 1
j loop_out
loop_out_end:

li $v0, 10
syscall

qsort:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	slt $t3, $a0, $a1
	beq $t3, $0, end
		move $t0, $a0#i
		move $t1, $a1#j
		sll $t2, $a0, 2
		lw $t2, arr($t2)#k
		while1:
		slt $t3, $t0, $t1
		beq $t3, $0, while1_end
			while2:
			slt $t3, $t0, $t1
			beq $t3, $0, while2_end
			sll $t3, $t1, 2
			lw $t4, arr($t3)#arr[j]
			slt $t3,$t4, $t2
			bne $t3, $0, while2_end
			subi $t1, $t1, 1
			j while2
			while2_end:
			if1:
			slt $t3, $t0, $t1
			beq $t3, $0, if1_end
			sll $t3, $t0, 2
			sll $t6, $t1, 2
			lw $t4, arr($t6)#!!!
			sw $t4, arr($t3)
			addi $t0, $t0, 1
			if1_end:
			while3:
			slt $t3, $t0, $t1
			beq $t3, $0, while3_end
			sll $t3, $t0, 2
			lw $t5, arr($t3)#arr[i]
			slt $t3,$t5, $t2
			beq $t3, $0, while3_end
			addi $t0, $t0, 1
			j while3
			while3_end:
			if2:
			slt $t3, $t0, $t1
			beq $t3, $0, if2_end
			sll $t3, $t1, 2
			sll $t6, $t0, 2
			lw $t5, arr($t6)
			sw $t5, arr($t3)#!!!
			subi $t1, $t1, 1
			if2_end:
			j while1
		while1_end:
		sll $t3, $t0, 2
		sw $t2, arr($t3)
		
		subi $sp, $sp, 4
		sw $a0, 0($sp)
		subi $sp, $sp, 4
		sw $a1, 0($sp)
		subi $a1, $t0, 1
		jal qsort
		lw $a1, 0($sp)
		addi $sp, $sp, 4
		lw $a0, 0($sp)
		addi $sp, $sp, 4
		
		subi $sp, $sp, 4
		sw $a0, 0($sp)
		subi $sp, $sp, 4
		sw $a1, 0($sp)
		addi $a0, $t0, 1
		jal qsort
		lw $a1, 0($sp)
		addi $sp, $sp, 4
		lw $a0, 0($sp)
		addi $sp, $sp, 4
		
	end:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	