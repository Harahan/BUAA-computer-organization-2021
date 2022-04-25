.data
arr: .space 32
sym: .space 32
en: .asciiz "\n"
sp: .asciiz " "
.text
	li $v0, 5
	syscall
	move $s0, $v0#n
	move $a0, $0#index
	jal FullArray
	li $v0, 10
	syscall
	
	FullArray:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	if_1:
		slt $t1, $a0, $s0
		beq $t1, 1, if_1_end
			li $t0, 0#!!!
			loop_1:
			beq $t0, $s0, loop_1_end
				sll $t1, $t0, 2
				lw $a0, arr($t1)
				li $v0, 1
				syscall
				la $a0, sp
				li $v0, 4
				syscall
				addi $t0, $t0, 1
				j loop_1
				loop_1_end:
			la $a0, en
			li $v0, 4
			syscall
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			jr $ra
			if_1_end:
	
	li $t0, 0#!!!		
	loop_2:
		beq $t0, $s0, loop_2_end
			sll $t1, $t0, 2
			if_2:
			lw $t3, sym($t1)
			bne $t3, $0, if_2_end
				sll $t2, $a0, 2
				addi $t3, $t0, 1
				sw $t3, arr($t2)
				sll $t2, $t0, 2
				li $t3, 1
				sw $t3, sym($t2)
				subi $sp, $sp, 4
				sw $a0, 0($sp)
				subi $sp, $sp, 4
				sw $t0, 0($sp)
				addi $a0, $a0,1
				jal FullArray
				lw $t0, 0($sp)
				addi $sp, $sp, 4
				lw $a0, 0($sp)
				addi $sp, $sp, 4
				sll $t2, $t0, 2
				li $t3, 0
				sw $t3, sym($t2)
				if_2_end:
			addi $t0, $t0, 1
			j loop_2
			loop_2_end:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
	
	
