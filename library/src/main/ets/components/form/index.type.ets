export interface IBestFormRule {
	required?: boolean
	message: string
	pattern?: RegExp
	validator?: <T>(rule: IBestFormRule, value: string) => boolean | string | Promise<T>
	trigger?: 'blur' | 'change'
	min?: number
	max?: number
}

export type RulesType = Record<string, IBestFormRule[]>