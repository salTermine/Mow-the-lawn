################################################################
# Homework #3
# name: SALVATORE TERMINE
# sbuid: 109523648
################################################################

.text

	.macro  contents  (%a  %b)
		
	.end_macro
	
	.macro collision %a %b
		
	.end_macro

################################################################
# Part 1 FUNCTION
# Open the file and read in data from the file byte by byte,
# storing each byte into memory starting at address of the array
# arr. The number of bytes read from the file should not exceed
# maxBytes. Close the file prior to returning. 
# @param arr Base address of the array in memory.
# @param filename Address of filename in memory.
# @param maxBytes Maximum number of bytes to read from the file
# into memory.
# @return int Return the number of bytes read from the file and
# stored in memory. -1 if an error occurs (ie. can't open file.
################################################################

arrayFill:
	move $t0, $a0		# Memory Address
	move $t1, $a1		# File Name
	move $t2, $a2		# Memory Space
	addi $t3, $zero, 0	# Counter
	
	# Open File
	li $v0, 13       
	la $a0, 0($t1)     
	li $a1, 0        
	li $a2, 0
	syscall            
	move $s0, $v0      	# File Descriptor
	blt $v0, 0, error	# Error
	
	# Read File
	move $a1, $t0   	# Memory Address
	li $a2, 1		# Number of Bytes to Read
loop:				# Loop to read Byte By Byte
	li $v0, 14       	
	move $a0, $s0      	# Move File Descriptor
	syscall
	beqz $v0, exit		# If v0 = 0 exit
	bgt $t3, $t2, exit	# If Counter is greater then memory space exit
	addi $a1, $a1,1		# Add 1 to memory address
	addi $t3, $t3, 1	# Add 1 to counter
	j loop

exit:
	# Close File 
	li $v0, 16       
	move $a0, $s0      
	syscall
	move $v0, $t3
	jr $ra            
error:
	li $v0 -1
	jr $ra
	
################## FIND2BYTE ##################################
# Calculate the row and column for the first occurrence of the
# 2-byte value in arr[row][column]. 
# @param arr Base address of the array in memory.
# @param value The 2-byte value to search for in the array.
# @param row The number of rows in the array.
# @param column The number of columns in the array. 
# @return x The row in the array where the value was located.
# -1 if not found.
# @return y The column in the array where the value was located.
# -1 if not found.
###############################################################

find2Byte:
	move $t0, $a0		# Array Address 0xFFFF0000
	move $t1, $a1		# Symbol to look for
	move $t2, $a2		# # of rows
	move $t3, $a3		# # of columns
	
	addi $t4, $zero, 0	# i = 0
 	addi $t5, $zero, 0	# j = 0
	j loopInner
loopOutter:
	addi $t4,$t4,1		# Add 1 to i
	addi $t5,$zero, 0	# Reset j = 0
	bne $t4,$t2, loopInner	# if i = 25 exit
	j notFound			

loopInner:
	# Row major order base address + (i * 80 * 2) + (j * 2)
	mul $t6, $t4, $t3	# multiply i x columns
	sll $t6, $t6,1		# multiply by 2
	sll $t7, $t5,1		# multiply by 2
	add $t8, $t6, $t7	# add prev 2
	add $t9, $t8, $t0	# add to base address
	lb $t9, 0($t9)
	beq $t9, $t1, done2
	addi $t5, $t5, 1
	bne $t5, $t3, loopInner
	j loopOutter
notFound:
	addi $t4, $zero, -1
	addi $t5, $zero, -1
	j done2
done2:
	move $v0, $t4
	move $v1, $t5
	jr $ra
	
#############################################################
# PART 2/3 FUNCTION
# Play the lawn mower game. The mower is at position
# (start_r, start_c). Move the lawn mower according to
# each character in moves string. 
# @param A Base address of the memory array.
# @param start_r The row of the mower.
# @param start_c The column of the mower.
# @param moves Address of string of characters for moves.
############################################################
playGame:
	addi $sp, $sp, -24		# Save whats in S Reg
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
	
	blt $s1, -1, done3		# Exit if Row is less then -1
	blt $s2, -1, done3		# Exit if Column is less then -1
	bgt $s1, 24, done3		# Exit if Row is > then 24
	bgt $s2, 79, done3		# Exit if Column is > then 79
	beq $s1, -1, startMower 	# If -1 then startMower
	beq $s2, -1, startMower 	# If -1 then startMower
	j start
##############################################################
startMower:
	lw $s4, currentPosition		# Load last position $s4
	beqz $s4, defaultStart		# If 0 then this is first time go to default
	sub $t3, $s4, $s0 		# Otherwise place mower
	li $t2, 80
	sll $t2, $t2, 1
	div $t3, $t2 
	mfhi $s2 
	srl $s2, $s2, 1
	mflo $s1 
	j nextMove
