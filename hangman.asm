    .data
    
name: .space 10 
curW: .space 20 
uGuess :.space 20 
nW: .word 3
arrW: .space 20 
point: .word 50 
state: .word 0 
nWin: .word 0 

prompt:     .asciiz     "Enter string ('.' to end) > "
dot:        .asciiz     "\n"
eqmsg:      .asciiz     "strings are equal\n"
nemsg:      .asciiz     "strings are not equal\n"
nhapmode: .asciiz "Nhap che do choi theo tu[w] hay ki tu[c]: "
str1:       .space      80
str2:       .space      80
modeword: .byte 'w'
tbtt: .asciiz "Keep playing? Yes[y]/No[n] (default is No): "
    .text

    .globl  main
main:
_mode:
	    #goi _randWord
    la $a0,nhapmode
    li $v0,4
    syscall

	li $v0, 12
	syscall
	lb $t1, modeword
	beq $v0, $t1, _Func_guessW
	bne $v0, $t1, _guessC
	

_mode.exit:
	li      $v0,10
	syscall
_Func_guessW:
	jal _guessW
	beq $v0,0, _mode.exit
	
	
	
	la      $a0,tbtt
    li      $v0,4
    syscall
    li $t0, 'y'
	li $v0, 12
	syscall
	beq $t0, $v0, _mode
	j _mode.exit
_guessW:
	addi $sp, $sp, -4
	sw $ra,($sp)
	
    # get first string
    la      $s2,str1
    move    $t2,$s2
    jal     getstr

    # get second string
    la      $s3,str2
    move    $t2,$s3
    jal     getstr
    
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
    

    
    la      $a0,eqmsg
    li      $v0,4
    
    
    syscall
    li $v0,1
    j _guessW.exit

# getstr -- prompt and read string from user
#
# arguments:
#   t2 -- address of string buffer
getstr:

	addi $sp, $sp, -8
	sw $ra,($sp)
	sw $t2, 4($sp)
    # prompt the user
    la      $a0,prompt
    li      $v0,4
    syscall

    # read in the string
    move    $a0,$t2
    li      $a1,79
    li      $v0,8
    syscall

    # should we stop?
    la      $a0,dot                     # get address of dot string
    lb      $a0,($a0)                   # get the dot value
    lb      $t2,($t2)                   # get first char of user string
    beq     $t2,$a0,getstr.exit                # equal? yes, exit program

                          # return
getstr.exit:
	lw $ra, ($sp)
	lw $t2, 4($sp)
	
	addi $sp, $sp, 8
	jr $ra
_guessW.exit:
lw $ra, ($sp)
addi $sp,$sp,4
jr $ra

# exit program
exit:
_guessC:

