class_name Player
extends CharacterBody2D

const ACCELERATION: float = 320
const MAX_SPEED: float = 80
const FRICTION: float = 120

var latest_kid: int = 0
var kid_count: int = 1

var talking: bool = false


@onready var bubble_point: Marker2D = %BubblePoint
@onready var interaction_zone: Area2D = $InteractionZone
