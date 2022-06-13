.data 
v: .word 3, 4, 5, 6, 7, 20, 30


.text

.globl main

main:
	li $a0, 0
	li $a1, 2
	jal partition

	li $v0,10
	syscall	

qselect:
	addi $sp,$sp, -24
	sw $s0,0($sp)
    	sw $s1,4($sp)
    	sw $s2,8($sp)
    	sw $s3,12($sp)
    	sw $s4,16($sp)
	sw $ra,20($sp)
	
	la $s0,v
	move $s1,$a0 # s1 is f
	move $s2,$a1 # s2 is l
	move $s3,$a2 # s3 is k
	
        bne $a0,$a1, dont_return_f
        	sll $t0,$s1,2
        	add $t0,$s0,$t0
        	lw  $v0,0($t0)
        	jr $ra
        	
       	dont_return_f:
        
        jal partition
        move $s4,$v0
        
        bne $s3,$s4, dont_return_k
        	sll $t0,$s3,2
        	add $t0,$s0,$t0
        	lw  $v0,0($t0)
        	j return
        
        dont_return_k:
        
        bgt $s3,$s4, k_greater_than_p
        	move $a0,$s1
        	sub  $a1,$s4,1
        	jal qselect
        	j return	
        
        k_greater_than_p:
        
        add  $a0,$s4,1
        move $a1,$s2
        jal  qselect
        j   return
       
return:
	lw $s0,0($sp)
   	lw $s1,4($sp)
   	lw $s2,8($sp)
   	lw $s3,12($sp)
   	lw $s4,16($sp)
  	lw $ra,20($sp)
   	addi $sp,$sp,24
	jr $ra		

partition:
    addi $sp,$sp, -32
    sw $s0,0($sp)
    sw $s1,4($sp)
    sw $s2,8($sp)
    sw $s3,12($sp)
    sw $s4,16($sp)
    sw $s5,20($sp)
    sw $s6,24($sp)
    sw $ra, 28($sp)
    la $s0,v # s0 address of v
    add $s1,$a1,$zero  # s1 value of l

    sll $s2,$a1,2
    
    add $s3,$s2,$s0 # s3 address of v[l]
    lw $s4,0($s3) # s4 value of v[l]/pivot
    add $s5,$a0,$zero # s5 value of f/i

    
    add $s6,$a0,$zero # s6 value of f/j
    loop:
        bge $s6,$s1, End_loop
        
        sll $t0,$s6,2
        add $t0,$t0,$s0   
        lw  $t0,0($t0)  # t0 value of v[j]
        
        
        bge $t0,$s4,contin
            add $a0,$s5,$zero # a0 is i
            add $a1,$s6,$zero # a1 is j
            jal swap
            addi $s5,$s5,1
        contin:
        addi $s6,$s6,1 #j++
       j loop
    End_loop:
    
    add $a0,$s5,$zero   
    add $a1,$s1,$zero
    jal swap
    add $v0,$s5,$zero
    lw $s0,0($sp)
    lw $s1,4($sp)
    lw $s2,8($sp)
    lw $s3,12($sp)
    lw $s4,16($sp)
    lw $s5,20($sp)
    lw $s6,24($sp)
    lw $ra, 28($sp)
    addi $sp,$sp, 32
    jr      $ra
    
    
    
    swap:     # swap entry point

        la $t0, v # t0 address of v
        
        sll $a0,$a0,2 
        sll $a1,$a1,2
        
        add $t1,$t0,$a0 # t1 address of i
        lw $t2,0($t1)
        
        add $t3,$t0,$a1 # t3 address of j
        lw $t4,0($t3)
        
        sw $t4,0($t1)
        sw $t2,0($t3)
        
        jr      $ra             # return to caller
