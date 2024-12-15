interface IBestButtonColorType {
    textColor: ResourceColor
    whiteColor: ResourceColor
}

export const IBestButtonColor: IBestButtonColorType = {
    textColor: $r("app.color.ibest_text_color"),
    whiteColor: $r("app.color.ibest_white")
}