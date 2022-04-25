.data
arr: .space 40

.text 
	li $v0, 5
	syscall
	move $s0, $v0#n
	
	li $t0, 0#i
	in:
	beq $t0, $s0, end_in
		li $v0, 12
		syscall
		sb $v0, arr($t0)
		addi $t0, $t0, 1
		j in
	end_in:
	
	li $t0, 0#i
	srl $t1, $s0, 1#n/2
	sub $t3, $s0, 1#n-1
	check:
	slt $t2, $t0, $t1
	beq $t2, 0, end_check
		sub $t2, $t3, $t0
		lb $t4, arr($t0)#arr[i]
		lb $t5, arr($t2)#arr[n-i-1]
		bne $t4, $t5, end_check
		addi $t0, $t0, 1
		j check  
	end_check:
	
	out:
	beq $t0, $t1, else
		la $a0, 0
		la $v0, 1
		syscall
		j end
	else:
		la $a0, 1
		la $v0, 1
		syscall
	
	end:
	la $v0, 10
	syscall
	
	
	