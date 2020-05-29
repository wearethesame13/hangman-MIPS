.data
	name: .space 11
	fileName: .asciiz"nguoichoi.txt"
	tb1: .asciiz"Nhap ten nguoi choi: "
	tb2: .asciiz"\nNhap diem: "
	tb3: .asciiz"\nNhap lan thang: "
	lenName: .word 0
	lenPoint: .word 0
	lennWin: .word 0
	point: .word 0
	nWin: .word 0
.text
	# Xuat tb1
	li $v0, 4
	la $a0, tb1
	syscall
	
	# Nhap ten
	li $v0, 8
	la $a0, name
	li $a1, 11
	syscall
	
	# Xuat tb2
	li $v0, 4
	la $a0, tb2
	syscall
	
	# Nhap point
	li $v0, 5
	syscall
	
	sw $v0, point
	
	# Xuat tb3
	li $v0, 4
	la $a0, tb3
	syscall
	
	# Nhap nWin
	li $v0, 5
	syscall
	
	sw $v0, nWin
	
	# truyen tham so
	# goi ham
	jal _export
	
	j Thoat

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
  
  Thoat:
  	li $v0, 10
  	syscall
