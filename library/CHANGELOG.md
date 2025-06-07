# 版本记录

## 2.1.2
#### 新增:

#### 优化:

#### Bug修复:


## 2.1.1
#### 新增:
1. IBestFloatBubble 悬浮球 组件;
2. IBestCarKeyboard 车牌键盘 组件;
3. IBestCarInput 车牌输入框 组件;
4. IBestPasswordInput 增加 autoFocus showCursor highlightType 属性;
5. IBestWatermark 增加 contentInteractive 属性.

#### 优化:
1. 日历农历初一日显示为月份.

#### Bug修复:
1. IBestImagePreview 侧滑关闭后无法打开问题;
2. 修复 IBestDialog buttonSpace 不生效问题.

## 2.1.0
#### 新增:
1. IBestCountTo 数字滚动 组件;
2. IBestSkeleton 骨架屏 组件;
3. IBestSteps 步骤条 组件;
4. IBestPopup  增加  keyboardAvoidMode keyboardAvoidDistance levelMode levelUniqueId 参数;
5. IBestDialog 增加 keyboardAvoidMode 参数;
6. IBestCheckGroup、IBestRadioGroup 增加 disabled 参数.

#### Bug修复:
1. IBestActionSheet IBestDialogUtil 优化多窗口关闭;
2. IBestPasswordInput 最后一位输入问题;
3. IBestCheckBox 禁用状态在分组中失效问题;
4. IBestStepper 输入时无法限制大小问题.

## 2.0.9
#### 新增:
1. IBestColorPicker 颜色选取 组件;
2. IBestDateTimePicker 日期时间选择 组件;
3. IBestDialog 增加 confirmButtonFontWeight;
4. IBestField 增加 messageTextAlign;
5. IBestNoticeBar 增加 radius;
6. IBestCalendar 增加 dayItemBuilder;
7. IBestTabs 增加 showActiveLine tabLineRadius activeFontWeight activeFontSize tabContentBuilder;
8. IBestTextEllipsis 增加 onActionClick.

#### Bug修复:
1. IBestDialog 组件宽度为百分比时在宽屏设备不生效问题;
2. IBestPopup 组件在横屏时位置错误问题;
3. IBestTextEllipsis 在文字较少时也显示操作文字问题;

## 2.0.8
#### 新增:
1. IBestPagination 分页组件;
2. IBestButton 增加 fontWeight 属性;
3. IBestHighlight 增加 maxLine overflow 属性;
4. IBestCheckbox  IBestCheckboxGroup  IBestRadioGroup 增加 beforeChange;
5. IBestDialog IBestPopup 增加 bgColor keyboardAvoidDistance levelMode levelUniqueId 属性;
6. IBestActionSheet 增加 radius 属性;
7. IBestPasswordInput 增加 onFinish;
8. IBestCircleProgress 增加 onReachTarget;
9. IBestProgress 增加 target onReachTarget，value 变更为双向绑定.


## 2.0.7
#### 新增:
1. 适配国际化
2. IBestHighlight 高亮文本组件;
3. IBestTable 表格组件;
4. IBestButton iconPosition 增加 top bottom;
5. IBestCheckbox 增加 bgColor bdColor 属性;
6. IBestRadio 增加 bgColor bdColor 属性;
7. IBestField 增加 prefix prefixFontColor suffix suffixFontColor 属性;
8. IBestDialog 增加 bgImage 属性;
9. IBestPopup 增加 bgImage 属性;
10. IBestPullRefresh onRefresh 增加回调参数 direction。

#### Bug修复:
1. 修复日历组件在范围选择时未选日期确认后报错问题。

#### 优化:
1. IBestCalendar weekFirstDay 属性类型变更为number。

## 2.0.6
#### 新增:
1. 新增 IBestImageCropper 图片裁剪组件;
2. IBestRadio name、IBestRadioGroup active 支持number boolean类型;
3. IBestField verticalAlign radius 属性, rules属性支持动态编辑;
4. IBestForm validate validateField 方法支持返回Promise;
5. IBestUploader 增加 showPreviewList 属性;
6. IBestPopover 增加 fixHeight maxHeight scrollBarState;
7. IBestCellGroup 增加 radius 属性;

