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
	if hand.get_child_count() < 3: return
	var item = hand.get_child(2)
	# Equip new item
	if item is Weapon: 
		print("is weapon")
		weapon = hand.get_child(2)
		hand.weapon = weapon
		weapon.weapon_fired.connect(hand.recoil_weapon)
		weapon.weapon_fired.connect(player_inv.adjust_ammo)
	if item.is_class("RigidBody3D"):
		(item as RigidBody3D).freeze = true

# Handle input here so unequipped weapons don't care about input
func fire_input():
	if !weapon: return
	if weapon.can_fire: 
		weapon.fire()
		
func reload_input():
	if !weapon: return
	hand.reload_weapon()
	player_inv.adjust_ammo()
