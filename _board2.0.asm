.data
	fin: .asciiz "D:/nguoichoi.txt"
	ins: .asciiz "\n "
	tb1: .asciiz "Top 10 diem cao nhat \n"
	list: .space 1024
	Score: .word 20
	GetScore: .space 100
	Stt: .word 20
	soNguoiChoi: .word 0
	infoPlayer: .space 20
	
	
.text
	jal _board

	li $v0,10
	syscall	
_board:
	addi $sp,$sp,-32
	sw $ra,($sp)
	
	li $v0,4
	la $a0,tb1
	syscall

	#openfile
	li $v0,13
	la $a0,fin
	li $a1,0
	li $a2,0
	syscall

	#Luu dia chi file vao $s0
	move $s0,$v0

	#Doc file
	li $v0,14
	move $a0,$s0
	la $a1,list
	li $a2,1000
	syscall
	

	#Lay diem tu chuoi va push stt vao list stt
	la $s0,list
	la $s1,GetScore
	#la $s2,Stt
	li $t0,1
Getscore:
	lb $t1,($s0)
	beq $t1,'\n',out1	#Neu doc den cuoi chuoi thi dung lai
	beq $t1,'-',checkScoreOrMatch	#Doc duoc dau - thi kiem tra xem phia sau la diem so hay so man choi win
	addi $s0,$s0,1
	j Getscore

checkScoreOrMatch:
	addi $s0,$s0,1	#Tang dia chi mang len de doc 
	lb $t1,($s0)
	beq $t1,'-',getscorenext	#Neu byte doc duoc la - thi out ra va doc tiep 

					#Doc ky tu thuoc diem so ra va store vao chuoi chua diem so
	sb $t1,($s1)
	addi $s1,$s1,1
	j checkScoreOrMatch

getscorenext:
	addi $t0,$t0,1
	li $t7,'*'
	sb $t7,($s1)
	addi $s1,$s1,1
	addi $s0,$s0,5		#Tang dia chi chuoi list
	j Getscore
out1:
	sub $t0,$t0,1
	sw $t0,soNguoiChoi	#In so nguoi choi dem duoc vao bien soNguoiChoi

	la $a0,GetScore
	li $v0,4
	syscall
	la $s3,Stt
	lw $t0,soNguoiChoi
	li $t1,1
pushStt:			#Dua cac gia tri stt tuong ung vao mang Stt 
	sw $t1,($s3)
	addi $t1,$t1,1
	bgt $t1,$t0,out2
	addi $s3,$s3,4
	j pushStt

out2:

	#Chuyen doi chuoi diem thanh so nguyen de so sanh
	la $s1,GetScore
	la $s3,Score
	

convert:
	li $a0,-1
	li $a1,-1
	li $a2,-1
	lb $a0,($s1)	 	#Load byte cua mang GetScore
	beq $a0,'\n',out3	#Neu doc den cuoi chuoi thi out
	beq $a0,'*',toconvert

	addi $s1,$s1,1
	lb $a1,($s1)
	beq $a1,'\n',out3	#Neu doc den cuoi chuoi thi out
	beq $a1,'*',toconvert

	addi $s1,$s1,1
	lb $a2,($s1)
	beq $a2,'\n',out3	#Neu doc den cuoi chuoi thi out
	beq $a2,'*',toconvert

toconvert:
	jal ConvertStrToInt	#goi ham chuyen tu ky tu sang so
	
	
	sw $v0,($s3)		#store word gia tri so vua chuyen vao mang Score
	addi $s1,$s1,1		# Tang dia chi 2 mang
	addi $s3,$s3,4
	j convert
out3:
	#Sap xep mang Score va dao stt tuong ung
	la $s1,Score
	la $s2,Stt
	move $s3,$s1
	move $s4,$s2
	li $t7,1
	lw $t0,soNguoiChoi
	#Dung 2 vong lap de sap xep
Sort:
	lw $t1,($s1)
	li $t6,1
	lw $t2,($s2)
SortIn:
	lw $t3,($s3)	
	lw $t4,($s4)
	bgt $t3,$t1,swap	#Neu phan tu sau lon hon phan tu truoc thi doi cho voi nhau
	addi $t6,$t6,1
	bgt $t6,$t0,footsort	#Neu vong lap trong chay het phan tu roi thi quay lai vong lap ngoai
	addi $s3,$s3,4
	addi $s4,$s4,4
	j SortIn
