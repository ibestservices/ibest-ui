import router from '@ohos.router';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { IBestButton, IBestNavBar, IBestHighlight } from '@ibestservices/ibest-ui';
import { ComponentRouterParams } from '../../assets/global.type';

@Entry
@Component
struct HighlightPage {
  @State title: string = (router.getParams() as ComponentRouterParams).title || ''

  @Builder
  Arrow() {
    Image($r('app.media.title_back')).height(160).rotate({ angle: 180 })
  }

  @Builder
  Btn() {
    IBestButton({ text: '按钮', type: 'primary' }).margin({ top: SPACE.SM })
  }

  build() {
    Column() {
      IBestNavBar({
        title: this.title,
        isShowStatusBar: true,
        onLeftClick: () => {
          router.back()
        }
      })
      List() {
        ListItem() {
          ComponentShowContainer({ title: '基础用法' }) {
            IBestHighlight({
              keywords: '难题',
              sourceString: '慢慢来，不要急，生活给你出了难题，可也终有一天会给出答案。'
            })
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '多字符匹配' }) {
            IBestHighlight({
              keywords: ['难题', '终有一天', '答案'],
              sourceString: '慢慢来，不要急，生活给你出了难题，可也终有一天会给出答案。'
            })
          }
        }.margin({
          bottom: SPACE.SM
        })
      }
      .layoutWeight(1)
      .padding({
        left: SPACE.SM,
        right: SPACE.SM
      })
    }
    .width(CONTAINER_SIZE.FULL)
    .height(CONTAINER_SIZE.FULL)
    .backgroundColor(modeColor.bg)
  }
}