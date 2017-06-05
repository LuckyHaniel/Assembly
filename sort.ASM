stack segment stack 
     byte 1024 dup(0)
stack ends

data segment
	arrayA	db	9,5,8,3,8,5,4,8,5,2,2,1,5,3,7,3,1,9,1,3
	lenA		dw	20
	arrayB	db	8,4,3,6,3,6,5,9,1,3,2,3,8,9,1,8,5,7,5,3
	lenB		dw	20
	arrayC	db	20	dup(0)
	posC		dw	0
	str1	db	'The old Array A is:','$'
	str2	db	'The old Array B is:','$'
	str3	db	'The new Array A is:','$'
	str4	db	'The new Array B is:','$'
	str5	db	'The Array C is:','$'
data	ends

code	segment
	assume	cs:code,ds:data,ss:stack
	main	proc	far;
		
		mov ax,1000H
		mov ss,ax
		mov sp,0010h					;栈初始化

		mov	ax,data
		mov	ds,ax						;数据域初始化
		call	oldOutput				;输出数组A,B

		mov	cx,lenA
		sortA:							;对数组A采用冒泡排序
			sub	si,si
			inc	si
			inSortA:
				mov	bl,arrayA[si]
				dec	si
				mov	al,arrayA[si]
				inc	si
				cmp	al,bl
				jl	inA
				mov	arrayA[si],al
				dec	si
				mov	arrayA[si],bl
				inc	si
				inA:
					inc	si
					cmp	si,lenA
					je	outA
					jmp	inSortA
			outA:
				loop	sortA

		mov	cx,lenB
		sortB:							;对数组B采用冒泡排序
			sub	si,si
			inc	si
			inSortB:
				mov	bl,arrayB[si]
				dec	si
				mov	al,arrayB[si]
				inc	si
				cmp	al,bl
				jl	inB
				mov	arrayB[si],al
				dec	si
				mov	arrayB[si],bl
				inc	si
				inB:
					inc	si
					cmp	si,lenB
					je	outB
					jmp	inSortB
			outB:
				loop	sortB

		call	newOutput				;输出排序后的数组
		lea	dx,str5
		mov	ah,09h
		int	21h						;输出字符串str5
		call	findC						;生成并输出数组C
		call	change					;输出换行
		ret
	main		endp
	
	change	proc						;换行子程序
	mov	ah,02h
	mov	dx,10D
	int	21h
	ret
	change	endp
	
	Poo	proc							;输出,的子程序
		mov	ah,02h
		mov	dx,2ch
		int	21h
		ret
	Poo	endp
	
	outputA	proc						;输出数组A的子程序
		mov	cx,lenA
		sub	si,si
		lopA:
			mov	dl,arrayA[si]
			add	dl,30h
			mov	ah,02h
			int	21h
			inc	si
			call	Poo
			loop	lopA
		call	change
		ret
	outputA	endp
	
	outputB	proc						;输出数组B的子程序
		mov	cx,lenB
		sub	si,si
		lopB:
			mov	dl,arrayB[si]
			add	dl,30h
			mov	ah,02h
			int	21h
			inc	si
			call	Poo
			loop	lopB
		call	change
		ret
	outputB	endp
	
	oldOutput	proc					;输出子程序，其中调用outputA和outputB
		lea	dx,str1
		mov	ah,09h
		int	21h
		call	outputA
		lea	dx,str2
		mov	ah,09h
		int	21h
		call	outputB
		ret
	oldOutput	endp
	
	newOutput	proc					;输出子程序，其中调用outputA和outputB
		lea	dx,str3
		mov	ah,09h
		int	21h
		call	outputA
		lea	dx,str4
		mov	ah,09h
		int	21h
		call	outputB
		ret
	newOutput	endp

	findC	proc							;寻找数组C并储存
		mov	si,lenA
		oloop:
			mov	bp,lenB
			mov	cx,lenA
			dec	si
			cmp	si,0
			je	return
			iloop:
				mov	al,arrayA[si]
				dec	bp
				mov	bl,arrayB[bp]
				cmp	al,bl
				je	outC
				loop	iloop
				jmp	oloop
		outC:
			mov	dl,al
			
			mov	bl,19
			mov	bp,posC
			mov	arrayC[bp],al
			inc	bp
			mov	posC,bp
			mov	ah,02h
			add	dl,30h
			int	21h
			call	Poo
			jmp	oloop
		return:ret
	findC	endp
code	ends
	end main