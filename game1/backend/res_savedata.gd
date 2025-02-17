class_name Res_SaveData
extends Resource

@export var unique_id : String = ""
@export var node_transform : bool = true

var node

func setup(_node:Node):
	node = _node
	
func get_data_to_save():
	var ret = {}
	ret["node_transform"] = node.global_transform
	return ret

func restore(data):
	for key in data.keys():
		match key:
			"node_transform":
				node.global_transform = data[key]
