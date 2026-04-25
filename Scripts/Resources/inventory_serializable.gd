extends Resource
class_name Inventory_Serializable
#-------------------------------------------------------------------------------
@export var consumable_item_array: Array[Item_Serializable]
@export var equip_item_array: Array[Equip_Serializable]
@export var key_item_array: Array[Key_Item_Serializable]
#-------------------------------------------------------------------------------
@export var money_serializable: Key_Item_Serializable
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = true
#-------------------------------------------------------------------------------
func Constructor() -> Inventory_Serializable:
	var _new_inventory_serializable: Inventory_Serializable =  Inventory_Serializable.new()
	#-------------------------------------------------------------------------------
	_new_inventory_serializable.consumable_item_array.clear()
	#-------------------------------------------------------------------------------
	for _i in consumable_item_array.size():
		var _consumable_item_serializable_array: Item_Serializable = consumable_item_array[_i].Constructor() as Item_Serializable
		_new_inventory_serializable.consumable_item_array.append(_consumable_item_serializable_array)
	#-------------------------------------------------------------------------------
	_new_inventory_serializable.equip_item_array.clear()
	#-------------------------------------------------------------------------------
	for _i in equip_item_array.size():
		var _equip_item_serializable_array: Equip_Serializable = equip_item_array[_i].Constructor() as Equip_Serializable
		_new_inventory_serializable.equip_item_array.append(_equip_item_serializable_array)
	#-------------------------------------------------------------------------------
	_new_inventory_serializable.key_item_array.clear()
	#-------------------------------------------------------------------------------
	for _i in key_item_array.size():
		var _key_item_serializable_array: Key_Item_Serializable = key_item_array[_i].Constructor() as Key_Item_Serializable
		_new_inventory_serializable.key_item_array.append(_key_item_serializable_array)
	#-------------------------------------------------------------------------------
	_new_inventory_serializable.money_serializable = money_serializable.Constructor()
	#-------------------------------------------------------------------------------
	return _new_inventory_serializable
#-------------------------------------------------------------------------------
