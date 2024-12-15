interface IBestUploaderColorType {
    textColor: ResourceColor
    activeBg: ResourceColor
}

export const IBestUploaderColor: IBestUploaderColorType = {
    textColor: $r("app.color.ibest_text_color"),
    activeBg: $r("app.color.ibest_active_color")
}