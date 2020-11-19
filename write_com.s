  .section .data
section_data:
  .ascii "  .section .data\n"
section_bss:
  .ascii "  .section .bss\n"
section_text:
  .ascii "  .section .text\n"
start_text:
  .ascii "  .global _start\n"
start_label:
  .ascii "_start:\n"
move_text:
  .ascii "  movq"
#all 64 bit register as text
rax_reg:
  .ascii " %rax"
rbx_reg:
  .ascii " %rbx"
rcx_reg:
  .ascii " %rcx"
rdx_reg:
  .ascii " %rdx"
rsi_reg:
  .ascii " %rsi"
rdi_reg:
  .ascii " %rdi"
rbp_reg:
  .ascii " %rbp"
rsp_reg:
  .ascii " %rsp"
#end of all 64 bit register as text
bang_txt:
  .ascii " $"

comma_txt:
  .ascii ","

  .section .bss
  .section .text


  .type write_section_data, @function
  .global write_section_data
write_section_data:
  pushq %rbp
  movq %rsp, %rbp

  pushq $17
  pushq %rcx
  pushq $section_data
  call writeLine
  addq $24, %rsp

  leave
  ret

  .type write_section_bss, @function
  .global write_section_bss
write_section_bss:
  pushq %rbp
  movq %rsp, %rbp

  pushq $16
  pushq %rcx
  pushq $section_bss
  call writeLine
  addq $24, %rsp

  leave
  ret

  .type write_section_text, @function
  .global write_section_text
write_section_text:
  pushq %rbp
  movq %rsp, %rbp

  pushq $17
  pushq %rcx
  pushq $section_text
  call writeLine
  addq $24, %rsp

  leave
  ret


  .type write_start, @function
  .global write_start
write_start:
  pushq %rbp
  movq %rsp, %rbp

  pushq $17
  pushq %rcx
  pushq $start_text
  call writeLine
  addq $24, %rsp

  pushq $8
  pushq %rcx
  pushq $start_label
  call writeLine
  addq $24, %rsp

  leave
  ret

  .type write_move, @function
  .global write_move
write_move:
  pushq %rbp
  movq %rsp, %rbp

  pushq $6
  pushq %rcx
  pushq $move_text
  call writeLine
  addq $24, %rsp

  #test first register
  xorq %rdx, %rdx #rdx holds address
  cmp $0, %bh
  jne next_cmp1
  leaq rax_reg, %rdx  

next_cmp1:
  cmp $1, %bh
  jne next_cmp2
  leaq rbx_reg, %rdx  

next_cmp2:
  cmp $2, %bh
  jne next_cmp3
  leaq rcx_reg, %rdx  

next_cmp3:
  cmp $3, %bh
  jne next_cmp4
  leaq rdx_reg, %rdx  

next_cmp4:
  cmp $4, %bh
  jne next_cmp5
  leaq rsi_reg, %rdx  

next_cmp5:
  cmp $5, %bh
  jne next_cmp6
  leaq rdi_reg, %rdx  

next_cmp6:
  cmp $6, %bh
  jne next_cmp7
  leaq rbp_reg, %rdx  

next_cmp7:
  cmp $7, %bh
  jne next_cmp8
  leaq rsp_reg, %rdx  
next_cmp8: 

#end loead first register
#load number 
  cmp $8, %bh
  jne next_cmp9

  pushq $2
  pushq %rcx
  pushq $bang_txt
  call writeLine
  addq $24, %rsp
 
  movq %rbx, %rdi 
  shlq $40, %rdi
  shrq $40, %rdi
  shrq $16, %rdi
  pushq %rdi
  pushq %rcx
  pushq %rsi
  call writeLine
  addq $24, %rsp
 
  jmp dont_do_reg
next_cmp9: 
#end load number
#load label
  cmp $9, %bh
  jne next_cmp10

  movq %rbx, %rdi 
  shlq $40, %rdi
  shrq $40, %rdi
  shrq $16, %rdi
  pushq %rdi
  pushq %rcx
  pushq %rsi
  call writeLine
  addq $24, %rsp
 
  jmp dont_do_reg 
next_cmp10:
#end load label
  pushq $5
  pushq %rcx
  pushq %rdx
  call writeLine
  addq $24, %rsp

dont_do_reg: 

#do second operand
  pushq $1
  pushq %rcx
  pushq $comma_txt
  call writeLine
  addq $24, %rsp
 
  xorq %rdx, %rdx #rdx holds address
  shrq $32, %rbx 

  cmp $0, %bh
  jne next_cmps1
  leaq rax_reg, %rdx  

next_cmps1:
  cmp $1, %bh
  jne next_cmps2
  leaq rbx_reg, %rdx  

next_cmps2:
  cmp $2, %bh
  jne next_cmps3
  leaq rcx_reg, %rdx  

next_cmps3:
  cmp $3, %bh
  jne next_cmps4
  leaq rdx_reg, %rdx  

next_cmps4:
  cmp $4, %bh
  jne next_cmps5
  leaq rsi_reg, %rdx  

next_cmps5:
  cmp $5, %bh
  jne next_cmps6
  leaq rdi_reg, %rdx  

next_cmps6:
  cmp $6, %bh
  jne next_cmps7
  leaq rbp_reg, %rdx  

next_cmps7:
  cmp $7, %bh
  jne next_cmps8
  leaq rsp_reg, %rdx  
next_cmps8: 

#load number 
  cmp $8, %bh
  jne next_cmps9

  pushq $2
  pushq %rcx
  pushq $bang_txt
  call writeLine
  addq $24, %rsp
 
  movq %rbx, %rdi 
  shlq $40, %rdi
  shrq $40, %rdi
  shrq $16, %rdi
  pushq %rdi
  pushq %rcx
  pushq %rsi
  call writeLine
  addq $24, %rsp
 
  jmp dont_do_reg1
next_cmps9: 
#end load number
#load label
  cmp $9, %bh
  jne next_cmps10

  movq %rbx, %rdi 
  shlq $40, %rdi
  shrq $40, %rdi
  shrq $16, %rdi
  pushq %rdi
  pushq %rcx
  pushq %rsi
  call writeLine
  addq $24, %rsp
 
  jmp dont_do_reg1 
next_cmps10:
#end load label
  pushq $5
  pushq %rcx
  pushq %rdx
  call writeLine
  addq $24, %rsp

dont_do_reg1: 

  leave
  ret
