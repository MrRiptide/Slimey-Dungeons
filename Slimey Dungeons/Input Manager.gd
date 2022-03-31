extends Node

func get_input_for(action):
	var output = ""
	var action_list = InputMap.get_action_list(action)
	for i in range(0, action_list.size()):
		if action_list[i] == null:
			continue
		if len(output) > 0:
			output += "|"
		output += action_list[i].as_text()
	return "[" + output + "]"
