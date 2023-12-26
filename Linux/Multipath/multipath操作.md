# 1. Multipath 简介

Device Mapper Multipath 可以将服务器节点和存储阵列之间的多条 IO 链路配置为一个单独的设备；

这些 IO 链路是由不同的线缆、交换机、控制器组成的 SAN 物理链路，multipath 将这些链路聚合在一起，生成一个单独的新设备

作用：

1. 数据冗余：multipath 可以实现在 active/passive 模式下的灾难转移，在 ap 模式下，只有一半的链路在工作，如果链路上的某一部分出现故障，multipath 就会切换到另一半链路上
2. 提高性能：multipath 亦可以配置为 active/active 模式，从而使 IO 任务以 round-robin 的方式分布到所有的链路上去；通过配置，multipath 还可以检测链路上的负载情况，动态地进行负载均衡

# 2. multipath 使用

## 2.1 multipath 部署

## 2.2 multipath 配置解释

这些配置项定义了对多路径设备的处理规则、默认配置以及黑名单例外规则，这些配置可以确保系统能够正确地识别和处理多路径设备。

```Bash
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Docsify-Guide</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta name="description" content="Description">
    <meta name="viewport"
        content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <!-- 设置浏览器图标 -->
    <link rel="icon" href="/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
    <!-- 默认主题 -->
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/docsify/lib/themes/vue.css">
</head>

<body>
    <!-- 定义加载时候的动作 -->
    <div id="app">加载中...</div>
    <script>
        window.$docsify = {
            // 项目名称
            name: 'Docsify-Guide',
            // 仓库地址，点击右上角的Github章鱼猫头像会跳转到此地址
            repo: 'https://github.com/YSGStudyHards',
            // 侧边栏支持，默认加载的是项目根目录下的_sidebar.md文件
            loadSidebar: true,
            // 导航栏支持，默认加载的是项目根目录下的_navbar.md文件
            loadNavbar: true,
            // 封面支持，默认加载的是项目根目录下的_coverpage.md文件
            coverpage: true,
            // 最大支持渲染的标题层级
            maxLevel: 5,
            // 自定义侧边栏后默认不会再生成目录，设置生成目录的最大层级（建议配置为2-4）
            subMaxLevel: 4,
            // 小屏设备下合并导航栏到侧边栏
            mergeNavbar: true,
            /*搜索相关设置*/
            search: {
                maxAge: 86400000,// 过期时间，单位毫秒，默认一天
                paths: 'auto',// 注意：仅适用于 paths: 'auto' 模式
                placeholder: '搜索',            
                // 支持本地化
                placeholder: {
                    '/zh-cn/': '搜索',
                    '/': 'Type to search'
                },
                noData: '找不到结果',
                depth: 4,
                hideOtherSidebarContent: false,
                namespace: 'Docsify-Guide',
            }
        }
    </script>
    <!-- docsify的js依赖 -->
    <script src="//cdn.jsdelivr.net/npm/docsify/lib/docsify.min.js"></script>
    <!-- emoji表情支持 -->
    <script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/emoji.min.js"></script>
    <!-- 图片放大缩小支持 -->
    <script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/zoom-image.min.js"></script>
    <!-- 搜索功能支持 -->
    <script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/search.min.js"></script>
    <!--在所有的代码块上添加一个简单的Click to copy按钮来允许用户从你的文档中轻易地复制代码-->
    <script src="//cdn.jsdelivr.net/npm/docsify-copy-code/dist/docsify-copy-code.min.js"></script>
</body>

</html>devices {
                device {
                        vendor                 "LIO-ORG"
                        product                "TCMU device"
                        hardware_handler       "1 alua"
                        path_grouping_policy   "failover"
                        path_selector          "queue-length 0"
                        failback               60
                        path_checker           tur
                        prio                   alua
                        prio_args          exclusive_pref_bit
                        fast_io_fail_tmo       25
                        no_path_retry          queue
                }
        }

blacklist {
# devnode ".*"
}

defaults {
        user_friendly_names yes
        find_multipaths yes
        enable_foreign "^$"
}

blacklist_exceptions {
        property "(SCSI_IDENT_|ID_WWN)"
}
```

1. `devices` 部分：这部分定义了对特定设备的处理规则。在这里，配置了对 LIO-ORG 供应商的 "TCMU device" 的处理规则。具体的配置包括：
   1. `vendor` 和 `product`：指定了需要处理的设备的厂商和产品信息。
   2. `hardware_handler`：指定了设备的硬件处理器，这里使用了 ALUA（Asymmetric Logical Unit Access）处理器。

      * ALUA 路径管理模式中的 "1" 表示使用了 ALUA 的标准版本。 ALUA 还有其他版本，比如 "2" 表示使用了 ALUA-2 标准
   3. `path_grouping_policy`：指定了路径分组的策略，这里是 failover，表示在主路径失效时切换到备用路径。
   4. `path_selector`：指定了路径选择器的策略，这里使用了 queue-length 0，表示使用队列长度为 0 的算法进行路径选择。
   5. `failback`：指定了路径的故障恢复时间，这里是 60 秒。
      在生产环境中如果使用主动/被动的分组策略，最好将 failback 设为 immediate，这样在发生路径故障后会立即切换到其他正常路径，以保证正常的数据访问
      failback 一般有以下可选参数：

      * immediate：表示指定立即恢复到包含活跃路径的最高级别路径组群
      * manual：不需要立即恢复，只有在操作者干预的情况下发生恢复
      * followover：当路径组的第一个路径成为活跃路径时应执行自动恢复
      * 大于 0 的数字：指定对应时间的推迟出错切换，以秒为单位，例如本文配置中为 60s

