tool
extends EditorScript

func _run() -> void:
	MarkdownGenerator.new().generate_markdown()

class MarkdownGenerator:
	const ReferenceCollector: Script = preload("./ReferenceCollector.gd").ReferenceCollector
	
	const GODOT_CLASS_DOC: String = "https://docs.godotengine.org/en/{version}/classes/class_{name}.html"
	
	var _classes: Dictionary
	var _sub_classes: Dictionary
	
	var collector = ReferenceCollector.new()
	
	var godot_docs_version: String
	var output: String = "res://doc/classes"
	
	func _init() -> void:
		var info: Dictionary = Engine.get_version_info()
		godot_docs_version = "%s.%s" % [info.major, info.minor]
	
	func generate_markdown(refresh_cache: bool = false) -> void:
		print("Generating Markdown files")
		
		var directory := Directory.new()
		
		if not directory.dir_exists(output):
			# warning-ignore:return_value_discarded
			directory.make_dir_recursive(output)
		
		var api_reference: Dictionary = collector.collect_api_reference(refresh_cache)
		var classes: Array = []
		
		for class_reference in api_reference["classes"]:
			if class_reference.get("hidden", false):
				continue
			var name: String = class_reference["name"]
			classes.append(class_reference)
			_classes[name] = class_reference
		
		for class_reference in classes:
			_get_sub_classes(class_reference, _sub_classes)
		
		for class_reference in classes:
			var name: String = class_reference["name"]
			var path: String = output.plus_file("class_%s.md" % name.to_lower())
			create_document(class_reference).save(path)
		print("Completed !")
	
	func create_document(class_reference: Dictionary) -> MarkdownDocument:
		var clazz_name: String = class_reference["name"]
		var description: String = class_reference["description"].strip_edges()
		var properties: Array = class_reference["members"]
		var methods: Array = class_reference["methods"]
		var signals: Array = class_reference["signals"]
		var constants: Array = class_reference["constants"]
		var sub_classes: Array = class_reference["sub_classes"]
		
		var parents: PoolStringArray = _get_class_parents(class_reference)
		var inheritors: Array = _get_class_inheritors(class_reference)
		# sort() method is only available in 3.5+ for Pool Arrays
		inheritors.sort()
		
		var formatted_parents := PoolStringArray()
		var formatted_inheritors := PoolStringArray()
		
		for parent in parents:
			formatted_parents.append(_get_type_link(parent))
		for inheritor in inheritors:
			formatted_inheritors.append(_get_type_link(inheritor))
		
		var skip_properties_description = true
		var skip_methods_description = true
		
		for method in class_reference["static_functions"]:
			method["is_static"] = true
			methods.append(method)
		
		var document := MarkdownDocument.new()
		document.append_header(clazz_name)
		
		document.append_paragraph("**Inherits:** " + formatted_parents.join(" < "))
		document.break_line()
		if inheritors.size() > 0:
			document.append_paragraph("**Inherited By:** " + formatted_inheritors.join(", "))
		
		# Description section
		if not description.empty():
			document.append_header("Description", MarkdownDocument.H2)
			document.append_paragraph(class_reference["description"])
		
		# Properties section
		if properties.size() > 0:
			var properties_table := MarkdownDocument.Table.new()
			properties_table.put("type", 0, 0)
			properties_table.put("name", 0, 1)
			for property in properties:
				var name: String = property["name"]
				var hidden: bool = property.get("hidden", false)
				var show: bool = property.get("show", false)
				if (name.begins_with("_") or hidden) and not show:
					continue
				var type: String = property["data_type"]
				var default_value = property["default_value"]
				
				var format: String = "[%s](#property-%s)"
				if property.get("deprecated", false):
					format = "~~[%s](#property-%s)~~"
				
				var index: int = properties_table.rows_size()
				properties_table.put(_get_type_link(type), index, 0)
				properties_table.put(
					format % [ 
					MarkdownDocument.escape_md(name),
					name.replace("_", "-")
				], index, 1)
				
				if default_value:
					properties_table.put(
						"`%s`" % _strigify_value(default_value),
						index, 2
					)
			
			if properties_table.columns_size() == 3:
				properties_table.put("default", 0, 2)
			if properties_table.rows_size() > 1:
				skip_properties_description = false
				document.append_header("Properties", MarkdownDocument.H2)
				document.append_table(properties_table)
		
		# Methods section
		if methods.size() > 0:
			var methods_table := MarkdownDocument.Table.new()
			methods_table.put("return type", 0, 0)
			methods_table.put("signature", 0, 1)
			for method in methods:
				var name: String = method["name"]
				if name == "_init":
					method["name"] = clazz_name
					method["return_type"] = clazz_name
				var hidden: bool = method.get("hidden", false)
				var show: bool = method.get("show", false)
				if (name.begins_with("_") or hidden) and not show:
					continue
				var return_type: String = method["return_type"]
				
				var signature: String = _get_method_signature(
						method,
						true, 
						method.get("is_static", false)
					)
				
				if method.get("deprecated", false):
					signature = "~~%s~~" % signature
				
				var index: int = methods_table.rows_size()
				methods_table.put(_get_type_link(return_type), index, 0)
				methods_table.put(signature, index, 1)
				
			if methods_table.rows_size() > 1:
				skip_methods_description = false
				document.append_header("Methods", MarkdownDocument.H2)
				document.append_table(methods_table)
		
		# Signals section
		if signals.size() > 0:
			document.append_header("Signals", MarkdownDocument.H2)
			var signals_list := MarkdownDocument.List.new(false)
			for _signal in signals:
				var name: String = _signal["name"]
				var hidden: bool = _signal.get("hidden", false)
				var show: bool = _signal.get("show", false)
				if (name.begins_with("_") or hidden) and not show:
					continue
				
				var format: String = "%s%s"
				if _signal.get("deprecated", false):
					format = "%s***deprecated*** %s"
				
				var item := signals_list.create_item(
					format % [
						MarkdownDocument.anchor("signal-" + name.replace("_", "-")),
						_get_signal_signature(_signal)
					]
				)
				item.append_paragraph(_get_description(_signal["description"], "signal"))
				
				if signals[-1] != _signal:
					item.horizontal_rule()
				
			document.append_list(signals_list)
		
		# Constants section
		if constants.size() > 0:
			document.append_header("Constants", MarkdownDocument.H2)
			var constants_list := MarkdownDocument.List.new(false)
			for constant in constants:
				var name: String = constant["name"]
				var hidden: bool = constant.get("hidden", false)
				var show: bool = constant.get("show", false)
				if (name.begins_with("_") or hidden) and not show:
					continue
				var type: String = constant["data_type"]
				var value = constant["value"]
				var item: MarkdownDocument.ListItem
				
				var format: String = "%s **%s**"
				if constant.get("deprecated", false):
					format = "%s ~~**%s**~~"
				
				if value is Dictionary:
					item = constants_list.create_item(
						format % [
							_get_type_link("Dictionary"),
							MarkdownDocument.escape_md(name)
						]
					)
					var entries := MarkdownDocument.List.new(false)
					for key in value:
						# warning-ignore:return_value_discarded
						entries.create_item("**%s** = %s" % [
							MarkdownDocument.escape_md(str(key)),
							_strigify_value(value[key])
						])
					item.append_list(entries)
				else:
					item = constants_list.create_item(
						"%s%s **%s** = %s" % [
							MarkdownDocument.anchor("constant-" + name.replace("_", "-")),
							_get_type_link(type),
							MarkdownDocument.escape_md(name),
							_strigify_value(value)
						]
					)
				
				item.append_paragraph(_get_description(constant["description"], "constant"))
				if constants[-1] != constant:
					item.horizontal_rule()
			document.append_list(constants_list)
		
		# Properties descriptions section
		if not skip_properties_description:
			document.append_header("Property Descriptions", MarkdownDocument.H2)
			var properties_list := MarkdownDocument.List.new(false)
			for property in properties:
				var name: String = property["name"]
				var hidden: bool = property.get("hidden", false)
				var show: bool = property.get("show", false)
				if (name.begins_with("_") or hidden) and not show:
					continue
				var type: String = property["data_type"]
				
				var format: String = "%s%s **%s**"
				if property.get("deprecated", false):
					format = "%s***deprecated*** %s **%s**"
				
				var item := properties_list.create_item(
					format % [
						MarkdownDocument.anchor("property-" + name.replace("_", "-")),
						_get_type_link(type),
						name
					]
				)
				
				var table := MarkdownDocument.Table.new()
				table.put("", 0, 0)
				table.put("method", 0, 1)
				var setter: String = property["setter"]
				var getter: String = property["getter"]
				var i: int = 1
				if not (setter.empty() or setter.begins_with("_")):
					table.put("*Setter*", i, 0)
					table.put("%s(value)" % MarkdownDocument.escape_md(setter), i, 1)
					i += 1
				if not (getter.empty() or getter.begins_with("_")):
					table.put("*Getter*", i, 0)
					table.put("%s()" % MarkdownDocument.escape_md(getter), i, 1)
					i += 1
				
				if i > 1:
					item.append_table(table)
				
				item.append_paragraph(_get_description(property["description"], "property"))
				if properties[-1] != property:
					item.horizontal_rule()
			document.append_list(properties_list)
		
		# Methods descriptions section
		if not skip_methods_description:
			document.append_header("Method Descriptions", MarkdownDocument.H2)
			var methods_list := MarkdownDocument.List.new(false)
			for method in methods:
				var name: String = method["name"]
				if name == "_init":
					method["name"] = clazz_name
					method["return_type"] = clazz_name
				var hidden: bool = method.get("hidden", false)
				var show: bool = method.get("show", false)
				if (name.begins_with("_") or hidden) and not show:
					continue
				
				var format: String = "%s%s %s"
				
				if method.get("deprecated", false):
					format = "%s***deprecated*** %s %s"
				
				var return_type: String = method["return_type"]
				var item := methods_list.create_item(
					format % [
						MarkdownDocument.anchor("method-" + name.replace("_", "-")),
						_get_type_link(return_type),
						_get_method_signature(
							method,
							false, 
							method.get("is_static", false)
						)
					]
				)
				item.append_paragraph(_get_description(method["description"], "method"))
				
				if methods[-1] != method:
					item.horizontal_rule()
				
			document.append_list(methods_list)
		
		if sub_classes.size() > 0:
			document.append_header("Sub Classes", MarkdownDocument.H2)
			for sub_class in class_reference["sub_classes"]:
				if sub_class.get("hidden", false):
					continue
				sub_class["is_sub_class"] = true
				document.horizontal_rule()
				document.text += create_document(sub_class).text
		
		return document

	func _get_class_parents(class_reference: Dictionary) -> PoolStringArray:
		var parents: PoolStringArray = class_reference["extends_class"]
		if parents.size() == 0:
			parents.append("Reference")
			parents.append("Object")
		else:
			var parent: String = parents[0]
			if parent == "Reference":
				parents.append("Object")
			elif parent != "Object":
				if ClassDB.class_exists(parent):
					parents.append(ClassDB.get_parent_class(parent))
				elif _classes.has(parent):
					parents.append_array(_get_class_parents(_classes[parent]))
				elif _sub_classes.has(parent):
					parents.append_array(_get_class_parents(_sub_classes[parent]))
			
		return parents
	
	func _get_class_inheritors(class_reference: Dictionary) -> PoolStringArray:
		var name: String = class_reference["name"]
		var inheritors := PoolStringArray()
		for _class in _classes.values():
			var extends_class: PoolStringArray = _class["extends_class"]
			if extends_class.size() > 0 and extends_class[0] == name:
				inheritors.append(_class["name"])
		for _class in _sub_classes.values():
			var extends_class: PoolStringArray = _class["extends_class"]
			if extends_class.size() > 0 and extends_class[0] == name:
				inheritors.append(_class["name"])
		return inheritors
	
	func _get_sub_classes(class_reference: Dictionary, _sub_classes: Dictionary = {}) -> void:
		var sub_path: String = class_reference.get("sub_path", class_reference["name"])
		var origin: String = class_reference.get("origin", class_reference["name"])
		class_reference["sub_path"] = sub_path
		for sub_class in class_reference["sub_classes"]:
			if sub_class.get("hidden", false):
				continue
			var name: String = sub_class["name"]
			sub_class["origin"] = origin
			sub_class["sub_path"] = sub_path + "." + name
			_sub_classes[name] = sub_class
			_get_sub_classes(sub_class, _sub_classes)
	
	func _get_description(description: String, of: String) -> String:
		description = description.strip_edges()
		return "> *There is currently no description for this %s.*" % of\
			if description.empty()\
			else description
		
	
	func _get_type_link(type: String) -> String:
		var local: bool = _sub_classes.has(type)
		match type:
			"null":
				return "void"
			"var":
				type = "Variant"
		var link: String
		
		var path: String
		if _classes.has(type):
			path = _classes.get("path", "")
		
		var builtin: bool = _is_builtin_type(type)
		var internal: bool = _classes.has(type) or _sub_classes.has(type)
		
		if not (builtin or internal):
			link = type
		elif local:
			link = "[%s](%s)" % [
				_sub_classes[type]["sub_path"],
				"./class_%s.md#%s" % [_sub_classes[type]["origin"].to_lower(), type.to_lower()]
			]
		else:
			link = "[%s](%s)" % [
				type,
				GODOT_CLASS_DOC.format({
					version = godot_docs_version,
					name = type.to_lower()
				}) if builtin else "./class_%s.md" % type.to_lower()
			]
		return link
	
	func _get_method_signature(method_reference: Dictionary, with_link: bool = true, is_static: bool = false) -> String:
		var name: String = method_reference["name"]
		var parameters := PoolStringArray()
		var default_rest: bool
		for parameter in method_reference["arguments"]:
			var type: String = parameter["type"]
			var default_value: String
			var has_default: bool = default_rest
			if parameter.has("default_value"):
				has_default = true
				default_rest = true
				default_value = _strigify_value(parameter["default_value"])
			if default_rest and default_value.empty():
				default_value = _get_default_value(type)
			parameters.append(
				_get_type_link(type)
				+ " " 
				+ MarkdownDocument.escape_md(parameter["name"])
				+ ("=" + default_value if has_default else "")
			)
		var qualifiers: PoolStringArray = []
		for qualifier in method_reference.get("qualifiers", []):
			qualifiers.append("<u>_%s_</u>" % qualifier)
		
		var signature: String =  ("**static** " if is_static else "") + (
				("[%s](#method-%s)" if with_link else "**%s**%s")
				+ " **(** %s **)** %s"
			) % [
				MarkdownDocument.escape_md(name),
				name.replace("_", "-") if with_link else "",
				parameters.join(", "),
				qualifiers.join(", ")
		]
		
		return signature.strip_edges()
	
	func _get_signal_signature(signal_reference: Dictionary) -> String:
		var name: String = signal_reference["name"]
		var parameters: PoolStringArray = signal_reference["arguments"]
		
		return "**%s** **(** %s **)**" % [
			MarkdownDocument.escape_md(name),
			parameters.join(", ")
		]
	
	static func _strigify_value(value) -> String:
		if value is String:
			return '"%s"' % value
		elif value is bool:
			return "true" if value else "false"
		elif value is float:
			if is_nan(value):
				return "NAN"
			elif is_inf(value):
				return  ("-" if sign(value) == -1 else "") + "INF"
		elif value == null:
			return "null"
		return str(value)
	
	static func _get_default_value(type: String) -> String:
		match type:
			"AABB":
				return "AABB()"
			"Array",\
			"PoolByteArray",\
			"PoolColorArray",\
			"PoolIntArray",\
			"PoolRealArray",\
			"PoolStringArray",\
			"PoolVector2Array",\
			"PoolVector3Array":
				return "[ ]"
			"Basis":
				return "Basis( )"
			"Color":
				return "Color( )"
			"Dictionary":
				return "{ }"
			"NodePath":
				return '@""'
			"Plane":
				return "Plane( )"
			"Quat":
				return "Quat( )"
			"RID":
				return "RID( )"
			"Rect2":
				return "Rect2( )"
			"String":
				return '""'
			"Transform":
				return "Transform( )"
			"Transform2D":
				return "Transform2D( )"
			"Vector2":
				return "Vector2( )"
			"Vector3":
				return "Vector3( )"
			"bool":
				return "false"
			"float":
				return "0.0"
			"int":
				return "0"
			_:
				return "null"
	
	static func _is_builtin_type(type: String) -> bool:
		return ClassDB.class_exists(type) or type in [
			"AABB",
			"Array",
			"Basis",
			"Color",
			"Dictionary",
			"NodePath",
			"Plane",
			"PoolByteArray",
			"PoolColorArray",
			"PoolIntArray",
			"PoolRealArray",
			"PoolVector2Array",
			"PoolVector3Array",
			"Quat",
			"RID",
			"Rect2",
			"String",
			"Transform",
			"Transform2D",
			"Variant",
			"Vector2",
			"Vector3",
			"bool",
			"float",
			"int"
		]
