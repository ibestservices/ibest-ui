import { IBestStringNumber } from '../../model/Global.type'

/**
 * 组件基本类型
 */
class IBestCascaderBaseType{
	text: ResourceStr = ""
	value: IBestStringNumber = ""
}
/**
 * 用户传入数据类型
 */
export class IBestCascaderOption extends IBestCascaderBaseType{
	isEnd?: boolean = false
	disabled?: boolean
	children?: IBestCascaderOption[]
}
/**
 * 组件实例参数类型
 */
export class IBestCascaderOptionInstanceType extends IBestCascaderOption{
	actived?: boolean = false
}
/**
 * 组件数据项实例
 */
@Observed
export class IBestCascaderOptionInstance extends IBestCascaderOptionInstanceType{
	constructor(value: IBestCascaderOptionInstanceType) {
		super()
		this.text = value.text
		this.value = value.value
		this.disabled = value.disabled
		this.actived = value.actived
		this.children = value.children
		this.isEnd = value.isEnd
	}
}