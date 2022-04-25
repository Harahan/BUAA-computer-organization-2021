.text
la $v0, 5
syscall
move $s0, $v0
li $t0, 100
li $t1, 4
li $t2, 400
div $s0, $t0
mfhi $t0
div $s0, $t1
mfhi $t1
div $s0, $t2
mfhi $t2
lf_begin:
	bne $t2, $0, else
	li $a0, 1
	li $v0, 1
	syscall
	jal end
else:
	bne $t1, $0, end
	beq $t0, $0, end
	li $a0, 1
	li $v0, 1
	syscall
	jal end
	
end:
	bne $a0, $0, end1
	li $v0, 1
	syscall

end1:
	li $v0, 10
	syscall
	






