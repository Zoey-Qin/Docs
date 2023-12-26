# 1. 模拟拔插 iSCSI 磁盘

1. 拔盘，对应的四个数字是 SCSI 的设备地址信息：可以通过 `lsscsi` 查看

   * 第一个数字（6）表示控制器编号，这是指第几个 SCSI 控制器，通常系统中只有一个控制器时为 0。
   * 第二个数字（0）表示通道编号，它指的是控制器上的通道号，通常也为 0。
   * 第三个数字（0）表示目标编号（Target ID），它表示 SCSI 设备的编号，通常为 0 到 7（一般情况下是0~15，但是一般来说只有0~7）
   * 第四个数字（0）表示盘片编号（LUN），在大多数情况下为 0，表示第一个逻辑单元号。

```Bash
echo "scsi remove-single-device 6 0 0 0"> /proc/scsi/scsi
```


2. 插盘

```Bash
echo "scsi add-single-device 6 0 0 0"> /proc/scsi/scsi
```
