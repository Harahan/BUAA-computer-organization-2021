.data
array:.space 1024
vis: .space 128
.macro getindex(%ans,%i,%j)#in macro you shouldn't change the parameter's value
	sll %ans, %i, 3
	add %ans, %ans, %j
	sll %ans, %ans, 2
.end_macro
.text
li $s2, 1#const
li $s3, 0#flag

li $v0, 5
syscall
move $s0, $v0#n
li $v0, 5
syscall
move $s1, $v0#m
li $t0, 0#i
input:
beq $t0, $s1, input_end
	li $v0, 5
	syscall
	move $t1, $v0#a index
	li $v0, 5
	syscall
	move $t2, $v0#b index
	getindex($t3,$t1,$t2)
	sw $s2, array($t3)#array[a][b]=1
	getindex($t3,$t2,$t1)
	sw $s2, array($t3)#array[a][b]=1
	addi $t0, $t0, 1
	j input
input_end:


li $a0, 1#k=1
jal dfs


move $a0, $s3#flag
li $v0, 1
syscall
li $v0, 10
syscall


dfs:
subi $sp, $sp, 4
sw $ra, 0($sp)
sll $t0, $a0, 2
sw $s2, vis($t0)#vis[k]=1
li $t0, 1#loop_temp i
loop2:
bgt $t0, $s0, loop2_end
	sll $t1, $t0, 2
	lw $t2, vis($t1)#load_vis[i]
	getindex($t3,$a0,$t0)
	lw $t3, array($t3)#load_array[k][i]
	if1:
		beq $t2, $s2, if1_end#if vis[i]==0,or if1_end
		bne $t3, $s2, if1_end#if array[k][i]==1,or if1_end
		subi $sp, $sp, 4
		sw $a0, 0($sp)
		subi $sp, $sp, 4
		sw $t0, 0($sp)
		move $a0, $t0#k=i
		jal dfs#dfs(k)
		lw $t0, 0($sp)
		lw $a0, 4($sp)
		addi $sp, $sp, 8  
		if1_end:
		if2:
			bne $s2, $s3, if2_end#if flag==1,or if2_end
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			jr $ra#return
			if2_end:
	addi $t0, $t0, 1#i++
	j loop2
loop2_end:


li $t0, 1#aa=1
li $t1, 1#loop_temp i
loop3:
	bgt $t1, $s0, loop3_end#if i>n, or loop3_end
	sll $t2, $t1, 2
	lw $t2, vis($t2)#load_vis[i]
	and $t0, $t0, $t2#aa=aa&vis[i] 
	addi $t1, $t1, 1
	j loop3
loop3_end:


if3:
	bne $t0, $s2, if3_end#if aa==1,or if3_end
	getindex($t1, $s2, $a0)
	lw $t1, array($t1)#load_array[1][k]
	bne $t1, $s2, if3_end#if array[1][k]==1,or if3_end
	li $s3, 1#flag=1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	if3_end:


sll $t0, $a0, 2
sw $0, vis($t0)
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra






	

