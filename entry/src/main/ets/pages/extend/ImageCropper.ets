import {
	IBestButton,
	IBestDialogUtil,
	IBestImageCropper,
	IBestImageCropperController,
	IBestSlider,
	IBestSwitch,
	IBestToast,
	IBestUploader,
	IBestUploaderFile
} from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';
import { savePixelMap, shareImage } from '../../utils/utils';
import { common } from '@kit.AbilityKit';
@Builder
export function ImageCropperBuilder(_: string, title: string){
	ImageCropperPage({title})
}

@Entry
@Component
struct ImageCropperPage {
	@State title: string = ''
	@State imgList: IBestUploaderFile[] = []
	@State initImg: string = ""
	private controller: IBestImageCropperController = new IBestImageCropperController()

	@State initImg1: string = "https://img0.baidu.com/it/u=3217812679,2585737758&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500"
	private controller1: IBestImageCropperController = new IBestImageCropperController()

	@State initImg2: string = "https://img1.baidu.com/it/u=404530833,1472694862&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=800"
	@State curScale: number = 1
	@State enableRotate: boolean = false
	@State curAngle: number = 0
	private controller2: IBestImageCropperController = new IBestImageCropperController()

	@State initImg3: ResourceStr = $r("app.media.01")
	private controller3: IBestImageCropperController = new IBestImageCropperController()

	@State previewUrl: PixelMap | null = null
	private context = this.getUIContext().getHostContext() as common.UIAbilityContext

	@Builder imgBuilder() {
		Column({space: SPACE.MD}) {
			Image(this.previewUrl)
				.width(260)
			Row({space: SPACE.MD}){
				SaveButton({ text: SaveDescription.SAVE_IMAGE })
					.onClick((event: ClickEvent, result: SaveButtonOnClickResult) => {
						if (result == SaveButtonOnClickResult.SUCCESS) {
							this.saveImg(this.previewUrl)
						}
					})
				IBestButton({
					text: "分享",
					btnWidth: 100,
					btnHeight: 40,
					round: true,
					onBtnClick: () => {
						shareImage(this.context, this.previewUrl!)
					}
				})
			}
		}
		.padding(SPACE.MD)
	}
	showResult() {
		IBestDialogUtil.open({
			title: "截取结果",
			defaultBuilder: (): void => this.imgBuilder()
		})
	}
	async saveImg(pixelMap: PixelMap | null){
		if(pixelMap){
			await savePixelMap(this.context, pixelMap)
			IBestToast.show({ message: `截图保存成功` })
		}
	}
	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }) {
						Column({ space: 20 }) {
							IBestUploader({
								fileList: $imgList,
								max: 1,
								onChange: (fileList: IBestUploaderFile[]) => {
									this.initImg = fileList[0].previewUri || ""
								}
							})
							IBestImageCropper({
								componentHeight: 300,
								url: this.initImg,
								controller: this.controller
							})
							Row({space: SPACE.XS}){
								IBestButton({
									text: "重选",
									onBtnClick: () => {
										this.imgList = []
									}
								})
								IBestButton({
									type: "primary",
									text: "获取结果",
									onBtnClick: () => {
										this.controller.getResult().then(res => {
											this.previewUrl = res
											this.showResult()
										})
									}
								})
							}.visibility(this.imgList.length ? Visibility.Visible : Visibility.None)
						}.padding(SPACE.XS).backgroundColor(modeColor.bg2)
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '在线图片', space: SPACE.MD }) {
						IBestImageCropper({
							componentHeight: 300,
							url: this.initImg1,
							controller: this.controller1
						})
						IBestButton({
							type: "primary",
							text: "获取结果",
							onBtnClick: () => {
								this.controller1.getResult(res => {
									this.previewUrl = res
									this.showResult()
								})
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '其他操作', space: SPACE.MD }) {
						IBestImageCropper({
							componentHeight: 500,
							url: this.initImg2,
							centerWidth: 260,
							centerHeight: 260,
							maxScale: 3,
							enableRotate: this.enableRotate,
							maxAngle: 45,
							controller: this.controller2
						})
						Row({ space: 14 }){
							Text("缩放比例")
							Row(){
								IBestSlider({
									value: $curScale,
									min: 1,
									max: 3,
									step: 0.01,
									onTouchMove: (value) => {
										this.controller2.setScale(value as number)
									},
									onChange: (value) => {
										this.controller2.setScale(value as number)
									}
								})
							}.layoutWeight(1)
						}
						Row({ space: 14 }){
							Text("开启旋转")
							IBestSwitch({
								value: $enableRotate,
								onChange: () => {
									this.curAngle = 0
								}
							})
						}.width("100%")
						Row({ space: 14 }){
							Text("旋转角度")
							Row() {
								IBestSlider({
									value: $curAngle,
									min: -45,
									max: 45,
									step: 1,
									onTouchMove: (value) => {
										this.controller2.setAngle(value as number)
									}
								})
							}.layoutWeight(1)
						}
						.visibility(this.enableRotate ? Visibility.Visible : Visibility.None)
						IBestButton({
							type: "primary",
							text: "获取结果",
							onBtnClick: () => {
								this.controller2.getResult(res => {
									this.previewUrl = res
									this.showResult()
								})
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义样式', space: SPACE.MD }) {
						IBestImageCropper({
							componentHeight: 500,
							url: this.initImg3,
							controller: this.controller3,
							shape: 'circle',
							centerWidth: 260
						})
						IBestButton({
							type: "primary",
							text: "获取结果",
							onBtnClick: async () => {
								this.previewUrl = await this.controller3.getResult()
								this.showResult()
							}
						})
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