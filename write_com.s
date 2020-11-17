  .section .data
section_data:
  .ascii "  .section .data\n"
section_bss:
  .ascii "  .section .bss\n"
section_text:
  .ascii "  .section .text\n"
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
