import { IBestAvatar, IBestAvatarGroup, IBestToast } from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function AvatarBuilder(_: string, title: string){
    AvatarPage({title})
}

@Entry
@Component
struct AvatarPage {
    @State title: string = ''
    @State avatar: string = 'https://img1.baidu.com/it/u=700838104,4078529388&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500'
    @State avatar1: string = 'https://img0.baidu.com/it/u=447148445,3812237851&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500'
    @State avatar2: string = 'https://img0.baidu.com/it/u=1596600438,2136408442&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500'
    @State avatar3: string = 'https://img0.baidu.com/it/u=2816983398,655618517&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500'
    @State avatar4: string = 'https://pics4.baidu.com/feed/1ad5ad6eddc451da34d4638413f67668d016325c.jpeg'
    @State avatar5: string = 'https://img0.baidu.com/it/u=2397297586,1192210697&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500'
    @State avatar6: string = 'https://img0.baidu.com/it/u=781626259,587761743&fm=253&fmt=auto&app=138&f=JPEG?w=300&h=300'
    @State avatar7: string = 'https://img0.baidu.com/it/u=3731477373,291511913&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500'
    @State errorAvatar: string = 'https://img1.baidu.com/it/u=700838104,4078529388'
    @State urls: string[] = [
        this.avatar,
        this.avatar1,
        this.avatar2,
        this.avatar3,
        this.avatar4,
        this.avatar5,
        this.avatar6,
        this.avatar7
    ]

    build() {
        NavDestination() {
            CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }){
                        IBestAvatar({
                            src: this.avatar,
                            onAvatarClick: () => {
                                IBestToast.show('点击了头像')
                            }
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '头像形状' }){
                        Row({space: SPACE.LG}){
                            IBestAvatar({
                                src: this.avatar1,
                                shape: 'circle'
                            })
                            IBestAvatar({
                                src: this.avatar2,
                                shape: 'square'
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '头像尺寸' }){
                        Row({space: SPACE.LG}){
                            IBestAvatar({
                                src: this.avatar3,
                                avatarSize: 30
                            })
                            IBestAvatar({
                                src: this.avatar4,
                                avatarSize: 40
                            })
                            IBestAvatar({
                                src: this.avatar5,
                                avatarSize: 50
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '图标头像' }){
                        Row({space: SPACE.LG}){
                            IBestAvatar({
                                icon: 'bill'
                            })
                            IBestAvatar({
                                icon: 'star'
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '文字头像' }){
                        Row({space: SPACE.LG}){
                            IBestAvatar({
                                text: "Z",
                                randomBgColor: true
                            })
                            IBestAvatar({
                                text: "张",
                                randomBgColor: true
                            })
                            IBestAvatar({
                                text: "郭",
                                randomBgColor: true
                            })
                            IBestAvatar({
                                text: "柴",
                                randomBgColor: true
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '显示徽标' }){
                        Row({space: SPACE.LG}){
                            IBestAvatar({
                                src: this.avatar,
                                badgeContent: 99
                            })
                            IBestAvatar({
                                src: this.avatar,
                                shape: 'square',
                                badgeIcon: "medal",
                                badgeIconColor: Color.Red,
                                badgePosition: "bottom-right"
                            })
                            IBestAvatar({
                                text: "张",
                                randomBgColor: true,
                                dot: true
                            })
                        }
                        .margin({top: SPACE.SM})
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '默认头像' }){
                        IBestAvatar({
                            src: this.errorAvatar
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '头像组' }){
                        Column({space: SPACE.MD}){
                            IBestAvatarGroup({
                                urls: this.urls,
                                onMoreClick: () => {
                                    IBestToast.show('点击了更多')
                                }
                            })
                            IBestAvatarGroup({
                                urls: this.urls,
                                shape: 'square',
                                gap: 0.3,
                                max: 7,
                                moreText: '更多',
                                onMoreClick: () => {
                                    IBestToast.show('点击了更多')
                                }
                            })
                        }
                        .alignItems(HorizontalAlign.Start)
                    }
                }
                ListItem().height(50)
            }
            .layoutWeight(1)
            .padding({ left: SPACE.SM, right: SPACE.SM })
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg2)
    }
}