* `path_checker`：指定了路径检测器的类型，这里使用了 TUR（Test Unit Ready）检测器。
* `prio` 和 `prio_args`：指定了路径的优先级和相关参数，这里是 alua 和 exclusive_pref_bit。
* `fast_io_fail_tmo`：指定了快速 IO 失败超时时间，这里是 25 秒。
* `no_path_retry`：指定了无路径时的重试策略，这里是 queue，表示将 IO 请求放入队列等待路径恢复。

2. `blacklist` 部分：这部分定义了需要屏蔽的设备。在这里，所有设备都是被注释掉的，表示没有设备被屏蔽。
3. `defaults` 部分：这部分定义了默认的多路径设备配置。具体的配置包括：
   1. `user_friendly_names`：指定了是否使用用户友好的设备名，这里是启用了用户友好的设备名。
   2. `find_multipaths`：指定了是否查找多路径设备，这里是启用了查找多路径设备。
   3. `enable_foreign`：指定了哪些设备应该被视为外部设备，这里是没有指定任何外部设备。
4. `blacklist_exceptions` 部分：这部分定义了例外的黑名单规则。在这里，使用了正则表达式来匹配例外的属性，这里匹配了以 "SCSI_IDENT_" 或 "ID_WWN" 开头的属性。

# 3. 多路径切主

## 3.1 确认设备对应的路径

```Bash
multipath -ll
```

![](https://avfz9yyd53o.feishu.cn/space/api/box/stream/download/asynccode/?code=ZTM2NGQ2ZDdlOTMyMjg2ZGM3M2FkN2UwNDQwY2FmNWZfZHJMS3ZsbElCR0ZkaEVsQ2p4R3RsejhyRWFpNXpFMXBfVG9rZW46VHRpa2JkY1pGb3VsWkJ4bmZiMWN0S29Cbkp2XzE3MDM1NTY2NTc6MTcwMzU2MDI1N19WNA)

以 mpathc 为例，对应有 sdg、sdd 两个设备，同时可以看到 sdg 状态为 active，说明此时 sdg 为 mpathc 的主路径

## 3.2 切换主路径

1. 进入 multipath 交互模式

```Bash
multipathd -k
```

2. 查看多路径拓扑

```Bash
show topology
```

与前文的信息对应

![](https://avfz9yyd53o.feishu.cn/space/api/box/stream/download/asynccode/?code=NDY2NjA0MzcwMzRhNzY1MTc2Yzk5NjkyMTFlOTkzYjhfUUh3VXJzVEJZMFpseTZNaTd3T3pWVFBpMDY5MVNESFZfVG9rZW46UGNJbWI4T29Eb2RQc1d4WDZBNWNVY1JFbmhjXzE3MDM1NTY2NTc6MTcwMzU2MDI1N19WNA)

3. 切主

以 mpathc 为例，设备下有多条路径，第一条 sdg 为 group 1，第二条 sdd 为 group 2， 如果想切换主路径到sdd，那么需要执行：

```Bash
switch map mpathc group 2
```

![](https://avfz9yyd53o.feishu.cn/space/api/box/stream/download/asynccode/?code=NzNiNWMwNzMwOTg5MDBkM2QzYTlmZTNmOGJiZjljOTZfQ1JESTFVU0Z3djE3TXlBS1Y2WHhhZjRiVVBaTUxsR1lfVG9rZW46SGJwcGJ6R1Q5bzNwTW94NHZMNmN1UjJSbmVkXzE3MDM1NTY2NTc6MTcwMzU2MDI1N19WNA)

## 3.3 测试

切换之后显示一般会有延时，可以打 IO 来看

![](https://avfz9yyd53o.feishu.cn/space/api/box/stream/download/asynccode/?code=YTA3MzgzNmI5NzdhMjk1NTM0ZmQ3N2JhYTQwMzhkNWVfQ25tSUNNTm5zajRkc2REMzFWMmFubjVzaXlTM1RHNTlfVG9rZW46QUVPTWJIZzI0bzNNWTl4YjNEcmMwaGZMbkxlXzE3MDM1NTY2NTc6MTcwMzU2MDI1N19WNA)

对 mpathc 进行顺序读：可以看到负载在 sdd 上

![](https://avfz9yyd53o.feishu.cn/space/api/box/stream/download/asynccode/?code=NGJlNDA3MzQxMDc2OWEwNjc2YjcyMjZmOGQ4OTBlZTdfQlVPb3hZT3ozTGFJaGlDcW00cjFYOWNvQkRkNHFoNVJfVG9rZW46T0VzZWI2T0wzb0hRVDR4VkhqVmNxMkNkbjRkXzE3MDM1NTY2NTc6MTcwMzU2MDI1N19WNA)

# 问题记录

---

# End
