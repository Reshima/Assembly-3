# who:  Rachael Shima
# what:  Lab3
		 # Lab3.asm
# why: Lab3 for cs264 
		 #stores an entered amount of integers in the stack
		 #sorts them in descending order
		 #prints them back out from the stack
# When: 13 May 2017
		 # 18 May 2017
		 
	.data
		Integers: .asciiz "How many integers would you like to store?: "
		line: .asciiz "\n"
		space: .asciiz " "
		Stack: .asciiz "Please enter an integer: "
		sort: .asciiz "Sorted Stack:"
	
		.text
		 .globl main

main:
			move $s8, $sp				#store stack
			
			la $a0, Integers			#display stack size prompt
			li $v0, 4					#print string
			syscall
		
			li $v0, 5					#read user integer
			syscall
		
			add $t0, $zero, $v0			#store the user integer in $t0
			li $t1, 0					#initialize loop counter
		
readloop:
			bgt $t1, $t0, print			#branch if stack is full

			la $a0, Stack				#ask user for values to put in the stack
			li $v0, 4					#print string
			syscall
			
			li $v0, 5					#read int 
			syscall
			
			move $t3, $v0				#store the user int
			addi $t1, $t1, 1			#incriment loop counter
			
			
subro:
			move $t5, $sp				#move $t5 to bottom of the stack
			move $t2, $sp				#move $t2 to bottom of the stack
			lw $t4, 0($t2)				#load the value of stack at index
			addi $sp, $sp, -4			#make room for integer
			bgt $t3, $t4, higher		#branch if stack needs to be rearranged
			sw $v0, 0($sp)				#store the int in the stack
			b readloop					#loop back to beginning
higher:
			sw $t4, 0($t5)				#move the smaller int down
			move $t5, $t2				#move $t5 up
			addi $t2, $t2, 4			#incriment $t2 to next int
			bgt $t2, $s8, store			#branch if the top of the stack is reached
			lw $t4, 0($t2)				#load the value of the next int for comparison
			blt $t3, $t4, store			#branch if next int is larger
			b higher					#loop
			
store:
			sw $t3, 0($t5)				#store the int at index
			b readloop					#loop back to top
			
print:
			la $a0, sort				#display sorted message
			li $v0, 4					#print string
			syscall
			
			move $t2, $s8				#move $t2 to top of the stack
printloop:
			la $a0, line				#start new line
			li $v0, 4					#print string
			syscall
			
			lw $a0, 0($t2)				#grab int from stack at index
			li $v0, 1					#print int
			syscall
			
			addi $t1, $t1, -1			#decremint counter
			addi $t2, $t2, -4			#decremint stack pointer
			beq $t1, 0, finish			#branch if stack is empty
			b printloop					#loop

finish:
			move $sp, $s8				#reset stack
			li $v0, 10					#terminate
			syscall