extends Node

## Constants
const gravity = 980.0

const MASK_FIRE = "mask_fire"
const MASK_DEATH = "mask_death"
const MASK_ANTIGRAVITY = "mask_gravity"
const MASK_NONE = "normal"
	
var mask_map = {
	"MASK_FIRE_KEY": MASK_FIRE,
	"MASK_DEATH_KEY": MASK_DEATH,
	"MASK_ANTIGRAVITY_KEY": MASK_ANTIGRAVITY
}

## Signals
signal mask_changed(current_mask: String);