##############################################################
defaultStart:	
	li $s1, 24 			# Default Row Position
	li $s2, 79 			# Default Column Position
	move $a0, $s0			# Move Arguments
	move $a1, $s1
	move $a2, $s2
	jal contents			# Calculate Address
	li $t0, 0x2F2B 			# Load Mower
	lh $t2, 0($v0)			# Load whats at calc'd address
	andi $t3, $t2, 0xFF20		# And it with FF20
	la $t4, cell			# Load cell into t4
	sh $t3, 0($t4)			# Save t3 in t4
	move $s4, $v0			# Move 
	sh $t0, 0($s4) 
	j nextMove
###############################################################
start:
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
################################################################
up:
	addi $s1, $s1, -1
	blt $s1, $zero, upDown
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal collision
	beqz $v0, setUp
	la $t2, cell
	lh $t1, 0($t2)
	andi $t1,$t1, 0xFF20
	ori $t1, $t1, 0x8000 
	sh $t1, 0($s4)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal contents
	lh $t1, 0($v0)
	la $t2, cell
	sh $t1, 0($t2)
	li $t0, 0x2F2B
	sh $t0, 0($v0)
	move $s4, $v0 
	li $a0, 500
	li $v0, 32
	syscall
	addi $s3, $s3, 1 
	j nextMove
	setUp:
		addi $s1, $s1, 1
		addi $s3, $s3, 1
		j nextMove
upDown:
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal collision
	beqz $v0, setUpDown
	addi $s1, $s1, 25
	la $t2, cell
	lh $t1, 0($t2)
	andi $t1,$t1, 0xFF20
	ori $t1, $t1, 0x8000 
	sh $t1, 0($s4)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal contents
	lh $t1, 0($v0)
	la $t2, cell
	sh $t1, 0($t2)
	li $t0, 0x2F2B
	sh $t0, 0($v0)
	move $s4, $v0 
	li $a0, 500
	li $v0, 32
	syscall
	addi $s3, $s3, 1 
	j nextMove
	setUpDown:
		addi $s1, $s1, 1
		addi $s3, $s3, 1
		j nextMove
################################################################
down:
	addi $s1, $s1, 1
	bgt $s1, 24, downUp
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal collision
	beqz $v0, setDown
	la $t2, cell
	lh $t1, 0($t2)
	andi $t1,$t1, 0xFF20
	ori $t1, $t1, 0x8000 
	sh $t1, 0($s4)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal contents
	lh $t1, 0($v0)
	la $t2, cell
	sh $t1, 0($t2)
	li $t0, 0x2F2B
	sh $t0, 0($v0)
	move $s4, $v0 
	li $a0, 500
	li $v0, 32
	syscall
	addi $s3, $s3, 1 
	j nextMove
	setDown:
		addi $s1, $s1, -1
		addi $s3, $s3, 1
		j nextMove

downUp:
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal collision
	beqz $v0, setDownUp
	addi $s1, $s1, -25
	la $t2, cell
	lh $t1, 0($t2)
	andi $t1,$t1, 0xFF20
	ori $t1, $t1, 0x8000 
	sh $t1, 0($s4)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal contents
	lh $t1, 0($v0)
	la $t2, cell
	sh $t1, 0($t2)
	li $t0, 0x2F2B
	sh $t0, 0($v0)
	move $s4, $v0 
	li $a0, 500
	li $v0, 32
	syscall
	addi $s3, $s3, 1 
	j nextMove
	setDownUp:
		addi $s1, $s1, -1
		addi $s3, $s3, 1
		j nextMove
################################################################
left:
	addi $s2, $s2, -1
	blt $s2, $zero, leftRight
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal collision
	beqz $v0, setLeft
	la $t2, cell
	lh $t1, 0($t2)
	andi $t1,$t1, 0xFF20
	ori $t1, $t1, 0x8000 
	sh $t1, 0($s4)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal contents
	lh $t1, 0($v0)
	la $t2, cell
	sh $t1, 0($t2)
	li $t0, 0x2F2B
	sh $t0, 0($v0)
	move $s4, $v0 
	li $a0, 500
	li $v0, 32
	syscall
	addi $s3, $s3, 1 
	j nextMove
	setLeft:
		addi $s2, $s2, 1
		addi $s3, $s3, 1
		j nextMove
###############################################################
leftRight:
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal collision
	beqz $v0, setLeftRight
	addi $s2, $s2, 80			# TONY WAS HERE
	la $t2, cell
	lh $t1, 0($t2)
	andi $t1,$t1, 0xFF20
	ori $t1, $t1, 0x8000 
	sh $t1, 0($s4)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal contents
	lh $t1, 0($v0)
	la $t2, cell
	sh $t1, 0($t2)
	li $t0, 0x2F2B
	sh $t0, 0($v0)
	move $s4, $v0 
	li $a0, 500
	li $v0, 32
	syscall
	addi $s3, $s3, 1
	j nextMove
	setLeftRight:
		addi $s2, $s2, 1
		addi $s3, $s3, 1
		j nextMove
	
