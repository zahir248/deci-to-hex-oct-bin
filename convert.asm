#Project COA QTSPIM

.data  
array: .space 40
userinput: .asciiz "Please enter 10 integers in  numbers 0 to 250 only :\n" 
invalid: .asciiz "Invalid Input \n:" 
binary:  .asciiz "\nBinary Equivalent: "
octal: .asciiz "\nOctal Equivalent: "
hexa: 	 .asciiz "\nHexadecimal Equivalent: "
space:   .asciiz "\n\n"
result:  .space 40
greet:  .asciiz ">>>>>>>>>>>>>>>   Thank You!!!   <<<<<<<<<<<<<<<"


.text
main :

        li $v0, 4
        la $a0, userinput
        syscall
	
        addi $t0, $t0, 40 

Loop :	

        beq $t3, $t0, nexus         #branch to nexus if $t3 is equal to $t0

        li $v0, 5                   #input values
        syscall

        move $t2, $v0  		    #move values from $v0 to $t2
	
        bgt $t2, 255, Wrong   	    #branch to Wrong if $t2 is greater than 255
        bltz $t2, Wrong 	    #branch to Wrong if $t2 is lesser than zero	

        sw $t2, array($t3)	    #save values $t2 into array $t3
        addi $t3, $t3, 4  	    #jump to next slot in register (start 0-36)
       
        j Loop                      #jump to Loop

nexus :

        move $t3, $zero  	    #reset number to the first
	
next :

        beq $t3, $t0, nexus2	    #branch to nexus2 if $t3 is equal to $t0
        li $v0, 4
        la $a0, binary
        syscall


#######################     BINARY      #######################     

Binary :
	
        lw $t2, array($t3)	    #from right to left, loads values in $t3 to $t2
        addi $t3, $t3, 4	    #jump to next slot in register
        addi $t4, $zero, 1 	    #load 1 as a mask
        sll $t4, $t4, 7		    #move the mask to appropriate position
        addi $t5, $zero, 8 	    #loop counter
	
loop :
        and $t1, $t2, $t4           #and the input with the mask
        beq $t1, $zero, print       #Branch to print if $t1 is equal to zero
       
        add $t1, $zero, $zero  	    #Zero out $t1
        addi $t1, $zero, 1 	    #Put a 1 in $t1

print :
	li $v0, 1
	move $a0, $t1
	syscall

	srl $t4, $t4, 1      
	addi $t5, $t5, -1           #decrement counter
	bne $t5, $zero, loop        #branch to loop if $t5 is equal to zero

j next                              #jump to next


#######################     OCTAL     #######################     

nexus2 :

        move $t3, $zero             #reset number to the first
        li $v0, 4
        la $a0, space
        syscall

next2 :
	beq $t3, $t0, nexus3	    #branch to nexus3 if $t3 is equal to $t0
	lw $t2, array($t3)	    #from right to left, loads values in $t3 to $t2  
	addi $t3, $t3, 4	    #jump to next slot in register

        li $t4, 0 		    #remainder
        li $t5, 0 		    #final octal number
        li $t6, 1  		    #placeInNumber
    
OCTAL :

        rem $t4, $t2, 8             #put the remainder from dividing the integer in $t2 by 8 into $t4
        div $t2, $t2, 8             #divide operation
        mul $t4, $t4, $t6           #multiply operation
        add $t5, $t5, $t4           #add values, $t5 + $t4, and store answer in $t5
        mul $t6, $t6, 10            #multiply operation
        bnez $t2, OCTAL             #branch to OCTAL if $t2 is not equal to zero

OCTAL2 : 

	li $v0, 4
	la $a0, octal
	syscall
	
        li $v0, 1
        move $a0, $t5
        syscall

j next2                             #jump to next2


#######################  HEXADECIMAL  #######################
nexus3 :

        move $t3, $zero		    #reset number to the first
        li $v0, 4
        la $a0, space		    #new space
        syscall

next3 :

	beq $t3, $t0, EXIT
	li $t6, 8                   #loads value 8 into $t6 for set counter
        la $t5, result              #where answer will be stored
	
	lw $t2, array($t3)	    #from right to left, loads values in $t3 to $t2  
	addi $t3, $t3, 4	    #jump to next slot in register
		
	li $v0, 4		
        la $a0, hexa		
        syscall
	
Hexa :
	beqz $t6, next4             #branch to next4 if $t6 is equal to zero
        rol $t2, $t2, 4       	    #rotate 4 bits to the left
        and $t4, $t2, 0xf           #mask with 1111
        ble $t4, 9, Sum             #branch to Sum if $t4 is equal or lesser than 9
        addi $t4, $t4, 55           #if greater than nine, add 55

        b End                       #go to End

Sum :

        addi $t4, $t4, 48   	    #add 48 to result

End :

        sb $t4, 0($t5)      	    #store hex digit into result
        addi $t5, $t5, 1            #increment address counter
        addi $t6, $t6, -1           #decrement loop counter
	    
j Hexa                              #jump to Hexa
    
next4 : 

	la $a0, result
        li $v0, 4
        syscall

j next3                             #jump to next3

Wrong  : 

	li $v0, 4
	la $a0, invalid
	syscall
	
EXIT :
      
        li $v0, 4
	la $a0, space
	syscall

     
	li $v0, 4
	la $a0, greet
	syscall

        li $v0,10
	syscall