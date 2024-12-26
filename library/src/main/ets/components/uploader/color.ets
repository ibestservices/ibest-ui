interface IBestUploaderColorType {
    uploaderBgColor: ResourceColor
    uploaderIconColor: ResourceColor
    fileBgColor: ResourceColor
    textColor: ResourceColor
    activeBg: ResourceColor
    maskTextColor: ResourceColor
}

export const IBestUploaderColor: IBestUploaderColorType = {
    uploaderBgColor: $r("app.color.ibest_uploader_background"),
    uploaderIconColor: $r("app.color.ibest_uploader_icon_color"),
    fileBgColor: $r("app.color.ibest_file_background"),
    textColor: $r("app.color.ibest_text_color"),
    activeBg: $r("app.color.ibest_active_color"),
    maskTextColor: $r("app.color.ibest_white")
}