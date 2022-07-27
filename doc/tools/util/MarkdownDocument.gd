class_name MarkdownDocument

enum {
	H1 = 1,
	H2,
	H3,
	H4,
	H5,
	H6,
}

var text: String

func append_header(header: String, level: int = H1) -> void:
	if level < 1 or level > 6:
		push_error("Invalid Markdown header level")
		return
	break_line()
	text += "%s %s\n" % ["#".repeat(level),  header]
	break_line()

func append_paragraph(paragraph: String) -> void:
	text += paragraph
	break_line()

func appened_quote(quote: MarkdownDocument) -> void:
	text += "> %s" % quote.text.replace("\n", "\n> ")

func append_list(list: List) -> void:
	text += list.to_string()
	break_line()

func append_fenced_block(code: String, highlighting: String = "") -> void:
	text += "```%s\n%s```" % [highlighting, code]
	break_line()

func append_table(table: Table) -> void:
	text += table.to_string()
	break_line()

func horizontal_rule() -> void:
	text += "_".repeat(16) + "\n"
	break_line()

func break_line() -> void:
	text += "  \n"

func save(path: String) -> void:
	var file := File.new()
	if file.open(path, File.WRITE) == OK:
		file.store_string(text)
	else:
		printerr('Failed opening file path "%s"' % path)

static func anchor(name: String) -> String:
	return '<a name="%s"></a>' % name

static func escape_md(string: String) -> String:
	return   string.replace("\\", "\\\\")\
			.replace("_", "\\_")\
			.replace("|", "\\|")\
			.replace("*", "\\*")\
			.replace("`", "\\`")\
			.replace("{", "\\{")\
			.replace("}", "\\}")\
			.replace("[", "\\[")\
			.replace("]", "\\]")\
			.replace("<", "\\<")\
			.replace(">", "\\>")\
			.replace("(", "\\(")\
			.replace(")", "\\)")\
			.replace("#", "\\#")\
			.replace("+", "\\+")\
			.replace("-", "\\-")\
			.replace(".", "\\.")\
			.replace("!", "\\!")

class List:
	var items: Array
	var indent_size: int
	var ordered: bool

	func _init(_ordered: bool) -> void:
		ordered = _ordered

	func create_item(text: String) -> ListItem:
		var item := ListItem.new(text, indent_size)
		items.append(item)
		return item

	func _to_string() -> String:
		var text: String = ""
		for i in items.size():
			var item: ListItem = items[i]
			text += "\t".repeat(indent_size) + ("%d. " % (i + 1) if ordered else "- ") + item.to_string()
			text += "\n"
		return text

class ListItem:
	var text: String
	var indent_size: int

	func _init(_text: String, _indent_size: int) -> void:
		text = _text
		text += "  \n"

	func append_paragraph(paragraph: String) -> void:
		text += "  \n"
		text += paragraph.indent("\t".repeat(indent_size + 1))

	func appened_quote(quote: MarkdownDocument) -> void:
		text += "  \n"
		text += "> %s\n" % quote.text.replace("\n", "\n> ")
		text = text.indent("\t".repeat(indent_size))

	func append_list(list: List) -> void:
		text += "  \n"
		list.indent_size = indent_size + 1
		text += list.to_string()

	func append_table(table: Table) -> void:
		text += "  \n"
		text += table.to_string()
		text = text.indent("\t".repeat(indent_size + 1))
		text += "  \n"

	func horizontal_rule() -> void:
		text += "  \n"
		text += "_".repeat(16) + "\n"

	func _to_string() -> String:
		return text

class Table:
	var data: Array = [[]]

	func resize(rows: int, columns: int) -> void:
		if rows > rows_size():
			for i in rows - rows_size():
				var column := PackedStringArray()
				column.resize(columns)
				data.append(column)
		else:
			data.resize(rows)

		for i in data.size():
			var row: PackedStringArray = data[i]
			row.resize(columns)
			data[i] = row

	func put(string: String, row: int, column: int) -> void:
		if row >= rows_size():
			resize(row + 1, columns_size())
		if column >= columns_size():
			resize(rows_size(), column + 1)
		data[row][column] = string

	func retrieve(row: int, column: int) -> String:
		return data[row][column]

	func rows_size() -> int:
		return data.size()

	func columns_size() -> int:
		return data[0].size() if rows_size() > 0 else 0

	func get_row(row: int) -> PackedStringArray:
		return data[row]

	func get_column(column: int) -> PackedStringArray:
		var values := PackedStringArray()
		for row in data:
			values.append(row[column])
		return values

	func _generate_seperator(column_widths: PackedInt32Array) -> String:
		var seperator: String = "|"
		for width in column_widths:
			seperator += "-".repeat(width + 2) + "|"
		return seperator

	func _to_string() -> String:
		var column_widths := PackedInt32Array()

		for i in columns_size():
			var size: int = 0
			for text in get_column(i):
				if text.length() > size:
					size = text.length()
			column_widths.append(size)

		var lines := PackedStringArray()
		for i in rows_size():
			var row := PackedStringArray()
			for j in columns_size():
				var column_width: int = column_widths[j]
				var text: String = retrieve(i, j)
				if text.length() < column_width:
					text += " ".repeat(column_width - text.length())
				row.append(text)
			lines.append("| %s |" % " | ".join(row))
			if i == 0:
				lines.append(_generate_seperator(column_widths))

		return "\n".join(lines)
