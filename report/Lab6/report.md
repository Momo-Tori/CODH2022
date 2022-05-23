## 补全指令

最后所有指令如图所示

![](pic/%E6%8C%87%E4%BB%A4%E9%9B%86%E5%90%88.png)

## 动态预测

### 饱和计数器

![](pic/1.png)

### 基于全局历史的分支预测

实现了对`branch`的支持

![](pic/2.jpg)


使用实例数组对饱和计数器实例化为数组


https://www.cnblogs.com/nevercode/p/15201279.html

### 跳转指令cache

实现了对`branch`和`jar`的支持，对于`jarr`因为其依赖于寄存器而不好进行处理故不支持

全相连、FIFO



参考https://zhuanlan.zhihu.com/p/490749315