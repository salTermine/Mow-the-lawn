playGame:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	
	move $s0, $a0 			# Base Memory Address 
	move $s1, $a1 			# Row
	move $s2, $a2 			# Column
	move $s3, $a3 			# Moves
	move $s4, $zero 		# Mower Position
	
	blt $s1, -1, done3
	blt $s2, -1, done3
	bgt $s1, 24, done3
	bgt $s2, 79, done3
	beq $s1, -1, startMower 
	beq $s2, -1, startMower 
	j start
##############################################################
startMower:
	lw $s4, position 
	beqz $s4, default
	sub $t3, $s4, $s0 
	li $t2, 160
	div $t3, $t2 
	mfhi $s2 
	srl $s2, $s2, 1
	mflo $s1 
	j nextMove
############################################################### 
default:
	li $s1, 24 
	li $s2, 79 
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal contents
	li $t0, 0x2F2B 
	lh $t2, 0($v0)
	andi $t3, $t2, 0xFF20
	la $t4, cell
	sh $t3, 0($t4)
	move $s4, $v0
	sh $t0, 0($s4) 
	j nextMove
###############################################################
start:
	jal contents
	move $s4, $v0
	lh $t4, 0($v0)
	la $t2, cell
	andi $t3, $t4, 0xFF20
	sh $t3, 0($t2)
###############################################################
nextMove:
	lb $t0, 0($s3)
	beqz $t0, done3
	beq $t0, 0x77, up
	beq $t0, 0x73, down
	beq $t0, 0x61, left
	beq $t0, 0x64, right
	addi $s3, $s3, 1 
	j nextMove
######################################################################
right:
	addi $s2, $s2, 1 
	move $t0, $s2
	beq $s2, 80, rightToLeft
	j goRight
rightToLeft:
	addi $t0, $s2, -80
goRight:
	li $t9, 80 
	li $t8, -80 
	bnez $v0, rightLeft
	addi $s2, $s2, -1 
	addi $s3, $s3, 1 
	j nextMove
####################################################################### 
left:
	addi $s2, $s2, -1 
	move $t0, $s2
	beq $s2, -1, leftToRight
	j goLeft
leftToRight:
	addi $t0, $s2, 80
goLeft:
	li $t9, -1 
	li $t8, 80 
	bnez $v0, leftRight
	addi $s2, $s2, 1 
	addi $s3, $s3, 1 
	j nextMove 
#######################################################################	
up:
	addi $s1, $s1, -1 
	move $t0, $s1
	beq $s1, -1, upToDown
	j goUp
upToDown:
	addi $t0, $s1, 25
goUp:
	li $t9, -1 
	li $t8, 25 
	bnez $v0, upDown
	addi $s1, $s1, 1 
	addi $s3, $s3, 1 
	j nextMove 
####################################################################	
down:
	addi $s1, $s1, 1 
	move $t0, $s1
	beq $s1, 25, downToUp
	j goDown
downToUp:
	addi $t0, $s1, -25
goDown:
	li $t9, 25 
	li $t8, -25 
	bnez $v0, downUp
	addi $s1, $s1, -1 
	addi $s3, $s3, 1 
	j nextMove
#####################################################################
rightLeft:
	addi $s3, $s3, 1 
	beq $s2, $t9, returnOtherSide
	la $t2, cell
	lh $t1, 0($t2)
	andi $t1,$t1, 0xFF20
	ori $t1, $t1, 0x8020 
	sh $t1, 0($s4)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal contents
	lh $t1, 0($v0)
	la $t2, cell
	sh $t1, 0($t2)
	li $t0, 0x2f2b
	sh $t0, 0($v0)
	move $s4, $v0 
	li $a0, 500
	li $v0, 32
	syscall
	j nextMove
#####################################################################
leftRight:
	addi $s3, $s3, 1 
	beq $s2, $t9, returnOtherSide
	la $t2, cell
	lh $t1, 0($t2)
	andi $t1,$t1, 0xFF20
	ori $t1, $t1, 0x8020 
	sh $t1, 0($s4)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal contents
	lh $t1, 0($v0)
	la $t2, cell
	sh $t1, 0($t2)
	li $t0, 0x2f2b
	sh $t0, 0($v0)
	move $s4, $v0 
	li $a0, 500
	li $v0, 32
	syscall
	j nextMove
############################################################################
returnOtherSide:
	add $s2, $s2, $t8 
	lh $t2, cell
	andi $t1,$t1, 0xff20
	ori $t2, $t2, 0x8000 
	sh $t2, 0($s4)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal contents
	lh $t1, 0($v0)
	la $t2, cell
	sh $t1, 0($t2)
	li $t0, 0x2f2b
	sh $t0, 0($v0)
	move $s4, $v0 
	li $a0, 500
	li $v0, 32
	syscall
	j nextMove
#############################################################################
upDown:
	addi $s3, $s3, 1 
	beq $s1, $t9, returnOtherSideUpDown
	la $t2, cell
	lh $t1, 0($t2)
	andi $t1,$t1, 0xff20
	ori $t1, $t1, 0x8000 
	sh $t1, 0($s4)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal contents
	lh $t1, 0($v0)
	la $t2, cell
	sh $t1, 0($t2)
	li $t0, 0x2f2b
	sh $t0, 0($v0)
	move $s4, $v0 
	li $a0, 500
	li $v0, 32
	syscall
	j nextMove
#############################################################################
downUp:
	addi $s3, $s3, 1 
	beq $s1, $t9, returnOtherSideUpDown
	la $t2, cell
	lh $t1, 0($t2)
	andi $t1,$t1, 0xff20
	ori $t1, $t1, 0x8000 
	sh $t1, 0($s4)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal contents
	lh $t1, 0($v0)
	la $t2, cell
	sh $t1, 0($t2)
	li $t0, 0x2f2b
	sh $t0, 0($v0)
	move $s4, $v0 
	li $a0, 500
	li $v0, 32
	syscall
	j nextMove
#############################################################################
returnOtherSideUpDown:
	add $s1, $s1, $t8 
	lh $t2, cell
	andi $t1,$t1, 0xff20
	ori $t2, $t2, 0x8000 
	sh $t2, 0($s4)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal contents
	lh $t1, 0($v0)
	la $t2, cell
	sh $t1, 0($t2)
	li $t0, 0x2f2b
	sh $t0, 0($v0)
	move $s4, $v0 
	li $a0, 500
	li $v0, 32
	syscall
	j nextMove
#############################################################################
contents:
	li $t0, 80 
	mul $t1, $t0, $a1 
	sll $t1, $t1, 1
	sll $a2, $a2, 1 
	add $t0, $a2, $t1 
	add $v0, $a0, $t0 
	jr $ra
#############################################################################
done3:
	sw $s4, position
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	jr $ra
##############################################################################