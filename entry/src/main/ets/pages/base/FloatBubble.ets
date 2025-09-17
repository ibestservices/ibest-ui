import { IBestButton, IBestCheckbox,
    IBestDialogUtil,
    IBestField,
    IBestFloatBubble,
    IBestIcon,
    IBestRadio,
    IBestRadioGroup,
    IBestSwitch,
    IBestTabItemType,
    IBestTabs,
    IBestToast
} from '@ibestservices/ibest-ui'
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function FloatBubbleBuilder(_: string, title: string) {
    FloatBubblePage({ title })
}

@Entry
@Component
struct FloatBubblePage {
    @State title: string = ''
    @State curTabName: string = "1"
    @State tabsList: IBestTabItemType[] = [
        {
            label: $r("app.string.basic_usage"),
            name: "1"
        },
        {
            label: "自由拖拽和磁吸",
            name: "2"
        },
        {
            label: "自定颜色和内容",
            name: "3"
        }
    ]
    @State bubbleShow: boolean = false
    @State bubbleShow1: boolean = false
    @State bubbleShow2: boolean = false

    @State isChecked: boolean = true
    @State group: string = "bubbleGroup"
    @State active: string = "1"
    @State switchValue: boolean = true
    @State value: string = ''
    @Builder customBubble(){
        Column({space: 6}){
            IBestIcon({
                name: "replay",
                iconSize: 16,
                color: "#fff"
            })
            Text("刷新").fontSize(12).fontColor("#fff")
        }
    }

    @Builder example() {
        Column() {
            ComponentShowContainer({ title: $r("app.string.component_button") }) {
                IBestButton({
                    type: 'primary',
                    text: $r("app.string.button"),
                    onBtnClick: () => {
                        IBestDialogUtil.open({
                            title: "提示",
                            message: "如果解决方法是丑陋的，那就肯定还有更好的解决方法，只是还没有发现而已。",
                            confirmButtonFontWeight: FontWeight.Bold,
                            dialogWidth: "90%"
                        })
                    }
                })
            }
            ComponentShowContainer({ title: $r("app.string.component_checkbox") }) {
                IBestCheckbox({
                    value: this.isChecked,
                    label: $r("app.string.content"),
                    onChange: checked => {
                        this.isChecked = checked as boolean
                    }
                })
            }
            ComponentShowContainer({ title: $r("app.string.component_radio") }) {
                IBestRadioGroup({ group: this.group, active: $active }) {
                    IBestRadio({ group: this.group, label: $r("app.string.content"), name: '1' })
                    IBestRadio({ group: this.group, label: $r("app.string.content"), name: '2' })
                }
            }
            ComponentShowContainer({ title: $r("app.string.component_switch") }) {
                Row() {
                    IBestSwitch({
                        value: $switchValue
                    })
                }
            }
            ComponentShowContainer({ title: '文本输入框' }) {
                IBestField({
                    value: $value,
                    label: "文本",
                    placeholder: "请输入文本",
                    hasBorder: false
                })
            }
        }
        .width(CONTAINER_SIZE.FULL)
        .layoutWeight(1)
        .padding({ left: SPACE.SM, right: SPACE.SM, bottom: SPACE.SM })
        .margin({ top: SPACE.SM })
    }
    onTabChange(){
        this.bubbleShow = false
        this.bubbleShow1 = false
        this.bubbleShow2 = false
        switch (this.curTabName){
            case "1":
                this.bubbleShow = true
                break
            case "2":
                this.bubbleShow1 = true
                break
            case "3":
                this.bubbleShow2 = true
                break
        }
    }
    build() {
        NavDestination() {
            CustomNavBar({ title: this.title })
            IBestTabs({
                tabsList: this.tabsList,
                currentName: $curTabName,
                onChange: () => {
                    this.onTabChange()
                }
            })
            this.example()
            IBestFloatBubble({
                show: this.bubbleShow,
                icon: "chat",
                onBubbleClick: () => {
                    IBestToast.show("点击了气泡")
                }
            })
            IBestFloatBubble({
                show: this.bubbleShow1,
                icon: "chat",
                dragAxis: "xy",
                autoHide: true,
				onBubbleClick: () => {
					IBestToast.show("点击了气泡")
				}
            })
            IBestFloatBubble({
                show: this.bubbleShow2,
                bubbleSize: 54,
                bgColor: "#ed4040",
                pos: {right: 0, bottom: 100},
                bubbleShadow: {
                    radius: 14,
                    color: "#333"
                }
            }){
                this.customBubble()
            }
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg)
        .onShown(() => {
            this.bubbleShow = true
        })
		.onWillHide(() => {
			this.bubbleShow = false
			this.bubbleShow1 = false
			this.bubbleShow2 = false
		})
    }
}