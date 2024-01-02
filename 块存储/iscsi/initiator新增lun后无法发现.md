# 1. 问题

在 gwcli 中对 122-client 新增了一个 image，显示成功了，但是在 node122 中 multipath -ll 无法扫描到

![1704177511346](image/initiator新增lun后无法发现/1704177511346.png)

只扫出原有的 map

![1704177613161](image/initiator新增lun后无法发现/1704177613161.png)

# 2. 解决

已做操作：

- iscsiadm -m discovery -t st -p node121
- systemctl restart iscsi
- systemctl restart iscsid


排查：

1. `iscsiadm -m node -T iqn.2023-12.com.ictrek:121-target -l` 发现输出为空

![1704177713931](image/initiator新增lun后无法发现/1704177713931.png)


正常的 node123：

![1704177853298](image/initiator新增lun后无法发现/1704177853298.png)


2. 手动重启 iSCSI 服务后，退出 iscsi
   ```
   iscsiadm -m node -T iqn.2023-12.com.ictrek:121-target --logout
   ```

    ![1704179821135](image/initiator新增lun后无法发现/1704179821135.png)


3. 重新关联
   ```
   iscsiadm -m node -T iqn.2023-12.com.ictrek:121-target -l
   ```

    ![1704179853208](image/initiator新增lun后无法发现/1704179853208.png)


4. 再次检查 mpath
   ```
   multipath -ll
   ```

    ![1704179889588](image/initiator新增lun后无法发现/1704179889588.png)
