import { IBestDropdownMenu, IBestDropdownItem, IBestDropdownMenuOption, IBestToast,
    IBestCell,
    IBestSwitch,
    IBestDropdownMenuController,
    IBestButton} from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function DropdownMenuBuilder(_: string, title: string){
    DropdownMenuPage({title})
}

@Entry
@Component
struct DropdownMenuPage{
    @State title: string = ''
    groupId: string = 'dropdown_menu'
    @State value: number = 1
    @State options: IBestDropdownMenuOption[] = [
        { text: '全部商品', value: 1 },
        { text: '新款商品', value: 2 },
        { text: '活动商品', value: 3 }
    ]
    @State value1: string = ''
    @State options1: IBestDropdownMenuOption[] = [
        { text: '默认排序', value: '' },
        { text: '好评排序', value: 'a' },
        { text: '销量排序', value: 'b' }
    ]

    groupId1: string = 'dropdown_menu_1'
    @State switchValue: boolean = true
    @State switchValue1: boolean = true

    groupId2: string = 'dropdown_menu_2'
    groupId3: string = 'dropdown_menu_3'
    groupId4: string = 'dropdown_menu_4'
    groupId5: string = 'dropdown_menu_5'
    @State value2: string = ''
    @State value3: string = ''
    @State options2: IBestDropdownMenuOption[] = [
        { text: '全部商品', icon: "star", value: '1' },
        { text: '新款商品', icon: "fire", value: '2' },
        { text: '活动商品', icon: "gem", value: '3', disabled: true }
    ]
    @State options3: IBestDropdownMenuOption[] = [
        { text: '默认排序', value: '' },
        { text: '好评排序', value: 'a' },
        { text: '销量排序', value: 'b' }
    ]
    @State options4: IBestDropdownMenuOption[] = []
    @State options5: IBestDropdownMenuOption[] = []
    private controller: IBestDropdownMenuController = new IBestDropdownMenuController()

    @Builder switchBuilder(){
        IBestSwitch({
            value: $switchValue
        })
    }
    @Builder switchBuilder1(){
        IBestSwitch({
            value: $switchValue1
        })
    }

