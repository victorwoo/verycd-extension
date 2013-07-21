verycd-extension
================

整理www.verycd.com电驴下载资源的Chrome插件及PowerShell脚本。

欢迎使用
--------
通过电骡（eMule）系列工具从[VeryCD](http://www.verycd.com "VeryCD")资源网站下载的文件，往往存放在一个公用的下载文件夹中。如果您是一个资源收藏家，下载了多个资源，每个资源又包含很多文件，那么这些海量的文件很可能会使您的下载文件夹显得杂乱无章。一段时间以后难以辨别这些眼花缭乱的音乐、视频文件，究竟是属于哪张专辑的。

这款“verycd-extension”工具的使命是为浩如烟海的电骡（驴）资源文件重建目录结构，让您的下载硬盘变得井井有条。

使用视频
--------
* 安装Chrome扩展
	* 打开Chrome浏览器，打开工具菜单 - 扩展程序。
	* 将下载好的VeryCDExtension.crx拖入Chrome窗口。
	* 打开任意一个VeryCD资源网页，点击“下载清单”下载资源清单文件。
	![安装Chrome扩展](http://i.imgur.com/yE0Xmav.gif)

* 整理电驴文件。
	* 将资源清单文件和Move-VeryCDFiles.exe工具放在电驴下载文件夹中。
	* 运行Move-VeryCDFiles.exe，程序将自动整理下载的资源。
	* missing.txt为缺失的资源ed2k链接。您可以把它们复制到电驴中继续下载。
	* 下载完整的资源清单文件将被移动到资源目录中，未下载完整的资源清单文件不会被移动。
	* 每个资源目录下将生成resource.url的资源网页快捷方式。
	![整理电驴资源](http://i.imgur.com/7gSIjT3.gif)

版本历史
--------
* 2013/07/15 发布1.0。
	* 实现Chrome扩展。
	* PowerShell脚本只支持手动编辑清单文件名。
* 2013/07/15 发布1.1。
	* PowerShell脚本支持批量处理清单。
	* PowerShell脚本支持重命名完成的清单。
* 2013/07/16 发布1.2。
	* 在清单中添加url信息、时间戳、版本号、文件ed2k地址。
	* 增加保存PDF功能（不完善）。
	* 增加版本比对功能。
	* 调整目录结构，减少路径过长的可能。
* 2013/07/21 发布1.3。

未来功能
--------
* 以二进制形式发布。
* 增量下载功能（高级）。

工作原理
--------
TODO

[PDFCreater](http://download.pdfforge.org/download/pdfcreator "PDFCreater")

使用局限
--------
TODO

关于作者
--------
QQ:46349731
[victorwoo@gmail.com](mailto:victorwoo@gmail.com "电子邮件")