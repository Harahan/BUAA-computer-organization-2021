ori $28, $0, 0
ori $29, $0, 0
ori $3, $3, 1
divu $10, $3
srlv $3, $10, $18
sra $10, $18, 23
bne $18, $18, label1
ori $3, $0, 0
lw $18, 8($3)
sltiu $3, $18, 25517
label1: mthi $18
sltu $10, $18, $3
or $18, $18, $3
ori $10, $10, 1
div $3, $10
slti $3, $3, 24095
bgez $10, label2
sll $18, $3, 2
ori $3, $0, 0
lbu $10, 6($3)
label2: xor $10, $3, $3
ori $10, $3, 58855
subu $18, $3, $3
bltz $18, label3
ori $3, $0, 0
sh $18, 0($3)
ori $18, $0, 0
lw $18, 0($18)
label3: add $10, $0, $3
ori $10, $0, 0
lw $10, 0($10)
bne $10, $18, label4
mthi $18
ori $10, $0, 0
sh $18, 10($10)
label4: nor $3, $18, $3
ori $10, $0, 0
sb $3, 3($10)
ori $10, $0, 0
sb $3, 12($10)
mult $10, $10
slt $3, $10, $3
srlv $10, $18, $10
or $3, $10, $3
xor $18, $18, $18
addiu $3, $3, -3537
srav $18, $3, $3
add $3, $0, $18
sltiu $10, $18, 21701
slti $3, $10, 18089
ori $3, $0, 0
lhu $10, 2($3)
add $3, $0, $18
ori $18, $0, 0
lw $18, 8($18)
ori $18, $0, 0
sh $3, 6($18)
ori $3, $0, 0
lw $10, 4($3)
addiu $18, $10, -8400
addiu $10, $10, -6609
mtlo $18
ori $3, $0, 0
sh $10, 2($3)
andi $10, $3, 937
nor $18, $10, $3
addi $10, $10, 0
sltiu $18, $10, -37
mfhi $18
ori $10, $0, 0
sb $18, 10($10)
nor $18, $3, $18
j label5
lui $10, 2168
nor $18, $3, $3
label5: ori $18, $0, 0
lbu $10, 2($18)
bne $18, $10, label6
addu $18, $18, $18
andi $3, $3, 59928
label6: lui $3, 22234
jal label7
ori $10, $0, 16
srlv $3, $18, $18
label7: addu $10, $10, $31
jalr $18, $10
nop
ori $10, $0, 0
lw $18, 0($10)
slt $3, $10, $18
andi $18, $10, 46673
srav $10, $10, $10
ori $10, $0, 0
sh $18, 2($10)
xor $3, $18, $10
xori $18, $18, 46611
sltu $3, $10, $10
srav $10, $18, $3
mtlo $18
ori $18, $0, 0
lbu $18, 13($18)
mthi $10
ori $3, $3, 1
div $3, $3
ori $18, $0, 0
lb $3, 3($18)
mflo $18
mfhi $18
xor $18, $18, $18
nor $10, $3, $18
sllv $18, $3, $3
sra $10, $10, 22
mflo $18
subu $3, $18, $3
ori $3, $0, 0
lh $3, 0($3)
j label8
slt $3, $10, $18
addiu $10, $18, 5971
label8: sub $18, $3, $3
ori $3, $0, 0
sw $18, 4($3)
ori $18, $0, 0
sh $3, 8($18)
srlv $10, $3, $10
nor $18, $10, $10
mthi $3
ori $3, $0, 0
sb $10, 2($3)
sltiu $10, $18, -17673
andi $18, $3, 17105
sub $10, $10, $10
ori $18, $0, 0
lb $3, 5($18)
nor $10, $3, $10
mtlo $18
ori $3, $0, 0
sw $18, 0($3)
sltu $3, $3, $18
mtlo $18
and $18, $18, $18
subu $10, $10, $10
xor $10, $10, $18
sra $10, $18, 24
mthi $3
slt $3, $3, $10
ori $18, $0, 0
lbu $10, 6($18)
bgez $10, label9
xori $10, $18, 18247
slti $18, $10, 19023
label9: addiu $18, $3, 7930
andi $18, $10, 21506
bgtz $3, label10
mthi $18
sra $10, $3, 6
label10: addi $10, $3, 0
ori $3, $0, 0
lh $3, 12($3)
ori $10, $0, 0
sh $18, 2($10)
ori $3, $0, 0
lh $10, 10($3)
srav $3, $3, $18
nor $3, $3, $10
nor $10, $18, $18
ori $10, $0, 0
lb $18, 14($10)
ori $3, $0, 0
lhu $3, 14($3)
beq $3, $3, label11
mult $10, $10
and $18, $3, $18
label11: nor $18, $10, $10
bltz $10, label12
and $3, $10, $10
sll $10, $10, 10
label12: addu $10, $18, $18
bgtz $18, label13
srav $10, $18, $10
nor $3, $10, $3
label13: srl $3, $3, 18
mthi $3
sll $10, $18, 1
jal label14
ori $3, $0, 16
mtlo $18
label14: addu $3, $3, $31
jr $3
nop
ori $10, $0, 0
sb $10, 15($10)
ori $10, $0, 0
lhu $18, 2($10)
ori $18, $0, 0
lhu $18, 0($18)
mflo $18
jal label15
ori $10, $0, 16
sllv $3, $18, $3
label15: addu $10, $10, $31
jalr $18, $10
nop
mthi $3
sllv $18, $10, $18
blez $18, label16
addi $18, $3, 0
ori $18, $0, 0
lh $18, 4($18)
label16: nor $18, $18, $3
add $18, $0, $3
subu $18, $10, $18
jal label17
ori $3, $0, 16
mflo $3
label17: addu $3, $3, $31
jalr $3, $3
nop
ori $10, $0, 0
lh $10, 12($10)
sra $10, $3, 22
bgez $18, label18
addiu $10, $3, 16451
nor $3, $3, $18
label18: srl $10, $3, 5
multu $3, $10
mult $3, $10
slt $10, $3, $3
ori $3, $3, 1
divu $18, $3
srl $18, $18, 1
bgez $10, label19
subu $18, $3, $10
srav $18, $3, $10
label19: ori $18, $0, 0
sw $18, 0($18)
bne $3, $3, label20
ori $10, $3, 5148
sltu $3, $10, $18
label20: addu $18, $3, $3
ori $18, $0, 0
sh $18, 10($18)
multu $10, $10
ori $3, $0, 0
sb $3, 14($3)
slt $18, $3, $10
ori $18, $0, 0
lhu $10, 2($18)
ori $10, $10, 1
divu $3, $10
sllv $18, $10, $10
sllv $10, $18, $10
ori $3, $0, 0
lbu $18, 3($3)
jal label21
ori $3, $0, 16
slt $10, $10, $18
label21: addu $3, $3, $31
jalr $3, $3
nop
ori $10, $0, 0
lw $10, 8($10)
sra $18, $3, 21
mfhi $3
j label22
sub $3, $10, $10
slt $10, $10, $3
label22: ori $3, $10, 64644
ori $3, $0, 0
sw $10, 12($3)
bltz $18, label23
andi $10, $18, 58676
mflo $18
label23: ori $10, $0, 0
lhu $3, 0($10)
bgtz $3, label24
mthi $3
sllv $10, $18, $18
label24: slt $18, $3, $10
addi $10, $18, 0
bne $18, $18, label25
and $3, $3, $10
ori $3, $3, 1
div $3, $3
label25: slt $3, $3, $18
mtlo $3
ori $18, $0, 0
sw $10, 12($18)
slt $10, $3, $18
subu $18, $3, $3
multu $10, $10
ori $3, $0, 0
lb $18, 1($3)
ori $3, $0, 0
lbu $3, 13($3)
ori $3, $0, 0
sh $18, 2($3)
addiu $3, $10, -31454
addi $10, $18, 0
ori $10, $0, 0
lb $3, 0($10)
j label26
srlv $10, $18, $10
lui $3, 10326
label26: ori $18, $0, 0
lw $10, 12($18)
sllv $10, $10, $18
ori $10, $0, 0
sb $10, 12($10)
and $3, $10, $10
ori $18, $0, 0
lhu $18, 14($18)
mult $3, $18
xor $18, $10, $10
bne $3, $10, label27
sll $10, $18, 6
ori $10, $0, 0
sw $18, 8($10)
label27: or $10, $18, $10
nor $18, $18, $10
mtlo $3
ori $3, $0, 0
sw $18, 0($3)
sll $3, $18, 22
sub $10, $3, $3
bgez $10, label28
ori $10, $0, 0
lw $3, 12($10)
mthi $18
label28: slti $18, $3, -8122
ori $18, $0, 0
lw $3, 4($18)
srlv $10, $18, $18
slt $3, $10, $3
bgtz $10, label29
subu $3, $18, $3
ori $18, $0, 0
sw $3, 8($18)
label29: add $3, $0, $10
sltiu $3, $10, 29384
lui $3, 11412
srlv $10, $18, $18
addi $18, $18, 0
slt $3, $18, $3
ori $18, $0, 0
lb $10, 1($18)
ori $18, $0, 0
lbu $18, 3($18)
srav $18, $18, $18
bgtz $3, label30
mtlo $18
ori $10, $0, 0
sh $18, 12($10)
label30: sltu $18, $3, $18
slti $3, $10, 7346
jal label31
ori $10, $0, 16
sllv $18, $18, $18
label31: addu $10, $10, $31
jr $10
nop
addiu $18, $3, -17909
beq $3, $3, label32
srl $3, $3, 13
subu $3, $10, $3
label32: sll $18, $3, 19
blez $3, label33
mtlo $10
addi $3, $3, 0
label33: ori $18, $18, 1
div $3, $18
sllv $3, $10, $10
multu $18, $3
bne $18, $18, label34
ori $10, $10, 1
divu $18, $10
addu $3, $10, $18
label34: or $3, $3, $10
ori $3, $0, 0
sh $3, 8($3)
srl $18, $18, 29
bne $10, $3, label35
ori $3, $0, 0
sw $3, 4($3)
mult $10, $3
label35: sltiu $10, $10, -30425
blez $10, label36
nor $18, $10, $10
addu $3, $10, $10
label36: ori $3, $0, 0
lhu $18, 8($3)
andi $10, $18, 27553
ori $10, $10, 1
div $10, $10
sub $10, $3, $3
and $3, $18, $3
xor $3, $18, $18
bltz $10, label37
sllv $10, $3, $3
slt $3, $10, $10
label37: srav $18, $18, $10
ori $3, $3, 1
divu $10, $3
sltu $3, $18, $18
mflo $18
slt $18, $18, $18
blez $10, label38
ori $3, $0, 0
lw $10, 8($3)
add $18, $0, $18
label38: subu $18, $3, $3
beq $18, $18, label39
addu $3, $3, $3
nor $3, $10, $10
label39: addiu $3, $18, 15487
sltu $18, $18, $10
mflo $18
multu $3, $10
xori $10, $10, 16272
andi $18, $10, 61581
mthi $3
ori $10, $0, 0
lw $10, 4($10)
bne $18, $18, label40
and $10, $10, $18
sra $10, $18, 30
label40: addu $3, $10, $18
srlv $18, $10, $18
lui $3, 3222
sltiu $18, $18, -30785
j label41
ori $10, $0, 0
lbu $18, 3($10)
nor $3, $3, $18
label41: sub $3, $3, $3
ori $18, $0, 0
sw $3, 4($18)
bne $18, $10, label42
srl $10, $18, 16
ori $3, $0, 0
lhu $10, 10($3)
label42: sra $3, $3, 13
sllv $3, $18, $10
mtlo $18
bgtz $10, label43
srav $10, $10, $18
add $18, $0, $10
label43: addu $3, $10, $18
ori $3, $0, 0
lb $18, 3($3)
blez $3, label44
mflo $10
sll $10, $18, 26
label44: lui $10, 7174
bgtz $18, label45
slt $3, $3, $3
ori $10, $0, 0
lbu $18, 7($10)
label45: add $3, $0, $18
add $10, $0, $10
jal label46
ori $18, $0, 16
subu $18, $18, $10
label46: addu $18, $18, $31
jr $18
nop
bgtz $18, label47
srl $10, $10, 2
ori $3, $0, 0
sh $3, 14($3)
label47: mflo $10
add $18, $0, $18
srav $3, $3, $3
slti $3, $10, 32664
srav $3, $18, $10
bltz $18, label48
srl $10, $10, 2
ori $18, $0, 0
lw $10, 4($18)
label48: ori $18, $0, 0
lbu $10, 0($18)
or $3, $3, $10
or $10, $18, $10
bgez $3, label49
srlv $3, $3, $10
subu $18, $3, $10
label49: xor $3, $3, $10
slti $10, $10, 1133
ori $3, $3, 61977
ori $10, $0, 0
lhu $10, 12($10)
sltiu $3, $3, -19589
slti $18, $10, 6142
bgez $3, label50
srl $18, $3, 20
ori $18, $3, 47713
label50: sra $3, $18, 30
ori $10, $0, 0
sb $18, 6($10)
xor $18, $18, $10
bne $18, $10, label51
mthi $18
srl $18, $10, 25
label51: ori $10, $0, 0
sw $18, 0($10)
beq $3, $18, label52
or $3, $18, $18
addi $18, $18, 0
label52: ori $18, $0, 0
lw $3, 4($18)
ori $10, $0, 0
sw $10, 4($10)
sltu $10, $18, $18
slt $18, $18, $3
bgez $10, label53
lui $18, 61535
mflo $10
label53: slt $10, $18, $3
jal label54
ori $18, $0, 16
nor $3, $3, $3
label54: addu $18, $18, $31
jalr $10, $18
nop
ori $18, $18, 1
div $10, $18
andi $18, $3, 14071
andi $3, $3, 11331
slt $10, $10, $10
lui $18, 48603
mfhi $3
ori $18, $0, 0
lbu $3, 0($18)
addiu $3, $10, 16780
ori $10, $0, 0
lw $18, 12($10)
addu $10, $3, $18
srav $3, $3, $18
add $18, $0, $18
xor $10, $18, $10
andi $10, $10, 21005
ori $3, $0, 0
lh $3, 4($3)
nor $10, $10, $10
ori $10, $0, 0
lb $3, 10($10)
ori $18, $18, 1
divu $3, $18
sll $3, $3, 23
nor $18, $10, $10
ori $18, $0, 0
lbu $18, 1($18)
ori $18, $0, 0
lh $18, 12($18)
mfhi $18
mult $10, $18
mflo $18
mult $3, $3
subu $3, $10, $10
xori $10, $10, 2566
jal label55
ori $18, $0, 16
nor $3, $3, $18
label55: addu $18, $18, $31
jalr $18, $18
nop
srlv $10, $10, $3
jal label56
ori $3, $0, 16
mflo $3
label56: addu $3, $3, $31
jr $3
nop
addi $10, $3, 0
ori $3, $0, 0
lw $10, 12($3)
nor $18, $18, $18
nor $18, $10, $18
bltz $3, label57
ori $10, $0, 0
lb $18, 6($10)
and $3, $3, $10
label57: ori $18, $0, 0
sw $3, 12($18)
srlv $3, $3, $3
bgez $3, label58
xori $18, $10, 10167
addiu $3, $3, -2929
label58: ori $18, $3, 43470
subu $10, $10, $10
jal label59
ori $18, $0, 16
add $3, $0, $10
label59: addu $18, $18, $31
jr $18
nop
sll $3, $18, 27
and $18, $3, $10
and $3, $10, $3
blez $18, label60
mfhi $3
or $3, $3, $10
label60: xori $18, $10, 46711
sltu $3, $3, $18
ori $10, $0, 0
lb $10, 10($10)
mtlo $10
add $18, $0, $10
subu $3, $3, $10
ori $10, $0, 0
lh $10, 0($10)
xori $3, $3, 30435
beq $18, $3, label61
mult $18, $18
srlv $18, $18, $10
label61: srav $10, $10, $3
jal label62
ori $18, $0, 16
subu $18, $18, $10
label62: addu $18, $18, $31
jr $18
nop
ori $3, $0, 0
sw $10, 12($3)
multu $18, $10
ori $18, $0, 0
sw $18, 4($18)
bgtz $18, label63
subu $10, $18, $10
ori $18, $0, 0
sw $10, 4($18)
label63: ori $3, $0, 0
sh $3, 8($3)
mthi $10
srav $10, $18, $3
mthi $10
bgtz $18, label64
slt $10, $3, $18
sltiu $18, $18, 3354
label64: sra $3, $18, 5
ori $10, $0, 0
lbu $3, 9($10)
ori $18, $0, 0
sw $3, 8($18)
lui $18, 11859
subu $3, $18, $3
ori $18, $0, 0
lw $10, 4($18)
bgtz $10, label65
addiu $3, $3, -8337
ori $18, $0, 0
lhu $3, 0($18)
label65: sll $18, $10, 1
slti $10, $10, 6052
ori $3, $0, 0
sb $18, 4($3)
bgtz $3, label66
ori $10, $10, 1
div $3, $10
srlv $3, $18, $10
label66: ori $18, $0, 0
sh $10, 14($18)
mult $3, $18
multu $3, $10
slti $3, $18, -526
ori $18, $0, 0
sb $10, 15($18)
xori $18, $3, 12519
ori $3, $0, 0
lb $3, 4($3)
bltz $18, label67
sllv $18, $10, $3
sllv $10, $10, $18
label67: sltu $3, $10, $3
mthi $3
jal label68
ori $10, $0, 16
mflo $18
label68: addu $10, $10, $31
jr $10
nop
mthi $3
sub $18, $18, $18
addi $18, $10, 0
addu $10, $3, $18
addi $18, $3, 0
bltz $10, label69
addi $3, $3, 0
srlv $3, $10, $3
label69: slt $10, $10, $3
bltz $18, label70
slt $10, $3, $18
sltiu $10, $3, -7918
label70: mfhi $3
slt $10, $10, $3
jal label71
ori $3, $0, 16
addiu $18, $18, -19339
label71: addu $3, $3, $31
jr $3
nop
xor $18, $3, $3
sll $3, $18, 23
ori $3, $0, 0
sw $3, 0($3)
mflo $3
srav $18, $18, $18
sllv $18, $18, $3
addiu $3, $3, -3031
ori $10, $10, 1
divu $3, $10
mflo $18
ori $3, $0, 0
sh $18, 4($3)
ori $10, $0, 0
sb $10, 6($10)
ori $10, $0, 0
sh $10, 0($10)
srav $10, $18, $3
xori $10, $10, 2272
blez $18, label72
sub $3, $18, $18
subu $3, $3, $3
label72: mult $18, $3
sll $10, $18, 15
andi $10, $3, 58129
or $18, $3, $3
ori $3, $0, 0
lh $3, 6($3)
bltz $10, label73
addi $18, $18, 0
mflo $10
label73: xori $3, $18, 27784
blez $10, label74
slti $3, $10, -9396
addu $3, $3, $3
label74: ori $18, $18, 54904
ori $18, $0, 0
lb $18, 5($18)
mthi $18
lui $18, 29998
blez $3, label75
addu $10, $18, $3
mtlo $3
label75: sltu $3, $3, $18
addiu $3, $10, -2980
ori $3, $0, 0
lw $3, 4($3)
mflo $10
mult $3, $18
sra $3, $10, 27
bltz $10, label76
slt $18, $3, $10
slti $3, $18, -8973
label76: sllv $3, $3, $3
lui $18, 15352
addi $18, $18, 0
bltz $18, label77
ori $18, $0, 0
lh $3, 12($18)
ori $18, $0, 0
lh $10, 4($18)
label77: multu $3, $3
addiu $3, $10, 26562
subu $18, $3, $18
add $10, $0, $10
sllv $10, $3, $10
ori $18, $0, 0
sw $10, 0($18)
andi $18, $18, 32398
ori $18, $0, 0
lhu $3, 10($18)
bltz $18, label78
mfhi $18
mtlo $18
label78: and $10, $3, $18
sra $18, $10, 14
ori $18, $18, 1
div $10, $18
mult $18, $3
sra $3, $18, 17
ori $10, $0, 0
lw $3, 0($10)
ori $10, $10, 1
divu $18, $10
sra $18, $10, 5
ori $3, $0, 0
sb $18, 14($3)
subu $3, $18, $10
mult $18, $10
ori $3, $0, 0
lb $10, 14($3)
sll $10, $18, 20
sra $3, $3, 14
mult $3, $3
srl $10, $3, 11
ori $18, $0, 0
lbu $18, 14($18)
xor $18, $10, $18
xor $10, $10, $18
xori $3, $3, 55447
multu $10, $18
ori $3, $0, 0
sb $3, 11($3)
mflo $18
multu $3, $10
sltiu $18, $18, 14501
slt $10, $3, $10
ori $10, $0, 0
lw $18, 8($10)
jal label79
ori $10, $0, 16
mult $3, $18
label79: addu $10, $10, $31
jr $10
nop
sltu $10, $3, $18
mfhi $18
sltu $18, $18, $10
lui $18, 45836
ori $18, $0, 0
sh $3, 14($18)
jal label80
ori $18, $0, 16
sltu $10, $3, $3
label80: addu $18, $18, $31
jr $18
nop
sltu $3, $10, $18
sllv $18, $10, $3
multu $3, $10
ori $10, $10, 1
div $18, $10
bgtz $18, label81
ori $3, $0, 0
lbu $10, 13($3)
ori $3, $0, 0
sb $3, 5($3)
label81: slti $3, $10, -25023
slti $3, $3, -12388
mflo $18
sltu $18, $18, $3
mfhi $18
jal label82
ori $10, $0, 16
sltu $18, $18, $3
label82: addu $10, $10, $31
jalr $18, $10
nop
ori $3, $0, 0
lw $3, 0($3)
bltz $3, label83
ori $10, $0, 0
lb $10, 8($10)
addi $10, $3, 0
label83: addiu $18, $10, -29950
slti $3, $3, -23286
ori $3, $0, 0
lb $10, 4($3)
ori $3, $3, 1
div $18, $3
mfhi $3
srav $18, $18, $3
mthi $3
ori $3, $0, 0
sw $10, 4($3)
srlv $18, $10, $18
slti $10, $3, -3696
addi $10, $10, 0
mfhi $10
addiu $18, $3, -10086
ori $18, $18, 1
divu $3, $18
beq $3, $10, label84
ori $18, $18, 1
div $3, $18
ori $18, $0, 0
sw $3, 0($18)
label84: sllv $18, $18, $3
srl $18, $3, 4
ori $10, $0, 0
lbu $10, 9($10)
jal label85
ori $10, $0, 16
sll $3, $10, 18
label85: addu $10, $10, $31
jr $10
nop
srl $3, $3, 17
ori $18, $0, 0
lh $18, 6($18)
mfhi $10
ori $18, $0, 0
lw $10, 8($18)
jal label86
ori $10, $0, 16
multu $10, $10
label86: addu $10, $10, $31
jalr $10, $10
nop
sll $18, $18, 1
mthi $10
j label87
multu $3, $10
ori $10, $3, 14772
label87: addu $3, $18, $18
srav $18, $18, $18
nor $10, $18, $3
multu $3, $18
mult $18, $3
bne $3, $3, label88
mtlo $3
ori $18, $18, 1
divu $10, $18
label88: ori $3, $0, 0
lhu $3, 6($3)
mult $10, $10
bgtz $3, label89
xori $18, $10, 39082
or $18, $10, $3
label89: ori $18, $0, 0
lw $3, 12($18)
