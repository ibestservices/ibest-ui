<p align="center">
    <img src="https://ibestservices.github.io/ibest-ui/AppScope/resources/base/media/app_logo_trans.png" width="100">
</p>

<h1 align="center">IBest-UI</h1>

<p align="center">轻量、可定制的 HarmonyOS NEXT 组件库</p>

<p align="center">
    <a href="https://ibestui.ibestservices.com/" target="_blank">文档</a>
    &nbsp;
    ·
    &nbsp;
    <a href="https://ohpm.openharmony.cn/#/cn/detail/@ibestservices%2Fibest-ui" target="_blank">三方库中心仓</a>
</p>

---

## 介绍

<a href="https://ibestui.ibestservices.com/" target="_blank">IBest-UI</a> 
由 <a href="https://www.ibestservices.com" target="_blank">安徽百得思维信息科技有限公司</a> 开源，是一个**轻量、简单易用、可定制主题、支持深色模式和浅色模式**的鸿蒙开源UI组件库，包含 Button、Calendar、Form、Field、Picker、Popup、Toast、Dialog、ImageCropper 等60+个优质组件，上手简单，使用方便，可大大提高鸿蒙开发者的开发效率。

目前 <a href="https://www.ibestservices.com/" target="_blank">ibestservices 官方</a> 提供了 <a href="https://ibestui.ibestservices.com/guide/home/" target="_blank">V1</a> 和 <a href="https://ibestui-v2.ibestservices.com/guide/home/" target="_blank">V2</a> 版本，当前为状态管理 **V1** 版本，开发者可根据自己项目使用的**状态管理版本**选择对应的版本进行开发，官方推荐使用V2。

如果觉得还不错，请帮忙给项目点个**Star**，谢谢！

<div>
	<img src="https://ibestservices.github.io/ibest-ui/screenshot/IBest-UI-Light.png" width="48%">
	<img src="https://ibestservices.github.io/ibest-ui/screenshot/IBest-UI-Dark.png" width="48%">
</div>

## 特性
- 🚀 60+个高质量组件，覆盖移动端主流场景
- 💪 单元测试覆盖率超过 90%，提供稳定性保障
- 📖 提供丰富的中文文档和组件示例
- 🍭 支持主题定制，内置 100+ 个主题变量
- 🍭 支持元服务
- 🍭 支持深色模式
- 🌍 支持国际化

## 体验预览

升级到 HarmonyOS NEXT 的手机，可在应用商店搜索 `best`、`ibest` 关键字，下载第一个名为 `IBest-UI` 的应用，即可体验。

## 下载安装

