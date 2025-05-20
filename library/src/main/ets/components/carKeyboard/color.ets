interface IBestCarKeyboardColorType {
    bg: ResourceColor
    keyBg: ResourceColor
    textColor: ResourceColor
    activeBg: ResourceColor
}

export const IBestCarKeyboardColor: IBestCarKeyboardColorType = {
    bg: $r("app.color.ibest_car_keyboard_background"),
    keyBg: $r("app.color.ibest_car_keyboard_key_background"),
    textColor: $r("app.color.ibest_text_color"),
    activeBg: $r("app.color.ibest_car_keyboard_key_active_color")
}