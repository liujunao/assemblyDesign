# assemblyDesign

对于 dosbox5.0 的使用欢迎参考 

[将汇编源代码通过DOSBox5.0编译成 .exe 文件](http://blog.csdn.net/yin__ren/article/details/78984708)

[dosbox生成可执行文件时的错误列表](http://blog.csdn.net/yin__ren/article/details/78985451)

1. 数据段：在数据段定义相关的打印提示语句和临时存储区

2. 堆栈段：定义200个字节大小的存储区

3. 代码段：

   > 1. 首先打印提示输入语句
   > 2. 对输入的数字进行检查，看是否有非法字段。若有，则提示重新输入
   > 3. 将获取的数字（ascii码）转换成真实值并保存在num4临时存储区中
   > 4. 然后将100赋给cx，进行循环。若cx小于输入值，则进行 5，否则进行 6
   > 5. 比较当前值与其各位数字立方和的大小，若相等，则输出该数，否则，跳过该循环
   > 6. 提示是否继续，若继续，回到3.1，否则，退出程序



说明：

1. 首先，代码中采取大量的子程序定义与调用，简化了主程序的代码量

2. 采取1号输入，并将输入保存在堆栈中

3. 采用 and ax,0FH 对输入的ascii码转换为真实的数字值

4. 采用 0-9 的立方值的 tab 来获取对应数的立方值，简化了多次乘法的性能消耗。

5. 堆栈和临时存储区段，使得对数据的存储更清晰