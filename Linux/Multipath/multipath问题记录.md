# 1. 链路失效：failed faulty running

现象：ALUA 模式下，mpath 的从链路都出现了失效的报错
（mpathc 的从链路也出现了相同现象，我这里手动使用 multipath -f mpathc 命令来临时移除了故障路径）

![1703559202765](image/multipath问题记录/1703559202765.png)

解决：

1. 有可能是 rbd-target-api 服务挂掉，需要拉起![1703561242594](image/multipath问题记录/1703561242594.png)
