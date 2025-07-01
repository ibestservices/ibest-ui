import { provinceData, provinceAndCityData, regionData } from "@ibestservices/area-data"
import { FieldValidateResult, IBestFormValidateResult } from "../form/index.type"
import { surname } from './surname'

export interface AddressParseResult {
  /**
   * 手机号
   */
  phone: string
  /**
   * 邮政编码
   */
  postalCode?: string
  /**
   * 省级数据
   */
  province: string
  /**
   * 市级数据
   */
  city: string
  /**
   * 区县级数据
   */
  area: string
  /**
   * 识别后的其他数据，门牌号等
   */
  detail: string
  /**
   * 姓名
   */
  name: string
  /**
   * 省级区域编码
   */
  provinceCode: string
  /**
   * 市级区域编码
   */
  cityCode: string
  /**
   * 区县级区域编码
   */
  areaCode: string
}

interface CascaderOption {
  text: string
  value: string
  children?: Array<CascaderOption>
}

interface AreaJsonBasicType {
  code: string
  name: string
}

interface CityJsonType extends AreaJsonBasicType {
  provinceCode: string
}

interface DistrictJsonType extends CityJsonType {
  cityCode: string
}

interface AddressParseResult_ {
  phone: string
  postalCode?: string
  province: Array<AreaJsonBasicType>
  city: Array<CityJsonType>
  area: Array<DistrictJsonType>
  detail: Array<string>
  name: string
  provinceCode: string
  cityCode: string
  areaCode: string
}

interface AddressParseConfigType {
  debug: boolean
  /**
   * 匹配名字的最大长度
   */
  nameMaxLength: number
  /**
   * 预处理过滤文本中的关键字，可根据情况添加
   */
  textFilter: Array<string>
}

// 过滤器返回类型
interface filterResult {
  /**
   * 过滤后其他内容
   */
  others: string
  /**
   * 过滤后的目标内容
   */
  target: string
}

const provincesJson: Array<AreaJsonBasicType> = provinceData.reduce((per: Array<AreaJsonBasicType>, cur: CascaderOption) => {
  per.push({code: cur.value, name: cur.text})
  return per
}, [])

const citiesJson: Array<CityJsonType> = provinceAndCityData.reduce((per: Array<CityJsonType>, cur: CascaderOption): Array<CityJsonType> => {
  if (!cur.children) {
    return per
  }

  const cityItems: Array<CityJsonType> = cur.children.map((child: CascaderOption): CityJsonType => {
    return {
      code: child.value,
      name: child.text,
      provinceCode: cur.value
    }
  })

  return per.concat(cityItems)
}, [])

const areasJson: Array<DistrictJsonType> = regionData.reduce((per: Array<DistrictJsonType>, cur: CascaderOption): Array<DistrictJsonType> => {
  if (!cur.children) return per

  const citiesData: Array<DistrictJsonType> = cur.children.reduce((cityResult: Array<DistrictJsonType>, city: CascaderOption): Array<DistrictJsonType> => {
    if (!city.children) return cityResult

    const districtItems: Array<DistrictJsonType> = city.children.map((district: CascaderOption): DistrictJsonType => ({
      code: district.value,
      name: district.text,
      cityCode: city.value,
      provinceCode: cur.value
    }))

    return [...cityResult, ...districtItems]
  }, [] as Array<DistrictJsonType>)

  return [...per, ...citiesData]
}, [])

const provinceString = JSON.stringify(provincesJson)
const cityString = JSON.stringify(citiesJson)
const areaString = JSON.stringify(areasJson)
const parseConfig: AddressParseConfigType = {
  debug: false,
  nameMaxLength: 4,
  textFilter: [
    '详细地址',
    '收货地址',
    '收件地址',
    '地址',
    '所在地区',
    '姓名',
    '收货人',
    '收件人',
    '联系人',
    '收',
    '邮编',
    '联系电话',
    '电话',
    '联系人手机号码',
    '电話',
    '電話',
    '聯系人',
    '手机号码',
    '手机号',
    '手机',
    '自治区直辖县级行政区划',
    '省直辖县级行政区划'
  ]
}
const log = (...args: Array<number|string|object>): void => {
  if(parseConfig.debug) console.log(args.map(arg => {
    if (typeof arg === 'object' && arg !== null) {
      return JSON.stringify(arg)
    }
    return String(arg)
  }).join(" "))
}

/**
 * 地址清洗
 * @param address
 * @param textFilter
 * @returns {*}
 */
