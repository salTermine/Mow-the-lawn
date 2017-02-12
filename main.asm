.text
################## MACROS #####################################

	.macro print_space		# Print Space
		li $v0, 11
		li $a0, ' '
		syscall 
	.end_macro

	.macro newline         		# Print New Line	
		li $v0, 4
		la $a0, nl
		syscall
	.end_macro
	
	.macro tab			# Print Tab
		li $v0, 4
		la $a0, tb
		syscall
	.end_macro
	
	.macro printstring(%x)		# Print String
		li $v0, 4		
		la $a0, %x
		syscall
	.end_macro

.globl main

main:

############ ARRAYFILL TEST CASE #############################

printstring(arrayFillString)
newline
la $a0, 0xFFFF0000
la $a1, map_1
li $a2, 0x5
jal arrayFill
move $t0, $v0
li $v0, 1
move $a0, $t0
syscall
########### FIND2BYTE TEST CASE ##############################

#printstring(find2ByteString)
#newline
#li $a0, 0xFFFF0000
#li $a1, 0x2B
#li $a2, 25
#li $a3, 80
#jal find2Byte

############### PLAY GAME ####################################

la $a0, 0xFFFF0000		# Memory Start Address
la $a1, map_1
li $a2, 0x5			# Total Memory Space
#jal arrayFill			# Load The Map

##############################################################

li $a0, 0xFFFF0000		# Memory Start Address
li $a1, 0x2B			# Symbol
li $a2, 25			# Number of Rows
li $a3, 80			# Number of Columns
#jal find2Byte			# Find Symbol

##############################################################

la $a0, 0xFFFF0000		# Memory Start Address
li $a1, -1			# Row Position
li $a2, -1			# Column Position
la $a3, moves			# String of moves
#jal playGame			# Play the Game

la $a0, 0xFFFF0000		# Memory Start Address
li $a1, -1			# Row Position
li $a2, -1			# Column Position
la $a3, moves			# String of moves
#jal playGame			# Play the Game

la $a0, 0xFFFF0000		# Memory Start Address
li $a1, 16			# Row Position
li $a2, 44			# Column Position
la $a3, moves			# String of moves
#jal playGame			# Play the Game

la $a0, 0xFFFF0000		# Memory Start Address
li $a1, -1			# Row Position
li $a2, -1			# Column Position
la $a3, moves			# String of moves
#jal playGame			# Play the Game

##############################################################
li $v0 10
#syscall
##############################################################

.data 

map_1: .asciiz "/Users/admin/Assembly/hw3/5bytes.map"
map_2: .asciiz "/Users/admin/Assembly/hw3/full_green.map"
map_3: .asciiz "/Users/admin/Assembly/hw3/landscape1.map"
map_4: .asciiz "/Users/admin/Assembly/hw3/landscape2.map"
map_5: .asciiz "/Users/admin/Assembly/hw3/partial_filled_green.map"
map_6: .asciiz "/Users/admin/Assembly/hw3/stripes.map"
map_7: .asciiz "/Users/admin/Assembly/hw3/stripes@.map"
map_8: .asciiz "/Users/admin/Assembly/hw3/extra.map"
arrayFillString: .asciiz "***** ArrayFill *****"
find2ByteString: .asciiz "***** Find2Byte *****"
playGameString: .asciiz "***** PlayGame *****"
fileInputMsg: 	.asciiz "Enter a file name: "
nl: .asciiz "\n"
tb: .asciiz "\t"
mapname: .ascii ""
mapBuff: .asciiz ""
moves: .asciiz "ddddddddddddddddddddddddddddddddddddddddddddd"

.include "hw3.asm"
