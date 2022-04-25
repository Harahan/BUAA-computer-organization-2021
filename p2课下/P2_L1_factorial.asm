.data
arr: .space 4004
.text
	li $v0, 5
	syscall
	move $s0, $v0#n
	jal fac
	
	loop2:
	bgt $0, $t6, loop2_end
		sll $t1, $t6, 2
		lw $t1, arr($t1)
		move $a0, $t1
		li $v0, 1
		syscall
	subi $t6, $t6, 1
	j loop2
	loop2_end:
	
	li $v0, 10
	syscall
	
	
	fac:
	li $t0, 1
	sw $t0, arr($0)
	li $t0, 2
	li $t6, 0
	loop3:
	bgt $t0, $s0, loop3_end
		li $t1, 0
		li $t2, 0
		loop4:
		bgt $t2, $t6, loop4_end
			sll $t3, $t2, 2
			lw $t4, arr($t3)
			mult $t4, $t0
			mflo $t4
			add $t4, $t4, $t1
			li $t5, 10
			div $t4, $t5
			mfhi $t4
			sw $t4, arr($t3)
			mflo $t1
			if:
			beq $t1, $0, if_end
			bne $t6, $t2, if_end
				addi $t6, $t6, 1
			if_end:
		addi $t2, $t2, 1
		j loop4
		loop4_end:
	addi $t0, $t0, 1
	j loop3
	loop3_end:
	jr $ra
	
		
