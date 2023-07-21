.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem msvcrt.lib, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf:proc
extern scanf:proc
extern fscanf:proc
extern fprintf:proc
extern fopen:proc
extern fclose:proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
fisier1 db "A.txt",0
fisier2 db "B.txt",0
fisier_out db "out.txt",0
fisier_out1 db "fisier_out.txt",0
mode db "r",0
mode1 db "w",0
message12 db "Transpusa matricei este:",13,10,0
message11 db "Matricea obtinuta in urma inmultirii cu numarul citit este:",13,10,0
message9 db "Diferenta celor doua matrice este:",13,10,0
message8 db "Suma celor doua matrice este:",13,10,0
message7 db "Derminantul este:",13,10,0
message6 db "Determinantul matricei este:%d",13,10,13,10,0
message5 db "Introduceti numarul cu care inmultim matricea:",13,10,13,10,0
message3 db "Introduceti matricea 1:",13,10,13,10,0
message4 db "Introduceti matricea 2:",13,10,13,10,0
message2 db "Introduceti numarul de linii(egal cu numarul de coloane)",13,10,13,10,0
message10 db "Introduceti operatia dorita:",13,10,13,10,0
ad db "A+B",0
dif db "A-B",0
inm db "a*A",0
det db "DET",0
transp db "TRANSPUSA",0
message1 db "Introduceti matricea:",13,10,13,10,0
format1 db "%d",0
format2 db "%d ",0
format3 db " ",13,10,0
format4 db "%s",0
s1 db 50 dup(0)
s dd 50 dup(0)
s2 dd 50 dup(0)
suma_vector dd 50 dup(0)
diferenta_vector dd 50 dup(0)
inmultire_vector dd 50 dup(0)
transpusa_vector dd 50 dup(0)
a dd 0
cnt dd 0
linii dd 0
linii_minus_1 dd 0
suma_determinant dd 0
suma_determinant_total dd 0
suma_determinant_minus dd 0
save dd 0
salvam dd 0
fp dd 0
p dd 0
q dd 0
fp1 dd 0
p1 dd 0
q1 dd 0
.code
start:
    
	;citim operatia
	push offset s1
	push offset format4
	call scanf
	add esp,8
	;verificam daca este adunare
	mov ecx,3
	mov esi,0
    mov ebx,0
	mov cnt,0
	verificam_adunare:
	                  mov al,ad[esi]
	                  cmp s1[esi],al
					  je aduna_contor
					  jne continua
					  aduna_contor:
					               add cnt,1
					  continua:
					           inc esi
    loop verificam_adunare
	;daca avem contorul pe 3 facem adunare
    mov ebx,3
    cmp ebx,cnt
    je fa_adunare
    jne mergi_mai_departe
    fa_adunare:
               
               ;citim prima matrice
			   push offset mode
			   push offset fisier1
			   call fopen
			   add esp,8
			   mov fp,eax
			   mov eax,0
			   mov esi,0
			   push offset linii
			   push offset format1
			   push fp
			   call fscanf
			   add esp,12
			   
			   mov eax,linii
	           mov edx,0
	           mul linii
	           mov ecx,eax
	           mov esi,0
	           mov edi,0
			   loop_1:
			          mov eax,0
	                  push ecx
	                  push offset a
			          push offset format1
					  push fp
			          call fscanf
			          add esp,12
			          mov eax,a
	                  mov s[esi],eax
			          add esi,4
			          pop ecx
              loop loop_1
			  ;citim a doua matrice
			  push offset mode
			  push offset fisier2
			  call fopen
			  add esp,8
			  mov p,eax
			  mov eax,0
			  mov esi,0
			  push offset linii
			  push offset format1
			  push p
			  call fscanf
			  add esp,12
			  mov eax,linii
	          mov edx,0
	          mul linii
	          mov ecx,eax
	          mov esi,0
	          mov edi,0
			  loop_2:
			         mov eax,0
	                 push ecx
	                 push offset a
			         push offset format1
					 push p
			         call fscanf
			         add esp,12
			         mov eax,a
	                 mov s2[esi],eax
			         add esi,4
			         pop ecx
			  loop loop_2
			  ;facem adunarea
			  mov esi,0
	          mov eax,linii
	          mul linii
	          mov ecx,eax
			  suma:
			       mov eax,0
		           mov ebx,0
		           mov eax,s[esi]
		           mov ebx,s2[esi]
		           adc eax,ebx
		           mov suma_vector[esi],eax
		           add esi,4
		    loop suma
			push offset message8
			call printf
			add esp,4
			;afisam suma
			mov eax,linii
	        mov edx,0
	        mul linii
	        mov ecx,eax
			mov salvam,ecx
			;salvez nr pt loop
	        mov eax,linii
	        mov ebx,4
	        mul ebx
	        mov ebx,eax
	        sub eax,4
	        mov linii_minus_1,eax
	        mov esi,0
			push offset mode1
			push offset fisier_out
			call fopen
			add esp,8
			mov q,eax
			mov eax,0
			mov ecx,salvam
			push offset message8
			push q
			call fprintf
			add esp,8
			mov ecx,salvam
			afisare:
			        mov eax,0
	                push ecx
			        mov eax,suma_vector[esi]
			        push suma_vector[esi]
			        push offset format2
					push q
			        call fprintf
			        add esp,12
			        mov eax,esi
			        mov edx,0
			        div ebx
			        add esi,4
			        cmp edx,linii_minus_1
			        jne continua1
			        je sari
					sari:
			             push offset format3
						 push q
				         call fprintf
				         add esp,8
					continua1:
			                 pop ecx
                             loop afisare
					 push q 
					 call fclose
					 add esp,4
	mergi_mai_departe:
	                 
		              ;verificam daca este diferenta
					  mov ecx,3
	                  mov esi,0
                      mov ebx,0
	                  mov cnt,0
					  verificam_diferenta:
					                      mov al,dif[esi]
	                                      cmp s1[esi],al
					                      je aduna_contor1
					                      jne continua2
										  aduna_contor1:
										                inc cnt
										  continua2:
										             inc esi
					  loop verificam_diferenta
					  mov ebx,3
                      cmp ebx,cnt
                      je fa_diferenta
                      jne mergi_mai_departe1
					  fa_diferenta:
					               push offset mode
                                   push offset fisier1
								   call fopen
                                   add esp,8
                                   mov fp1,eax
			                       mov eax,0
	                               mov esi,0
	                               push offset linii
	                               push offset format1
								   push fp1
								   call fscanf
								   add esp,12
	                               mov eax,linii
	                               mov edx,0
								   mul linii
								   mov ecx,eax
								   mov esi,0
								   mov edi,0
								   loop_3:
                                          mov eax,0
	                                      push ecx
	                                      push offset a
			                              push offset format1
										  push fp1
			                              call fscanf
			                              add esp,12
			                              mov eax,a
	                                      mov s[esi],eax
			                              add esi,4
			                              pop ecx
                                   loop loop_3
                                   ;citim a doua matrice
                                    push offset mode
									push offset fisier2
                                    call fopen
                                    add esp,8
			                        mov p1,eax
	                                mov eax,0
	                                mov esi,0
	                                push offset linii
									push offset format1
									push p1
									call fscanf
									add esp,12
									mov eax,linii
									mov edx,0
									mul linii
									mov ecx,eax
									mov esi,0
									mov edi,0
								
	                            
                                    loop_4:
									       mov eax,0
	                                       push ecx
	                                       push offset a
			                               push offset format1
										   push p1
			                               call fscanf
			                               add esp,12
			                               mov eax,a
	                                       mov s2[esi],eax
			                               add esi,4
			                               pop ecx
								    loop loop_4
									
									mov esi,0
									mov eax,linii
	                                mul linii
	                                mov ecx,eax
	                                
									diferenta:
									           mov eax,0
											   mov ebx,0
									           mov eax,s[esi]
			                                   mov ebx,s2[esi]
			                                   sub eax,ebx
			                                   mov diferenta_vector[esi],eax
			                                   add esi,4
									loop diferenta
									push offset message9
									call printf
									add esp,4
									;afisam diferenta
									mov eax,linii
	                                mov edx,0
	                                mul linii
	                                mov ecx,eax
									mov salvam,ecx
	                                mov eax,linii
	                                mov ebx,4
	                                mul ebx
	                                mov ebx,eax
	                                sub eax,4
	                                mov linii_minus_1,eax
	                                mov esi,0
									push offset mode1
									push offset fisier_out
									call fopen
									add esp,8
									mov q1,eax
									mov eax,0
									mov ecx,salvam
									push offset message9
									push q1
									call fprintf
									add esp,8
									mov ecx,salvam
									
									
			
									afisare_diferenta:
									                  mov eax,0
	                                                  push ecx
			                                          mov eax,diferenta_vector[esi]
			                                          push diferenta_vector[esi]
			                                          push offset format2
													  push q1
			                                          call fprintf
			                                          add esp,12
			                                          mov eax,esi
			                                          mov edx,0
			                                          div ebx
			                                          add esi,4
			                                          cmp edx,linii_minus_1
			                                          jne continua3
			                                          je sari1
													  sari1:
													        push offset format3
				                                            push q1
				                                            call fprintf
				                                            add esp,8
													  continua3:
													            pop ecx
                                                                loop afisare_diferenta
													push q1
											        call fclose
											        add esp,4
                        mergi_mai_departe1:
						                    
                                           ;verificam daca este inmultire
                                            mov ecx,3
	                                        mov esi,0
                                            mov ebx,0
	                                        mov cnt,0
                                            verificam_inmultire:
                                                                mov al,inm[esi]
	                                                            cmp s1[esi],al
					                                            je aduna_contor2
					                                            jne continua4
                                                                aduna_contor2:
                                                                              inc cnt
                                                                continua4:
                                                                          inc esi
                                            loop verificam_inmultire
                                            mov ebx,3
                                            cmp ebx,cnt
                                            je fa_inmultire
                                            jne mergi_mai_departe2
                                            fa_inmultire:
											             ;citim prima matrice
                                                         push offset mode
                                                         push offset fisier1
														 call fopen
														 
                                                         add esp,8
                                                         mov fp,eax
														 mov eax,0
														 mov esi,0
														 push offset linii
														 push offset format1
														 push fp
														 call fscanf
														 add esp,12
														 mov eax,linii
														 mov edx,0
														 mul linii
														 mov ecx,eax
														 mov esi,0
														 mov edi,0
			                                             
                                                         loop_5:
                                                                mov eax,0
	                                                            push ecx
	                                                            push offset a
			                                                    push offset format1
																push fp
			                                                    call fscanf
			                                                    add esp,12
			                                                    mov eax,a
	                                                            mov s[esi],eax
			                                                    add esi,4
			                                                    pop ecx
                                                         loop loop_5
                                                         ;in continuare citim numarul cu care vrem sa inmultim matricea A
														 push offset message5
														 call printf
														 add esp,4
	                                                     push offset a
                                                         push offset format1
	                                                     call scanf
                                                         add esp,4
                                                         mov eax,linii
	                                                     mul linii
	                                                     mov ecx,eax
                                                         mov esi,0
	                                                     mov edi,0														 
			                                             inmultire:
														           mov eax,0
			                                                       mov ebx,0
			                                                       mov eax,s[esi]
			                                                       mov ebx,a
			                                                       mul ebx
			                                                       mov inmultire_vector[edi],eax
			                                                       add esi,4
			                                                       add edi,4
														loop inmultire
														
														push offset message11
														call printf
														add esp,4
														;afisam inmultirea
														mov eax,linii
	                                                    mov edx,0
	                                                    mul linii
	                                                    mov ecx,eax
	                                                    mov salvam,ecx
														mov eax,linii
	                                                    mov ebx,4
	                                                    mul ebx
	                                                    mov ebx,eax
	                                                    sub eax,4
	                                                    mov linii_minus_1,eax
	                                                    mov esi,0
														push offset mode1
														push offset fisier_out
														call fopen
														add esp,8
														mov q,eax
														mov eax,0
														mov ecx,salvam
														push offset message11
														push q
														call fprintf
														add esp,8
														mov ecx,salvam
											            mov edi,0
														afisare_inmultire:
														                  mov eax,0
	                                                                      push ecx
			                                                              mov eax,inmultire_vector[esi]
			                                                              push inmultire_vector[esi]
			                                                              push offset format2
																		  push q
			                                                              call fprintf
			                                                              add esp,12
			                                                              mov eax,edi
			                                                              mov edx,0
			                                                              div ebx
			                                                              add edi,4
			                                                              add esi,4
			                                                              cmp edx,linii_minus_1
			                                                              jne continua5
			                                                              je sari2
																		  sari2:
																		            push offset format3
																					push q
				                                                                    call fprintf
				                                                                    add esp,8
																		  continua5:
																		         pop ecx
                                                                                 loop afisare_inmultire
																		
																		push q
											                            call fclose
											                            add esp,4
																		
																		
																		
												mergi_mai_departe2:
                                                                    ;verficam transpusa
																	mov ecx,9
	                                                                mov esi,0
                                                                    mov ebx,0
	                                                                mov cnt,0
																	verificam_transpusa:
																	                    mov al,transp[esi]
	                                                                                    cmp s1[esi],al
					                                                                    je aduna_contor3
					                                                                    jne continua6
                                                                                        aduna_contor3:
                                                                                                      inc cnt
                                                                                        continua6:
                                                                                                  inc esi
																    loop verificam_transpusa
																	mov ebx,9
                                                                    cmp ebx,cnt
                                                                    je fa_transpusa
                                                                    jne mergi_mai_departe3
																	fa_transpusa:
																	             ;citim matricea
																				 push offset mode
																				 push offset fisier1
																				 call fopen
																				 add esp,8
																			     mov fp,eax
                                                                                 mov eax,0
																				 mov esi,0
																				 push offset linii
																				 push offset format1
																				 push fp
																				 call fscanf
																				 add esp,12
																				 mov eax,linii
																				 mov edx,0
																				 mul linii
																				 mov ecx,eax
																				 mov esi,0
																				 mov edi,0
																				 
                                                                                 loop_6:
                                                                                        mov eax,0
	                                                                                    push ecx
	                                                                                    push offset a
			                                                                            push offset format1
																						push fp
			                                                                            call fscanf
			                                                                            add esp,12
			                                                                            mov eax,a
	                                                                                    mov s[esi],eax
			                                                                            add esi,4
			                                                                            pop ecx
                                                                                 loop loop_6
																	             mov eax,linii
	                                                                             mul linii
	                                                                             mov ecx,eax
	                                                                             mov edi,0
	                                                                             mov esi,0
	                                                                             mov eax,linii
	                                                                             mov ebx,4
	                                                                             mul ebx
	                                                                             mov ebx,eax
	                                                                             sub eax,4
	                                                                             mov linii_minus_1,eax
	                                                                             mov cnt,0
																				 transpusa:
																				           push ecx
			                                                                               mov eax,0
			                                                                               mov save,ebx
			                                                                               mov ebx,cnt
			                                                                               mov eax,s[ebx]
			                                                                               mov transpusa_vector[esi+edi],eax
			                                                                               mov ebx,save
			                                                                               mov ebp,0
			                                                                               mov eax,cnt
			                                                                               mov edx,0
			                                                                               div ebx
			                                                                               cmp edx,linii_minus_1
			                                                                               jne continua7
			                                                                               je sari3
																						   sari3:
																						         add edi,4
			                                                                                     mov eax,0
					                                                                             mov edx,0
					                                                                             mov ebp,-4
					                                                                             mov eax,linii
					                                                                             mul ebp
					                                                                             mov esi,eax
																							continua7:
																							          add esi,linii
					                                                                                  add esi,linii
					                                                                                  add esi,linii
					                                                                                  add esi,linii
			                                                                                          pop ecx
					                                                                                  add cnt,4
					                                                                                  loop transpusa
																	                ;afisam transpusa
																					push offset message12
																					call printf
																					add esp,4
																					mov eax,linii
																					mov edx,0
	                                                                                mul linii
	                                                                                mov ecx,eax
																					mov salvam,ecx
	                                                                                mov eax,linii
	                                                                                mov ebx,4
	                                                                                mul ebx
	                                                                                mov ebx,eax
	                                                                                sub eax,4
	                                                                                mov linii_minus_1,eax
	                                                                                mov esi,0
																					push offset mode1
																					push offset fisier_out
																					call fopen
																					mov q,eax
																					mov eax,0
																					mov ecx,salvam
																					push offset message12
																					push q
																				    call fprintf
																					add esp,8
																					mov ecx,salvam
																					
																					
																					afisare_transpusa:
																					                  mov eax,0
	                                                                                                  push ecx
			                                                                                          mov eax,transpusa_vector[esi]
			                                                                                          push transpusa_vector[esi]
			                                                                                          push offset format2
																									  push q
			                                                                                          call fprintf
			                                                                                          add esp,12
			                                                                                          mov eax,esi
			                                                                                          mov edx,0
			                                                                                          div ebx
			                                                                                          add esi,4
			                                                                                          cmp edx,linii_minus_1
			                                                                                          jne continua8
			                                                                                          je sari4
			                                                                                          sari4:
			                                                                                                push offset format3
																											push q
				                                                                                            call fprintf
				                                                                                            add esp,8
		                                                                                              continua8:
			                                                                                                    pop ecx
                                                                                                                loop afisare_transpusa
																												
																												
																									push q
											                                                        call fclose
											                                                        add esp,4
																	mergi_mai_departe3:
																	                   ;verificam determinatul
																					   mov ecx,3
	                                                                                   mov esi,0
                                                                                       mov ebx,0
	                                                                                   mov cnt,0
                                                                                       verificam_determinant:
																	                                         mov al,det[esi]
	                                                                                                         cmp s1[esi],al
					                                                                                         je aduna_contorul3
					                                                                                         jne continuaa6
                                                                                                             aduna_contorul3:
                                                                                                                           inc cnt
                                                                                                             continuaa6:
                                                                                                                       inc esi
																	                   loop verificam_determinant
																	                   
																					   mov ebx,3
                                                                                       cmp ebx,cnt
                                                                                       je fa_determinant
                                                                                       jne mergi_mai_departe4
																	                   fa_determinant:
																					                  ;citim matricea
																	                                  push offset mode
																									  push offset fisier1
																									  
                                                                                                      call fopen
																									  add esp,8
																									  mov fp,eax
																									  mov eax,0
																									  mov esi,0
																									  push offset linii
																									  push offset format1
																									  push fp
																									  call fscanf
																									  add esp,12
																									  mov eax,linii
																									  mov edx,0
																									  mul linii
																									  mov ecx,eax
																									  mov esi,0
																									  mov edi,0
			                                                                                          
																	                                  looop_6:
																	                                          mov eax,0
	                                                                                                          push ecx
	                                                                                                          push offset a
			                                                                                                  push offset format1
																											  push fp
			                                                                                                  call fscanf
			                                                                                                  add esp,12
			                                                                                                  mov eax,a
	                                                                                                          mov s[esi],eax
			                                                                                                  add esi,4
			                                                                                                  pop ecx
																                                      loop looop_6
																									  
																									  
																									  
																	                                  mov eax,salvam
																				                      cmp eax,2
																				                      jne fa_det_de_ord_3
																				                      je determinantul
																									  determinantul:
																				                                    mov eax,0
																								                    mov ebx,0
																								                    mov esi,0
																								                    mov eax,s[0]
																								                    mov ebx,s[12]
																								                    mul ebx
																								                    mov suma_determinant,eax
																								                    mov eax,s[4]
																								                    mov ebx,s[8]
																								                    mul ebx
																								                    
																													sub suma_determinant,eax
																													push offset mode1
																													push offset fisier_out
																													call fopen
																													mov q,eax
																													mov eax,0
																													mov ecx,salvam
																													push suma_determinant
																													push offset message6
																													push q
																										            
																								                    call fprintf
																								                    add esp,8
																													push q
											                                                                        call fclose
											                                                                        add esp,4
																													
																				                      fa_det_de_ord_3:
																									                 
																									                 mov eax,linii
																									                 cmp eax,3
																									                 jne iesi
																									                 je calculeaza_det
																									                 calculeaza_det:
																									                                mov eax,0
																																	mov ebx,0
																																	mov suma_determinant_minus,0
																																	mov suma_determinant_total,0
																																	mov eax,s[0]
																																	mov ebx,s[16]
																																	mul ebx
																																	mov suma_determinant_minus,eax
																																	mov eax,s[32]
																																	mul suma_determinant_minus
																																	mov suma_determinant_total,eax
																																	mov eax,s[12]
																																	mov ebx,s[28]
																																	mul ebx
																																	mov suma_determinant_minus,eax
																																	mov eax,s[8]
																																	mul suma_determinant_minus
																																	add suma_determinant_total,eax
																																	mov eax,s[24]
																																	mov ebx,s[4]
																																	mul ebx
																																	mov suma_determinant_minus,eax
																																	mov eax,s[20]
																																	mul suma_determinant_minus
																																	add suma_determinant_total,eax
																																	mov eax,s[8]
																																	mov ebx,s[16]
																																	mul ebx
																																	mov suma_determinant_minus,eax
																																	mov eax,s[24]
																																	mul suma_determinant_minus
																																	sbb suma_determinant_total,eax
																																	mov eax,s[0]
																																	mov ebx,s[28]
																																	mul ebx
																																	mov suma_determinant_minus,eax
																																	mov eax,s[20]
																																	mul suma_determinant_minus
																																	sbb suma_determinant_total,eax
																																	mov eax,s[12]
																																	mov ebx,s[4]
																																	mul ebx
																																	mov suma_determinant_minus,eax
																																	mov eax,s[32]
																																	mul suma_determinant_minus
																																	sbb suma_determinant_total,eax
																																	push offset mode1
																													push offset fisier_out
																													call fopen
																													mov q,eax
																													mov eax,0
																													mov ecx,salvam
																													push suma_determinant_total
																													push offset message6
																													push q
																										            
																								                    call fprintf
																								                    add esp,8
																													push q
											                                                                        call fclose
											                                                                        add esp,4
																																	
																									          iesi:
																											     
																									               jmp mergi_mai_departe4

                                                                    mergi_mai_departe4:                   																											

																	
	push 0
	call exit
	end start