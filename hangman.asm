.data
	fileIn: .asciiz "tudien.txt"      # filename for input
	buffer: .space 1024
	numberOfWord: .word 0
	randNumb: .word 0
	tb1: .asciiz "Nhap ten nguoi choi: "
	name: .space 100
	curW: .space 20
	nW: .word 0
	arrW: .space 20 
	state: .word 0 
	nWin: .word 0
	state0: .asciiz "\n ______\n|     |\n|\n|\n|\n|\n"  
	state1: .asciiz "\n ______\n|     |\n|     0\n|\n|\n|\n"
	state2: .asciiz "\n ______\n|     |\n|     0\n|     |\n|\n|\n"
	state3: .asciiz "\n ______\n|     |\n|     0\n|    /|\n|\n"
	state4: .asciiz "\n ______\n|     |\n|     0\n|    /|\\\n|\n|\n"
	state5: .asciiz "\n ______\n|     |\n|     0\n|    /|\\\n|    /\n|\n|\n|\n"
	state6: .asciiz "\n ______\n|     |\n|     0\n|    /|\\\n|    / \\\n|\n|\n|\n"
	randNum: .word 0
	underScore: .asciiz "*"
	myGuessW: .space 20
	point: .word 0
	prompt:     .asciiz     "\nTu ban doan la: "
	dot:        .asciiz     "\n"
	eqmsg:      .asciiz     "\nBan da thang\n"
	nemsg:      .asciiz     "\nBan da thua\n"
	nhapmode: .asciiz "\nNhap che do choi theo tu[w] hay ki tu[c]: "
	str1:       .space      80
	str2:       .space      80
	modeword: .byte 'w'
	tbtt: .asciiz "\nChoi tiep? Yes[y]/No[n] (mac dinh la No): "
	
	tbG: .asciiz "Nhap ki tu: "
	tbThang: .asciiz "\nBan da chien thang"
	tbThua: .asciiz "\nBan da thua"
	
	fileName: .asciiz "nguoichoi.txt"
	lenName: .word 0
	lenPoint: .word 0
	lennWin: .word 0
	
	replay: .asciiz"\nBan co muon choi lai khong: 1. Co, 0. Khong"
	subSymbol: .asciiz"-"
.text
main:
	#li $v0,5
	#sw $v0,nW
	#syscall
	
	#li $v0,8
	#la $a0,curW
	#li $a1,10
	#syscall
	
	
	#li $v0,8
	#la $a0,arrW
	#li $a1,10
	#syscall

	#lw $a0,nW
	#la $a1,arrW
	#la $a2,curW
	#jal _printWord
	
	#li $v0,10
	#syscall

	jal _inputName
start:
	jal _mode
	
	jal _endPoint
	jal _export
	#reset point and nWin
	sw $0,point
	sw $0,nWin
	jal _continue
	
	li $v0,10
	syscall

_randWord: 

	addi $sp,$sp,-64
	sw $ra,($sp)
	sw $v0,4($sp)
	sw $a0,8($sp)
	sw $a1,12($sp)
	sw $a2,16($sp)
	sw $a3,20($sp)
	sw $s0,24($sp)
	sw $s6, 28($sp)
	sw $t0,32($sp)
	sw $t1,36($sp)
	#lay de trong file tudien.txt
	#open a file for writing
	li   $v0, 13       # system call for open file
	la   $a0, fileIn     # board file name
	li   $a1, 0        # Open for reading
	syscall            # open a file (file descriptor returned in $v0)
	move $s6, $v0      # save the file descriptor
	
	#read from file
	li   $v0, 14       # system call for read from file
	move $a0, $s6      # file descriptor
	la   $a1, buffer   # address of buffer to which to read
	li   $a2, 1024    # hardcoded buffer length
	syscall            # read from file

	# Close the file
	li   $v0, 16       # system call for close file
	move $a0, $s6      # file descriptor to close
	syscall            # close file
	
	

	lw $a1, nW
	la $a2, curW	
	la $a3, buffer
	la $t9, numberOfWord

	jal _randWord.FindNumberOfWord
	

	
	sw $t9,  numberOfWord

	jal _randWord.FindRandomNumber


	lw $a0, randNumb
	lw $a1, nW
	la $a2, curW	
	la $a3, buffer

	
	jal _randWord.FindRandomWord

	
	jal _getArrW
	
	lw $a0,nW
	la $a1,arrW
	la $a2,curW

	lw $ra,($sp)
	lw $v0,4($sp)
	lw $a0,8($sp)
	lw $a1,12($sp)
	lw $a2,16($sp)
	lw $a3,20($sp)
	lw $s0,24($sp)
	lw $s6, 28($sp)
	lw $t0,32($sp)
	lw $t1,36($sp)
	
	
	

	addi $sp,$sp,64

	jr $ra
	
	
	
	
