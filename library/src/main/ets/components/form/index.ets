
@Component
export struct IBestForm {
	@Prop space: number = 20
	@BuilderParam defaultBuilder: () => void
	aboutToAppear(): void {
		// console.log('aboutToAppear', JSON.stringify(this.rules))
	}
	build() {
		Column({ space: this.space + 'lpx' }){
			this.defaultBuilder()
		}
		.alignItems(HorizontalAlign.Start)
	}
}