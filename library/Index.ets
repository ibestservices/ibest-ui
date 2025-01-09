import { setIBestUIBaseStyle } from './src/main/ets/theme-chalk/src'
import IBestToast from './src/main/ets/apis/IBestToast'
import IBestActionSheet from './src/main/ets/apis/IBestActionSheet'
import IBestImagePreview from './src/main/ets/apis/IBestImagePreview'
import IBestDialogUtil from './src/main/ets/apis/IBestDialog'
import IBestNotify from './src/main/ets/apis/IBestNotify'
import GlobalStore from './src/main/ets/utils/GlobalStore'
import { IBestGlobalConfigType, IBestGlobalVoid } from './src/main/ets/model/Global.type'
const init = GlobalStore.init
const setGlobalConfig = GlobalStore.setGlobalConfig

setGlobalConfig()

export {
	init as IBestInit,
	setIBestUIBaseStyle,
	setIBestUIBaseStyle as IBestSetUIBaseStyle,
	setGlobalConfig as IBestSetGlobalConfig,
	IBestToast,
	IBestActionSheet,
	IBestImagePreview,
	IBestDialogUtil,
	IBestNotify
}

export type {
	IBestGlobalConfigType
}

export const IBest: IBestGlobalVoid = {
	init: GlobalStore.init,
	setGlobalConfig: GlobalStore.setGlobalConfig,
	setUIBaseStyle: setIBestUIBaseStyle
}

export { debounce, throttle } from './src/main/ets/utils/DebounceThrottle'

export { IBestUIBaseStyleType } from './src/main/ets/theme-chalk/src/index.type'

export { IBestButton } from './src/main/ets/components/button/index'

export { IBestCheckbox } from './src/main/ets/components/checkbox/index'

export { IBestCheckboxGroup, CheckboxGroupContext } from './src/main/ets/components/checkboxGroup/index'
export { IBestCheckboxGroupController } from './src/main/ets/components/checkboxGroup/index.type'

export { IBestSwitch } from './src/main/ets/components/switch/index'

export { IBestTag } from './src/main/ets/components/tag/index'

export { IBestCell } from './src/main/ets/components/cell/index'

export { IBestCellGroup } from './src/main/ets/components/cellGroup/index'

export { IBestWatermark } from './src/main/ets/components/waterMark/index'

export { IBestRadio } from './src/main/ets/components/radio/index'

export { IBestRadioGroup } from './src/main/ets/components/radioGroup/index'

export { IBestEmpty } from './src/main/ets/components/empty/index'

export { IBestDialog } from './src/main/ets/components/dialog/index'

export { IBestStepper } from './src/main/ets/components/stepper/index'

export { IBestCalendar } from './src/main/ets/components/calendar/index'
export { IBestCalendarDialog } from './src/main/ets/components/calendar/calendarDialog'
export { CalendarConfirmResultType, SelectType, SelectedStyleType } from './src/main/ets/components/calendar/index.type'

export { IBestLoading } from './src/main/ets/components/loading/index'

export { IBestTabs } from './src/main/ets/components/tab/index'
export { IBestTabItem, IBestTabItemType, IBestTabController } from './src/main/ets/components/tab/index.type'

export { IBestPopup } from './src/main/ets/components/popup/index'

export { IBestCascader, IBestCascaderContent } from './src/main/ets/components/cascader/index'
export { IBestCascaderOption } from './src/main/ets/components/cascader/index.type'

export { IBestField } from './src/main/ets/components/field/index'
export { IBestFieldValueType } from './src/main/ets/components/field/index.type'

export { IBestForm } from './src/main/ets/components/form/index'
export { IBestFormController, IBestFormRule } from './src/main/ets/components/form/index.type'

export { IBestPicker } from './src/main/ets/components/picker/index'
export { IBestPickerOption } from './src/main/ets/components/picker/index.type'

export { IBestPickerGroup } from './src/main/ets/components/pickerGroup/index'

export { IBestDatePicker } from './src/main/ets/components/datePicker/index'
export { IBestDatePickerResultType } from './src/main/ets/components/datePicker/index.type'

export { IBestTimePicker } from './src/main/ets/components/timePicker/index'

export { IBestNumberKeyboard } from './src/main/ets/components/numberKeyboard/index'

export { IBestPasswordInput } from './src/main/ets/components/passwordInput/index'

export { IBestSearch } from './src/main/ets/components/search/index'

export { IBestRate } from './src/main/ets/components/rate/index'

export { IBestSignature } from './src/main/ets/components/signature/index'
export { IBestSignatureController } from './src/main/ets/components/signature/index.type'

export { IBestSlider } from './src/main/ets/components/slider/index'
export { IBestSliderValue } from './src/main/ets/components/slider/index.type'

export { IBestUploader } from './src/main/ets/components/uploader/index'
export { IBestUploaderFile } from './src/main/ets/components/uploader/index.type'

export { IBestPullRefresh } from './src/main/ets/components/pullRefresh'
export { IBestRefreshContentParams } from './src/main/ets/components/pullRefresh/index.type'

export { IBestIcon } from './src/main/ets/components/icon/index'
export {IBestIconClassify, IBestIconData} from './src/main/ets/components/icon/config'

export { IBestBadge } from './src/main/ets/components/badge/index'

export { IBestNavBar } from './src/main/ets/components/navBar/index'

export { IBestCircleProgress } from './src/main/ets/components/circleProgress/index'

export { IBestCollapse } from './src/main/ets/components/collapse/index'
export { IBestCollapseController } from './src/main/ets/components/collapse/index.type'
export { IBestCollapseItem } from './src/main/ets/components/collapseItem/index'

export { IBestDivider } from './src/main/ets/components/divider/index'

export { IBestNoticeBar } from './src/main/ets/components/noticeBar/index'

export { IBestProgress } from './src/main/ets/components/progress/index'

export { IBestCountDown } from './src/main/ets/components/countDown/index'
export { IBestCountDownController } from './src/main/ets/components/countDown/index.type'

export { IBestPopover } from './src/main/ets/components/popover/index'
export { IBestPopoverAction, IBestPopoverController } from './src/main/ets/components/popover/index.type'

export { IBestTextEllipsis } from './src/main/ets/components/textEllipsis/index'

export { IBestSideBar } from './src/main/ets/components/sideBar/index'
export { IBestSideBarItem } from './src/main/ets/components/sideBarItem/index'

export { IBestSwipeCell } from './src/main/ets/components/swipeCell/index'

export { IBestCanvasDrawer } from './src/main/ets/components/canvasDrawer/index'
export { IBestCanvasContent } from './src/main/ets/components/canvasDrawer/index.type'