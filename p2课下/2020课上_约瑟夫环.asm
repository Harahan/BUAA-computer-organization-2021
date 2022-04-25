.data 
arr: .space 400
.text
	li $v0, 5
	syscall
	move $s0, $v0#n
	li $v0, 5
	syscall
	move $s1, $v0#m
	li $t0, 0
	loop_in:
	beq $t0, $s0, loop_in_end
		sll $t1, $t0, 2
		addi $t2, $t0, 1
		sw $t2, arr($t1)
	addi $t0, $t0, 1
	j loop_in
	loop_in_end:
	li $t2, 0#k
	li $t0, 0#i
	subi $t1, $s0, 1#n-1
	loop:
	beq $t0, $t1, loop_end
		jal next
		sll $t3, $t2, 2
		sw $0, arr($t3)
		addi $t2, $t2, 1
		div $t2, $s0
		mfhi $t2
	addi $t0, $t0, 1
	j loop
	loop_end:
	jal next
	sll $t2, $t2, 2
	lw $a0, arr($t2)
	li $v0, 1
	syscall
	li $v0, 10
	syscall
	
next:
	li $t4, 0#i
	loop_n:
	beq $t4, $s1, loop_n_end
		add $t5, $t2, $t4
		div $t5, $s0
		mfhi $t5
		sll $t5, $t5, 2
		lw $t5, arr($t5)
		if:
		bne $t5, $0, if_end
			loop_n_2:
			add $t5, $t2, $t4
			div $t5, $s0
			mfhi $t5
			sll $t5, $t5, 2
			lw $t5, arr($t5)
			bne $t5, $0, loop_n_2_end
			addi $t2, $t2, 1
			j loop_n_2
			loop_n_2_end:
		if_end:
	addi $t4, $t4, 1
	j loop_n
	loop_n_end:
	add $t2, $t2, $s1
	subi $t2, $t2, 1
	div $t2, $s0
	mfhi $t2
	jr $ra
	
