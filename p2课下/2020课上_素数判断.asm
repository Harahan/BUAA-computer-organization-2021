.data

.text
li $v0, 5
syscall
move $s0, $v0#n
li $t0, 1
beq $s0, $t0, end1
li $t0, 2
srl  $t1, $s0, 1#n/2
loop:
bgt $t0, $t1, end2
	div $s0, $t0
	mfhi $t2
	beq $t2, $0, end2
addi $t0, $t0, 1
j loop
end2:
bgt $t0, $t1, if
	li $a0, 0
	li $v0, 1
	syscall
	j end
if:
	li $a0, 1
	li $v0, 1
	syscall
	j end

end1:
	li $a0, 0
	li $v0, 1
	syscall
	
	
end:
	li $v0, 10
	syscall