_randWord.FindNumberOfWord:
	
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $t0,8($sp)
	sw $t1, 12($sp) 
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	sw $t4, 24($sp)
	
	move $s0, $a3
	li $t0, 0 #i = 0
	li $t1, '*'
	li $t2, '\r'
_randWord.FindNumberOfWord.Loop:
	lb $t3, ($s0)
	
	addi $s0, $s0, 1

	beq $t3, $t1, _randWord.FindNumberOfWord.Plus
	beq $t3, $t2, _randWord.FindNumberOfWord.End	
	j _randWord.FindNumberOfWord.Loop
	
_randWord.FindNumberOfWord.Plus:
	addi $t0, $t0, 1
	
	j _randWord.FindNumberOfWord.Loop
_randWord.FindNumberOfWord.End:	
	move $t9,$t0 

	lw $ra,($sp)
	lw $s0,4($sp)
	lw $t0,8($sp)
	lw $t1, 12($sp) 
	lw $t2, 16($sp)
	lw $t3, 20($sp)

	addi $sp,$sp, 32
	jr $ra

_randWord.FindRandomNumber:
	addi $v0, $zero, 30        # Syscall 30: System Time syscall
	syscall                  # $a0 will contain the 32 LS bits of the system time
	add $t0, $zero, $a0     # Save $a0 value in $t0 

	addi $v0, $zero, 40        # Syscall 40: Random seed
	add $a0, $zero, $zero   # Set RNG ID to 0
	add $a1, $zero, $t0     # Set Random seed to
	syscall
	lw $t0, numberOfWord
	addi $t0, $t0, 1
	addi $v0, $zero, 42        # Syscall 42: Random int range
	add $a0, $zero, $zero   # Set RNG ID to 0
	add $a1, $zero, $t0    # Set upper bound to 4 (exclusive)
	syscall                  # Generate a random number and put it in $a0
	sw $a0, randNumb
	jr $ra
_randWord.FindRandomWord:

	addi $sp,$sp,-64
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s2,8($sp) 
	sw $s3,12($sp) 
	sw $t0,16($sp)
	sw $t1, 20($sp)
	sw $t2, 24($sp)
	sw $t3, 28($sp)
	sw $t4, 32($sp)

	move $s0, $a0 #randNumb
	move $s2, $a2 #curW
	move $s3, $a3 #buffer

	li $t0, 0		
	li $t1, '*'
	li $t2, 0
	li $t4, '\r'
	
_randWord.FindRandomWord.Loop:
	beq $t0, $s0, _randWord.FindRandomWord.Found
	lb $t3, ($s3)
	addi $s3, $s3, 1
	beq $t3, $t1, _randWord.FindRandomWord.Plus
	j _randWord.FindRandomWord.Loop
_randWord.FindRandomWord.Plus:
	addi $t0, $t0, 1 #tang so thu tu tu
	j _randWord.FindRandomWord.Loop
_randWord.FindRandomWord.Found:
	
	lb $t3, ($s3)
	beq $t3, $t1, _randWord.FindRandomWord.End
	beq $t3, $t4, _randWord.FindRandomWord.End

	sb $t3,($s2)
	
	
	addi $s2, $s2, 1 #tang curW
	addi $s3, $s3, 1 #tang buffer
	addi $t2, $t2, 1 #tang nW
	j _randWord.FindRandomWord.Found
