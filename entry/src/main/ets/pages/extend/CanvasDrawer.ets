import {
    IBestButton,
    IBestCanvasContent,
    IBestCanvasDrawer,
	IBestCell,
	IBestToast,
	IBestUploader,
    IBestUploaderFile
} from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';
import RouterUtil from '../../utils/routerUtil';
import { savePixelMap, shareImage } from '../../utils/utils';
import { common } from '@kit.AbilityKit';

@Builder
export function CanvasDrawerBuilder(_: string, title: string){
	CanvasDrawerPage({title})
}

@Entry
@Component
struct CanvasDrawerPage {
	@State title: string = ''
	@State canvasWidth: number = 360
	@State canvasHeight: number = 200
	@State contentList: IBestCanvasContent[] = [
		{ type: "text", text: $r("app.string.app_name"), left: 20, top: 10 },
		{ type: "text", text: "今人不见古时月", left: 120, top: 10 },
		{ type: "image", url: "https://res1.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/800_800_6DEFA8E52CD749385860692A24DA15B9.png", width: 100, height: 100, left: 20, top: 50 },
		{ type: "image", url: $r("app.media.app_icon"), width: 50, height: 50, left: 170, top: 50 }
	]
	@State contentList1: IBestCanvasContent[] = [
		{ type: "image", url: "https://img1.baidu.com/it/u=3367326055,3107318562&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500", width: 100, height: 100, left: 20, top: 20, borderRadius: 50 },
		{ type: "image", url: "https://img1.baidu.com/it/u=1371594408,1235079511&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=539", right: 50, top: 30, width: 112, height: 120, deg: 45, borderRadius: 20 }
	]
	@State contentList2: IBestCanvasContent[] = []
	@State contentList3: IBestCanvasContent[] = [
		{ type: "text", text: $r("app.string.app_name"), fontSize: 20, left: 20, top: 10 },
		{ type: "text", text: "IBest-UI", fontColor: "red", left: 120, top: 10 },
		{ type: "text", text: "今人不见古时月, 今月曾经照古人", textDecoration: "underline", width: 150, maxLineNumber: 2, left: 20, top:40 },
		{ type: "text", text: "今人不见古时月, 今月曾经照古人", textDecoration: "lineThrough", lineHeight: 24, width: 150, maxLineNumber: 2, textAlign: "center", left: 20, top: 90 },
		{ type: "text", text: "今人不见古时月, 今月曾经照古人", fontWeight: "bold", width: 150, maxLineNumber: 2, textAlign: "right", right: 20, top: 130 }
	]
	@State canvasShow: boolean = false
	@State pixelMap: PixelMap | null = null
	@State canvasShow1: boolean = false
	@State pixelMap1: PixelMap | null = null
	@State canvasShow2: boolean = false
	@State pixelMap2: PixelMap | null = null
	@State canvasShow3: boolean = false
	@State pixelMap3: PixelMap | null = null
	@State canvasShow4: boolean = false
	@State pixelMap4: PixelMap | null = null
	@State canvasShow5: boolean = false
	@State imgList: IBestUploaderFile[] = []
	@State pixelMap5: PixelMap | null = null
	@State canvasShow6: boolean = false
	@State pixelMap6: PixelMap | null = null

	private context = getContext(this) as common.UIAbilityContext;

