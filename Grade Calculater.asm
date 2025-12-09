jmp 	start

promptText:		db	'Enter students grades 0-100 (maximum 10 students) or empty string to stop: $' 
gradeErrorText:	db	'Please enter only grades from 0 to 100!! $'
noGradeErrorText:   db	'You did not enter a grade!! $'
tryAgainText:   db  'Do you want to try again (1 for yes, others for no)? $'
thankYouText:       db  'Thank you for using our program!$'
  
gradesText:		db	'Grades are $'
totalText:		db	'Total is $'  
averageText:    db	'Average is $'  
gradeCharachtersText:		db	'Grades Charchters are $'

linefeed:	    db	10 ,'$'         ; 10d is the ascii code for line feed

numOfStudent:   db  0                
grades:         db  0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
total:          dw  0
average:        db  0

return:
    ret
    
readGrades:	  ;read grades written by use
            cmp si, 10  ;check if grades reaches maximum size
            je inputEnd ;stop taking inputs from the user
            mov cx, 0
            mov	bx, 0
            mov	dx, promptText ;display prompt text for user
    		mov	ah, 09h
    		int	21h
            
begin:	
        mov	ah, 01h         ;wait for input
		int	21h 		
		 
		cmp	al, 0dh         ; 0dh is the ascii code for carriage return
		je	saveGrade
		
		cmp al, '0'         ;check if numbers are valid 
		jl	GradeError
		
		cmp al, '9'
		jg	GradeError 
		 
		mov	ah, 0
		sub	al, 30h         ;get the actual number
		push	ax
		mov	ax, 10
		mul	bx              
		pop	bx
		add	bx, ax          ;for manipulating multi-digit numbers
		
		jmp checkGrade      ;check if grades are valid
		
saveGrade:  ;save grade after successful sumbit
        cmp cx, 0        ;if enter is presses and no number was entered it directs the program to stop taking inputs
        je   inputEnd
        mov [grades + si], bl  ;save grade in memory
        inc si
        call   newline
        call   newline
        jmp readGrades
   
		
checkGrade:              
        cmp bx, 100   ;if the grade is more than 100 it is wrong so error message will be printed
        jg gradeError
        
        inc cx        ;if it is within accepted range, the counter will be incremented
        jmp	begin
		
GradeError:
        call   newline
        call   moveToBeggining
        
        mov	dx, gradeErrorText    ;display error message
		mov	ah, 09h
		int	21h
		 
		call   newline
		call   moveToBeggining 
		call   newline
		
		jmp readGrades
		
inputEnd:
        mov cx, si	
        mov [numOfStudent], cl	 ;save the number of entered grades
        ret
        
noGrade:
        call   newline
        call   moveToBeggining
        
        mov	dx, noGradeErrorText  ; if the program stopped taking inputs
        ; while no grade was stored it will print a message at the end of program
		mov	ah, 09h
		int	21h 
		
		call   moveToBeggining 
        call   newline       
        call   newline
		
		jmp tryAgain

displayGradeCharachter:   
        mov	dx, gradeCharachtersText  
    	mov	ah, 09h
    	int	21h
        mov si, numOfStudent 
        mov cx, 0
        mov cl, [si]
        mov bp, 0         
        
        mov si, grades

traceGrades:
        cmp bp, cx
        je  return
        
        mov bl, [si + bp]
        inc bp
        
        cmp bl, 90            ;For grade A
        jge A
        
        cmp bl, 80            ;For grade B
        jge B 
        
        cmp bl, 70            ;For grade C
        jge C
        
        cmp bl, 60            ;For grade D
        jge D                         
         
        mov dx, 46h           ;For grade F
        jmp printCharachter
        
printCharachter:         
    	mov	ah, 02h   ;print single charachter
    	int	21h
    	mov dx, 20h   ;add space between grades
    	mov	ah, 02h
    	int	21h
        jmp traceGrades
        
A: 
    mov dx, 41h
    jmp printCharachter
B:  
    mov dx, 42h
    jmp printCharachter
C:
    mov dx, 43h
    jmp printCharachter
D:
    mov dx, 44h
    jmp printCharachter

        
    

displayGrades:
        mov	dx, gradesText
    	mov	ah, 09h
    	int	21h
        mov si, numOfStudent 
        mov cx, 0
        mov cl, [si]
        mov bp, 0
        mov di, cx
        
        mov si, grades
        
printGrade:        
        cmp bp, di
        je  return
        
        mov ax, 0
        mov al, [si + bp]  ;get grade from memory
        inc bp
        	
        mov	bx, 10
		mov	cx, 0
    push1:		mov	dx, 0        ;convert grade number into string
    		div	bx
    		push	dx
    		inc 	cx
    		cmp	al, 0
    		jne	push1
    
    pop1:		pop	dx          ;print grade to user
    		add	dl, 30h
    		mov	ah, 02h
    		int	21h
    		dec	cx
    		jnz	pop1
    	
    	mov dx, 20h             ;add space between grades
    	mov	ah, 02h
    	int	21h
        jmp printGrade 
        
 
writeNumber:
        mov ax, 0
        mov al, [si + bp]
        inc bp
        	
        mov	bx, 10
		mov	cx, 0
    push2:		mov	dx, 0
    		div	bx
    		push	dx
    		inc 	cx
    		cmp	al, 0
    		jne	push2
    
    pop2:		pop	dx
    		add	dl, 30h
    		mov	ah, 02h
    		int	21h
    		dec	cx
    		jnz	pop2
    		ret

moveToBeggining:       ;move cursor to the beggining of the line
        mov	dx, 0Dh
    	mov	ah, 02h
    	int	21h
        ret
newline:	
        mov	dx, linefeed   ;adds new line
		mov	ah, 09h
		int	21h
        ret

tryAgain:  ;ask user to try again
        mov	dx, tryAgainText
    	mov	ah, 09h
    	int	21h
    	
    	mov ah, 01h    ;wait for input
    	int 21h
    	
    	cmp	al, '1'    ;1 mens yes
    	jne end
    	
    	call   newline
        call   moveToBeggining
        call   newline
        jmp start           ;restart the program	


start:	
        mov bp, 0
        mov si, 0
		call 	readGrades
		
		mov si, numOfStudent

		cmp [si], 0
		je noGrade
		
		
		call    moveToBeggining 
        call    newline
        call    newLine
        
        call    displayGrades
        call    moveToBeggining 
        call    newline
		call    displayGradeCharachter 
		
		
		
		call    end
		
thankYou:
        call   newline
        call   moveToBeggining 
        call   newline
        mov	dx, thankYouText
		mov	ah, 09h
		int	21h
		ret

        
end:    
        call thankYou
		mov	ax, 0x4c00		;terminate program
		int 	21h

