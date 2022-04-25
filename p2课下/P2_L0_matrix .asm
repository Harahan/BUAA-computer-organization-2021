.data
matrix1: .space 400
matrix2: .space 400
matrix3: .space 400
str_space: .asciiz " "
str_enter: .asciiz "\n"

.macro getindex(%ans, %row, %col, %n)
	mult %row, %n
	mflo %ans
	add %ans, %ans, %col
	sll %ans, %ans, 2
.end_macro

.text
	 li $v0, 5
	 syscall
	 move $s0, $v0#n
	 li $t0, 0#row
	 loop1:
	 beq $t0, $s0, end_loop1
	 li $t1, 0#col
	 loop2:
	 beq $t1, $s0, end_loop2
	 li $v0, 5
	 syscall
	 getindex($t2, $t0, $t1, $s0)
	 sw $v0, matrix1($t2)
	 addi $t1, $t1, 1
	 j loop2
	 end_loop2:
	 addi $t0, $t0, 1
	 j loop1
	 end_loop1:
	 
	 
	 li $t0, 0#row
	 loop3:
	 beq $t0, $s0, end_loop3
	 li $t1, 0#col
	 loop4:
	 beq $t1, $s0, end_loop4
	 li $v0, 5
	 syscall
	 getindex($t2, $t0, $t1, $s0)
	 sw $v0, matrix2($t2)
	 addi $t1, $t1, 1
	 j loop4
	 end_loop4:
	 addi $t0, $t0, 1
	 j loop3
	 end_loop3:
	 
	 li $t0, 0#i
	 loop5:
	 beq $t0, $s0, end_loop5
	 li $t1, 0#j
	 loop6:
	 beq $t1, $s0, end_loop6
	 li $t6, 0#reset
	 li $t2, 0#k
	 loop7:
	 beq $t2, $s0, end_loop7
	 getindex($t3,$t0,$t2,$s0)
	 lw $t3, matrix1($t3)
	 getindex($t4,$t2,$t1,$s0)
	 lw $t4, matrix2($t4)
	 mult $t3,$t4
	 mflo $t5
	 add $t6, $t6, $t5
	 addi $t2, $t2, 1
	 j loop7
	 end_loop7:
	 getindex($t7, $t0, $t1, $s0)
	 sw $t6, matrix3($t7)
	 addi $t1, $t1, 1
	 j loop6
	 end_loop6:
	 addi $t0, $t0, 1
	 j loop5
	 end_loop5:
	 
	 li $t0, 0#row
	 loop8:
	 li $t1, 0#col
	 beq $t0, $s0, end_loop8
	 loop9:
	 beq $t1, $s0, end_loop9
	 getindex($t2, $t0, $t1, $s0)
	 lw $a0, matrix3($t2)
	 li $v0, 1
	 syscall
	 la $a0, str_space
	 li $v0, 4
	 syscall
	 addi $t1, $t1, 1
	 j loop9
	 end_loop9:
	 addi $t0, $t0, 1
	 la $a0, str_enter
	 li $v0, 4
	 syscall
	 j loop8
	 end_loop8:
	 
	 li $v0, 10
	 syscall
	 
	
	
	