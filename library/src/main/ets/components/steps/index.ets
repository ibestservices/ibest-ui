

@Component
export struct IBestSteps{
	/**
	 * 当前激活的步骤索引
     */
	@Link active: number
	/**
	 * 步骤条方向
     */
	@Prop placeDirection: Axis = Axis.Vertical
	build() {

	}
}