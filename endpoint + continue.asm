.data
	# Bien dat them
	replay: .asciiz"\nBan co muon choi lai khong: 1. Co, 0. Khong"
	subSymbol: .asciiz"-"
	fileName: .asciiz"nguoichoi.txt"
	
	# Bien mac dinh
	name: .space 10
	curW: .space 20
	uGuess: .space 20
	nW: .word 0
	arrW: .space 20
	point: .word 0
	state: .word 0
	nWin: .word 0
.text
_endPoint: 
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
	
_continue:
	# Thong bao choi lai
	li $v0, 4
	la $a0, replay
	syscall
	
	# Nhap lua chon
	li $v0, 5
	syscall
	
	# Neu co thi -> mode
	beq $v0, 1, _mode
	
	# Ket thuc chuong trinh
	li $v0, 10
	syscall
	
	
	
