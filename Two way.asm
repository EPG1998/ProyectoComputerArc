.data
intro: .asciiz "Este código implementa el algoritmo 2-way con un método de reemplazo "
endln: .asciiz "\n"
ran: .asciiz "Random\n"
lru: .asciiz "LRU\n"
size: .word 14
entrada: .word 1,2,3,4,2,5,6,2,7,8,2,4,9,2
block: .word 0, 0, 0, 0, 0, 0, 0, 0




.text

li $t5, 0                 #$t5 = Replacement = 0, 0=Random    1=LRU
li $t6, 4                 #$t6 = b_size = 4

#setea el seed, ponlo en el tope
li $v0, 40
li $a0, 0
li $a1, 4589532			#seed
      syscall
la $a0, intro             #guardar el string a ser impreso
jal print_string          #imprimir string
jal replace_string        #imprimir el resto de introduccion

la $s1, size
lw $s1, 0($s1)
jal 2way





#arr[address]
#address = starting address + 4i

2way:
      li $t0, 0            #hits = 0
      li $t1, 0            #i
      la $s0, entrada      #Carga dirección del arreglo
      la $s4, block
LOOP: bge $t1, $s1, Exit   #i > size ---> Exit
      mul $s2, $t1, 4      #$s2 = 4*i
      add $s2, $s2, $s0    #address = start_address + 4*i
      lw $s2, 0($s2)       #Carga valor del arreglo entrada


      div $t7, $t6, 2      #B_size / 2
      div $s2, $t7,        #Valor del arreglo %
      mfhi $s5             #Set_des
      addi $s5, $s5, 1
      mul $s5, $s5, 2
      add $s5, $s5, -2     #Indice del arreglo

      mul $s5, $s5, 4
      add $s5, $s5, $s4    #address del bloque

      lw $s3, 0($s5)       #valor de ese address del bloque
      beq $s3, $s2,  HIT   #if (input == valor arreglo bloque), go to HIT
      lw $s3, 4($s5)       #valor de ese address
      beq $s3, $s2,  HIT    #if (input == valor arreglo bloque), go to HIT
      j REPLACE
UPDATE:
      addi $t1, $t1, 1    #i++
      j LOOP

HIT:
      addi $t0, $t0, 1
      j UPDATE

REPLACE:
      beq $t5, 0,     RANDOM
      j LRU





RANDOM:
                      #guarda un numero random de 0 a 1 y lo guarda en $a0
      li $v0, 42
      li $a0, 0
      li $a1, 2
      syscall

      mul $s6, $a0, 4
      add $s6, $s6, $s5

      sw $s2, 0($s6)

      j UPDATE
LRU:



Exit:
    jr $ra

#funciones de impresión
###################################
print_int:
      li $v0, 1
      syscall
      jr $ra

print_string:
      li $v0, 4
      syscall
      jr $ra
#####################################
#decision de impresion de reemplazo
#####################################
replace_string:
      beq $t5, $0, rand_string
      j lru_string

rand_string:
      la $a0, ran
      j print_string

lru_string:
      la $a0, lru
      j print_string