################################################################
right:
	addi $s2, $s2, 1
	bgt $s2, 79, rightLeft
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal collision
	beqz $v0, setRight
	la $t2, cell
	lh $t1, 0($t2)
	andi $t1,$t1, 0xFF20
	ori $t1, $t1, 0x8000 
	sh $t1, 0($s4)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal contents
	lh $t1, 0($v0)
	la $t2, cell
	sh $t1, 0($t2)
	li $t0, 0x2F2B
	sh $t0, 0($v0)
	move $s4, $v0 
	li $a0, 500
	li $v0, 32
	syscall
	addi $s3, $s3, 1
	j nextMove
	setRight:
		addi $s2, $s2, -1
		addi $s3, $s3, 1
		j nextMove
################################################################
rightLeft:
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal collision
	beqz $v0, setRightLeft
	addi $s2, $zero, 0			
	la $t2, cell
	lh $t1, 0($t2)
	andi $t1,$t1, 0xFF20
	ori $t1, $t1, 0x8000 
	sh $t1, 0($s4)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal contents
	lh $t1, 0($v0)
	la $t2, cell
	sh $t1, 0($t2)
	li $t0, 0x2F2B
	sh $t0, 0($v0)
	move $s4, $v0 
	li $a0, 500
	li $v0, 32
	syscall
	addi $s3, $s3, 1
	j nextMove
	setRightLeft:
		addi $s2, $s2, -1
		addi $s3, $s3, 1
		j nextMove
################################################################
nextMove:
	lb $t0, 0($s3)
	beqz $t0, done3
	beq $t0, 0x77, up
	beq $t0, 0x73, down
	beq $t0, 0x61, left
	beq $t0, 0x64, right		      # Tony loves jared
	addi $s3, $s3, 1 
	j nextMove
################################################################
contents:
	li $t0, 80 
	mul $t1, $t0, $a1 
	sll $t1, $t1, 1
	sll $a2, $a2, 1 
	add $t0, $a2, $t1 
	add $v0, $a0, $t0 
	jr $ra
################################################################
collision:
	li $t0, 80 
	mul $t1, $t0, $a1 
	sll $t1, $t1, 1
	sll $a2, $a2, 1 
	add $t0, $a2, $t1 
	add $t0, $a0, $t0
	lhu $t0, 0($t0)
	beq $t0, 0x7F52, isCollision	# Rock
	beq $t0, 0x4F20, isCollision	# Water
	beq $t0, 0x2F5E, isCollision	# Tree
	beq $t0, 0x3F20, isCollision	# Dirt
	li $t1, 0xB06F			# Flowers
	beq $t0, $t1, isCollision
	addi $v0, $v0, 1
	j isGood
isCollision:
	addi $v0, $zero, 0
isGood:
	jr $ra
################################################################
done3:
	sw $s4, currentPosition
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	jr $ra
##############################################################################
#extraCredit


###############################################################################

.data
x: .word 24
y: .word 79
cell: .space 4
currentPosition: .space 0
#extraCredit: .asciiz "O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è ˇ O O O O O O O O  è è                                                                   è è ˇ O O O O O O O O  è è O O O ? ? ? ? ? ? ? ? ? ? ? O O ? ? ? ? ? ? ? ? ? ? ? O O ? ? ? ? ? ? ? ? ? ? ? ? O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O ? O O O O O O O O O O O O ? O O O O O O O O O O O O ? O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O ? O O O O O O O O O O O O ? O O O O O O O O O O O O ? O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O ? O O O O O O O O O O O O ? O O O O O O O O O O O O ? O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O ? O O O O O O O O O O O O ? ? ? ? ? ? ? ? ? ? ? O O ? ? ? ? ? ? ? ? ? ? ? O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O ? O O O O O O O O O O O O O O O O O O O O O O ? O O ? O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O ? O O O O O O O O O O O O O O O O O O O O O O ? O O ? O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O ? O O O O O O O O O O O O O O O O O O O O O O ? O O ? O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O ? O O O O O O O O O O O O O O O O O O O O O O ? O O ? O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O ? O O O O O O O O O O O O O O O O O O O O O O ? O O ? O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O ? ? ? ? ? ? ? ? ? ? ? O O ? ? ? ? ? ? ? ? ? ? ? O O ? ? ? ? ? ? ? ? ? ? ? O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O / / / / / / O O O / / / / / / O O O / / / / / / O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O O O O O / O O O O O O O O / O O O / O O O O O O / O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O O O O / O O O O O O O O / O O O O / O O O O O O / O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O O O / O O O O O O O O / O O O O O / O O O O O O / O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O O / / / / / O O O / / / / / / O O O / / / / / / O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O  è è ˇ O O O O O O O O  è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è è ˇ O O O O O O O O                                                                        O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O O"
