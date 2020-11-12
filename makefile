obj_files = main.o read_file.o
manuel: $(obj_files)
	ld -o manuel $(obj_files)

main: main.s
	as --gstabs main.s -o main.o 

read_file: read_file.s
	as --gstabs read_file.s -o read_file.o 
