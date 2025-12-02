#Head
class_name Head extends Node3D
@export var hand: Hand
@export var player_inv: PlayerInventory
var weapon: Weapon

## (Un)equips the item in hand and resets existing signal connections.
func equip_item() -> void:
	# Unequip old item
	if weapon:
		weapon.weapon_fired.disconnect(hand.recoil_weapon)
		weapon.weapon_fired.disconnect(player_inv.adjust_ammo)
		weapon = null
	var items_in_hand: Array = hand.get_children().filter(func(c): return c is Item)
	if items_in_hand.is_empty(): return
	var item_node = items_in_hand.front()
	# Equip new item
	if item_node is Weapon: 
		weapon = item_node
		hand.item = weapon
		weapon.weapon_fired.connect(hand.recoil_weapon)
		weapon.weapon_fired.connect(player_inv.adjust_ammo)
	# TODO: Might have gravity issues, unfreeze unequipped
	if item_node.is_class("RigidBody3D"):
		#(item as RigidBody3D).gravity_scale = 0
		(item_node as RigidBody3D).freeze = true
		pass
	hand.grip_item()

# Handle input here so unequipped weapons don't care about input
func fire_input():
	if !weapon: return
	if weapon.can_fire: 
		weapon.fire()
		
func reload_input():
	if !weapon: return
	hand.reload_weapon()
	player_inv.adjust_ammo()
