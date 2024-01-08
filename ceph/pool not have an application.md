1. ceph -s出现 warn : 1 pool(s) do not have an application enabled

![image-20240108103637343](D:\notes\Docs\ceph\assets\image-20240108103637343.png)

2. 查看具体告警信息

```
ceph health detail
```

![image-20240108103759378](D:\notes\Docs\ceph\assets\image-20240108103759378.png)可以看到这是因为创建 pool 却没有指定具体应用导致的



3. 为 pool 指定应用，这里提示有 rbd、cephfs、rgw 可用
   我这里是块应用，所以指定为 rbd

   ```
   ceph osd pool application enable mypool rbd
   ```

   ![image-20240108104004610](D:\notes\Docs\ceph\assets\image-20240108104004610.png)

4. 验证集群状态

![image-20240108104028556](D:\notes\Docs\ceph\assets\image-20240108104028556.png)