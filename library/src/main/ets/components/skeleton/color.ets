interface IBestSkeletonColorType {
	bgColor: ResourceColor
	bgDarkerColor: ResourceColor
}

export const IBestSkeletonColor: IBestSkeletonColorType = {
	bgColor: $r("app.color.ibest_skeleton_bg_color"),
	bgDarkerColor: $r("app.color.ibest_skeleton_bg_color_darker")
}