_randWord.FindRandomWord.End:
	
	
	sw $t2, nW

	#restore
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s2,8($sp) 
	lw $s3,12($sp) 
	lw $t0,16($sp)
	lw $t1, 20($sp)
	lw $t2, 24($sp)
	lw $t3, 28($sp)
	lw $t4, 32($sp)

	addi $sp,$sp,64
	jr $ra
_getArrW:
	#store
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1, 8($sp)
	sw $t0,12($sp)
	sw $t1,16($sp)
	
		

	la $s0, arrW
	lw $s1, nW
	li $t0, '0'	#gia tri
	li $t1, 0	#bien dem
	
_getArrW.Loop:
	sb $t0, ($s0)
	
	addi $s0, $s0, 1
	addi $t1, $t1, 1
	blt $t1, $s1, _getArrW.Loop


	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1, 8($sp)
	lw $t0,12($sp)
	lw $t1,16($sp)

	addi $sp,$sp,32
	jr $ra

	
	
_printWord:

	
	
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2, 12($sp)
	sw $t0,16($sp) 
	sw $t1, 20($sp)
	sw $t2, 24($sp)
	sw $t3, 28($sp)

	li $t0,0 # i = 0
	li $t1, '0'
	li $t2, '1'
	move $s0,$a0 #nW
	move $s1,$a1 #arrW
	move $s2, $a2 #curW
	
	
_printWord.Loop:
	lb $t3, ($s1)
	
	beq $t3, $t1, _printWord.Loop.printUnderScore
	beq $t3, $t2, _printWord.Loop.printCharacter
_printWord.Loop.printUnderScore: 
	li $v0, 11
	lb $a0, underScore
	syscall
	j _printWord.Loop.printCharacter.GoBack
_printWord.Loop.printCharacter:
	li $v0, 11
	lb $a0, ($s2)
	syscall
	j _printWord.Loop.printCharacter.GoBack

_printWord.Loop.printCharacter.GoBack:
	addi $t0,$t0,1	
	addi $s1,$s1,1
	addi $s2,$s2,1
	bne $t0,$s0, _printWord.Loop

	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $t0,16($sp)
	
	#xoa stack
	addi $sp,$sp,32
	# tra ve
	jr $ra

	
_printMan:
	addi $sp,$sp,-32

	sw $ra,($sp)
	sw $t1,4($sp)

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
	lw $ra,($sp)
	lw $t1,4($sp)
	
	#xoa stack
	addi $sp,$sp,32
	# tra ve
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

	#remove \n	
	li $s0,0               # Set index to 0
remove:
    lb $a3,name($s0)      # Load character at index
    addi $s0,$s0,1        # Increment index
    bnez $a3,remove    # Loop until the end of string is reached
    beq $a1,$s0,skip      # Do not remove \n when it isn't present
    subiu $s0,$s0,2     # Backtrack index to '\n'
    sb $0, name($s0)        # Add the terminating character in its place
skip:
	jr $ra


_mode:
	addi $sp,$sp,-4
	sw $ra,($sp)
_mode.continue:
	sw $0,state
	
	la $a0,nhapmode
	li $v0,4
	syscall
	
	
	
	li $v0, 12
	syscall
	lb $t1, modeword
	beq $v0, 'w', _Func_guessW
	beq $v0, 'c', _Func_guessC


_mode.exit:
	lw $ra, ($sp)
	addi $sp,$sp,4
	#li $v0,10
	#syscall
	jr $ra
_Func_guessW:
	#goi _randWord
	jal _randWord
	
	jal _guessW
	beq $v0,0, _mode.exit
	la      $a0,tbtt
	li      $v0,4
	syscall
	
	li $t0, 'y'
	li $v0, 12
	syscall
	
	beq $t0, $v0, _mode.continue
	j _mode.exit


_Func_guessC:
	
	jal _randWord
	jal _guessC
	beq $v0,0, _mode.exit
	la      $a0,tbtt
	li      $v0,4
	syscall
	
	li $t0, 'y'
	li $v0, 12
	syscall
	
	beq $t0, $v0, _mode.continue
	j _mode.exit


