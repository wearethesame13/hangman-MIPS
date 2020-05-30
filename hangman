.data
	curW: .space 20
	arrW: .space 20
	nW: .word 0
	point: .word 0
	state: .word 0
	tbG: .asciiz "Nhap ki tu: "
	tbThang: .asciiz "Ban da chien thang"
	tbThua: .asciiz "Ban da thua"
.text
	

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
	_ktArrW.fin:
	beq $t2,0,_ktArrW.con2
		li $v0,1
	_ktArrW.con2:
	li $v0,0
	
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
	subi $sp,$sp,28
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $t0,8($sp)
	sw $t1,12($sp)
	sw $t2,16($sp)
	sw $t3,20($sp)
	sw $t4,24($sp)
	
	la $t0,curW #tu 
	la $t1,arrW
	lw $s0,nW #so luong ki tu
	jal _ktArrW
	_guessC.Loop
	beq $v0,1,_guessC.Win
	lw $t3,state
	bge $t3,7,_guessC.Lose
	li $v0,4 #Thong bao doan
	la $a0,tbG
	syscall
	li $v0,12 #Doc ki tu
	syscall
	move $t4,$v0
	li $t2,0
	_guessC.loop2:
	bge $t2,$s0,_guessC.fin2
		lb $t3,($t0) #doc ki tu tu mang
		bne $t4,$t3,_guessC.iCon #kiem tra
			li $t4,'1'
			sw $t4,($t1) #neu bang thi luu xuong arrW 1
		_guessC.iCon:
		addi $t0,$t0,1
		addi $t1,$t1,1
		addi $t2,$t2,1
	j _guessC.loop2
	_guessC.fin2:
	jal _printMan #In ra trang thai
	jal _printWord #In ra tu
	j _guessC.Loop:
	_guessC.Win:
	li $v0,4
	la $a0,tbThang
	syscall
	li $v0,1
	j _guessC.end
	_guessC.Lose:
	li $v0,4
	la $a0,tbThua
	syscall
	li $v0,0
	_guessC.end:
	
	#unstack
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $t0,8($sp)
	lw $t1,12($sp)
	lw $t2,16($sp)
	lw $t3,20($sp)
	lw $t4,24($sp)
	addi $sp,$sp,28
	jr $ra
