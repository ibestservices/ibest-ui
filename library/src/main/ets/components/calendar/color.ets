interface IBestCalendarColorType {
    bgColor: ResourceColor
    disabledBg: ResourceColor
    textColor: ResourceColor
    textWhite: ResourceColor,
    markTextColor: ResourceColor
}

export const IBestCalendarColor: IBestCalendarColorType = {
    bgColor: $r("app.color.ibest_background_2"),
    disabledBg: $r("app.color.ibest_background"),
    textColor: $r("app.color.ibest_text_color"),
    textWhite: $r("app.color.ibest_white"),
    markTextColor: $r("app.color.ibest_calendar_month_mark_color")
}