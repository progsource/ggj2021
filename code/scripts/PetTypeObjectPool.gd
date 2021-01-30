extends Reference

var unused_pet_types = []
var used_pet_types = []

func init_pool() -> void:
	for i in range(GLOBAL.PetType.COUNT - 1):
		unused_pet_types.append(i)

func get_random_pet_type() -> int :
	if unused_pet_types.size() < 1:
		return -1
	var r = GLOBAL.rng.randi_range(0, unused_pet_types.size() - 1)
	var i = unused_pet_types[r]
	used_pet_types.append(i)
	unused_pet_types.remove(r)
	return i

func return_type(pet_type : int) -> void :
	var index = used_pet_types.find(pet_type)
	if index == -1:
		return

	used_pet_types.remove(index)
	unused_pet_types.append(pet_type)