#### Bug修复:
1. 修复 IBestDatePicker IBestTimePicker title属性不生效问题.

## 2.0.5
#### 新增:
1. IBestTabs 增加 isShowActiveBg activeBgColor inactiveBgColor radius 属性;
2. IBestPopover 增加 borderSizeType 属性;
3. IBestForm 支持动态表单验证;
4. IBestField 增加 caretColor min max 属性.

#### Bug修复:
1. 修复 IBestUploader 文件缓存路径不完整问题;
2. 修复 IBestPasswordInput 密码输入框 在重新赋值时显示异常的问题;
3. 修复 IBestField 必填*位置异常问题;
4. 修复元服务报错问题.

## 2.0.4
1. 增加 IBestCanvasDrawer 画布绘制组件;
2. IBestNavBar 增加 titleTextAlign 属性, 适配元服务右上角胶囊位置;
3. IBestPullRefresh 增加 上滑加载 配置;
4. IBestPopover 增加 onOpen 事件, IBestPopoverAction 增加 value 属性;
5. IBestField 增加 inputFontSize 属性.

#### Bug修复:
1. IBestPullRefresh 下拉时卡主问题.

## 2.0.3
1. README 添加组件介绍;
2. IBestButton 增加 iconPosition 属性.

## 2.0.2
1. 已适配深色模式, 可自定义浅色与深色主题颜色;
2. 新增 SwipeCell 滑动单元格组件;
3. IBestButton 增加 icon fontColor btnBorderColor btnBorderRadius 属性;
4. IBestCalendar 增加 clock 打卡模式, clockSuccessText isShowUnClock unClockText 属性;
5. IBestCheckbox 增加 activeList placeDirection space controller 属性;
6. IBestPopup 增加 titleColor closeIconColor 属性;
7. IBestField 增加 bgColor placeholderColor 属性;
8. IBestRadio 增加 active placeDirection space 属性;
9. IBestSearch 增加 labelColor textFontSize rightBtnBgColor rightBtnPressBgColor 属性;
10. IBestSlider 增加 buttonBgColor 属性;
11. IBestStepper 增加 value 属性;
12. IBestUploader 增加 uploaderBgColor 属性;
13. IBestWatermark 增加 bgColor 属性.

#### 重要变更:
1. IBestCheckbox IBestRadio IBestStepper 组件优化了使用方法, 支持双向绑定, 请对照文档修改.

#### Bug修复:
1. 修复 IBestField 的 onLeftIconClick 函数不执行问题;
2. 修复 IBestDatePicker 组件 不显示日的情况下月份范围异常问题;
3. 修复 IBestUploader 组件在元服务无法使用问题.

## 2.0.0
1. 增加 IBestNoticeBar 通知栏组件;
2. 增加 IBestProgress 进度条组件;
3. 增加 IBestPopover 气泡弹出框组件;
4. 增加 IBestTextEllipsis 文本省略组件;
5. 增加 IBestCountDown 倒计时组件;
6. 增加 IBestSideBar 侧边导航组件;
7. IBestPicker、IBestDatePicker、IBestTimePicker 增加 horizontal、itemWidth、contentHeight、optionFontSize 属性;
8. IBestField 增加 showLabel 属性.

## 1.19.0
#### 新增:
1. 增加 IBestNavBar 导航栏组件;
2. 增加 IBestCircleProgress 环形进度条组件;
3. 增加 IBestCollapse 折叠面板组件;
4. 增加 IBestDivider 分割线组件;
5. IBestIcon 增加 iconRadius 属性;
6. IBestField 增加 leftIconSize rightIconSize labelFontSize labelColor 属性;
7. IBestPasswordInput 增加 isShowBorder bdColor cellBgColor cellTextColor dotFontSize textFontSize tipFontSize 属性.

#### Bug修复:
1. 修复 IBestCalendar 在设定的跨月时间范围时, 如果翻到下月, 上月日期会被禁用.

