import { IBestFormRuleItem } from '../form/index.type'
import { IBestFieldValueType } from './index.type'

export function isEmptyValue(value: IBestFieldValueType) {
	if (Array.isArray(value)) {
		return !value.length
	}
	return value === '' || value === null || value === undefined
}

export function runSyncRule(value: IBestFieldValueType, rule: IBestFormRuleItem) {
	if (isEmptyValue(value)) {
		return !rule.required
	}
	if (typeof value === "string" && rule.pattern) {
		return rule.pattern.test(value)
	}
	if ((rule.min != undefined || rule.max != undefined) && (typeof value === "string" || Array.isArray(value))) {
		let flag1: boolean = true, flag2: boolean = true
		if (rule.min != undefined) {
			flag1 = value.length >= rule.min
		}
		if (rule.max != undefined) {
			flag2 = value.length <= rule.max
		}
		return flag1 && flag2
	}
	return true
}

export function runRuleValidator(value: string, rule: IBestFormRuleItem) {
	return new Promise<string | boolean>((resolve) => {
		const returnVal = rule.validator!(value)
		if (typeof returnVal != "boolean" && typeof returnVal != "string") {
			returnVal.then(resolve)
			return
		}
		resolve(returnVal)
	})
}
