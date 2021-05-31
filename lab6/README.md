#### 版本记录

- [x] Ver0.5

  basic五级流水

  需要`nop`填充，没有`flush`，没有`stall`

  不支持冒险，不支持分支（`beq`，`jal`，`j`，`jr`）

- [x] Ver0.6

  引入了`write_finish`，在写入寄存器后修改，解决了`structural hazard`

  支持`flush`，分支预测总是不跳转，解决了`control hazard`

- [x] Ver0.8

  支持stall，通过了`main.s`的测试

- [ ] Ver1.0

  支持forwarding

  

  

  
  
  