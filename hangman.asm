.data
	fileIn: .asciiz "tudien.txt"      # filename for input
	buffer: .space 10000
	tb1: .asciiz "Nhap ten nguoi choi: "
	name: .space 100
	curW: .space 20
	nW: .word 0
	arrW: .space 20 
	state: .word 0 
	state0: .asciiz "\n ______\n|     |\n|\n|\n|\n|\n"  
	state1: .asciiz "\n ______\n|     |\n|     0\n|\n|\n|\n"
	state2: .asciiz "\n ______\n|     |\n|     0\n|     |\n|\n|\n"
	state3: .asciiz "\n ______\n|     |\n|     0\n|    /|\n|\n"
	state4: .asciiz "\n ______\n|     |\n|     0\n|    /|\\\n|\n|\n"
	state5: .asciiz "\n ______\n|     |\n|     0\n|    /|\\\n|    /\n|\n|\n|\n"
	state6: .asciiz "\n ______\n|     |\n|     0\n|    /|\\\n|    / \\\n|\n|\n|\n"
	randNum: .word 0
	underScore: .asciiz "_"
.text
	jal _randWord
	li $v0,4
	la $a0,curW
	syscall
	
	li $v0,10 #end program
	syscall
	
	
_randWord: 
	#lay de trong file tudien.txt
	#open a file for writing
	li   $v0, 13       # system call for open file
	la   $a0, fin      # board file name
	li   $a1, 0        # Open for reading
	li   $a2, 0
	syscall            # open a file (file descriptor returned in $v0)
	move $s6, $v0      # save the file descriptor

	#read from file
	li   $v0, 14       # system call for read from file
	move $a0, $s6      # file descriptor
	la   $a1, buffer   # address of buffer to which to read
	li   $a2, 10000    # hardcoded buffer length
	syscall            # read from file

	# Close the file
	li   $v0, 16       # system call for close file
	move $a0, $s6      # file descriptor to close
	syscall            # close file

	la $a1,nW
	la $a2, curW	
	la $a3, buffer
	

	lw $a1, 10000
    	li $v0, 42  
    	syscall
    	add $a0, $a0, 0

	li $a1, 0
	li $t0, 0
	move $s0, $a0 #nW
	move $s1, $a1 #curW
	li $s2, '*'
	move $s3, $a3 #buffer
	
_randWord.FindStartPoint.Loop:	
	beq $t0, $a0, _randWord.FindStartPoint.Return
	addi $t0, $t0, 1
	addi $s3, $s3, 1 
	j _randWord.FindStartPoint.Loop
_randWord.FindStartPoint.Return: 
	
_randWord.FindFirstWord.Loop:
	lb $t1, ($s3)
	addi $s3, $s3, 1
	beq $t1, $s2, _randWord.FindFirstWord.Return
	j _randWord.FindFirstWord.Loop
_randWord.FindFirstWord.Return:
	
_randWord.FindCurrentWord.Loop:
	lb $t1, ($s3)
	addi $s3, $s3, 1
	beq $t1, $s2, _randWord.FindCurrentWord.Return
	sb $t1, ($s1)
	addi $s1, $s1, 1
	addi $s0, $s0, 1
	j _randWord.FindCurrentWord.Loop
_randWord.FindCurrentWord.Return:

_printWord:

	la $a0,nW
	la $a1,arrW
	la $a2, curW
	addi $sp,$sp,16
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2, 12($a2)
	sw $t0,16($sp) 

	li $t0,0 # i = 0
	move $s0,$a0 #nW
	move $s1,$a1 #arrW
	move $s2, $a2 #curW

	
_printWord.Loop:
	beq $a1, '0', _printWord.Loop.printUnderScore
	beq $a1, '1', _printWord.Loop.printCharacter
_printWord.Loop.printUnderScore: 
	li $v0, 4
	la $a0, underScore
	syscall
	j _GoBack
_printWord.Loop.printCharacter:
	li $v0, 4
	la $a0, ($s2)
	syscall
	j _GoBack
_GoBack:
	addi $t0,$t0,1	
	addi $s1,$s1,4
	addi $s2,$s2,4
	blt $t0,$s0, _printWord.Loop

	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $t0,12($sp)
	lw $t1,16($sp)
	
	#xoa stack
	addi $sp,$sp,32
	# tra ve
	jr $ra
	
_printMan:
	lw $t1, state
	beq $t1, 0, _printMan.State0
	beq $t1, 1, _printMan.State1
	beq $t1, 2, _printMan.State2
	beq $t1, 3, _printMan.State3
	beq $t1, 4, _printMan.State4
	beq $t1, 5, _printMan.State5
	beq $t1, 6, _printMan.State6
	j	_printMan.End
_printMan.State0:
	li $v0,4
	la $a0,state0
	syscall
	j _printMan.End
_printMan.State1:
	li $v0,4
	la $a0,state1
	syscall
	j _printMan.End
_printMan.State2:
	li $v0,4
	la $a0,state2
	syscall
	j _printMan.End
_printMan.State3:
	li $v0,4
	la $a0,state3
	syscall
	j _printMan.End
_printMan.State4:
	li $v0,4
	la $a0,state4
	syscall
	j _printMan.End
_printMan.State5:
	li $v0,4
	la $a0,state5
	syscall
	j _printMan.End
_printMan.State6:
	li $v0,4
	la $a0,state6
	syscall
_printMan.End:
	jr $ra
_inputName:
	#xuat thong bao nhap ten nguoi choi
	li $v0, 4
	la $a0, tb1
	syscall
	
	#nhap ten nguoi choi
	li $v0, 8
	la $a0, name
	li $a1, 11
	syscall
	
	 li $s0,0               # Set index to 0
remove:
    lb $a3,name($s0)      # Load character at index
    addi $s0,$s0,1        # Increment index
    bnez $a3,remove    # Loop until the end of string is reached
    beq $a1,$s0,skip      # Do not remove \n when it isn't present
    subiu $s0,$s0,2     # Backtrack index to '\n'
    sb $0, name($s0)        # Add the terminating character in its place
skip:

	
	
