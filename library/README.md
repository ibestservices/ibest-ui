# IBest-UI

## 简介

IBest-UI是一个**轻量、简单易用、可定制主题、支持深色模式和浅色模式**的鸿蒙开源UI组件库, 包含 Button、Calendar、Form、Field、Picker、Popup、Toast、Dialog、ImageCropper 等50+个优质组件。

目前 ibestservices 官方提供了 <a href='https://ohpm.openharmony.cn/#/cn/detail/@ibestservices%2Fibest-ui' target="_blank">V1</a> 和 <a href='https://ohpm.openharmony.cn/#/cn/detail/@ibestservices%2Fibest-ui-v2' target="_blank">V2</a> 版本, 当前为状态管理 **V1** 版本，请根据自己项目使用的**状态管理版本**选择对应的版本使用。

![IBest-UI-Light](https://ibestservices.github.io/ibest-ui/screenshot/IBest-UI-Light.png)

![IBest-UI-Dark](https://ibestservices.github.io/ibest-ui/screenshot/IBest-UI-Dark.png)

## 文档地址

https://ibestui.ibestservices.com

## 特性
- 🚀 50+ 个高质量组件，覆盖移动端主流场景
- 💪 单元测试覆盖率超过 90%，提供稳定性保障
- 📖 提供丰富的中文文档和组件示例
- 🍭 支持主题定制，内置 100+ 个主题变量
- 🍭 支持元服务
- 🍭 支持深色模式
- 🌍 支持国际化

## 体验预览

升级到 HarmonyOS NEXT 的手机, 可在应用商店搜索 `best`、`ibest` 关键字, 下载第一个名为 `IBest-UI` 的应用, 即可体验。

## 下载安装

```ts
ohpm install @ibestservices/ibest-ui
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 组件介绍

### 基础组件
| 组件                   | 介绍                                                                             |                                                                                            |
|:---------------------|:-------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|
| Button 按钮            | 按钮用于触发一个操作，如提交表单。                                                              | <a href="https://ibestui.ibestservices.com/components/button/" target="__blank">文档</a>     |
| Cell 单元格             | 单元格为列表中的单个展示项。                                                                 | <a href="https://ibestui.ibestservices.com/components/cell/" target="__blank">文档</a>       |
| Icon 图标              | 基于字体的图标集，可以通过 IBestIcon 组件使用。                                                  | <a href="https://ibestui.ibestservices.com/components/icon/" target="__blank">文档</a>       |
| Popup 弹出层            | 弹出层容器，用于展示弹窗、信息提示等内容，支持多个弹出层叠加展示。                                              | <a href="https://ibestui.ibestservices.com/components/popup/" target="__blank">文档</a>      |
| Toast 轻提示            | 在页面中间弹出黑色半透明提示，用于消息通知、加载提示、操作结果提示等场景。                                          | <a href="https://ibestui.ibestservices.com/components/toast/" target="__blank">文档</a>      |

### 表单组件
| 组件                  | 介绍                                                                             |                                                                                                |
|:--------------------|:-------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|
| Calendar 日历         | 日历用于选择单个、多个日期或日期范围。                                                            | <a href="https://ibestui.ibestservices.com/components/calendar/" target="__blank">文档</a>       |
| Cascader 级联选择器      | 级联选择框，用于多层级数据的选择，典型场景为省市区选择。                                                   | <a href="https://ibestui.ibestservices.com/components/cascader/" target="__blank">文档</a>       |
| Checkbox 复选框        | 在一组备选项中进行多选。                                                                   | <a href="https://ibestui.ibestservices.com/components/checkbox/" target="__blank">文档</a>       |
| DatePicker 日期选择     | 日期选择器，用于选择年、月、日，通常与弹出层组件配合使用。                                                  | <a href="https://ibestui.ibestservices.com/components/datepicker/" target="__blank">文档</a>     |
| Field 输入框           | 用户可以在文本框内输入或编辑文字。                                                              | <a href="https://ibestui.ibestservices.com/components/field/" target="__blank">文档</a>          |
| Form 表单             | 用于数据录入、校验，支持输入框、单选框、复选框、文件上传等类型，需要与 Field 输入框 组件搭配使用。                          | <a href="https://ibestui.ibestservices.com/components/form/" target="__blank">文档</a>           |
| NumberKeyboard 数字键盘 | 虚拟数字键盘，可以配合密码输入框组件或自定义的输入框组件使用。                                                | <a href="https://ibestui.ibestservices.com/components/numberkeyboard/" target="__blank">文档</a> |
| PasswordInput 密码输入框 | 带网格的输入框组件，可以用于输入密码、短信验证码等场景，通常与数字键盘组件配合使用。                                     | <a href="https://ibestui.ibestservices.com/components/passwordInput/" target="__blank">文档</a>  |
| Picker 选择器          | 提供多个选项集合供用户选择，支持单列选择、多列选择和级联选择，通常与弹出层组件配合使用。                                   | <a href="https://ibestui.ibestservices.com/components/picker/" target="__blank">文档</a>         |
| PickerGroup 选择器组    | 用于结合多个 Picker 选择器组件，在一次交互中完成多个值的选择。                                            | <a href="https://ibestui.ibestservices.com/components/pickergroup/" target="__blank">文档</a>    |
| Radio 单选框           | 在一组备选项中进行单选。                                                                   | <a href="https://ibestui.ibestservices.com/components/radio/" target="__blank">文档</a>          |
| Rate 评分             | 用于对事物进行评级操作。                                                                   | <a href="https://ibestui.ibestservices.com/components/rate/" target="__blank">文档</a>           |
| Search 搜索           | 用于搜索场景的输入框组件。                                                                  | <a href="https://ibestui.ibestservices.com/components/search/" target="__blank">文档</a>         |
| Slider 滑块           | 滑动输入条，用于在给定的范围内选择一个值。                                                          | <a href="https://ibestui.ibestservices.com/components/slider/" target="__blank">文档</a>         |
| Signature 签名        | 用于签名场景的组件，基于 Canvas 实现。                                                        | <a href="https://ibestui.ibestservices.com/components/signature/" target="__blank">文档</a>      |
| Stepper 步进器         | 步进器由增加按钮、减少按钮和输入框组成，用于在一定范围内输入、调整数字。                                           | <a href="https://ibestui.ibestservices.com/components/stepper/" target="__blank">文档</a>        |
| Switch 开关           | 用于在打开和关闭状态之间进行切换。                                                              | <a href="https://ibestui.ibestservices.com/components/switch/" target="__blank">文档</a>         |
| TimePicker 时间选择     | 日期选择器，用于选择年、月、日，通常与弹出层组件配合使用。                                                  | <a href="https://ibestui.ibestservices.com/components/timepicker/" target="__blank">文档</a>     |
| Uploader 文件上传       | 用于将本地的图片或文件上传至服务器，并在上传过程中展示预览图和上传状态。目前 Uploader 组件不包含将文件上传至服务器的接口逻辑，该步骤需要自行实现。 | <a href="https://ibestui.ibestservices.com/components/uploader/" target="__blank">文档</a>       |

### 反馈组件
| 组件               | 介绍                                                   |                                                                                             |
|:-----------------|:-----------------------------------------------------|---------------------------------------------------------------------------------------------|
| ActionSheet 动作面板 | 底部弹起的模态面板，包含与当前情境相关的多个选项。                            | <a href="https://ibestui.ibestservices.com/components/actionsheet/" target="__blank">文档</a> |
| Dialog 弹出框       | 弹出模态框，常用于消息提示、消息确认，或在当前页面内完成特定的交互操作。支持组件调用和函数调用两种方式。 | <a href="https://ibestui.ibestservices.com/components/dialog/" target="__blank">文档</a>      |
| Loading 加载       | 加载图标，用于表示加载中的过渡状态。                                   | <a href="https://ibestui.ibestservices.com/components/loading/" target="__blank">文档</a>     |
| Notify 消息提示      | 在页面顶部展示消息提示。                                         | <a href="https://ibestui.ibestservices.com/components/notify/" target="__blank">文档</a>      |
| PullRefresh 下拉刷新 | 轻量级, 用于提供下拉刷新的交互操作。                                  | <a href="https://ibestui.ibestservices.com/components/pullrefresh/" target="__blank">文档</a> |
| SwipeCell 滑动单元格  | 可以左右滑动来展示操作按钮的单元格组件。                                 | <a href="https://ibestui.ibestservices.com/components/swipecell/" target="__blank">文档</a>   |

### 展示组件
| 组件                   | 介绍                                 |                                                                                                |
|:---------------------|:-----------------------------------|------------------------------------------------------------------------------------------------|
| Badge 徽标             | 在右上角展示徽标数字或小红点。                    | <a href="https://ibestui.ibestservices.com/components/badge/" target="__blank">文档</a>          |
| CircleProgress 环形进度条 | 圆环形的进度条组件。                         | <a href="https://ibestui.ibestservices.com/components/circleProgress/" target="__blank">文档</a> |
| Collapse 折叠面板        | 将一组内容放置在多个折叠面板中，点击面板的标题可以展开或收缩其内容。 | <a href="https://ibestui.ibestservices.com/components/collapse/" target="__blank">文档</a>       |
| CountDown 倒计时        | 用于实时展示倒计时数值，支持毫秒精度。                | <a href="https://ibestui.ibestservices.com/components/countDown/" target="__blank">文档</a>      |
| Divider 分割线          | 用于将内容分隔为多个区域。                      | <a href="https://ibestui.ibestservices.com/components/divider/" target="__blank">文档</a>        |
| Empty 空状态            | 空状态时的占位提示。                         | <a href="https://ibestui.ibestservices.com/components/empty/" target="__blank">文档</a>          |
| Highlight 高亮文本       | 高亮指定文本内容。                          | <a href="https://ibestui.ibestservices.com/components/highlight/" target="__blank">文档</a>      |
| ImagePreview 图片预览    | 图片放大预览。                            | <a href="https://ibestui.ibestservices.com/components/imagepreview/" target="__blank">文档</a>   |
| NoticeBar 通知栏        | 用于循环播放展示一组消息通知。                    | <a href="https://ibestui.ibestservices.com/components/noticeBar/" target="__blank">文档</a>      |
| Popover 气泡弹出框        | 弹出式的气泡菜单。                          | <a href="https://ibestui.ibestservices.com/components/popover/" target="__blank">文档</a>        |
| Progress 进度条         | 用于展示操作的当前进度。                       | <a href="https://ibestui.ibestservices.com/components/progress/" target="__blank">文档</a>       |
| Table 表格             | 用于展示多条结构类似的数据。                     | <a href="https://ibestui.ibestservices.com/components/table/" target="__blank">文档</a>          |
| Tag 标签               | 用于标记关键词和概括主要内容。                    | <a href="https://ibestui.ibestservices.com/components/tag/" target="__blank">文档</a>            |
| TextEllipsis 文本省略    | 对长文本进行省略，支持展开/收起。                  | <a href="https://ibestui.ibestservices.com/components/textEllipsis/" target="__blank">文档</a>   |
| Watermark 水印         | 在页面上添加特定的文字或图案作为水印，可用于防止信息盗用。      | <a href="https://ibestui.ibestservices.com/components/watermark/" target="__blank">文档</a>      |

### 导航组件
| 组件            | 介绍                             |                                                                                            |
|:--------------|:-------------------------------|--------------------------------------------------------------------------------------------|
| NavBar 导航栏    | 为页面提供导航功能，常用于页面顶部。             | <a href="https://ibestui.ibestservices.com/components/navBar/" target="__blank">文档</a>     |
| Pagination 分页 | 数据量过多时，采用分页的形式将数据分隔，每次只加载一个页面。 | <a href="https://ibestui.ibestservices.com/components/pagination/" target="__blank">文档</a> |
| SideBar 侧边导航  | 垂直展示的导航栏，用于在不同的内容区域之间进行切换。     | <a href="https://ibestui.ibestservices.com/components/sideBar/" target="__blank">文档</a>    |
| Tab 标签页       | 选项卡组件，用于在不同的内容区域之间进行切换。        | <a href="https://ibestui.ibestservices.com/components/tab/" target="__blank">文档</a>        |

### 业务组件
| 组件                | 介绍               |                                                                                              |
|:------------------|:-----------------|:---------------------------------------------------------------------------------------------|
| CanvasDrawer 画布绘制 | 用于绘制海报、图片加水印等场景。 | <a href="https://ibestui.ibestservices.com/components/canvasDrawer/" target="__blank">文档</a> |
| ImageCropper 图片裁剪 | 用于裁剪图片。          | <a href="https://ibestui.ibestservices.com/components/imageCropper/" target="__blank">文档</a> |

## 需要权限
ohos.permission.INTERNET

## 官方生态

| 项目        | 描述                                                              |                                                                                     |
|:----------|:----------------------------------------------------------------|:------------------------------------------------------------------------------------|
| area-data | 中国省市区数据，适用于鸿蒙 arkui的 TextPicker 和 IBest-ui 的 IBestCascader 等组件。 | <a href="https://ohpm.openharmony.cn/#/cn/detail/@ibestservices%2Farea-data">地址</a> |

## 链接
- [Github](https://github.com/ibestservices/ibest-ui)
- [Gitee](https://gitee.com/ibestservices/ibest-ui)
- [更新日志](https://github.com/ibestservices/ibest-ui/releases)

## 交流QQ群
官方QQ群 953492584

![QQ1群](https://ibestservices.github.io/ibest-ui/screenshot/QQ%E7%BE%A4.jpg)

## 微信群
先进QQ群，拉你进微信群

## 约束与限制
在下述版本验证通过：
```text
DevEco Studio 5.0.2 Release
Build #DS-233.14475.28.36.507210
构建版本：5.0.7.210, built on February 11, 2025
Runtime version: 17.0.12+1-b1087.25 x86_64
VM: OpenJDK 64-Bit Server VM by JetBrains s.r.o.
macOS 15.3.1
GC: G1 Young Generation, G1 Old Generation
Memory: 2048M
Cores: 12
Metal Rendering is ON
Registry:
  idea.plugins.compatible.build=IC-233.14475.28
Non-Bundled Plugins:
  com.alibabacloud.intellij.cosy (2.1.2)
```

## 开源协议
本项目基于 Apache License 2.0，请自由地享受和参与开源。