```
lrm(2020第二次第三题)
op      rs     rt     offest
6       5      5       16
111111(自己编的，方便自己测试)
Addru <- GPR[rs] + sign_ext(offest)
Addr <- Mem[Addru]4...0
GPR[Addr] <- GPR[rt]
```

```
lhw(名字是自己编的，2021第一次第三题)
op    rs    rt    offest
6     5     5     16
100001(自己编的，与lh一致，方便自己测试)
Addr <- GPR[rs] + sign_ext(offest)
half <- Mem[Addr](Addr[0]==0,half为一个半字)
if 1 in word more than 0:
	GPR[rt] <- half
else:
	GPR[31] <- half
endif
	
```

```
bonall:(2021第一次第二题)
opcode  rs  rt   offest
6       5   5     16
000101(自己编的，与bne一致，方便自己测)
I:   target_offest<-sign(offest||0^2)
     condition <- GPR[rs] + GPR[rt] = 0
     GPR[31]<-PC + 8
  
I+1: if condition:
				PC <- PC + starget_offest	
      else:
		        NullilyCurrentInstruction()
	  endif
		        
		        
Tips(当时考场给了)：32'h8000_0000,32'h8000_0000不是相反数
```