swap:				# swap  so thu tu
	move $t5,$t4
	move $t4,$t2
	move $t2,$t5
	sw $t4,($s4)
	sw $t2,($s2)

	move $t5,$t3		#swap diem so
	move $t3,$t1
	move $t1,$t5
	sw $t3,($s3)
	sw $t1,($s1)
	
	addi $s3,$s3,4		#Tang dia chi cua 2 mang o vong lap trong
	addi $s4,$s4,4
	j SortIn
	

footsort:
	addi $t7,$t7,1
	bge $t7,$t0,out4	#neu phan tu dem o vong lap ngoai lon hon so nguoi choi thi dung lai
	addi $s2,$s2,4		#Tang dia chi 2 mang o vong lap ngoai
	addi $s1,$s1,4
	j Sort	
out4:
	#In ra danh sach ten - diem - manchoiwin theo thu tu trong mang Stt
	la $s1,Stt
	lw $t0,soNguoiChoi	#load address Stt,so nguoi choi,
	li $t7,1		#Khoi tao bien (1)dem so nguoi choi duoc in ra 
Xuat:
	la $s0,list		#load address cua chuoi doc tu file
	li $t2,1		#Khoi tao lai bien dem (2) moi khi vong lap duoc lap lai
	lw $t1,($s1)		#load word gia tri cua phan tu Stt tai vi tang dan tu 1 - > n
	
Readlist:
	beq $t1,$t2,print	#neu bien dem (2) bang gia tri cua phan tu Stt tuong ung thi in ra thong tin cua nguoi choi o stt do
	lb $t3,($s0)
	beq $t3,'*',Tangdem	#Moi khi doc duoc ky tu * thi tang dem (2) len 
	addi $s0,$s0,1
	j Readlist
Tangdem:
	addi $t2,$t2,1
	addi $s0,$s0,1
	j Readlist

print:				#In ra tung ki tu bat dau sau dau * va ket thuc o dau * tiep theo
	addi $s0,$s0,1
	lb $a0,($s0)
	beq $a0,'*',endprint	#Gap dau * thi se dung in
	li $v0,11
	syscall
	j print
endprint:
	li $v0,4		#Xuong dong
	la $a0,ins
	syscall
	addi $t7,$t7,1		#Kiem tra xem da in du 10 nguoi diem cao nhat chua
	beq $t7,11,end
	addi $s1,$s1,4
	j Xuat			#Quay tro lai vong lap ban dau
	
end:	
	lw $ra,($sp)
	addi $sp,$sp,32
	jr $ra

#=================Chuyen ky tu thanh so=================
ConvertStrToInt:		#Chuyen ky tu thanh so : 
				# so = hang tram*100 + hang chuc*10 + don vi

	sw $a0,4($sp)
	sw $a1,8($sp)
	sw $ra,12($sp)
	sw $a2,16($sp)
	
	beq $a2,-1,check
	beq $a2,0,dov0
	beq $a2,1,dov1
	beq $a2,2,dov2
	beq $a2,3,dov3
	beq $a2,4,dov4
	beq $a2,5,dov5
	beq $a2,6,dov6
	beq $a2,7,dov7
	beq $a2,8,dov8
	beq $a2,9,dov9
dov0:
	li $s2,0
	j hangchuc
dov1:
	li $s2,1
	j hangchuc
dov2:
	li $s2,2
	j hangchuc
dov3:
	li $s2,3
	j hangchuc
dov4:
	li $s2,4
	j hangchuc
dov5:
	li $s2,5
	j hangchuc
dov6:
	li $s2,6
	j hangchuc
dov7:
	li $s2,7
	j hangchuc
dov8:
	li $s2,8
	j hangchuc
dov9:
	li $s2,9
	j hangchuc

hangchuc:
	beq $a1,0,hachu0
	beq $a1,1,hachu1
	beq $a1,2,hachu2
	beq $a1,3,hachu3
	beq $a1,4,hachu4
	beq $a1,5,hachu5
	beq $a1,6,hachu6
	beq $a1,7,hachu7
	beq $a1,8,hachu8
	beq $a1,9,hachu9
hachu0:
	li $s1,0
	j hangtram
hachu1:
	li $s1,1
	j hangtram
hachu2:
	li $s1,2
	j hangtram
hachu3:
	li $s1,3
	j hangtram
hachu4:
	li $s1,4
	j hangtram
