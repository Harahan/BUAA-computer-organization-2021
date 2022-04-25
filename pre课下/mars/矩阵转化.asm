.data
array: .space 10000
str_enter: .asciiz "\n"
str_space: .asciiz " "



.text
li $v0, 5
syscall
move $s0, $v0#i
li $v0, 5
syscall
move $s1, $v0#j


li $t0, 0#count
multu $s0, $s1
mflo $s2
sll $s2, $s2, 2#total byte


in_i:
li $v0, 5
syscall
sw $v0, array($t0)
addi $t0, $t0, 4
beq $t0, $s2, out_i
j in_i
out_i:

move $t3, $s2
subi $t3, $t3, 4#total byte-4
move $t1, $s0#i count


for_i:
beq $t1, $0, for_i_end
move $t2, $s1#j count


for_j:
beq $t2, $0, for_j_end


judge_print:
lw $a0,  array($t3)
beq $a0, $0, judge_end
move $a0, $t1
li $v0, 1
syscall
la $a0, str_space
li $v0, 4
syscall		
move $a0, $t2
li $v0, 1
syscall	
la $a0, str_space
li $v0, 4
syscall
lw $a0, array($t3)
li $v0, 1
syscall
la $a0, str_enter
li $v0, 4
syscall	
judge_end:
subi $t2, $t2, 1
subi $t3, $t3, 4
j for_j


for_j_end:
subi $t1, $t1, 1
j for_i
for_i_end:


li $v0, 10
syscall




			
			















