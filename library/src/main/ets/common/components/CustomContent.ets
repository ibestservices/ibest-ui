@Component
export default struct customContent {
	@BuilderParam customBuilder: () => void
	build() {
		this.customBuilder()
	}
}