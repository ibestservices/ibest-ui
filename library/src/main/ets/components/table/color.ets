interface IBestTableColorType {
	headerBgColor: Resource
	headerTextColor: Resource
	borderColor: Resource
	cellBgColor: Resource
	cellStripeColor: Resource
	cellTextColor: Resource
	footerBgColor: Resource
}

export const IBestTableColor: IBestTableColorType = {
	headerBgColor: $r("app.color.ibest_table_header_background"),
	headerTextColor: $r("app.color.ibest_table_header_text_color"),
	borderColor: $r("app.color.ibest_table_border_color"),
	cellBgColor: $r("app.color.ibest_table_cell_background"),
	cellStripeColor: $r("app.color.ibest_table_cell_stripe_color"),
	cellTextColor: $r("app.color.ibest_table_cell_text_color"),
	footerBgColor: $r("app.color.ibest_table_footer_background"),
}