    build() {
        NavDestination() {
            CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.MD }){
                        IBestDropdownMenu({ groupId: this.groupId }){
                            IBestDropdownItem({
                                groupId: this.groupId,
                                value: this.value,
                                options: this.options,
                                onChange: value => {
                                    this.value = value as number
                                    IBestToast.show("选项为：" + value)
                                }
                            })
                            IBestDropdownItem({
                                groupId: this.groupId,
                                value: this.value1,
                                options: this.options1,
                                onChange: value => {
                                    this.value1 = value as string
                                    IBestToast.show("选项为：" + value)
                                }
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义菜单内容', titlePaddingLeft: SPACE.MD }){
                        IBestDropdownMenu({ groupId: this.groupId1, controller: this.controller }){
                            IBestDropdownItem({
                                groupId: this.groupId1,
                                value: this.value,
                                options: this.options,
                                onChange: value => {
                                    this.value = value as number
                                }
                            })
                            IBestDropdownItem({
                                groupId: this.groupId1,
                                title: "筛选"
                            }){
                                IBestCell({
                                    title: "轻量",
                                    center: true,
                                    rightIconBuilder: (): void => this.switchBuilder()
                                })
                                IBestCell({
                                    title: "简单",
                                    center: true,
                                    rightIconBuilder: (): void => this.switchBuilder1()
                                })
                                Row(){
                                    IBestButton({
                                        type: "primary",
                                        text: "确定",
                                        btnWidth: "100%",
                                        btnHeight: 50,
                                        round: true,
                                        onBtnClick: () => {
                                            this.controller.close()
                                        }
                                    })
                                }.padding({top: 5, bottom: 5, left: 10, right: 10})
                            }
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义样式', titlePaddingLeft: SPACE.MD }){
                        IBestDropdownMenu({
                            groupId: this.groupId2,
                            activeColor: "#ee0a24",
                            radius: 8,
                            menuHeight: 36,
                            menuFontSize: 12,
                            menuShadow: { color: 'rgba(100, 101, 102, 0.2)', radius: 12, offsetY: 2 },
                            menuIcon: $r("app.media.icon_arrow_down_full")
                        }){
                            IBestDropdownItem({
                                groupId: this.groupId2,
                                value: this.value,
                                options: this.options2,
                                onChange: value => {
                                    this.value = value as number
                                }
                            })
                            IBestDropdownItem({
                                groupId: this.groupId2,
                                value: this.value1,
                                options: this.options3,
                                onChange: value => {
                                    this.value1 = value as string
                                }
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '横向滚动', titlePaddingLeft: SPACE.MD }){
                        IBestDropdownMenu({ groupId: this.groupId3, menuWidthType: "auto" }){
                            IBestDropdownItem({
                                groupId: this.groupId3,
                                value: this.value,
                                options: this.options,
                                onChange: value => {
                                    this.value = value as number
                                    IBestToast.show("选项为：" + value)
                                }
                            })
                            IBestDropdownItem({
                                groupId: this.groupId3,
                                value: this.value1,
                                options: this.options1,
                                onChange: value => {
                                    this.value1 = value as string
                                    IBestToast.show("选项为：" + value)
                                }
                            })
                            IBestDropdownItem({
                                groupId: this.groupId3,
                                value: this.value1,
                                options: this.options1,
                                onChange: value => {
                                    this.value1 = value as string
                                    IBestToast.show("选项为：" + value)
                                }
                            })
                            IBestDropdownItem({
                                groupId: this.groupId3,
                                value: this.value1,
                                options: this.options1,
                                onChange: value => {
                                    this.value1 = value as string
                                    IBestToast.show("选项为：" + value)
                                }
                            })
                            IBestDropdownItem({
                                groupId: this.groupId3,
                                value: this.value1,
                                options: this.options1,
                                onChange: value => {
                                    this.value1 = value as string
                                    IBestToast.show("选项为：" + value)
                                }
                            })
                            IBestDropdownItem({
                                groupId: this.groupId3,
                                value: this.value1,
                                options: this.options1,
                                onChange: value => {
                                    this.value1 = value as string
                                    IBestToast.show("选项为：" + value)
                                }
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '异步选项', titlePaddingLeft: SPACE.MD }){
                        IBestDropdownMenu({ groupId: this.groupId4 }){
                            IBestDropdownItem({
                                groupId: this.groupId4,
                                title: "商品",
                                value: this.value2,
                                options: this.options4,
                                onOpen: () => {
                                    setTimeout(() => {
                                        this.options4 = [
                                            { text: '打折商品', value: '1' },
                                            { text: '新款商品', value: '2' },
                                            { text: '活动商品', value: '3' }
                                        ]
                                    }, 1500)
                                },
                                onChange: value => {
                                    this.value2 = value as string
                                }
                            })
                            IBestDropdownItem({
                                groupId: this.groupId4,
                                title: "排序",
                                value: this.value3,
                                options: this.options5,
                                onOpen: () => {
                                    setTimeout(() => {
                                        this.options5 = [
                                            { text: '默认排序', value: 'a' },
                                            { text: '好评排序', value: 'b' },
                                            { text: '销量排序', value: 'c' },
                                        ]
                                    }, 1500)
                                },
                                onChange: value => {
                                    this.value3 = value as string
                                }
                            })
                        }
                        Row(){
                            IBestButton({
                                type: 'primary',
                                text: '重置',
                                onBtnClick: () => {
                                    this.value2 = ''
                                    this.value3 = ''
                                }
                            })
                        }.width(CONTAINER_SIZE.FULL).justifyContent(FlexAlign.Center).margin({top: SPACE.MD})
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '禁用菜单', titlePaddingLeft: SPACE.MD }){
                        IBestDropdownMenu({ groupId: this.groupId5 }){
                            IBestDropdownItem({
                                groupId: this.groupId5,
                                value: this.value,
                                options: this.options,
                                disabled: true
                            })
                            IBestDropdownItem({
                                groupId: this.groupId5,
                                value: this.value1,
                                options: this.options1,
                                disabled: true
                            })
                        }
                    }
                }
            }
            .layoutWeight(1)
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg)
    }
}