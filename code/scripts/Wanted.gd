extends Node2D

const PetHeadMap = {
	GLOBAL.PetType.Cat0 : Vector2(208, 32),
	GLOBAL.PetType.Cat1 : Vector2(208, 48),
	GLOBAL.PetType.Cat2 : Vector2(208, 64),
	GLOBAL.PetType.Cat3 : Vector2(208, 80),
	GLOBAL.PetType.Cat4 : Vector2(208, 96),
	GLOBAL.PetType.Dog0 : Vector2(224, 32),
	GLOBAL.PetType.Dog1 : Vector2(224, 48),
	GLOBAL.PetType.Dog2 : Vector2(224, 64),
	GLOBAL.PetType.Dog3 : Vector2(224, 80),
	GLOBAL.PetType.Dog4 : Vector2(224, 96),
}

var wanted_id : int = -1
var pet_type : int = 0

onready var delivery_spot = $DeliverySpot

# warning-ignore:shadowed_variable
func set_pet(pet_type : int) -> void :
	self.pet_type = pet_type
	$Pet.region_rect.position.x = PetHeadMap[pet_type].x
	$Pet.region_rect.position.y = PetHeadMap[pet_type].y
