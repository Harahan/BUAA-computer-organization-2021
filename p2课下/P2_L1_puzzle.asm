.data
arr: .space 200
vis: .space 200
.macro gi(%ans,%r,%c,%n)
	mult %r, %n
	mflo %ans
	add %ans, %ans, %c
	sll %ans, %ans, 2
.end_macro 
.text 
	li $v0, 5
	syscall
	move $s0, $v0#m
	li $v0, 5
	syscall
	move $s1, $v0#n
	li $t0,0
	for_in_1:
		beq $t0, $s0, for_in_1_end
			li $t1, 0
			for_in_2:
				beq $t1, $s1, for_in_2_end
					gi($t3,$t0,$t1,$s1)
					li $v0, 5
					syscall
					sw $v0, arr($t3)
				addi $t1, $t1, 1
				j for_in_2
				for_in_2_end:
		addi $t0, $t0, 1
		j for_in_1
		for_in_1_end:
		
	li $v0, 5
	syscall
	move $s2, $v0#p
	subi $s2, $s2, 1
	li $v0, 5
	syscall
	move $s3, $v0#q
	subi $s3, $s3, 1
	li $v0, 5
	syscall
	move $s4, $v0#l
	subi $s4, $s4, 1
	li $v0, 5
	syscall
	move $s5, $v0#k
	subi $s5, $s5, 1
	
	gi($t0,$s2,$s3,$s1)
	li $t1, 1
	sw $t1, vis($t0)
	move $a0, $s2
	move $a1, $s3
	li $s6,0
	jal dfs
	move $a0, $s6#s
	li $v0, 1
	syscall 
	li $v0, 10
	syscall
	
	dfs:
		subi $sp, $sp, 4
		sw $ra, 0($sp)
		if:
		gi($t0, $s4,$s5,$s1)
		lw $t1, vis($t0)
		#move $a0, $t1
		#li $v0, 1
		#syscall
		beq $t1, $0, end_if
			addi $s6, $s6, 1
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			jr $ra
		end_if:
		
		if_1:
			addi $t0, $a0, 1#p+1
			slt $t3, $t0, $s0
			beq $t3, $0,  if_1_end
			gi($t1, $t0, $a1, $s1)
			lw $t2, arr($t1)
			bne $t2, $0, if_1_end
			lw $t2, vis($t1)
			bne $t2, $0, if_1_end
			li $t0, 1
			sw $t0, vis($t1)
			subi $sp, $sp, 4
			sw $a0, 0($sp)
			subi $sp, $sp, 4
			sw $a1, 0($sp)
			addi $a0, $a0, 1
			jal dfs
			lw $a1, 0($sp)
			addi $sp, $sp, 4
			lw $a0, 0($sp)
			addi $sp, $sp, 4
			addi $t0, $a0, 1
			gi($t1,$t0, $a1, $s1)
			sw $0, vis($t1)
			if_1_end:
			
			if_2:
			subi $t0, $a0, 1#p-1
			slt $t3, $t0, $0
			bne $t3, $0,  if_2_end
			gi($t1, $t0, $a1, $s1)
			lw $t2, arr($t1)
			bne $t2, $0, if_2_end
			lw $t2, vis($t1)
			bne $t2, $0, if_2_end
			li $t0, 1
			sw $t0, vis($t1)
			subi $sp, $sp, 4
			sw $a0, 0($sp)
			subi $sp, $sp, 4
			sw $a1, 0($sp)
			subi $a0, $a0, 1
			jal dfs
			lw $a1, 0($sp)
			addi $sp, $sp, 4
			lw $a0, 0($sp)
			addi $sp, $sp, 4
			subi $t0, $a0, 1
			gi($t1,$t0, $a1, $s1)
			sw $0, vis($t1)
			if_2_end:
			
			if_3:
			addi $t0, $a1, 1#q+1
			slt $t3, $t0, $s1
			beq $t3, $0,  if_3_end
			gi($t1, $a0, $t0, $s1)
			lw $t2, arr($t1)
			bne $t2, $0, if_3_end
			lw $t2, vis($t1)
			bne $t2, $0, if_3_end
			li $t0, 1
			sw $t0, vis($t1)
			subi $sp, $sp, 4
			sw $a0, 0($sp)
			subi $sp, $sp, 4
			sw $a1, 0($sp)
			addi $a1, $a1, 1
			jal dfs
			lw $a1, 0($sp)
			addi $sp, $sp, 4
			lw $a0, 0($sp)
			addi $sp, $sp, 4
			addi $t0, $a1, 1
			gi($t1,$a0, $t0, $s1)
			sw $0, vis($t1)
			if_3_end:
			
			if_4:
			subi $t0, $a1, 1#q-1
			slt $t3, $t0, $0
			bne $t3, $0,  if_4_end
			gi($t1, $a0, $t0, $s1)
			lw $t2, arr($t1)
			bne $t2, $0, if_4_end
			lw $t2, vis($t1)
			bne $t2, $0, if_4_end
			li $t0, 1
			sw $t0, vis($t1)
			subi $sp, $sp, 4
			sw $a0, 0($sp)
			subi $sp, $sp, 4
			sw $a1, 0($sp)
			subi $a1, $a1, 1
			jal dfs
			lw $a1, 0($sp)
			addi $sp, $sp, 4
			lw $a0, 0($sp)
			addi $sp, $sp, 4
			subi $t0, $a1, 1
			gi($t1,$a0, $t0, $s1)
			sw $0, vis($t1)
			if_4_end:
			
			end:
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			jr $ra	
			
			
			