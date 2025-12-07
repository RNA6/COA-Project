jmp 	start

promptText:		db	'Enter students grades 0-100 (maximum 10 students) or empty string to stop: $' 
gradeErrorText:	db	'Please enter only grades from 0 to 100!! $'
noGradeErrorText:   db	'You did not enter a grade!! $'
tryAgainText:   db  'Do you want to try again (1 for yes, others for no)? $'
thankYouText:       db  'Thank you for using our program!$'
totalText:		db	'Total is $'  
averageText:    db	'Average is $'  
gradesText:		db	'Grades are $'

linefeed:	    db	10 ,'$'         ; 10d is the ascii code for line feed

numOfStudent:   db  0                
grades:         db  0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
total:          dw  0
average:        db  0

;Hi
readGrades:	
            cmp si, 10
            je inputEnd 
            mov cx, 0
            mov	bx, 0
            mov	dx, promptText
    		mov	ah, 09h
    		int	21h
            
begin:	
        mov	ah, 01h
		int	21h 		
		 
		cmp	al, 0dh         ; 0dh is the ascii code for carriage return
		je	saveGrade
		
		cmp al, '0'
		jl	GradeError
		
		cmp al, '9'
		jg	GradeError 
		 
		mov	ah, 0
		sub	al, 30h
		push	ax
		mov	ax, 10
		mul	bx
		pop	bx
		add	bx, ax
		
		jmp checkGrade 
		
saveGrade:
        cmp cx, 0
        je   inputEnd
        mov [grades + si], bl
        inc si
        call   newline
        call   newline
        jmp readGrades
   
		
checkGrade: 
        cmp bx, 0
        jl gradeError
        
        cmp bx, 100
        jg gradeError
        
        inc cx
        jmp	begin
		
GradeError:
        call   newline
        call   moveToBeggining
        
        mov	dx, gradeErrorText
		mov	ah, 09h
		int	21h
		 
		call   newline
		call   moveToBeggining 
		call   newline
		
		jmp readGrades
		
inputEnd:
        mov cx, si	
        mov [numOfStudent], cl	
        ret
        
noGrade:
        call   newline
        call   moveToBeggining
        
        mov	dx, noGradeErrorText
		mov	ah, 09h
		int	21h
		je end


moveToBeggining:
        mov	dx, 0Dh
    	mov	ah, 02h
    	int	21h
        ret
newline:	
        mov	dx, linefeed
		mov	ah, 09h
		int	21h
        ret

tryAgain:
        mov	dx, promptText
    	mov	ah, 09h
    	int	21h
    	
    	cmp	al, '1'
    	jne end
    	
    	call   newline
        call   moveToBeggining
        call   newline
        jmp start           	


start:	
        mov bp, 0
        mov si, 0
		call 	readGrades
		
		mov si, numOfStudent

		cmp [si], 0
		je noGrade 
		
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

