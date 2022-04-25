echo off
:pc
data_generate.exe
std.exe < in.txt > std_out.txt
java -jar mars.jar mc CompactDataAtZero nc sort.asm < in.txt > src_out.txt
fc std_out.txt src_out.txt
goto pc