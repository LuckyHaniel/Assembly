data	segment
	num1	db	?					;A
	num2	db	?					;B
	str1	db 'Please input num A:','$'
	str2	db	'Please input num B:','$'
	result1	db	'Now A is :','$'
	result2	db	',Now B is :','$'
data ends

code	segment
main	proc	far
	assume	cs:code,ds:data
	mov	ax,data					;��ʼ��
	mov	ds,ax
	start:	
	lea	dx,str1					;����A,B����ֻ���Ǹ�λ��
	mov	ah,09h
	int	21h
	mov	ah,1
	int	21h
	mov	num1,al
	call	change
	
	lea	dx,str2
	mov	ah,09h
	int	21h
	mov	ah,1
	int	21h
	mov	num2,al
	call	change
	
	judgeb:
	sub	ax,ax
	mov	al,num2
	mov	bl,2
	div	bl
	cmp	ah,1				;�ж�B�Ƿ�Ϊ����
	je	judgea				;�ǣ���ת�ж�A
	jmp	output			;�񣬽�������
	
	judgea:
	sub	ax,ax
	mov	al,num1
	mov	bl,2
	div	bl
	cmp	ah,1				;�ж�A�Ƿ�Ϊ����
	je	addab					;�ǣ�A,B��һ
	jmp	swapab			;�񣬽���A,B
	
	addab:					;A,B��һ
	inc	num1
	inc	num2
	jmp	output
	
	swapab:					;����A,B
	mov	al,num1
	mov	bl,num2
	mov	num2,al
	mov	num1,bl
	jmp	output
	
	output:					;���A��B
	sub	dx,dx
	lea	dx,result1
	mov	ah,09h
	int	21h
	mov	dl,num1
	mov	ah,02h
	int	21h
	sub	dx,dx
	lea	dx,result2
	mov	ah,09h
	int	21h
	mov	dl,num2
	mov	ah,02h
	int	21h
	call	change
	call	change
	jmp	start
main	endp

change	proc				;����
	mov	ah,02h
	mov	dx,10D
	int	21h
	ret
change	endp
code ends
	end	main
	