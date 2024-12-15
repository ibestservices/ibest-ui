interface IBestCalendarColorType {
    bgColor: ResourceColor
    textColor: ResourceColor
    textWhite: ResourceColor,
    markTextColor: ResourceColor
}

export const IBestCalendarColor: IBestCalendarColorType = {
    bgColor: $r("app.color.ibest_background_2"),
    textColor: $r("app.color.ibest_text_color"),
    textWhite: $r("app.color.ibest_white"),
    markTextColor: $r("app.color.ibest_calendar_month_mark_color")
}