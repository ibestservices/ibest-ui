@Component
export default struct customContent {
	@BuilderParam customBuilder?: () => void
	build() {
		if(this.customBuilder){
			this.customBuilder()
		}
	}
}