tool
extends "res://addons/material_maker/node_base.gd"

func _ready():
	initialize_properties([ $gradient ])

func _get_shader_code(uv, slot = 0):
	var rv = { defs="", code="" }
	var src = get_source()
	if src == null:
		return rv
	var src_code = src.get_shader_code(uv)
	if generated_variants.empty():
		rv.defs = src_code.defs+parameters.gradient.get_shader("%s_gradient" % name);
	var variant_index = generated_variants.find(uv)
	if variant_index == -1:
		variant_index = generated_variants.size()
		generated_variants.append(uv)
		rv.code = src_code.code+"vec4 %s_%d_rgba = %s_gradient(%s);\n" % [ name, variant_index, name, src_code.f ]
	rv.rgba = "%s_%d_rgba" % [ name, variant_index ]
	return rv

func _on_Control_updated(v):
	parameters.gradient = v
	update_shaders()
