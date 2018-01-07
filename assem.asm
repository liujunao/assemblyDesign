data segment

	outFir db 0AH,0DH,'please input a 3-digit number:$'
	outErr db 0AH,0DH,'your input is illeagle,$'
	outNext db ' please input again: $'
	outAn db 0AH,0DH,'the narcissistic number is ',0AH,0DH,'$'
	outAg db 0Ah,0DH,'Are you again? y or n: $'
	
	tab dw 0,1,8,27,64,125,216,343,512,729
	tmp dw 3 dup(0)
	num1 db ?			;当作寄存器使用
	num2 dw ?			;储存各位数字的立方
	num3 dw ?			;存储当前数
	num4 dw ?			;储存输入的值
	
data ends

stack segment
	db 200 dup(0)
stack ends 

code segment
	assume cs:code,ds:data,ss:stack

start:
	mov ax,data
	mov ds,ax
	lea dx,outFir		;打印提示输入语句
	mov ah,9
	int 21h
	jmp input			;获取三次的输入
s4:	jmp trNum			;得到输入的数
s5:	lea dx,outAn
	mov ah,9
	int 21h
	mov cx,100
s1: 
	mov num3,cx
	call cube			;得到当前数的各位位数的立方和
	mov ax,num2
	cmp ax,num3		
	je 	outputAn		;相等则跳转到打印输出
s2:	inc cx
	cmp cx,num4
	jne s1
	lea dx,outAg		;打印是否继续
	mov ah,9
	int 21h
	call answer			;根据输入，判断是否继续
s3:	mov ax,4c00h
	int 21h

outputAn:				;打印输出
	mov dl,[si+4]
	add dl,48
	mov ah,2
	int 21h
	mov dl,[si+2]
	add dl,48
	mov ah,2
	int 21h
	mov dl,[si]
	add dl,48
	mov ah,2
	int 21h
	mov dl,','
	mov ah,2
	int 21h
	jmp s2
	
answer proc
	mov ah,1
	int 21h
	cmp al,'y'
	je start
	cmp al,'n'
	je s3
	ret
answer endp
	
cube proc				;得到当前数的各位位数的立方和
	push cx
	lea si,tmp
	mov bh,0
	mov ax,num3
	mov bl,10
	div bl
	mov bl,ah
	push bx
	mov byte ptr [si],ah
	mov ah,0
	mov bl,10
	div bl
	mov bl,ah
	push bx
	mov byte ptr [si+2],ah
	mov bl,al
	push bx
	mov byte ptr [si+4],al
	xor bx,bx
	mov num2,0
	mov cx,3
	lea di,tab
cu1:pop ax
	mov bx,2
	mul bx
	mov bx,ax
	mov ax,[di+bx]	;获取 tab 表中相应的立方值
	add num2,ax
	loop cu1
	pop cx
	ret
cube endp
	
trNum:				;得到输入的数
	mov num4,0
	mov cx,0
tr:	mov ax,0
	pop ax
	mov num1,al
	call index			;求指数
	add num4,bx
	inc cx
	cmp cx,3
	jne tr
	jmp s5
	
index proc					;求指数
	mov ax,cx
	push cx					;保护现场
	mov cx,ax
	xor ax,ax
	mov al,num1
	mov bx,ax
ind1:
	jcxz ind
	mov al,bl
	mov bl,10
	mul bl
	mov bx,ax
	loop ind1
ind:pop cx
	ret
index endp
	
input:				;获取输入
	mov cx,3
inp:mov ah,1			;一号输入
	int 21h
	cmp al,'0'		
	jb err
	cmp al,'9'
	ja err				;当输入的是非数字时，提示错误，并重新输入
	and al,0FH			;获取真值（之前的为ascii码）
	push ax				;将获取的值压入堆栈
	loop inp
	jmp s4
	
err:					;当输入非法时，输出提示语句
	lea dx,outErr
	mov ah,9
	int 21h
	lea dx,outNext
	mov ah,9
	int 21h
	jmp input 

code ends
	end start