_guessW:
	addi $sp, $sp, -20
	sw $ra,($sp)
	sw $s2,4($sp)
	sw $s3,8($sp)
	sw $t6,12($sp)
	sw $t7,16($sp)
	
	li $v0,11
	li $a0,'\n'
	syscall
	
	lw $a0,nW
	la $a1,arrW
	la $a2,curW
	jal _printWord
   
	li $v0,11
	li $a0,'\n'
	syscall

	
    # get first string
    la $s2,curW
	
	#li $v0,4
	#la $a0, curW
	#syscall
	# special
	la $t6, curW
Special_Loop:
	lb $t7, ($t6)
	beqz $t7, Special
	addi $t6, $t6, 1
	j Special_Loop
Special:
	li $t7, '\n'
	sb $t7, ($t6)
	addi $t6, $t6, 1
	sb $0, ($t6)
	#debug
	#la $a0, curW
	#li $v0,4
	#syscall
    # get second string
    #la      $s3,str2
    #move    $t2,$s3
    #jal     getstr
    la $a0, myGuessW
    li $a1,20       # Max number of characters 20
    li $v0,8
    syscall         # Prompting User
        li $s0,0        # Set index to 0



    la $s3, myGuessW
	la $a0, curW
	li $v0,4
	syscall
    
    j cmploop
    

# string compare loop (just like strcmp)
cmploop:
    lb      $t2,($s2)                   # get next char from str1
    lb      $t3,($s3)                   # get next char from str2
    bne     $t2,$t3,cmpne               # are they different? if yes, fly

    beq     $t2,$zero,cmpeq             # at EOS? yes, fly (strings equal)

    addi    $s2,$s2,1                   # point to next char
    addi    $s3,$s3,1                   # point to next char
    j       cmploop

# strings are _not_ equal -- send message
cmpne:
    la      $a0,nemsg
    li      $v0,4
    syscall
    li $v0,0
    j	_guessW.exit

# strings _are_ equal -- send message
cmpeq:
    lw $s1, nW
    lw $s2, point
    add $s2,$s2,$s1
    sw $s2, point
    lw $s1,nWin
    addi $s1,$s1,1
    sw $s1,nWin
    la      $a0,eqmsg
    li      $v0,4
    syscall
    li $v0,1
    j _guessW.exit

_guessW.exit:
 li $s0,0        # Set index to 0
	remove2:
    lb $a3,curW($s0)    # Load character at index
    addi $s0,$s0,1      # Increment index
    bnez $a3,remove2     # Loop until the end of string is reached
    beq $a1,$s0,skip2    # Do not remove \n when string = maxlength
    subiu $s0,$s0,2     # If above not true, Backtrack index to '\n'
    sb $0, curW($s0)    # Add the terminating character in its place
    skip2:
	lw $ra,($sp)
	lw $s2,4($sp)
	lw $s3,8($sp)
	lw $t6,12($sp)
	lw $t7,16($sp)
	addi $sp,$sp,20
	jr $ra


_ktArrW: #KT arrW co bat het
	#stack
	subi $sp,$sp,24
	sw $ra,0($sp)
	sw $t0,4($sp)
	sw $t1,8($sp)
	sw $t2,12($sp)
	sw $t3,16($sp)
	sw $s0,20($sp)
	
	la $t0,arrW
	lw $s0,nW
	li $t1,0
	li $t2,1
_ktArrW.loop:
	bge $t1,$s0,_ktArrW.fin
	lb $t3,($t0)
	bne $t3,'0',_ktArrW.Con
	li $t2,0
_ktArrW.Con:
	addi $t0,$t0,1
	addi $t1,$t1,1
	j _ktArrW.loop
_ktArrW.fin:
	beq $t2,0,_ktArrW.con2
	li $v0,1
	j _ktArrW.end
_ktArrW.con2:
	li $v0,0
	_ktArrW.end:
	#unstack
	lw $ra,0($sp)
	lw $t0,4($sp)
	lw $t1,8($sp)
	lw $t2,12($sp)
	lw $t3,16($sp)
	lw $s0,20($sp)
	addi $sp,$sp,24
	jr $ra
	