const pretreatmentAddressText = (address: string, textFilter: Array<string> = []): string => {
  // 去换行等
  address = address
    .replace(/\r\n/g, ' ')
    .replace(/\n/g, ' ')
    .replace(/\t/g, ' ')

  // 过滤掉自定义的关键字
  textFilter.forEach(str => {
    address = address.replace(new RegExp(str, 'g'), ' ')
  })

  const pattern = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\]\.<>/?~！@#￥……&*（）——|{}【】‘；：”“’。，、？]", 'g')
  address = address.replace(pattern, ' ')

  // 多个空格replace为一个
  address = address.replace(/ {2,}/g, ' ')
  //适配直辖市区
  const municipality = [
    '北京',
    '上海',
    '天津',
    '重庆'
  ]
  municipality.forEach(str => {
    address = address.replace(str+str, str)
  })
  return address
}

/**
 * 匹配电话
 * @param address
 * @returns filterResult
 */
const filterPhone = (address: string): filterResult => {
  let phone = ''
  // 整理电话格式
  address = address.replace(/(\d{3})-(\d{4})-(\d{4})/g, '$1$2$3')
  address = address.replace(/(\d{3}) (\d{4}) (\d{4})/g, '$1$2$3')
  address = address.replace(/(\d{4}) \d{4} \d{4}/g, '$1$2$3')
  address = address.replace(/(\d{4})/g, '$1')

  const mobileReg = /(0|\+?86-?|17951|)?1[3456789]\d{9}(-\d{4})?/g
  const mobile = mobileReg.exec(address)
  if (mobile) {
    phone = mobile[0]
    address = address.replace(mobile[0], ' ')
  }
  return {others: address, target: phone.replace(/^\+?86-?/g, '')} as filterResult
}

/**
 * 匹配邮编
 * @param address
 * @returns filterResult
 */
const filterPostalCode = (address: string): filterResult => {
  let postalCode = ''
  const postalCodeReg = /[1-9]\d{5}(?!\d)/g
  const code = postalCodeReg.exec(address)
  if (code) {
    postalCode = code[0]
    address = address.replace(code[0], ' ')
  }
  return {others: address, target: postalCode} as filterResult
}

/**
 * 按照省市区县镇排序
 * @param splitAddress
 * @returns Array<string>
 */
const sortAddress = (splitAddress: Array<string>): Array<string> => {
  const result: Array<string> = []
  const getIndex = (str: string) => {
    return splitAddress.findIndex(item => ~item.indexOf(str))
  }
  ['省', '市', '区', '县', '镇'].forEach(item => {
    let index = getIndex(item)
    if (~index) {
      result.push(splitAddress.splice(index, 1)[0])
    }
  })

  return [...result, ...splitAddress]
}

/**
 * 利用正则表达式解析
 * @param fragment
 * @param hasParseResult
 * @returns Partial<AddressParseResult>
 */
