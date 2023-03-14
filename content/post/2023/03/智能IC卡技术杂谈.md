---
title: "智能 IC 卡技术杂谈"
date: 2023-03-14T02:29:14Z
lastmod: 2023-03-14T02:29:14Z
draft: false
keywords: [转载,IC, Mifare1, M1, ISO-14443, ISO7816, UID, CUID, FUID, APDU, EMV, PBOC, COS,]
description: ""
tags: [转载, IC, M1, APDU, EMV, PBOC]
categories: [mcu]
author: ""

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: true
toc: true
autoCollapseToc: false
postMetaInFooter: true
hiddenFromHomePage: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: true
mathjax: false
mathjaxEnableSingleDollar: false
mathjaxEnableAutoNumber: false

# You unlisted posts you might want not want the header or footer to show
hideHeaderAndFooter: false

# You can enable or disable out-of-date content warning for individual post.
# Comment this out to use the global config.
#enableOutdatedInfoWarning: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

> 转自： [智能 IC 卡技术杂谈 | UinIO.com 电子技术博客 (uinika.github.io)](https://uinika.github.io/Embedded/Mifare/)
> OR: https://zhuanlan.zhihu.com/p/427769694

**集成电路卡**又称为  **IC 卡**（Integrated Circuit Card），是一种内嵌有集成电路的塑料`标签`或`卡片`，其集成电路当中包含有  `8`  位或者  `32`  位的**微控制单元** MCU、**只读存储器** ROM、**电可擦只读存储器** EEPROM（按字节操作）或者**闪速存储器** Flash（按扇区操作）、**随机访问存储器** RAM，以及固化在只读存储器 ROM 当中的**片内操作系统**（COS，Chip Operating System），并且通常内置有  `DES`、`RSA`、`国密 SMx`、`SSF`  等加解密算法。

![](https://uinika.github.io/Embedded/Mifare/logo.png)

目前市场上主流的 IC 卡芯片有[**恩智浦 NXP**](https://www.mifare.net/en/)  的  **Mifare**  系列、[**英飞凌 Infineon**](https://www.infineon.com/cms/cn/product/security-smart-card-solutions/)  的  **SL**  系列、、[**复旦微电子**](http://www.fmsh.com/7e67a741-a1ed-718d-15e3-83bdb6ecf4fa/)  的  **FM**  系列，[**华大半导体**](http://www.hed.com.cn/CN/WebPage_51_77.aspx)的  **SHC**  和  **CIU**  系列除此之外，还有  [**华虹集成电路**](http://www.shhic.com/products.aspx)  的  **SHC**  系列，以及[**大唐微电子**](https://www.datang.com/productservice/ps1/list1.html)  的  **DMT**  系列，[**紫光国微**](https://www.gosinoic.com/index.php?f=lists&catid=10)的  **THD**  系列。这些芯片主要遵循  **《ISO/IEC 7816》**  和**《ISO/IEC 14443 TypeA》**两部协议规范，本文主要介绍了笔者在日常工作当中，经常接触到的各类智能卡相关的技术与规范。

<!--more-->

## 接触 & 非接触 & 双界面卡

接照用途和构成，可以将 IC 卡划分为**存储卡**（Memory Card）和带有 CPU 的**智能卡**（Smart Card）。

- **接触式卡**：IC 芯片封装在 PVC 塑料里面，但是触点外露，需要与卡槽产生物理接触才能读写数据；
- **非接触式卡**：IC 芯片依然被封装在 PVC 塑料当中，但是通过内置的线圈感应读写卡设备上的电磁波，从而实现非接触式的读写数据；
- **双界面卡**：集`接触式`与`非接触式`接口为一体的单芯片智能卡，两种接口共享着相同的微控制器、操作系统、EEPROM；

![](https://uinika.github.io/Embedded/Mifare/IC-Card.gif)

> **注意**：许多 IC 卡芯片的数据手册当中，`读写卡设备`通常被称为**邻近耦合装置**（**PCD**，Proximity Coupling Device），而`IC 卡片`本身则通常被称为**感应卡**（**PICC**，Proximity Card）。

## ISO/IEC 7816

**ISO/IEC 7816**  是一种标准化的接触式智能卡通信协议，主要用于读写**接触式**的集成电路卡，该协议由如下 14 个部分组成：

- [**ISO7816-1**](https://www.iso.org/standard/14732.html)：物理特性；
- [**ISO7816-2**](https://www.iso.org/standard/14733.html)：触点的尺寸与位置；
- [**ISO7816-3**](https://www.iso.org/standard/38770.html)：电子接口与传输协议；
- [**ISO7816-4**](https://www.iso.org/standard/77180.html)：用于交换的组织、安全、命令，即定义了如何使用**应用程序标识符**检索卡片中的应用程序，并且执行相关的检索操作；
- [**ISO7816-5**](https://www.iso.org/standard/34259.html)：应用提供商注册，即通过对**应用程序标识符**进行国际注册，从而授予其唯一性；
- [**ISO7816-6**](https://www.iso.org/standard/64598.html)：交换用行业间数据元素；
- [**ISO7816-7**](https://www.iso.org/standard/28869.html)：用于结构化卡片查询语言（SCQL，Structured Card Query Language）的行业间指令 ；
- [**ISO7816-8**](https://www.iso.org/standard/66092.html)：安全操作的命令与机制；
- [**ISO7816-9**](https://www.iso.org/standard/67802.html)：卡片管理相关的指令；
- [**ISO7816-10**](https://www.iso.org/standard/30558.html)：电子信号与同步卡的应答复位；
- [**ISO7816-11**](https://www.iso.org/standard/67799.html)：采用生物特征识别的方法，来进行个人身份验证；
- [**ISO7816-12**](https://www.iso.org/standard/40604.html)：USB 电气接口及操作过程；
- [**ISO7816-13**](https://www.iso.org/standard/40605.html)：多应用环境下的应用管理命令；
- [**ISO7816-15**](https://www.iso.org/standard/65250.html)：密码信息应用，即加密信息的通用语法和格式，以及在适当时共享此信息的机制

其中，**ISO/IEC 7816-4**  里面定义了**应用协议数据单元**（APDU，Application Protocol Data Unit）相关的内容，包括接口上交换的  `命令-响应`  对的内容、检索 IC 卡里数据元素和数据对象的方法、通过历史字节的结构与内容来描述 IC 卡的工作特性、IC 卡当中程序和数据的结构、访问 IC 卡里文件和数据的方法、定义 IC 卡内文件与数据访问权限的安全体系结构、用于识别与定位 IC 卡当中应用的方法与机制、安全消息传递的方式、访问 IC 卡内置的处理算法；

> **注意**：国际标准化组织并未提供标号为《ISO 7816-14》的技术规范；

## ISO/IEC 14443

**ISO/IEC 14443**  定义了  **Type A**  和  **Type B**  两种 IC 卡类型，它们均工作在  `13.56MHz`  无线频率，两者的主要区别在于调制方式、编码方案（协议第 2 部分）、协议初始化过程（协议第 3 部分）三个方面，但是都共同采用了协议第 4 部分定义的传输协议，该协议主要由如下 4 个部分组成：

- [**ISO/IEC 14443-1**](https://www.iso.org/standard/73596.html)：物理特性；
- [**ISO/IEC 14443-2**](https://www.iso.org/standard/82757.html)：射频电源以及信号接口；
- [**ISO/IEC 14443-3**](https://www.iso.org/standard/76566.html)：初始化和防撞；
- [**ISO/IEC 14443-4**](https://www.iso.org/standard/76562.html)：传输协议；

`读写卡装置`与 IC 卡之间的无线通信频率为  `13.56MHz`，当`读写卡装置`对 IC 卡进行读写操作时，所发出的信号主要由 2 部分叠加组成：

1. **电源信号**：是一组由`读写卡装置`向 IC 卡发送的固定频率电磁波，卡片内置  **LC 串联谐振电路**  的频率与`读写卡装置`发射的频率相同，在电磁波的激励下这个 LC 电路产生共振，让卡片内置的电容充满电荷，同时另一端连接的单向导通**电子泵**会将这些电荷传送至另一个电容进行存储，当累积电荷达到  `2V`  时，该电容就可以作为电源为卡片进行供电；
2. **指令与数据信号**：用于`读写卡装置`指挥 IC 芯片完成数据的读取、修改、储存等操作，并且返回响应信号给`读写卡装置`，从而完成一次读写操作过程；

ISO/IEC 14443 可以具体划分为由恩智浦（NXP）等公司提出的  **Type A**，以及由意法半导体（ST）等公司提出的  **Type B**  两种标准，两者的区别主要体现在  **IC 卡**与`读写卡装置`之间的通讯调制方式：

1. **Type A 标准**：表示数据  `1`  时，信号会出现  `0.2 ~ 0.3`  微秒的间隔；而当表示数据  `0`  时，信号可能有间隙也可能没有，这与前后的信息相关；这种方式优点在于信息区别明显，受干扰的机会少，反应速度快，不容易误操作；缺点在于当需要为 IC 卡提供更高的工作电压时，传输的电量有可能会出现波动；
2. **Type B 标准**：表达数据  `1`  的信号幅度更大，而数据  `0`  的信号幅度更小，该方式的优点在于可以持续不断的传递信号，不会出现能量波动的情况；缺点在于数据区别不够明显，相对更容易受到外界干扰；

## Mifare 1 卡

恩智浦半导体于 1994 年 推出的  [Mifare Classic 系列](https://www.nxp.com/products/rfid-nfc/mifare-hf/mifare-classic:MC_41863)  也被称为  **Mifare 1**，即俗称的  **M1 卡**。其工作频率为  `13.56MHZ`，符合  **ISO 14443 Type A**  非接触式射频卡规范，虽然其采用的私有算法  **CRYPTO1**  已经遭到破解，但是由于目前国内市场上存在着大量与其相兼容的国产芯片（例如复旦微电子的  [**FM11RF08**](http://www.fmsh.com/7e67a741-a1ed-718d-15e3-83bdb6ecf4fa/)  芯片），所以并不妨碍其被广泛使用在安全等级要求较低的场合。

![](https://uinika.github.io/Embedded/Mifare/Mifare-0.png)

- **标准 M1 卡**：第  `0`  扇区不可以进行修改，其它扇区则可以反复进行擦写；
- **UID 卡**：所有区块都可以被重复擦写，可以重复修改卡片 ID ，并且响应后门指令（克隆卡会被使用后门指令检测到）；
- **CUID 卡**：所有区块都可以被重复擦写，同样可以重复修改卡片 ID ，但是不会响应后门指令（避免克隆卡被后门指令检测）；
- **FUID 卡**：`0`  区块只能够被写入一次，然后变为 M1 卡，在 CUID 复无效的情况下，或许可以绕开反克隆设备；

标准 Mifare 1 卡的 EEPROM 被划分为  **16**  个**扇区**（Sectors），其中每个扇区由  **4**  个**数据块**（Blocks）组成，每个数据块拥有  **16**  个**字节**（Bytes）：

![](https://uinika.github.io/Embedded/Mifare/Mifare-1.png)

1. **厂商信息**（Manufacturer Block）：第  **0**  扇区的**块 0**，用于存放厂商的 32 位序列号，已经固化，只可读不可修改；
2. **数据块**（Data Blocks）：用于保存数据，可以直接读写，以特殊数据格式表示时，可以进行初始化赋值、加减值、读取值；
3. **扇区模块**（Value Blocks）：每个扇区的**块 3**，存放的是该扇区的密码  **A**（6 bytes）、存取控制（4 bytes）、密码  **B**（6 bytes）；

![](https://uinika.github.io/Embedded/Mifare/Mifare-2.png)

1. **复位应答**（Request Standard/All）：上电复位之后，IC 卡使用**应答请求码**（**ATQA**，Answer To Qequest）响应`请求 REQA`或`唤醒 WUPA`的指令；
2. **防碰撞循环**（Anticollision Loop）：当存在多张 IC 卡在读写卡装置的周围时，为了防止发生冲突与碰撞，需要从多张 IC 卡当中选择一张作为处理对象，而未选中的 IC 卡则会处于空闲模式，以等待下一步被选择，这个过程当中会返回一个被选中的 IC 卡序列号；
3. **选择 IC 卡**（Select Card）： 选择当前被选中的 IC 卡序列号，此时 IC 卡会返回一个**选择确认码**（**SAK**，Select AcKnowledge）；
4. **三次互相确认**（Three Pass Authentication）：选定待处理的 IC 卡之后，读写卡装置开始确定当前所要访问的扇区号，并且对该扇区的密码进行校验，在经过三次互相确认之后，就可以通过加密的信号进行通信；而当选择另一个扇区时，则必须重新进行扇区的密码校验；

当  `IC 卡`与`读写卡装置`完成上述认证过程之后，就可以执行如下操作步骤：

- **读写块**（Read/Write Block）：读写一个块当中的数据；
- **加减法**（Decrement/Increment）：对块当中的内容执行加减法，并将结果保存在**内部传输缓冲区**；
- **恢复**（Restore）：将一个块的内容移动至`内部传输缓冲区`；
- **传输**（Transfer）：将`内部传输缓冲区`的内容写入到一个**数据块**；
- **停止**（Halt）：将卡片置于暂停工作状态；

## 应用协议数据单元 APDU

应用协议数据单元（**APDU**，Application Protocol Data Unit）是卡片和外部应用之间的通信报文协议，其格式标准被定义在  **ISO7816-4**  当中，具体可以被划分为**命令**和**响应**两种类型：

- **命令 APDU**  由`读写卡装置`发送到`智能卡`，其中包含一个必选的 4 字节头部  `CLA + INS + P1 + P2`  以及  `0 ~ 255`  字节的数据；
- **响应 APDU**  由`智能卡`返回给`读写卡装置`，其中包含有必选的 2 字节状态字和  `0 ~ 255`  字节的数据；

下面表格展示了一个 APDU **命令-响应对**（Command-Response Pair），即**命令 APDU**  和**响应 APDU**：

| 命令 APDU 字段 | 功能描述                                                           | 字节数  |
| -------------- | ------------------------------------------------------------------ | ------- |
| 命令头         | 表示 CLA 的类字节                                                  | 1       |
| -              | 表示 INS 的指令字节                                                | 1       |
| -              | 表示  `P1 - P2`  的参数字节                                        | 2       |
| $L_c$ 字段     | 编码 $N_c$ = 0 时缺省，而 $N_c$ > 0 时出现                         | 0,1,3   |
| 命令数据字段   | 编码 $N_c$ = 0 时缺省，而 $N_c$ > 0 时体现为一个 $N_c$字节的字符串 | $N_c$   |
| $L_e$ 字段     | 编码 $N_c$ = 0 时缺省，而 $N_c$ > 0 时出现；                       | 0,1,2,3 |

| 响应 APDU 字段 | 功能描述                                                           | 字节数             |
| -------------- | ------------------------------------------------------------------ | ------------------ |
| 响应数据字段   | 编码 $N_r$ = 0 时缺省，而 $N_r$ > 0 时体现为一个 $N_r$字节的字符串 | $N_r$ (最多 $N_e$) |
| 响应尾         | 状态字节为 `SW1-SW2`                                               | 2                  |

## EMV 与 PBOC 银行卡标准

**EMV**（Europay MasterCard Visa）标准是由全球三大银行卡组织**欧陆卡**（Europay）、**万事达卡**（MasterCard）和**维萨卡**（Visa）共同发起制定的银行卡技术标准，是基于 IC 卡的金融支付标准，目前已经成为全球公认的统一标准。其中，接触式卡片以  **ISO/IEC 7816**  作为标准，而**非接触式卡片**则主要以  **ISO/IEC 14443**  作为标准。

**中国人民银行**（PBOC，People's Bank of China）于 2013 年正式颁布《中国金融集成电路 IC 卡规范》`V3.0`  版本，类似上面的介绍的 EMV，也属于一种**金融集成电路智能卡**感应端与接收端的规范标准。并且接触式卡片同样以  **ISO/IEC 7816**  作为标准，而**非接触式卡片**则主要以  **ISO/IEC 14443**  作为标准。

- 第  **1**  部分：《总则》；
- 第  **3**  部分：《与应用无关的 IC 卡与终端接口规范》；
- 第  **4**  部分：《借记贷记应用规范》；
- 第  **5**  部分：《借记贷记应用卡片规范》；
- 第  **6**  部分：《借记贷记应用终端规范》；
- 第  **7**  部分：《借记贷记应用安全规范》；
- 第  **8**  部分：《与应用无关的非接触式规范》；
- 第  **10**  部分：《借记贷记应用个人化指南》；
- 第  **12**  部分：《非接触式 IC 卡支付规范》；
- 第  **13**  部分：《基于借记贷记应用的小额支付规范》；
- 第  **14**  部分：《非接触式 IC 卡小额支付扩展应用规范》；
- 第  **15**  部分：《电子现金双币支付应用规范》；
- 第  **16**  部分：《IC 卡互联网终端规范》；
- 第  **18**  部分：《基于安全芯片的线上支付技术规范》；

## 智能卡操作系统 COS

**卡片操作系统**（**COS**，Card Operating System）紧密围绕着其所服务的智能卡特点而研发，设计时会紧密结合智能卡内置存储器的分区情况，并且遵循 ISO/IEC 7816 或者 ISO/IEC 14443 等国际标准，主要用于控制智能卡与外界的信息交换，管理智能卡当中的存储器，并且在智能卡内部完成各种命令的处理。由于目前主要解决的是如何处理与响应外部命令的问题，并不会涉及到共享和并发的管理，所以其本质上更加接近于监控程序，而非一个完整的操作系统。

> **注意**：[**Java Card™**](https://www.oracle.com/java/java-card.html)  目前已经成为 COS 事实上的工业标准，其以 Java 虚拟机作为基础，通过更为安全的方式来执行 Java Applet，并且支持多应用动态下载，具有平台无关、高安全性、高可靠性、一卡多用等特点。

## 安全单元 SE

**安全元件**（**SE**，Secure Element）也称安全芯片，主要由安全硬件和软件两部分组成，硬件部分包括安全的运行环境、存储、算法、接口等；软件部分则提供安全的交互机制，确保 SE 与上位机之间命令与数据的交互安全。基于 SE 对数据进行安全处理，可以实现设备的身份认证、数据传输加密、敏感信息保护等功能。

伴随近年 5G 逐步组网商用，物联网在迎来较快发展的同时，安全问题日益突出，物联网的安全需求主要存在于如下四个方面：

1. 硬件设备的唯一标识符；
2. 硬件设备端与云服务端的双向身份认证；
3. 数据的加密传输；
4. 远程 OTA 的安全升级；

基于嵌入式安全元件 SE 提供的安全存储与运算环境，就可以为物联网设备运营者提供一个安全可信任的**根**，然后再由运营者发行 SE 当中的设备 ID 以及证书密钥等，结合云端的安全服务，从而形成一套完整的物联网安全方案。

## ARM SecurCore

[**ARM SecurCore**](https://developer.arm.com/ip-products/processors/securcore)  是一系列专门为高性能、大容量**智能卡**与嵌入式安全产品而设计的芯片内核架构，目前主要有如下两款：

- **ARM SecurCore SC000**：针对**超大容量**的智能卡和嵌入式安全应用，内置了  **ARM Cortex-M0**  微控制器内核，功率较小，封装面积较小。![](https://uinika.github.io/Embedded/Mifare/SecurCore-SC000.png)
- **ARM SecurCore SC300**：针对**高性能**的智能卡和嵌入式安全应，内置了  **ARM Cortex-M3**  微控制器内核，功率较大，封装面积较大。![](https://uinika.github.io/Embedded/Mifare/SecurCore-SC300.png)

## ARM TrustZone

[**ARM TrustZone**](https://developer.arm.com/ip-products/security-ip/trustzone)  在芯片内部提供了一种安全高效的的方法，TrustZone 技术已经分别被集成到采用  **Armv8-A**  架构的  [Cortex-A](https://developer.arm.com/ip-products/security-ip/trustzone/trustzone-for-cortex-a)  系列以及采用  **Armv8-M**  架构的  [Cortex-M](https://developer.arm.com/ip-products/security-ip/trustzone/trustzone-for-cortex-m)  系列芯片当中，通过在微控制器系统当中创建独立的可信与非可信区域，确保数据、固件、片上外设的安全性。

![](https://uinika.github.io/Embedded/Mifare/TrustZone.png)

ARM TrustZone 技术通常需要结合如下的软件和规范进行使用：

- **Mbed OS**：基于 C/C++ 的开源安全实时操作系统；
- **CMSIS-Pack**：通用微控制器软件接口标准，提供了 Cortex 系列微控制器与外设的一致接口标准；
- **Trusted Firmware-M**：可信固件，运行在硬件隔离的安全环境当中，用于提供安全服务；

下面的表格展示了采用 ARM TrustZone 技术的相关厂商以及对应的典型产品型号：

| 芯片厂商           | 型号                       | 内核架构   |
| ------------------ | -------------------------- | ---------- |
| Microchip          | SAM L11                    | Cortex-M23 |
| Nordic             | nRF9160 与 nRF5340         | Cortex-M33 |
| Nuvoton            | M2351                      | Cortex-M23 |
| NXP                | LPC5500 和 i.MX RT600 系列 | Cortex-M33 |
| Silicon Labs       | Gecko Series 2             | Cortex-M33 |
| STMicroelectronics | STM32L5                    | Cortex-M33 |

**Mbed OS** 是一款基于 Cortex-M 微控制器的嵌入式实时操作系统，其提供了一个包含有存储、连接、设备管理、传感器驱动、输入输出设备的抽象层。

![](https://uinika.github.io/Embedded/Mifare/Mbed.png)

## STMicroelectronics 安全解决方案

![](https://uinika.github.io/Embedded/Mifare/STMicroelectronics.png)

针对银行、身份认证、支付解决方案，均支持 **ISO7816**、**ISO14443 A/B** 智能卡协议：

- **ST31 系列**：基于 ARM SecurCore SC000 核心架构，常用于智能卡应用程序；
- **STPay 系列**：基于 ST31 的硬件架构，主要用于安全支付的场景；

针对 NFC、eSE、eSIM 产品的移动安全交易解决方案：

- **ST33 系列**：基于 ARM SecurCore SC300 核心架构，应用于 SIM、eSIM、eSE 场景；
- **ST21NFC 系列**：用于 NFC 的微控制器；
- **ST54 系列**：基于 ST33 的硬件架构，同时整合了 eSIM、eSE、NFC 主控；

同样基于 **ST33** 硬件架构，所提供的车规级 eSIMs 解决方案，致力于汽车生态系统的安全连接：

- **ST33G1M2A 系列**：依然基于 ARM SecurCore SC300 核心架构；
- **ST33GTPMA 系列**：eSE 片上系统；
- **ST4SIM-A 系列**：eSIM 片上系统；

针对物联网生态系统当中的嵌入式平台到网关和服务器：

- **STSAFE-A 系列**：用于嵌入式系统和商标保护；
- **STSAFE-J 系列**：用于网关和物联网设备；
- **STSAFE-TPM 系列**：针对标准化和可验证的 TPM 服务；

主要基于 ARM SecurCore SC300 核心架构，针对工业控制与物联网的组网与通迅用途：

- **ST4SIM-S**：用于物联网；
- **ST4SIM-M**：用于工业控制；
- **ST4SIM-A**：用于汽车；

## Infineon 安全解决方案

英飞凌在通用微控制器方面，提供了基于 32 位 ARM Cortex 架构的 **PSoC**（基于 Cortex M0 和 M4 架构的系列）、**TRAVEO T2G**（基于 Cortex M4 和 M7 的高性能系列）、**XMC**（基于 Cortex M0 和 M4 架构的工业控制系列）微控制器。

![](https://uinika.github.io/Embedded/Mifare/Infineon-2.png)

除此之外，英飞凌还拥有自行研发的 **TriCore** 多核心微控制器架构，并基于此推出了 [AURIX](https://www.infineon.com/cms/en/product/microcontroller/32-bit-tricore-microcontroller/aurix-security-solutions/) 系列车规级微控制器（常用于装载有发动机控制程序的乘用车 ECU），包括第一代 **TC2XX** 和第二代 **TC3XX** 两个产品序列，最大特色在于嵌入了**硬件安全模块**（HSM，Hardware Security Module），其中包含了 `32 位安全计算平台`、`存储密钥和身份 ID 的受保护存储区`、`AES-128 硬件加速器`和`随机数生成器`。总而言之，HSM 提供了一个安全的平台，通过防火墙将其与微控制器的其他部分隔开，从而创建了一个可信的执行环境。

![](https://uinika.github.io/Embedded/Mifare/Infineon-1.png)

> **注意**：除此之外，英飞凌还提供有适用于非接触式卡片的 **CIPURSE** 安全解决方案，以及集成嵌入式安全方案 **OPTIGA**，和带有操作系统的集成嵌入式安全解决方案 **SECORA**。

## NXP 安全解决方案

[**恩智浦 NXP**](https://www.nxp.com/products/processors-and-microcontrollers:MICROCONTROLLERS-AND-PROCESSORS#/) 即提供了基于 **ARM** 内核的通用微控制器系列产品：

- **i.MX 系列**：基于 Cortex-A7/A8/A9、ARM9、Arm11 核心架构，用于多媒体显示场景；
- **Layerscape 系列**：基于 Cortex-A7/A9/A53/A57/A72 多核心架构，适用于企业、云计算和工业市场；
- **S32 系列**：基于 Cortex-M/R/A 核心架构，属于车规级芯片；
- **S32V 系列**：四核 Cortex-A53 架构，用于视觉处理、机器学习等应用；

也提供了基于自家 **Power** 架构的通用微控制器系列：

- **8xxx, 7xxx, 7xx, 6xx 系列**：基于 Power 架构 **e600** 核心的中央处理器，适用于服务器、瘦客户端、游戏系统；
- **S32R 雷达系列**：基于 Power 架构 **e200z4** 和 **e200z7** 核心，优化并且加速了雷达信号的处理；
- **MPC5xxx 系列**：基于 Power 架构 **e200z4** 和 **e200z1** 核心，专注于质量和长期可靠性的车用微控制器；
- **QorIQ P 系列**：基于多核心 Power 架构，适用于跨运营商、企业、军事和工业市场的网络应用；
- **QorIQ Qonverge 平台**：在 Power 架构的基础上加入了 StarCore 核心的 DSP 架构，用于通信基站；
- **QorIQ T 系列**：基于高效的 Power 架构，该系列常用于低功耗节能产品；
- **PowerQUICC 系列**：基于 Power 架构，常用于通信处理；

除此之外，恩智浦 NXP 还提供了安全与认证相关的解决方案：

- **认证和防伪解决方案**：内嵌有支持 AES、DES、RSA 算法的 `EdgeLock SE050/SE051` 物联网安全元件；
- **电子证照解决方案**：基于 NXP 自身的 **SmartMX** 安全控制器和嵌入式操作系统的 `SmartMX3 P71D321/P71D320`、`SmartMX2 P60`；

其中，值得一提的是其于 2018 年推出的 [**2GO**](https://www.nxp.com.cn/products/security-and-authentication/secure-service-2go-platform:SECURE_SERVICE_2GO) 安全服务平台，为物联网设备提供了一系列安全可扩展的服务：

![](https://uinika.github.io/Embedded/Mifare/NXP.png)

- **MIFARE 2GO**：用于管理物联网设备 Mifare 芯片中保存的数字化交通凭证，该安全服务已经完全集成至 Google Pay；
- **mWallet 2GO**：移动钱包开发解决方案，并且已经集成到 MasterCard 和 Visa 的生态合作体系；
- **mID 2GO**：移动身份验证解决方案，用于安全的联接、管理、操作数字化身份信息；
- **NTAG**：基于 NFC 标签的安全增值服务，包含`芯片自定义服务`、`标签管理`、`身份验证`等功能；
- **EdgeLock 2GO**：物联网服务平台，用于安全的部署与管理采用 `EdgeLock SE050` 安全元件的物联网设备；

## Renesas 安全解决方案

[**瑞萨 Renesas**](https://www2.renesas.cn/cn/zh) 拥有基于 **ARM Cortex-M** 内核的 **Synergy** 系列微控制器，以及采用自研 **Renesas eXtreme** 内核的 **RX** 系列微控制器。在安全解决方案方面，则推出了基于 Cortex-M23/M33 架构，并采用了 ARM TrustZone 技术的 **RA** 系列：

![](https://uinika.github.io/Embedded/Mifare/Renesas.png)

## 国产芯片厂商安全解决方案

[**兆易创新 Gigadevice**](https://www2.renesas.cn/cn/zh) 推出了基于 **ARM Cortex-M23** 内核的 `GD32E230/231/232` 系列，以及 **ARM Cortex-M33** 内核的 `GD32E5` 的高性能系列。
