.data
	intro: .asciiz "Este programa implementa el método directo de mapping\n "
	block4: .asciiz "Estos outputs son del caché: "
	block: .word 0, 0, 0, 0, 0, 0, 0, 0
  	size: .word 14
  	entrada: .word 1,2,3,4,2,5,6,2,7,8,2,4,9,2
	endl: .asciiz "\n"
	hits: .asciiz "The amount of hits are : "

.text
			li $t7, 0
			li $v0, 4								#imprimir introducción
			la $a0, intro
			syscall
			#Starting the program
			la $s1, size						#Initialize register
			lw $s1, 0($s1)					#$s1 = size of the array 14
			li $s2, 4								#$s2 =size of block = 4
			la $s5, block 					#s5 = principio address block
			jal Block								#Llama al procedimiento Block
			jal Print2
			li $s2, 8								#$s2 =size of block = 8
			la $s5, block 					#s5 = principio address block
			sw $t7, 0($s5)
			sw $t7, 4($s5)
			sw $t7, 8($s5)
			sw $t7, 12($s5)
			jal Block								#"Llama" al procedimiento Block
			jal Print2
			j STOP									#Salta al label STOP


			#Block
##################################
Block:
			li $t3, 0								#Contador de hits
			la $t0, ($ra)
			jal Print
			la $ra, ($t0)
			la $s4, entrada					#s4 = principio adress arreglo entrada
			#añade primeros 4 al bloque
			li $t1, 0 							#$t1 = i = 0
LOOP:	bge $t1, $s1, Exit			#branch	if $t1 >= $s0, i >= size
			lw $s6, 0 ($s4)					#$s6 = elemento de la entrada
			#compara el elemento de entrada con valores en el cahché
			#compara elemento de entrada con elemento guardado en bloque
			li $t2, 0								#$t2 = i2 = 0
LOOP2:bge $t2, $s2, REPLACE
			lw $s7, 0($s5)
			beq $s6, $s7, HIT
UPDATE2:
			addi $t2, $t2, 1 				#i2++
			addi $s5, $s5, 4 				#Mueve el pointer del arreglo
			j LOOP2

HIT:
			addi $t3, $t3 , 1 			#Cantidades de hits
			j UPDATE

REPLACE:
			div $s6, $s2,
			mfhi $t4
			beq $t4, 0, sum
			addi $t4, $t4, -1
Replace_rest:
			la $s5, block 					#s5 = principio address block
			mul $t4, $t4, 4					#t4 = 4*i
			add $t4, $t4, $s5				#t4 = starting address + 4*i
			sw $s6, 0($t4) #Tratar primero no es seguro
      j UPDATE

sum:
			addi $t4, $s2, -1				#t4 = size - 1
			j Replace_rest

Exit:
			jr $ra

UPDATE:
			addi $t1 ,$t1, 1 				#i++
			addi $s4, $s4, 4 				#Mueve el pointer del arreglo
			j LOOP

Print:
li $v0, 4											#imprimir introduccion del block 4
la $a0, block4
syscall
li $v0, 1
la $a0, ($s2)									#imprimir el numero de bloques en chaché
syscall
li $v0, 4 										#imprimir un endl
la $a0, endl
syscall
jr $ra

Print2:
li $v0, 4											#imprimir el texto que indica cuales son sus hits
la $a0, hits
syscall
li $v0, 1
la $a0, ($t3)									#imprimir el numero de hits
syscall
li $v0, 4											#imprimir endline
la $a0, endl
syscall
jr $ra

##################################
STOP: li $v0 , 10
			syscall