const parseRegionWithRegexp = (fragment: string, hasParseResult: AddressParseResult_): Partial<AddressParseResult_> => {
  let province = hasParseResult.province || [], city = hasParseResult.city || [], area = hasParseResult.area || []
  let detail: string[] = []

  let matchStr = ''
  if (province.length === 0) {
    for (let i = 1; i < fragment.length; i++) {
      const str = fragment.substring(0, i + 1)
      const regexProvince = new RegExp(`\{\"code\":\"[0-9]{1,6}\",\"name\":\"${str}[\u4E00-\u9FA5]*?\"}`, 'g')
      const matchProvince = provinceString.match(regexProvince)
      if (matchProvince) {
        const provinceObj: AreaJsonBasicType = JSON.parse(matchProvince[0])
        if (matchProvince.length === 1) {
          province = []
          matchStr = str
          province.push(provinceObj)
        }
      } else {
        break
      }
    }

    if (province[0]) {
      fragment = fragment.replace(new RegExp(matchStr, 'g'), '')
    }
  }

  if (city.length === 0) {
    for (let i = 1; i < fragment.length; i++) {
      const str = fragment.substring(0, i + 1)
      const regexCity = new RegExp(`\{\"code\":\"[0-9]{1,6}\",\"name\":\"${str}[\u4E00-\u9FA5]*?\",\"provinceCode\":\"${province[0] ? `${province[0].code}` : '[0-9]{1,6}'}\"\}`, 'g')
      const matchCity = cityString.match(regexCity)
      if (matchCity) {
        const cityObj: CityJsonType = JSON.parse(matchCity[0])
        if (matchCity.length === 1) {
          city = []
          matchStr = str
          city.push(cityObj)
        }
      } else {
        break
      }
    }
    if (city[0]) {
      const provinceCode = city[0].provinceCode
      fragment = fragment.replace(new RegExp(matchStr, 'g'), '')
      if (province.length === 0) {
        const regexProvince = new RegExp(`\{\"code\":\"${provinceCode}\",\"name\":\"[\u4E00-\u9FA5]+?\"}`, 'g')
        const matchProvince = provinceString.match(regexProvince)
        if(matchProvince) province.push(JSON.parse(matchProvince[0]))
      }
    }

  }

  if (area.length === 0) {
    for (let i = 1; i < fragment.length; i++) {
      const str = fragment.substring(0, i + 1)
      const regexArea = new RegExp(`\{\"code\":\"[0-9]{1,9}\",\"name\":\"${str}[\u4E00-\u9FA5]*?\",\"cityCode\":\"${city[0] ? city[0].code : '[0-9]{1,6}'}\",\"provinceCode\":\"${province[0] ? `${province[0].code}` : '[0-9]{1,6}'}\"\}`, 'g')
      const matchArea = areaString.match(regexArea)
      if (matchArea) {
        const areaObj: DistrictJsonType = JSON.parse(matchArea[0])
        if (matchArea.length === 1) {
          area = []
          matchStr = str
          area.push(areaObj)
        }
      } else {
        break
      }
    }
    if (area[0]) {
      const provinceCode = area[0].provinceCode
      const cityCode = area[0].cityCode
      fragment = fragment.replace(matchStr, '')
      if (province.length === 0) {
        const regexProvince = new RegExp(`\{\"code\":\"${provinceCode}\",\"name\":\"[\u4E00-\u9FA5]+?\"}`, 'g')
        const matchProvince = provinceString.match(regexProvince)
        if(matchProvince) province.push(JSON.parse(matchProvince[0]))
      }
      if (city.length === 0) {
        const regexCity = new RegExp(`\{\"code\":\"${cityCode}\",\"name\":\"[\u4E00-\u9FA5]+?\",\"provinceCode\":\"${provinceCode}\"\}`, 'g')
        const matchCity = cityString.match(regexCity)
        if(matchCity) city.push(JSON.parse(matchCity[0]))
      }
    }
  }

  // 解析完省市区如果还存在地址，则默认为详细地址
  if (fragment.length > 0) {
    detail.push(fragment)
  }

  return {
    province,
    city,
    area,
    detail,
  }
}

/**
 * 判断是否是名字
 * @param fragment
 * @returns {string}
 */
const judgeFragmentIsName = (fragment: string, nameMaxLength: number): string => {
  if (!fragment || !/[\u4E00-\u9FA5]/.test(fragment)) {
    return ''
  }

  // 如果包含下列称呼，则认为是名字，可自行添加
  const nameCall = ['先生', '小姐', '同志', '哥哥', '姐姐', '妹妹', '弟弟', '妈妈', '爸爸', '爷爷', '奶奶', '姑姑', '舅舅']
  if (nameCall.find(item => ~fragment.indexOf(item))) {
    return fragment
  }

  const filters = ['街道', '乡镇', '镇', '乡']
  if (~filters.findIndex(item => ~fragment.indexOf(item))) {
    return ''
  }

  // 如果百家姓里面能找到这个姓，并且长度在1-5之间
  const nameFirst = fragment.substring(0, 1)
  if (fragment.length <= nameMaxLength && fragment.length > 1 && ~surname.indexOf(nameFirst)) {
    return fragment
  }

  return ''
}

const judgeIsName = (text: string): boolean => {
  const res = judgeFragmentIsName(text, parseConfig.nameMaxLength)
  return res != ''
}

