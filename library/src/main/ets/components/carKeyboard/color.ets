interface IBestNumberKeyboardColorType {
    bg: ResourceColor
    keyBg: ResourceColor
    textColor: ResourceColor
    activeBg: ResourceColor
    white: ResourceColor
}

export const IBestNumberKeyboardColor: IBestNumberKeyboardColorType = {
    bg: $r("app.color.ibest_number_keyboard_background"),
    keyBg: $r("app.color.ibest_number_keyboard_key_background"),
    textColor: $r("app.color.ibest_text_color"),
    activeBg: $r("app.color.ibest_number_keyboard_key_active_color"),
    white: $r("app.color.ibest_white")
}