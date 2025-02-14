import { IBestFormRuleItem } from '../form/index.type'
import { IBestFieldValueType } from './index.type'

export function isEmptyValue(value: IBestFieldValueType) {
	if (Array.isArray(value)) {
		return !value.length
	}
	return !value
}

export function runSyncRule(value: IBestFieldValueType, rule: IBestFormRuleItem) {
	if (isEmptyValue(value)) {
		return !rule.required
	}
	if (rule.pattern && typeof value === "string") {
		return rule.pattern.test(value)
	}
	if ((rule.min != undefined || rule.max != undefined) && typeof value === "string") {
		if (rule.min != undefined && rule.max != undefined) {
			return rule.min <= value.length && value.length <= rule.max
		}else if (rule.min != undefined) {
			return value.length >= rule.min
		}else if (rule.max != undefined) {
			return value.length <= rule.max
		}
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
