.data
	str: .asciiz "Insert an integer\n "
	size: .word 8
	arr: .word 0,1,2,3,4,5,6,7
	str2: .asciiz "Ya esta en el arreglo"
	str3: .asciiz "The number was chaneged"

.text



STOP: li $v0 , 10
			syscall
