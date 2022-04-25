.data
A: .asciiz "A"
B: .asciiz "B"
C: .asciiz "C"
to:.asciiz "--->"
sp:.asciiz "\n"
.macro save(%a)
	subi $sp, $sp, 4
	sw %a, 0($sp)
.end_macro

.macro load(%b)
	lw %b, 0($sp)
	addi $sp, $sp, 4
.end_macro

.macro swap(%c,%d)
	move $t8, %c
	move %c, %d
	move %d, $t8
.end_macro

.text 
	li $v0, 5
	syscall
	move $s0, $v0
	move $t0, $s0
	la $t1, A
	la $t2, B
	la $t3, C
	jal han
	li $v0, 10
	syscall
	
	han:
		save($ra)
		li $t4, 1
		if:
		bne $t0, $t4, if_end
			move $a0, $t1
			li $v0, 4
			syscall
			la $a0, to
			li $v0, 4
			syscall
			move $a0, $t3
			li $v0, 4
			syscall
			la $a0, sp
			li $v0, 4
			syscall
			load($ra)
			jr $ra
		if_end:
			save($t0)
			save($t1)
			save($t2)
			save($t3)
			swap($t2, $t3)
			subi $t0, $t0, 1
			jal han
			load($t3)
			load($t2)
			load($t1)
			load($t0)
			move $a0, $t1
			li $v0, 4
			syscall
			la $a0, to
			li $v0, 4
			syscall
			move $a0, $t3
			li $v0, 4
			syscall
			la $a0, sp
			li $v0, 4
			syscall
			save($t0)
			save($t1)
			save($t2)
			save($t3)
			swap($t1, $t2)
			subi $t0, $t0, 1
			jal han
			load($t3)
			load($t2)
			load($t1)
			load($t0)
			
			load($ra)
			jr $ra