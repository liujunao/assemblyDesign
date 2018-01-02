assume cs:code,ds:data

data segment
	num db ?
	outFir dw 'please input a 3-digit-number:','$'
	outLe dw 'your input is less than 100,','$'
	outGr dw 'your input is than 999,','$'
	outCo dw ' please input again: ','$'
data ends

code segment
	start:
		mov ax,data[1]
		mov ds,ax
		lea dx,outFir ;打印提示语句
		mov ah,9
		int 21h		  ;调用9号输出功能
		jmp input	  ;调转到输入
		
		sub al,63H    ;将输入数减去99，以规定循环的次数
		mov cx,al	  ;将循环次数赋给cx
	
	s:
					  ;获取该数字相应的位数
					  
					  
					  ;求该数字各位数字的立方和
					  ;将各位数字的平方和与原数进行比较
	
	input:
		mov ah,1 	  ;调用1号输入功能
		int 21h
		cmp al,63h	  ;将输入值与99相比
		jng ouputL 	  ;如果小于100
		
		cmp al,627h	  ;将输入值与999相比
		jge ouputG	  ;如果大于1000
		
		mov num,al    ;将输入赋给 num
		jmp jmpend
		
	ouputL:			  ;输出数字小于100
		mov ax,data[3]
		mov ds,ax
		lea dx,outLe 
		mov ah,9
		int 21h
		jmp outputC
	
	ouputG:			  ;输入数字大于1000
		mov ax,data[5]
		mov ds,ax
		lea dx,outFir
		mov ah,9
		int 21h
		jmp outputC
		
		
	outputC:	      ;输出“请重新输出”
		mov ax,data[7]
		mov ds,ax
		lea dx,outCo
		mov ah,9
		int 21h
		jmp input
		
	judge:
		cmp num,''
		
	
	jmpend:
		mov ax,4c00h
		int 21h
		
		
	code ends
	end start
		
		