hachu5:
	li $s1,5
	j hangtram
hachu6:
	li $s1,6
	j hangtram
hachu7:
	li $s1,7
	j hangtram
hachu8:
	li $s1,8
	j hangtram
hachu9:
	li $s1,9
	j hangtram
	
hangtram:
	beq $a0,0,hatr0
	beq $a0,1,hatr1
	beq $a0,2,hatr2
	beq $a0,3,hatr3
	beq $a0,4,hatr4
	beq $a0,5,hatr5
	beq $a0,6,hatr6
	beq $a0,7,hatr7
	beq $a0,8,hatr8
	beq $a0,9,hatr9
hatr0:
	li $s0,0
	j convert3x
hatr1:
	li $s0,1
	j convert3x
hatr2:
	li $s0,2
	j convert3x
hatr3:
	li $s0,3
	j convert3x
hatr4:
	li $s0,4
	j convert3x
hatr5:
	li $s0,5
	j convert3x
hatr6:
	li $s0,6
	j convert3x
hatr7:
	li $s0,7
	j convert3x
hatr8:
	li $s0,8
	j convert3x
hatr9:
	li $s0,9
	j convert3x

convert3x:
	li $s3,100
	li $s4,10
	add $v0,$s2,$zero
	
	mult $s1,$s4
	mflo $s1
	add $v0,$v0,$s1
	mult $s0,$s3
	mflo $s0
	add $v0,$v0,$s0
	
	j exit_function
	
check:
	bne $a1,-1,chuso
	
	beq $a0,'0',dvi0
	beq $a0,'1',dvi1
	beq $a0,'2',dvi2
	beq $a0,'3',dvi3
	beq $a0,'4',dvi4
	beq $a0,'5',dvi5
	beq $a0,'6',dvi6
	beq $a0,'7',dvi7
	beq $a0,'8',dvi8	
	beq $a0,'9',dvi9

dvi0:
	li $v0,0
	j exit_function
dvi1:
	li $v0,1
	j exit_function
dvi2:
	li $v0,2
	j exit_function
dvi3:
	li $v0,3
	j exit_function
dvi4:
	li $v0,4
	j exit_function
dvi5:
	li $v0,5
	j exit_function
dvi6:
	li $v0,6
	j exit_function
dvi7:
	li $v0,7
	j exit_function
dvi8:
	li $v0,8
	j exit_function
dvi9:
	li $v0,9
	j exit_function	

chuso:
	beq $a0,'1',chuc1
	beq $a0,'2',chuc2
	beq $a0,'3',chuc3
	beq $a0,'4',chuc4
	beq $a0,'5',chuc5
	beq $a0,'6',chuc6
	beq $a0,'7',chuc7
	beq $a0,'8',chuc8
	beq $a0,'9',chuc9

chuc1:
	li $s0,1
	j donvi
chuc2:
	li $s0,2
	j donvi
chuc3:
	li $s0,3
	j donvi
chuc4:
	li $s0,4
	j donvi
chuc5:
	li $s0,5
	j donvi
chuc6:
	li $s0,6
	j donvi
chuc7:
	li $s0,7
	j donvi
chuc8:
	li $s0,8
	j donvi
chuc9:
	li $s0,9
	j donvi
donvi:
	beq $a1,'0',dv0
	beq $a1,'1',dv1
	beq $a1,'2',dv2
	beq $a1,'3',dv3
	beq $a1,'4',dv4
	beq $a1,'5',dv5
	beq $a1,'6',dv6
	beq $a1,'7',dv7
	beq $a1,'8',dv8	
	beq $a1,'9',dv9

dv0:
	li $s1,0
	j convertx
dv1:
	li $s1,1
	j convertx
dv2:
	li $s1,2
	j convertx
dv3:
	li $s1,3
	j convertx
dv4:
	li $s1,4
	j convertx
dv5:
	li $s1,5
	j convertx
dv6:
	li $s1,6
	j convertx
dv7:
	li $s1,7
	j convertx
dv8:
	li $s1,8
	j convertx
dv9:
	li $s1,9
	j convertx
convertx:
	li $s2,10
	mult $s0,$s2
	mflo $s3
	add $v0,$s3,$s1
	j exit_function

exit_function:
	lw $a0,4($sp)
	lw $a1,8($sp)
	lw $ra,12($sp)
	lw $a2,16($sp)

	jr $ra
	

	
