class_name CollisionConfigure 
extends Node


static var GROUND: int = 0x1
static var TEAM1: int = 0x2
static var TEAM2: int = 0x4
static var USABLE: int = 0x8


static func auto_team_projectile(object: CollisionObject2D, team: int = 0):
	if team == GROUND:
		pass
	elif team == TEAM1:
		object.collision_layer = 0x0
		object.collision_mask = GROUND | TEAM2
	elif team == TEAM2: 
		object.collision_layer = 0x0
		object.collision_mask = GROUND | TEAM1