## 1.18.0
#### 新增:
1. 新增 IBestBadge 徽标组件;
2. Search 增加 textColor 属性;
3. IBestCell 增加 leftContentWidth、leftIconMarginRight、rightIconMarginLeft、leftRightPadding、borderSizeType、borderLeft、bdColor 属性;
4. IBestToast 增加 iconWidth 属性;
5. IBestCheckBox IBestRadio 增加 labelFontSize 属性;
6. IBestEmpty 增加 emptyImgUrl 属性;
7. IBestPopup 增加 headerBuilder 插槽;
8. IBestSearch 增加 textColor 属性;
#### 重要变更:
1. 组件库全局尺寸单位默认为vp, 可自定义配置, 升级后可能会出现部分组件尺寸偏大情况, 只需将原先传递的尺寸改为原来一半即可.
#### BUG修复:
1. IBestToast 同时打开无法关闭问题;
2. IBestCascader 异步加载时崩溃问题;

## 1.17.1

1. 修复bug

## 1.17.0

1. 新增 IBestIcon 组件;
2. 新增 IBestPullRefresh 下拉刷新组件;
3. IBestTab 新增 onTabClick 事件;
4. 增加导出 IBestCascaderContent 级联组件, 可独立在页面中使用或与其他自定义组件组合使用;
5. IBestCell 增加 leftIcon leftIconColor leftIconSize rightIcon rightIconColor rightIconSize 属性;
6. IBestActionSheet 增加 cancelTextColor、beforeClose 属性.

另: 新发布 @ibestservices/area-data 库, 可用于Cascader相关组件.

## 1.16.0

新增:
1. 增加 IBestDialogUtil 弹框API;
2. IBestDialog 增加 visible、theme、buttonSpace、confirmButtonBgColor、cancelButtonBgColor、closeOnBackPress、onOpen、onClose 属性;
3. 增加 IBestNotify 消息提示API;
4. IBestToast 增加 showLoading 方法.

变更:
IBestDialog 组件显隐控制方式由原来的controller方式变为由 visible 属性控制, 简化使用.


优化:
1. 优化 IBestLoading 组件动画效果;
2. 优化 IBestPopup 组件隐藏动画效果.

## 1.15.0
新增:
1. 增加 slider 滑块组件;
2. 增加 Uploader 文件上传组件;
3. 增加图片预览api IBestImagePreview;
4. tab组件新增 fontSize 属性;
5. form组件新增 getFormValues 方法, 同步获取表单数据。

兼容变更:
1. 所有组件(Watermark、Signature除外)颜色相关属性类型改为 RescourseColor 。

## 1.14.0
1. Search 组件增加 customRightButton 属性
2. 增加 IBestActionSheet API
3. 增加 IBestSignature 组件
4. 组件库初始化变更

## 1.13.0
1. 增加search rate组件
2. watermark组件使用stack包裹
3. button组件增加宽高设置

## 1.12.1
watermark引用文件大小写不一致报错bug修复

## 1.12.0
1. 新增numberKeyboard、passwordInput组件 ;
2. popup 新增 maskColor 属性 ;
3. 新增全局初始化方法 IBestInit ;
4. 一些样式优化 。

## 1.11.1
1. bug修复

## 1.11.0
1. 增加: Picker、DatePicker、TimePicker、PickerGroup
2. Cascader组件支持双向绑定;
3. Tab组件支持双向绑定, 优化参数声明。

## 1.10.0
1. 增加Form以及Field组件

## 1.9.1
1. Cascader与Popup组件代码大小写格式纠正

## 1.9.0
1. 增加Cascader与Popup组件

## 1.8.0
1. 增加tab组件

## 1.7.0
1. 增加loading组件
2. 修复若干bug

## 1.6.0
1. 增加toast组件

## 1.5.0
1. 增加calendar组件

## 1.4.0
1. 编写stepper组件以及对应的展示页面

## 1.3.0
1. 兼容API 11

## 1.2.0
1. 增加dialog组件以及对应的展示页面

## 1.1.0
1. 增加empty组件以及对应的展示页面

## 1.0.3
1. checkbox组件UI展示bug修复

## 1.0.2
1. package增加`keywords`、`tags`、`homepage`、`repository`
2. 代码格式以及注释调整

## 1.0.1
1. Readme内容调整

## 1.0.0 初版