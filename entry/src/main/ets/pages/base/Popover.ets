import { IBestButton, IBestPopover, IBestPopoverAction, IBestPopoverController, IBestToast } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { LengthMetrics } from '@kit.ArkUI';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function PopoverBuilder(_: string, title: string){
	PopoverPage({title})
}

@Entry
@Component
struct PopoverPage {
    @State title: string = ''
    @State actions: IBestPopoverAction[] = [
        {
            text: '选项一'
        },
        {
            text: '选项二'
        },
        {
            text: '选项三'
        }
    ]
    @State textValue: string = ""

    @State actions1: IBestPopoverAction[] = [
        {
            text: '选项一'
        },
        {
            text: '选项二'
        }
    ]
    @State actions2: IBestPopoverAction[] = [
        {
            text: '选项一',
            iconName: 'add-o'
        },
        {
            text: '选项二',
            iconName: 'music-o'
        },
        {
            text: '选项三',
            icon: $r("app.media.app_icon")
        }
    ]
    @State actions3: IBestPopoverAction[] = [
        {
            text: '选项一',
            disabled: true
        },
        {
            text: '选项二',
            disabled: true
        },
        {
            text: '选项三',
        }
    ]
    @State actions4: IBestPopoverAction[] = [
        { text: '选项一' },
        { text: '选项二' },
        { text: '选项三' },
        { text: '选项四' },
        { text: '选项五' },
        { text: '选项六' },
        { text: '选项七' },
        { text: '选项八' },
        { text: '选项九' },
        { text: '选项十' }
    ]

    @Builder triggerBuilder(type: string, text?: string){
        if(type == "button"){
            IBestButton({
                type: "primary",
                text
            })
        }else if(type == "text"){
            Text(text)
        }else if(type == "img"){
            Image($r("app.media.app_icon")).width(30)
        }else if(type == "input"){
            TextInput({text: this.textValue, placeholder: text})
                .width(CONTAINER_SIZE.FULL)
                .onChange((text: string) => {
                    if(text){
                        this.actions = text.split("").map(e => {
                            let obj: IBestPopoverAction = {
                                text: "选项" + e
                            }
                            return obj
                        })
                    }else{
                        this.actions = [
                            {
                                text: '选项一'
                            },
                            {
                                text: '选项二'
                            },
                            {
                                text: '选项三'
                            }
                        ]
                    }
                })
        }
    }

    private controller: IBestPopoverController = new IBestPopoverController()
    @Builder popoverContent(){
        Column({space: SPACE.MD}){
            Row({space: SPACE.MD}){
                Image($r("app.media.app_icon")).width(18)
                Text("自定义提示内容")
            }
            IBestButton({
                type: "primary",
                buttonSize: "small",
                text: "确定",
                onBtnClick: () => {
                    this.controller.close()
                }
            })
        }
        .alignItems(HorizontalAlign.End)
        .padding(SPACE.MD)
    }

    build() {
		NavDestination() {
			CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }) {
                        Column({space: SPACE.MD}){
                            Row({space: SPACE.MD}){
                                IBestPopover({
                                    actions: this.actions,
                                    triggerBuilder: (): void => this.triggerBuilder("button", "基础用法"),
                                    onSelect: (action: IBestPopoverAction, index: number) => {
                                        IBestToast.show(action.text)
                                    }
                                })
                                IBestPopover({
                                    actions: this.actions,
                                    triggerBuilder: (): void => this.triggerBuilder("text", "文字触发")
                                })
                                IBestPopover({
                                    actions: this.actions,
                                    triggerBuilder: (): void => this.triggerBuilder("img")
                                })
                            }
                            IBestPopover({
                                actions: this.actions,
                                popoverWidth: CONTAINER_SIZE.FULL,
                                triggerBuilder: (): void => this.triggerBuilder("input", "输入框触发"),
                                onSelect: (action: IBestPopoverAction, index: number) => {
                                    this.textValue = action.text
                                }
                            })
                        }.width(CONTAINER_SIZE.FULL).alignItems(HorizontalAlign.Start)
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '弹出位置' }) {
                        Row({space: SPACE.MD}){
                            IBestPopover({
                                actions: this.actions1,
                                placement: Placement.Right,
                                triggerBuilder: (): void => this.triggerBuilder("button", "右侧")
                            })
                            IBestPopover({
                                actions: this.actions1,
                                placement: Placement.TopLeft,
                                triggerBuilder: (): void => this.triggerBuilder("button", "上左侧")
                            })
                            IBestPopover({
                                actions: this.actions1,
                                placement: Placement.TopRight,
                                triggerBuilder: (): void => this.triggerBuilder("button", "上右侧")
                            })
                            IBestPopover({
                                actions: this.actions1,
                                placement: Placement.Left,
                                triggerBuilder: (): void => this.triggerBuilder("button", "左侧")
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '选项配置' }) {
                        Row({space: SPACE.MD}){
                            IBestPopover({
                                actions: this.actions2,
                                triggerBuilder: (): void => this.triggerBuilder("button", "展示图标")
                            })
                            IBestPopover({
                                actions: this.actions3,
                                triggerBuilder: (): void => this.triggerBuilder("button", "选项禁用")
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义样式' }) {
                        Flex({wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(20), cross: LengthMetrics.vp(20)}}){
                            IBestPopover({
                                actions: this.actions,
                                showArrow: false,
                                triggerBuilder: (): void => this.triggerBuilder("button", "隐藏箭头")
                            })
                            IBestPopover({
                                actions: this.actions,
                                space: 12,
                                triggerBuilder: (): void => this.triggerBuilder("button", "间距")
                            })
                            IBestPopover({
                                actions: this.actions,
                                radius: 16,
                                triggerBuilder: (): void => this.triggerBuilder("button", "圆角")
                            })
                            IBestPopover({
                                actions: this.actions,
                                bgColor: '#4a4a4a',
                                textColor: '#fff',
                                dividerColor: "#646566",
                                triggerBuilder: (): void => this.triggerBuilder("button", "背景色")
                            })
                            IBestPopover({
                                actions: this.actions,
                                popoverWidth: 200,
                                triggerBuilder: (): void => this.triggerBuilder("button", "宽度")
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义内容' }) {
                        Row({space: SPACE.MD}){
                            IBestButton({
                                type: "primary",
                                text: "打开popover",
                                onBtnClick: () => {
                                    this.controller.open()
                                }
                            })
                            IBestPopover({
                                controller: this.controller,
                                actions: this.actions,
                                triggerBuilder: (): void => this.triggerBuilder("button", "自定义内容"),
                                popoverContentBuilder: (): void => this.popoverContent()
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义高度' }) {
                        Flex({wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(20), cross: LengthMetrics.vp(20)}}){
                            IBestPopover({
                                actions: this.actions4,
                                fixHeight: 200,
                                triggerBuilder: (): void => this.triggerBuilder("button", "固定高度")
                            })
                            IBestPopover({
                                actions: this.actions4,
                                maxHeight: 300,
                                scrollBarState: BarState.Off,
                                triggerBuilder: (): void => this.triggerBuilder("button", "最大高度")
                            })
                        }
                    }
                }
				ListItem().height(50)
            }
            .layoutWeight(1)
            .padding({ left: SPACE.SM, right: SPACE.SM })
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg)
    }
}