```ts
ohpm install @ibestservices/ibest-ui
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 组件介绍

### 基础组件
| 组件        | 介绍                                    |                                                                                       |
|:----------|:--------------------------------------|---------------------------------------------------------------------------------------|
| Button 按钮 | 按钮用于触发一个操作，如提交表单。                     | <a href="https://ibestui.ibestservices.com/components/button/" target="_blank">文档</a> |
| Cell 单元格  | 单元格为列表中的单个展示项。                        | <a href="https://ibestui.ibestservices.com/components/cell/" target="_blank">文档</a>   |
| Icon 图标   | 基于字体的图标集，可以通过 IBestIcon 组件使用。         | <a href="https://ibestui.ibestservices.com/components/icon/" target="_blank">文档</a>   |
| Popup 弹出层 | 弹出层容器，用于展示弹窗、信息提示等内容，支持多个弹出层叠加展示。     | <a href="https://ibestui.ibestservices.com/components/popup/" target="_blank">文档</a>  |
| Toast 轻提示 | 在页面中间弹出黑色半透明提示，用于消息通知、加载提示、操作结果提示等场景。 | <a href="https://ibestui.ibestservices.com/components/toast/" target="_blank">文档</a>  |

### 表单组件
| 组件                    | 介绍                                                                             |                                                                                               |
|:----------------------|:-------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------|
| Calendar 日历           | 日历用于选择单个、多个日期或日期范围。                                                            | <a href="https://ibestui.ibestservices.com/components/calendar/" target="_blank">文档</a>       |
| Caliper 卡尺            | 用于选择某个范围内的值。                                                                   | <a href="https://ibestui.ibestservices.com/components/caliper/" target="_blank">文档</a>        |
| CarInput 车牌输入框        | 用于输入车牌号码。                                                                      | <a href="https://ibestui.ibestservices.com/components/carInput/" target="_blank">文档</a>       |
| CarKeyboard 车牌键盘      | 带网格的输入框组件，通常与车牌输入框组件或其它自定义输入框配合使用。                                             | <a href="https://ibestui.ibestservices.com/components/carkeyboard/" target="_blank">文档</a>    |
| Cascader 级联选择器        | 级联选择框，用于多层级数据的选择，典型场景为省市区选择。                                                   | <a href="https://ibestui.ibestservices.com/components/cascader/" target="_blank">文档</a>       |
| Checkbox 复选框          | 在一组备选项中进行多选。                                                                   | <a href="https://ibestui.ibestservices.com/components/checkbox/" target="_blank">文档</a>       |
| DatePicker 日期选择       | 日期选择器，用于选择年、月、日，通常与弹出层组件配合使用。                                                  | <a href="https://ibestui.ibestservices.com/components/datepicker/" target="_blank">文档</a>     |
| DateTimePicker 日期时间选择 | 日期时间选择器，用于选择年、月、日、时、分、秒，通常与弹出层组件配合使用。                                          | <a href="https://ibestui.ibestservices.com/components/datetimepicker/" target="_blank">文档</a> |
| Field 输入框             | 用户可以在文本框内输入或编辑文字。                                                              | <a href="https://ibestui.ibestservices.com/components/field/" target="_blank">文档</a>          |
| Form 表单               | 用于数据录入、校验，支持输入框、单选框、复选框、文件上传等类型，需要与 Field 输入框 组件搭配使用。                          | <a href="https://ibestui.ibestservices.com/components/form/" target="_blank">文档</a>           |
| NumberKeyboard 数字键盘   | 虚拟数字键盘，可以配合密码输入框组件或自定义的输入框组件使用。                                                | <a href="https://ibestui.ibestservices.com/components/numberkeyboard/" target="_blank">文档</a> |
| PasswordInput 密码输入框   | 带网格的输入框组件，可以用于输入密码、短信验证码等场景，通常与数字键盘组件配合使用。                                     | <a href="https://ibestui.ibestservices.com/components/passwordInput/" target="_blank">文档</a>  |
| Picker 选择器            | 提供多个选项集合供用户选择，支持单列选择、多列选择和级联选择，通常与弹出层组件配合使用。                                   | <a href="https://ibestui.ibestservices.com/components/picker/" target="_blank">文档</a>         |
| PickerGroup 选择器组      | 用于结合多个 Picker 选择器组件，在一次交互中完成多个值的选择。                                            | <a href="https://ibestui.ibestservices.com/components/pickergroup/" target="_blank">文档</a>    |
| Radio 单选框             | 在一组备选项中进行单选。                                                                   | <a href="https://ibestui.ibestservices.com/components/radio/" target="_blank">文档</a>          |
| Rate 评分               | 用于对事物进行评级操作。                                                                   | <a href="https://ibestui.ibestservices.com/components/rate/" target="_blank">文档</a>           |
| Search 搜索             | 用于搜索场景的输入框组件。                                                                  | <a href="https://ibestui.ibestservices.com/components/search/" target="_blank">文档</a>         |
| Signature 签名          | 用于签名场景的组件，基于 Canvas 实现。                                                        | <a href="https://ibestui.ibestservices.com/components/signature/" target="_blank">文档</a>      |
| Slider 滑块             | 滑动输入条，用于在给定的范围内选择一个值。                                                          | <a href="https://ibestui.ibestservices.com/components/slider/" target="_blank">文档</a>         |
| Stepper 步进器           | 步进器由增加按钮、减少按钮和输入框组成，用于在一定范围内输入、调整数字。                                           | <a href="https://ibestui.ibestservices.com/components/stepper/" target="_blank">文档</a>        |
| Switch 开关             | 用于在打开和关闭状态之间进行切换。                                                              | <a href="https://ibestui.ibestservices.com/components/switch/" target="_blank">文档</a>         |
| TimePicker 时间选择       | 日期选择器，用于选择年、月、日，通常与弹出层组件配合使用。                                                  | <a href="https://ibestui.ibestservices.com/components/timepicker/" target="_blank">文档</a>     |
| Uploader 文件上传         | 用于将本地的图片或文件上传至服务器，并在上传过程中展示预览图和上传状态。目前 Uploader 组件不包含将文件上传至服务器的接口逻辑，该步骤需要自行实现。 | <a href="https://ibestui.ibestservices.com/components/uploader/" target="_blank">文档</a>       |

### 反馈组件
| 组件                | 介绍                                                   |                                                                                             |
|:------------------|:-----------------------------------------------------|---------------------------------------------------------------------------------------------|
| ActionSheet 动作面板  | 底部弹起的模态面板，包含与当前情境相关的多个选项。                            | <a href="https://ibestui.ibestservices.com/components/actionsheet/" target="_blank">文档</a>  |
| Dialog 弹出框        | 弹出模态框，常用于消息提示、消息确认，或在当前页面内完成特定的交互操作。支持组件调用和函数调用两种方式。 | <a href="https://ibestui.ibestservices.com/components/dialog/" target="_blank">文档</a>       |
| DropdownMenu 下拉菜单 | 向下弹出的菜单列表。                                           | <a href="https://ibestui.ibestservices.com/components/dropdownMenu/" target="_blank">文档</a> |
| FloatBubble 浮动气泡  | 悬浮在页面边缘的可点击气泡。                                       | <a href="https://ibestui.ibestservices.com/components/floatbubble/" target="_blank">文档</a>  |
| Guide 引导          | 分步引导用户了解产品功能的气泡组件，用来引导用户并介绍产品。                       | <a href="https://ibestui.ibestservices.com/components/guide/" target="_blank">文档</a>        |
| Loading 加载        | 加载图标，用于表示加载中的过渡状态。                                   | <a href="https://ibestui.ibestservices.com/components/loading/" target="_blank">文档</a>      |
| Notify 消息提示       | 在页面顶部展示消息提示。                                         | <a href="https://ibestui.ibestservices.com/components/notify/" target="_blank">文档</a>       |
| PullRefresh 下拉刷新  | 轻量级，用于提供下拉刷新的交互操作。                                   | <a href="https://ibestui.ibestservices.com/components/pullrefresh/" target="_blank">文档</a>  |
| SwipeCell 滑动单元格   | 可以左右滑动来展示操作按钮的单元格组件。                                 | <a href="https://ibestui.ibestservices.com/components/swipecell/" target="_blank">文档</a>    |

### 展示组件
| 组件                   | 介绍                                 |                                                                                               |
|:---------------------|:-----------------------------------|-----------------------------------------------------------------------------------------------|
| Avatar 头像            | 用于展示用户头像。                          | <a href="https://ibestui.ibestservices.com/components/avatar/" target="_blank">文档</a>         |
| Badge 徽标             | 在右上角展示徽标数字或小红点。                    | <a href="https://ibestui.ibestservices.com/components/badge/" target="_blank">文档</a>          |
| CircleProgress 环形进度条 | 圆环形的进度条组件。                         | <a href="https://ibestui.ibestservices.com/components/circleProgress/" target="_blank">文档</a> |
| Collapse 折叠面板        | 将一组内容放置在多个折叠面板中，点击面板的标题可以展开或收缩其内容。 | <a href="https://ibestui.ibestservices.com/components/collapse/" target="_blank">文档</a>       |
| CountDown 倒计时        | 用于实时展示倒计时数值，支持毫秒精度。                | <a href="https://ibestui.ibestservices.com/components/countDown/" target="_blank">文档</a>      |
| CountTo 数字滚动         | 用于需要滚动数字到某一个值的场景，目标要求是一个递增的值。      | <a href="https://ibestui.ibestservices.com/components/countTo/" target="_blank">文档</a>        |
| Divider 分割线          | 用于将内容分隔为多个区域。                      | <a href="https://ibestui.ibestservices.com/components/divider/" target="_blank">文档</a>        |
| Empty 空状态            | 空状态时的占位提示。                         | <a href="https://ibestui.ibestservices.com/components/empty/" target="_blank">文档</a>          |
| Highlight 高亮文本       | 高亮指定文本内容。                          | <a href="https://ibestui.ibestservices.com/components/highlight/" target="_blank">文档</a>      |
| ImagePreview 图片预览    | 图片放大预览。                            | <a href="https://ibestui.ibestservices.com/components/imagepreview/" target="_blank">文档</a>   |
| NoticeBar 通知栏        | 用于循环播放展示一组消息通知。                    | <a href="https://ibestui.ibestservices.com/components/noticeBar/" target="_blank">文档</a>      |
| Popover 气泡弹出框        | 弹出式的气泡菜单。                          | <a href="https://ibestui.ibestservices.com/components/popover/" target="_blank">文档</a>        |
| Price 价格             | 用于展示价格。                            | <a href="https://ibestui.ibestservices.com/components/price/" target="_blank">文档</a>          |
| Progress 进度条         | 用于展示操作的当前进度。                       | <a href="https://ibestui.ibestservices.com/components/progress/" target="_blank">文档</a>       |
| ReadMore 查看更多        | 用于内容超出指定高度时，显示"展开/收起"按钮。           | <a href="https://ibestui.ibestservices.com/components/readMore/" target="_blank">文档</a>       |
| RollingText 翻滚文本     | 文本翻滚动效，可以翻滚数字。                     | <a href="https://ibestui.ibestservices.com/components/rollingText/" target="_blank">文档</a>    | 
| SectorProgress 扇形进度条 | 用于展示进度、占比。                         | <a href="https://ibestui.ibestservices.com/components/sectorProgress/" target="_blank">文档</a> |
| Segmented 分段控制器      | 用于展示多个选项并允许用户选择其中单个选项。             | <a href="https://ibestui.ibestservices.com/components/segmented/" target="_blank">文档</a>      |
| Skeleton 骨架屏         | 用于在内容加载过程中展示一组占位图形。                | <a href="https://ibestui.ibestservices.com/components/skeleton/" target="_blank">文档</a>       |
| Steps 步骤条            | 用于展示操作流程的各个环节，让用户了解当前的操作在整体流程中的位置。 | <a href="https://ibestui.ibestservices.com/components/steps/" target="_blank">文档</a>          |
| Table 表格             | 用于展示多条结构类似的数据。                     | <a href="https://ibestui.ibestservices.com/components/table/" target="_blank">文档</a>          |
| Tag 标签               | 用于标记关键词和概括主要内容。                    | <a href="https://ibestui.ibestservices.com/components/tag/" target="_blank">文档</a>            |
| TextEllipsis 文本省略    | 对长文本进行省略，支持展开/收起。                  | <a href="https://ibestui.ibestservices.com/components/textEllipsis/" target="_blank">文档</a>   |
| Watermark 水印         | 在页面上添加特定的文字或图案作为水印，可用于防止信息盗用。      | <a href="https://ibestui.ibestservices.com/components/watermark/" target="_blank">文档</a>      |

### 导航组件
| 组件            | 介绍                             |                                                                                           |
|:--------------|:-------------------------------|-------------------------------------------------------------------------------------------|
| NavBar 导航栏    | 为页面提供导航功能，常用于页面顶部。             | <a href="https://ibestui.ibestservices.com/components/navBar/" target="_blank">文档</a>     |
| Pagination 分页 | 数据量过多时，采用分页的形式将数据分隔，每次只加载一个页面。 | <a href="https://ibestui.ibestservices.com/components/pagination/" target="_blank">文档</a> |
| SideBar 侧边导航  | 垂直展示的导航栏，用于在不同的内容区域之间进行切换。     | <a href="https://ibestui.ibestservices.com/components/sideBar/" target="_blank">文档</a>    |
| Tab 标签页       | 选项卡组件，用于在不同的内容区域之间进行切换。        | <a href="https://ibestui.ibestservices.com/components/tab/" target="_blank">文档</a>        |

### 业务组件
| 组件                   | 介绍                |                                                                                               |
|:---------------------|:------------------|:----------------------------------------------------------------------------------------------|
| CanvasDrawer 画布绘制    | 用于绘制海报、图片加水印等场景。  | <a href="https://ibestui.ibestservices.com/components/canvasDrawer/" target="_blank">文档</a>   |
| ColorPicker 颜色选择     | 用于选择颜色。           | <a href="https://ibestui.ibestservices.com/components/colorPicker/" target="_blank">文档</a>    |
| ContactAddress 联系人地址 | 用于选择联系人地址，可粘贴识别。 | <a href="https://ibestui.ibestservices.com/components/contactAddress/" target="_blank">文档</a> |
| ImageCropper 图片裁剪    | 用于裁剪图片。           | <a href="https://ibestui.ibestservices.com/components/imageCropper/" target="_blank">文档</a>   |

## 需要权限
ohos.permission.INTERNET

## 官方生态

| 项目                           | 描述                                                                                         |                                                                                                         |
|:-----------------------------|:-------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------|
| @ibestservices/ibest-ui-v2   | 一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库，基于状态管理v2版本。                                          | <a href="https://ohpm.openharmony.cn/#/cn/detail/@ibestservices%2Fibest-ui-v2" target="_blank">地址</a>   |
| @ibestservices/ucharts       | 一个类型丰富、高性能、可扩展、支持主题定制的图表库。                                                                 | <a href="https://ohpm.openharmony.cn/#/cn/detail/@ibestservices%2Fucharts" target="_blank">地址</a>       |
| @ibestservices/area-data     | 中国省市区数据，适用于鸿蒙 ArkUI 的 TextPicker 和 IBest-UI 的 IBestCascader 等组件。                           | <a href="https://ohpm.openharmony.cn/#/cn/detail/@ibestservices%2Farea-data" target="_blank">地址</a>     |
| @ibestservices/ibest-orm     | 一个轻量、简单易用、全功能、支持实体关联、事务、自动迁移的鸿蒙开源 ORM 工具库。                                                 | <a href="https://ohpm.openharmony.cn/#/cn/detail/@ibestservices%2Fibest-orm" target="_blank">地址</a>     |
| @ibestservices/ibest-barcode | 一个轻量、简单易用的鸿蒙开源条形码组件，支持CODE39、CODE93、CODE128、、EAN13、UPC、ITF、MSI、Pharmacode、Codabar等多种条码类型。 | <a href="https://ohpm.openharmony.cn/#/cn/detail/@ibestservices%2Fibest-barcode" target="_blank">地址</a> |

## 链接
- [Github](https://github.com/ibestservices/ibest-ui)
- [Gitee](https://gitee.com/ibestservices/ibest-ui)
- [Gitcode](https://gitcode.com/ibestservices/ibest-ui)
- [更新日志](https://github.com/ibestservices/ibest-ui/releases)

## 交流QQ群
官方QQ群 953492584

![QQ1群](https://ibestservices.github.io/ibest-ui/screenshot/QQ%E7%BE%A4.jpg)

## 微信群
添加IBest-UI助手，备注 "鸿蒙开发"
![微信群](https://ibestservices.github.io/ibest-ui/screenshot/IBest-UI助手.jpg)

## 约束与限制
在下述版本验证通过：
```text
DevEco Studio 5.1.1 Release
Build #DS-233.14475.28.36.511823
构建版本：5.1.1.823，built on July 12，2025
Runtime version: 17.0.12+1-b1087.25 x86_64
VM: OpenJDK 64-Bit Server VM by JetBrains s.r.o.
macOS 15.5
GC: G1 Young Generation，G1 Old Generation
Memory: 2048M
Cores: 12
Metal Rendering is ON
Registry:
  idea.plugins.compatible.build=IC-233.14475.28
Non-Bundled Plugins:
  com.harmonyos.cases (1.0.10-Alpha)
  com.huawei.agc.ecomarket.component.plugin (233.14475.28)
  com.alibabacloud.intellij.cosy (2.5.15)
```

## 开源协议
本项目基于 MIT 协议，请自由地享受和参与开源。

## 贡献者
感谢以下同学对IBest-UI做的贡献:

<a href="https://github.com/ibestservices/ibest-ui/graphs/contributors">
  <img src="https://ibestservices.github.io/ibest-ui/screenshot/Contributors.png" />
</a>

## 打赏
本项目为开源免费项目，长期维护需要时间和精力。如果您认可它的价值，欢迎通过打赏支持项目发展。您的每一份鼓励，都是我持续更新的动力源泉。   

<img src="https://ibestservices.github.io/ibest-ui/screenshot/WxRewardCode.jpg" width="50%">

<img src="https://ibestservices.github.io/ibest-ui/screenshot/ZfbRewardCode.jpg" width="50%">