_guessC:
	#stack
	subi $sp,$sp,32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $t0,8($sp)
	sw $t1,12($sp)
	sw $t2,16($sp)
	sw $t3,20($sp)
	sw $t4,24($sp)
	sw $t5,28($sp)
	
	#debug
	#li $v0,4
	#la $a0,curW
	#syscall
	
	lw $s0,nW #so luong ki tu
_guessC.Loop:
	#debug
	#li $v0,4
	#la $a0,arrW
	#syscall
	lw $a0,nW
	la $a1,arrW
	la $a2,curW
	jal _printWord
	jal _ktArrW
	la $t0,curW #tu 
	la $t1,arrW
	beq $v0,1,_guessC.Win
	lw $t3,state
	bge $t3,7,_guessC.Lose
	li $v0,11
	li $a0,'\n'
	syscall
	li $v0,4 #Thong bao doan
	la $a0,tbG
	syscall
	li $v0,12 #Doc ki tu
	syscall
	move $t4,$v0
	li $t2,0
	li $t5,0
_guessC.loop2:
	bge $t2,$s0,_guessC.fin2
	lb $t3,($t0) #doc ki tu tu mang
	bne $v0,$t3,_guessC.iCon #kiem tra
	li $t4,'1'
	sb $t4,($t1) #neu bang thi luu xuong arrW 1
	addi $t5,$t5,1
_guessC.iCon:
	addi $t0,$t0,1
	addi $t1,$t1,1
	addi $t2,$t2,1
	j _guessC.loop2
_guessC.fin2:
	
	
	bnez $t5,_guessC.true
	lw $t5,state
	addi $t5,$t5,1
	sw $t5,state
_guessC.true:
	jal _printMan
	j _guessC.Loop
_guessC.Win:
	li $v0,4
	la $a0,tbThang
	syscall
	lw $t0,point
	lw $t1,nW
	add $t0,$t0,$t1
	sw $t0,point
	lw $t0,nWin
	addi $t0,$t0,1
	sw $t0,nWin
	li $v0,1
	j _guessC.end
_guessC.Lose:
	li $v0,4
	la $a0,tbThua
	syscall
	li $v0,0
	sw $0,state
_guessC.end:
	
	#unstack
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $t0,8($sp)
	lw $t1,12($sp)
	lw $t2,16($sp)
	lw $t3,20($sp)
	lw $t4,24($sp)
	lw $t5,28($sp)
	addi $sp,$sp,32
	jr $ra
	
_export:
	# Dau thu tuc
	# Khai bao stack
	addi $sp, $sp, -56
	sw $ra, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $a0, 24($sp)
	sw $a1, 28($sp)
	sw $a2, 32($sp)
	sw $s0, 36($sp)
	sw $s1, 40($sp)
	sw $s2, 44($sp)
	sw $s5, 48($sp)
	sw $s6, 52($sp)
	
	# Tinh strlen cua name
	# khoi tao vong lap
	li $t1,0
    	la $t0, name
    	
dest_1:
    	lb   $a0,0($t0)
    	beqz $a0,done1
    	addi $t0,$t0,1
    	addi $t1,$t1,1
    	j dest_1
    	
done1:
    	# t1 chua strlen
 	sw $t1, lenName
 	
 	# Tinh strlen cua Point
 	# khoi tao vong lap
	li $t1,0
    	lw $t0, point
    	li $t2, 10
dest_2:
    	div $t0, $t2
    	mflo $t3
    	mfhi $t4
    	addi $t1, $t1, 1
    	move $t0, $t3
    	bne $t3, 0, dest_2
    	
	sw $t1, lenPoint
	
	# Tinh strlen cua nWin
 	# khoi tao vong lap
	li $t1,0
    	lw $t0, nWin
    	li $t2, 10