	aboutToAppear() {
		this.canvasShow = true
		this.canvasShow1 = true
		this.canvasShow2 = true
		this.canvasShow3 = true
		this.canvasShow4 = true
		this.canvasShow6 = true
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
						Column({space: SPACE.SM}){
							Image(this.pixelMap)
								.width(this.canvasWidth)
								.height(160)
							if(this.pixelMap){
								Row({space: SPACE.XS}){
									SaveButton({
										text: SaveDescription.SAVE_IMAGE,
										buttonType: ButtonType.Capsule
									}).onClick((event: ClickEvent, result: SaveButtonOnClickResult) => {
										if (result == SaveButtonOnClickResult.SUCCESS) {
											this.saveImg(this.pixelMap)
										}
									})
									IBestButton({
										text: "分享",
										btnWidth: 100,
										btnHeight: 40,
										round: true,
										onBtnClick: () => {
											shareImage(this.context, this.pixelMap!)
										}
									})
								}
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义背景' }) {
						Column({space: SPACE.XS}){
							Image(this.pixelMap1)
								.width(this.canvasWidth)
								.height(100)
							Image(this.pixelMap2)
								.width(this.canvasWidth)
								.height(100)
							Image(this.pixelMap3)
								.width(this.canvasWidth)
								.height(100)
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '图片样式' }) {
						Column({space: SPACE.XS}){
							Image(this.pixelMap4)
								.width(this.canvasWidth)
								.height(this.canvasHeight)
							if(this.pixelMap5){
								Image(this.pixelMap5)
									.width(this.canvasWidth)
									.height(this.canvasHeight)
							}
							if(!this.imgList.length){
								Row(){
									IBestUploader({
										fileList: $imgList,
										max: 1,
										onChange: (fileList: IBestUploaderFile[]) => {
											this.contentList2 = [
												{type: "image", url: fileList[0].previewUri, width: 100, height: 120, left: 20, top: 20},
												{type: "text", text: $r("app.string.app_name"), left: 70, top: 80, fontColor: "#ed4040"}
											]
											this.canvasShow5 = true
										}
									})
								}.padding(SPACE.XS).backgroundColor(modeColor.bg2)
							}else{
								IBestButton({
									text: "重选",
									type: "primary",
									onBtnClick: () => {
										this.imgList = []
										this.pixelMap5 = null
									}
								})
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '文字样式' }) {
						Image(this.pixelMap6)
							.width(this.canvasWidth)
							.height(this.canvasHeight)
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '制作海报' }) {
						IBestCell({
							title: '试一试',
							isLink: true,
							onCellClick: () => {
								RouterUtil.push("MakePoster")
							}
						})
					}
				}
				ListItem().height(50)
			}
			.layoutWeight(1)
			.padding({ left: SPACE.SM, right: SPACE.SM })
			if(this.canvasShow){
				IBestCanvasDrawer({
					canvasWidth: this.canvasWidth,
					canvasHeight: 160,
					contentList: this.contentList,
					onDrawFinish: pixelMap => {
						this.pixelMap = pixelMap
						this.canvasShow = false
					}
				})
			}
			if(this.canvasShow1){
				IBestCanvasDrawer({
					canvasWidth: this.canvasWidth,
					canvasHeight: 100,
					canvasBgColor: modeColor.primaryColor,
					onDrawFinish: pixelMap => {
						this.pixelMap1 = pixelMap
						this.canvasShow1 = false
					}
				})
			}
			if(this.canvasShow2){
				IBestCanvasDrawer({
					canvasWidth: this.canvasWidth,
					canvasHeight: 100,
					canvasBgImg: "https://img0.baidu.com/it/u=295003109,130135700&fm=253&fmt=auto&app=120&f=JPEG?w=1422&h=800",
					onDrawFinish: pixelMap => {
						this.pixelMap2 = pixelMap
						this.canvasShow2 = false
					}
				})
			}
			if(this.canvasShow3){
				IBestCanvasDrawer({
					canvasWidth: this.canvasWidth,
					canvasHeight: 100,
					linerGradient: {
						angle: 128,
						colors: [["rgba(69,123,180,1)", 0], ["rgba(152,174,199,1)", 0.7]]
					},
					onDrawFinish: pixelMap => {
						this.pixelMap3 = pixelMap
						this.canvasShow3 = false
					}
				})
			}
			if(this.canvasShow4){
				IBestCanvasDrawer({
					canvasWidth: this.canvasWidth,
					canvasHeight: this.canvasHeight,
					contentList: this.contentList1,
					onDrawFinish: pixelMap => {
						this.pixelMap4 = pixelMap
						this.canvasShow4 = false
					}
				})
			}
			if(this.canvasShow5){
				IBestCanvasDrawer({
					canvasWidth: this.canvasWidth,
					canvasHeight: this.canvasHeight,
					contentList: this.contentList2,
					onDrawFinish: pixelMap => {
						this.pixelMap5 = pixelMap
						this.canvasShow5 = false
					}
				})
			}
			if(this.canvasShow6){
				IBestCanvasDrawer({
					canvasWidth: this.canvasWidth,
					canvasHeight: this.canvasHeight,
					contentList: this.contentList3,
					onDrawFinish: pixelMap => {
						this.pixelMap6 = pixelMap
						this.canvasShow6 = false
					}
				})
			}
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}