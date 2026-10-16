  

>Github仓库地址:
>https://github.com/Timecube-6624/TOMATS-No3SeniorHigh

---

# 关于如何使用GitHub:
## 安装git：
先下载git并安装，使用如下命令或访问下载页并安装
```bash
winget install --id Git.Git -e --source winget https://github.com/git-for-windows/git/releases/download/v2.56.0.windows.2/Git-2.56.0.2-64-bit.exe
```
安装过程中一路按照默认配置不要改任何东西

---

## 配置仓库： 
按下win+X再按A以管理员身份打开Poweshell
使用 git --version 检查一下版本是否正确(一定要在安装后打开powershell)
再创建目录，这个目录将是你稍后克隆仓库的`[目标目录]`
然后使用命令
``` bash
git clone [选项] <仓库地址> [目标目录]
```
例如：
```bash
git clone https://github.com/Timecube-6624/TOMATS-No3SeniorHigh.git 
```
%%"D:\Projects\TOMATS" (路径一定要带引号，引号内的路径在powershell会变蓝)
按下回车就会开始克隆%%
如果你发现git找不到，请检查你的环境变量里面有没有git的cmd文件夹路径，以及是不是在最上面

![](C:\Users\Timecube_2024\Documents\xwechat_files\wxid_y7l61zrehkzj12_c7c4\temp\Ann\Weixin%20Image_20261016194344_2.jpg)可以问AI这个错误结果是什么意思，我这个是PowerToys的界面，不是系统界面，系统界面去网上搜一下路径


---
# 安装VScode：
然后我们来安装用于版本管理的工具VScode

找到在群里发送的VScode安装包，下载下来，双击安装，并修改路径到你希望安装的位置，它是有图形化界面的
然后安装汉化，在主界面的左上角有个扩展，如图所示：
![](C:\Users\Timecube_2024\Documents\xwechat_files\wxid_y7l61zrehkzj12_c7c4\temp\Ann\Weixin%20Image_20261016193828_1.jpg)
进去搜3个插件：
**Chinese (Simplified) (简体中文) Language Pack for Visual Studio Code**
**Git Graph**
**Live Server**
安装它们
这个时候如果网络畅通，仓库是已经克隆下来了的
请在主界面打开文件夹那里打开你的目标文件夹，如果你发现欢迎界面不见了，请点这里：
![](C:\Users\Timecube_2024\Documents\xwechat_files\wxid_y7l61zrehkzj12_c7c4\temp\Ann\Weixin%20Image_20261016194615_3.jpg)
如果你有很多个项目要进行，请点这里：
![](C:\Users\Timecube_2024\Documents\xwechat_files\wxid_y7l61zrehkzj12_c7c4\temp\Ann\Weixin%20Image_20261016194655_4.jpg)
这个时候你就能看到仓库里的文件了，在左下角应该会有Git Graph，这个是把仓库图形化的；  
![](C:\Users\Timecube_2024\Documents\xwechat_files\wxid_y7l61zrehkzj12_c7c4\temp\Ann\Weixin%20Image_20261016194801_5.jpg)
右下角应该会有Go Life，这个是把HTML直接建站变成本地网页的，地址是127.0.0.1:5500，端口号会显示在按钮的位置
![700](C:\Users\Timecube_2024\Documents\xwechat_files\wxid_y7l61zrehkzj12_c7c4\temp\Ann\Weixin%20Image_20261016194958_6.jpg)

---
# 使你的仓库可以推送
接下来让你的代码可以推送(需要Github账号和一台手机)：
先注册一个GitHub账号，并且通过2FA(多因素认证)
2FA手机端可以使用微软的身份验证器程序，那个不需要登录也免费

然后点击VScode左下角的头像登录GitHub，注意copilot会自动激活，请关闭它

![](C:\Users\Timecube_2024\Documents\xwechat_files\wxid_y7l61zrehkzj12_c7c4\temp\Ann\Weixin%20Image_20261016195242_7.jpg)  
从最底下可以拉出一个终端，启动需要一定的时间，路径就是项目文件夹路径，可以使用cd [路径]的方式更改路径
![](C:\Users\Timecube_2024\Documents\xwechat_files\wxid_y7l61zrehkzj12_c7c4\temp\Ann\Weixin%20Image_20261016195355_8.jpg)
在这里面再次输入git --version确定它正确工作
然后使用命令
```bash
git remote add origin https://github.com/Timecube-6624/TOMATS-No3SeniorHigh.git
```

```bash
git pull origin main
```
git会弹出一个界面让你在GitHub授权，如果pull不行就push一下
然后就可以正常使用右侧图形化面板进行操作了

---
# 附件
 
 >[!NOTE] 关于git的完整内容：
 > 
 > 【程式与网页开发者必备技能！Git 和 GitHub 零基础快速上手，轻松掌握版本控制的要诀！】 https://www.bilibili.com/video/BV1WT421S7y4/?share_source=copy_web&vd_source=acd633748838579ff4654acc6003ee63
 
 >[!NOTE] 关于Git Graph的使用要点
 > 
 > 【GitGraph可视化操作(上)：分支管理、合并策略与工作区、暂存操作】 https://www.bilibili.com/video/BV1Q6w3zrEvL/?share_source=copy_web&vd_source=acd633748838579ff4654acc6003ee63
 
 