interface IBestCarInputColorType {
    textColor: ResourceColor
    borderColor: ResourceColor
    bg: ResourceColor
}

export const IBestCarInputColor: IBestCarInputColorType = {
    textColor: $r("app.color.ibest_car_input_text_color"),
    borderColor: $r("app.color.ibest_car_input_border_color"),
    bg: $r("app.color.ibest_car_input_background")
}