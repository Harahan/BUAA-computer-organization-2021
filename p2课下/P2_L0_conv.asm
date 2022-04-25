.data
ar:.space 512
bf: .space 512
tar: .space 512
en: .asciiz "\n"
sp: .asciiz " "
.macro gi(%ans,%r,%c,%n)
	mult %r, %n
	mflo %ans
	add %ans, %ans, %c
	sll %ans, %ans, 2
.end_macro
.text 
	li $v0, 5
	syscall
	move $s0, $v0#m1
	li $v0, 5
	syscall
	move $s1, $v0#n1
	li $v0, 5
	syscall
	move $s2, $v0#m2
	li $v0, 5
	syscall
	move $s3, $v0#n2
	
	li $t0, 0#i
	il:
	beq $t0, $s0, il_end
		li $t1, 0#j
		jl:
		beq $t1, $s1, jl_end
			li $v0, 5
			syscall
			gi($t2,$t0,$t1,$s1)
			sw $v0, ar($t2)
		addi $t1, $t1, 1
		j jl
		jl_end:
	addi $t0, $t0, 1
	j il
	il_end:
	
	li $t0, 0#i
	il1:
	beq $t0, $s2, il1_end
		li $t1, 0#j
		jl1:
		beq $t1, $s3, jl1_end
			li $v0, 5
			syscall
			gi($t2,$t0,$t1,$s3)
			sw $v0, bf($t2)
		addi $t1, $t1, 1
		j jl1
		jl1_end:
	addi $t0, $t0, 1
	j il1
	il1_end:
	
	sub $s4, $s0, $s2
	addi $s4, $s4, 1#m1-m2+1
	sub $s5, $s1, $s3
	addi $s5, $s5, 1#n1-n2+1
	
	li $t0, 0#i
	il2:
	beq $t0, $s4, il2_end
		li $t1, 0#j
		jl2:
		beq $t1, $s5, jl2_end
			li $t7, 0#reset
			li $t2, 0#k
			kl:
			beq $t2, $s2, kl_end
				li $t3, 0#l
				ll:
				beq $t3, $s3, ll_end
					add $t4, $t0, $t2
					add $t5, $t1, $t3
					gi($t6, $t4, $t5, $s1)
					lw $t6, ar($t6)
					gi($t4, $t2, $t3, $s3)
					lw $t4, bf($t4)
					mult $t4, $t6
					mflo $t5
					add $t7, $t7, $t5
				addi $t3, $t3, 1
				j ll
				ll_end:	
			addi $t2, $t2, 1
			j kl
			kl_end:	
		gi($t6, $t0,$t1,$s5)
		sw $t7,tar($t6)
		addi $t1, $t1, 1
		j jl2
		jl2_end:
	addi $t0, $t0, 1
	j il2
	il2_end:
	
	li $t0, 0#i
	il3:
	beq $t0, $s4, il3_end
		li $t1, 0#j
		jl3:
		beq $t1, $s5, jl3_end
			gi($t2,$t0,$t1,$s5)
			lw $a0, tar($t2)
			li $v0, 1
			syscall
			la $a0, sp
			li $v0, 4
			syscall
		addi $t1, $t1, 1
		j jl3
		jl3_end:
	la $a0, en
	li $v0, 4
	syscall
	addi $t0, $t0, 1
	j il3
	il3_end:
	
	li $v0, 10
	syscall