const AddressParseSync = (address: string): AddressParseResult => {
  const parseResult: AddressParseResult_ = {
    phone: '',
    province: [],
    city: [],
    area: [],
    detail: [],
    name: '',
    provinceCode: '',
    cityCode: '',
    areaCode: '',
  }

  address = pretreatmentAddressText(address, parseConfig.textFilter)
  log('预处理文本 --->', address)

  const resultPhone: filterResult = filterPhone(address)
  address = resultPhone.others
  parseResult.phone = resultPhone.target
  log('电话 --->', JSON.stringify(resultPhone))

  const resultCode: filterResult = filterPostalCode(address)
  address = resultCode.others
  parseResult.postalCode = resultCode.target
  log('邮政编码 --->', JSON.stringify(resultCode))

  // 地址分割，排序
  let splitAddress = address.split(' ').filter(item => item && !/^\d+$/.test(item)).map(item => item.trim())
  splitAddress = sortAddress(splitAddress)
  log('分割地址 --->', JSON.stringify(splitAddress))

  const takeStartTime = new Date().getTime()
  // 找省市区和详细地址
  splitAddress.forEach((item, index) => {
    // 识别地址
    if (!parseResult.province[0] || !parseResult.city[0] || !parseResult.area[0]) {
      let parse = parseRegionWithRegexp(item, parseResult)
      parseResult.province = parse.province || []
      parseResult.area = parse.area || []
      parseResult.city = parse.city || []
      parseResult.detail = parseResult.detail.concat(parse.detail || [])
      parseResult.areaCode =  parseResult.area[0]?.code || ''
      parseResult.provinceCode =  parseResult.province[0]?.code || ''
      parseResult.cityCode =  parseResult.city[0]?.code || ''
    } else {
      parseResult.detail.push(item)
    }
  })
  const takeEndTime = new Date().getTime()
  log('解析耗时--->', takeEndTime - takeStartTime, "毫秒")

  const province = parseResult.province[0]
  const city = parseResult.city[0]
  const area = parseResult.area[0]
  let detail = parseResult.detail

  detail = detail.map(item => item.replace(new RegExp(`${province && province.name}|${city && city.name}|${area && area.name}`, 'g'), ''))
  detail = Array.from(new Set(detail))
  log('去重--->', detail)

  // 地址都解析完了，姓名应该是在详细地址里面
  if (detail && detail.length > 0) {
    const copyDetail = [...detail].filter(item => !!item)
    copyDetail.sort((a, b) => a.length - b.length)
    // 排序后从最短的开始找名字，没找到的话就看第一个是不是
    const index = copyDetail.findIndex(item => judgeFragmentIsName(item, parseConfig.nameMaxLength))
    let name = ''
    if (~index) {
      name = copyDetail[index]
    } else if (copyDetail[0] && copyDetail[0].length <= parseConfig.nameMaxLength && /[\u4E00-\u9FA5]/.test(copyDetail[0])) {
      name = copyDetail[0]
    }

    // 找到了名字就从详细地址里面删除它
    if (name) {
      parseResult.name = name
      detail.splice(detail.findIndex(item => item === name), 1)
      log('提取名字后--->', detail)
    }
  }

  const provinceName = province && province.name
  let cityName = city && city.name
  if (~['市辖区', '区', '县', '镇'].indexOf(cityName)) {
    cityName = provinceName
  }

  return {
    phone: parseResult.phone,
    postalCode: parseResult.postalCode,
    province: provinceName || '',
    city: cityName || '',
    area: (area && area.name) || '',
    detail: (detail && detail.length > 0 && detail.join('')) || '',
    name: parseResult.name,
    provinceCode: parseResult.provinceCode,
    cityCode: parseResult.cityCode,
    areaCode: parseResult.areaCode
  }
}

const AddressParse = (address: string): Promise<AddressParseResult|null> => new Promise((resolve, reject) => {
  try {
    resolve(AddressParseSync(address))
  } catch (error) {
    reject(error)
  }
})

export class IBestContactAddressController {
  /**
   * 解析文本地址
   */
  static parseText: (text: string) =>  Promise<AddressParseResult|null> = AddressParse
  static parseTextSync: (text: string) => AddressParseResult = AddressParseSync
  /**
   * 判断名字
   */
  static judgeName: (val: string) => boolean = (val: string) => {
    return judgeIsName(val)
  }
  /**
   * 判断手机
   */
  static judgePhone: (val: string) => boolean = (val: string) => {
    return filterPhone(val).target != ''
  }
  /**
   * 验证整个表单
   * @param callBack 回调函数
   */
  public validateForm: (callBack?: (valid: boolean, field: FieldValidateResult[]) => void) => Promise<IBestFormValidateResult> = () => {
    let res: IBestFormValidateResult = {
      valid: true,
      fields: []
    }
    return Promise.resolve(res)
  }
  /**
   * 获取所有值
   */
  public getFormValues: () => AddressParseResult = () => {
    return {
      phone: '',
      province: '',
      city: '',
      area: '',
      detail: '',
      name: '',
      provinceCode: '',
      cityCode: '',
      areaCode: '',
    }
  }
  /**
   * 设置表单数据
   */
  public setFormValues: (val: AddressParseResult) => void = () => {}

  /**
   * 清除表单数据
   */
  public cleanFormValues: () => void = () => {}
}