import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { IbestIconData } from './config'
import { IbestIconDataType } from './index.type'
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { IBestLoading } from '../loading';

@Component
export struct IBestIcon {
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
  /**
   * 图标名称或图片链接
   */
  @Prop @Watch('nameChange') name: keyof IbestIconDataType | string = 'arrow'
  /**
   * 图标颜色
   */
  @Prop color: ResourceColor = ''
  /**
   * 图标大小，如 20px 20vp
   */
  @Prop iconSize: number | string = 20
  @State pixelMapImg: PixelMap | undefined = undefined
  @State loading: boolean = false

  aboutToAppear(): void {
    this.getImage()
  }

  nameChange(e: string) {
    this.getImage()
  }

  getImage() {
    if (this.isImage()) {
      this.requestImageUrl(this.name)
    }
  }

  isImage(): boolean {
    return this.name?.includes('/')
  }

  requestImageUrl(url: string) {
    this.loading = true
    http.createHttp().request(url, (error: BusinessError, data: http.HttpResponse) => {
      if (error) {
        console.error(`request image failed: url: ${url}, code: ${error.code}, message: ${error.message}`)
      } else {
        let imgData: ArrayBuffer = data.result as ArrayBuffer
        let imgSource: image.ImageSource = image.createImageSource(imgData)

        class sizeTmp {
          height: number = 100
          width: number = 100
        }

        let options: Record<string, number | boolean | sizeTmp> = {
          'alphaType': 0,
          'editable': false,
          'pixelFormat': 3,
          'scaleMode': 1,
          'size': { height: 100, width: 100 }
        }
        imgSource.createPixelMap(options).then((pixelMap: PixelMap) => {
          console.error('image createPixelMap success')
          this.pixelMapImg = pixelMap
          this.loading = false
        })
      }
    })
  }

  build() {
    Column() {
      if (this.isImage()) {
        if (this.loading) {
          IBestLoading({
            loadingIconType: "spinner",
          })
        } else {
          Image(this.pixelMapImg).width(this.iconSize).height(this.iconSize)
        }
      } else {
        Text(Object(IbestIconData)[this.name])
          .fontFamily('ibestFont')
          .fontColor(this.color)
          .fontSize(this.iconSize)
      }

    }
  }
}