/*
 * field 值类型
 */
export type IBestFieldValueType = string | number | boolean | Array<string | number>
/*
 * 文本对齐方式
 */
export type FieldTextAlign = '' | 'left' | 'center' | 'right'
/*
 * 文本位置
 */
export type LabelPositionType = '' | 'left' | 'top'
/*
 * 星号位置
 */
export type RequireAsteriskPositionType = '' | 'left' | 'right'
/*
 * 输入框类型
 */
export type IBestFieldType = 'normal' | 'password' | 'email' | 'number' | 'phone' | 'username' | 'number-password' | 'decimal'
/*
 * 清除图标显示时机
 */
export type ClearTriggerType = 'always' | 'focus'
/*
 * 格式化时机
 */
export type FormatTriggerType = 'onchange' | 'onblur'