dest_3:
    	div $t0, $t2
    	mflo $t3
    	mfhi $t4
    	addi $t1, $t1, 1
    	move $t0, $t3
    	bne $t3, 0, dest_3
    	
	sw $t1, lennWin

	
	# Luu ten nguoi dung vao nguoichoi.txt
	# Open (for writing) a file that does not exist
 	li   $v0, 13       # system call for open file
  	la   $a0, fileName     # output file name
  	li   $a1, 9        # Open for writing (flags are 0: read, 1: write)
  	li   $a2, 0        # mode is ignored
  	syscall            # open a file (file descriptor returned in $v0)
  	move $s6, $v0      # save the file descriptor 
  ###############################################################
  	# Write to file just opened
  	li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	la   $a1, name   # address of buffer from which to write
  	lw $t1, lenName
 	move   $a2, $t1      # hardcoded buffer length
 	syscall            # write to file
 	
 	# Cap phat 1 byte de ghi "-"
	li $v0, 9
	li $a0, 1
	syscall
	move $s5, $v0
 	# Ghi dau "-"
 	li $t1, 45
 	sb $t1, ($s5)
 	
 	# Write "-" to file 
 	li   $v0, 15       
  	move $a0, $s6      
  	move   $a1, $s5   
 	li   $a2, 1     
 	syscall     
 	
 	# Cap phat 4 bytes cho $s0
 	li $v0, 9
 	li $a0, 4
 	syscall
 	move $s0, $v0
 	
	lw $s1, point
	li $s2, 10
 	addi $s0, $s0, 4
tachso:
 	addi $s0, $s0, -1
 	div $s1, $s2
 	mflo $t1
 	mfhi $t2
 	addi $t2, $t2, 48
 	sb $t2, 0($s0)
 	move $s1, $t1
 	bne $t1, 0, tachso
 	
 	
 	# Write Point
 	li   $v0, 15       
  	move $a0, $s6
  	move $a1, $s0
 	lw $t1, lenPoint
 	move $a2, $t1
 	syscall
 	
 	# Write "-" to file 
 	li   $v0, 15       
  	move $a0, $s6      
  	move   $a1, $s5   
 	li   $a2, 1     
 	syscall  


	# Write "nWin"
	# Cap phat 4 bytes cho $s0
 	li $v0, 9
 	li $a0, 4
 	syscall
 	move $s0, $v0
 	
	lw $s1, nWin
	li $s2, 10
 	addi $s0, $s0, 4
tachso1:
 	addi $s0, $s0, -1
 	div $s1, $s2
 	mflo $t1
 	mfhi $t2
 	addi $t2, $t2, 48
 	sb $t2, 0($s0)
 	move $s1, $t1
 	bne $t1, 0, tachso1
 	
 	# Write nWin
 	li   $v0, 15       
  	move $a0, $s6
  	move $a1, $s0
 	lw $t1, lennWin
 	move $a2, $t1
 	syscall
 	
 	# Write "*"
 	# Ghi dau "*"
 	li $t1, 42
 	sb $t1, ($s5)
 	
 	# Write "*" to file 
 	li   $v0, 15       
  	move $a0, $s6      
  	move   $a1, $s5   
 	li   $a2, 1     
 	syscall     
	
 	
  ###############################################################
  	# Close the file 
  	li   $v0, 16       # system call for close file
  	move $a0, $s6      # file descriptor to close
  	syscall            # close file
  ###############################################################
  
  # Cuoi thu tuc: Restore
  	lw $ra, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $a0, 24($sp)
	lw $a1, 28($sp)
	lw $a2, 32($sp)
	lw $s0, 36($sp)
	lw $s1, 40($sp)
	lw $s2, 44($sp)
	lw $s5, 48($sp)
	lw $s6, 52($sp)
  # Xoa stack
  	add $sp, $sp, 56
  	jr $ra
  	
_endPoint: 
	li $v0,11
	li $a0,'\n'
	syscall

	# In ten nguoi choi
	li $v0, 4
	la $a0, name
	syscall
	
	# In -
	li $v0, 4
	la $a0, subSymbol
	syscall
	
	# In Tong diem
	li $v0, 1
	lw $a0, point
	syscall
	
	# In -
	li $v0, 4
	la $a0, subSymbol
	syscall
	
	# In So luot thang
	li $v0, 1
	lw $a0, nWin
	syscall
	jr $ra

	
_continue:
	# Thong bao choi lai
	li $v0, 4
	la $a0, replay
	syscall
	
	# Nhap lua chon
	li $v0, 5
	syscall
	
	# Neu co thi -> mode
	beq $v0, 1, start
	
	# Ket thuc chuong trinh
	li $v0, 10
	syscall
	jr $ra
