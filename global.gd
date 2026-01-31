extends Node

## Constants
const gravity = 980.0

const MASK_FIRE = "MASK_FIRE"
const MASK_DEATH = "MASK_DEATH"
const MASK_ANTIGRAVITY = "MASK_ANTIGRAVITY"
	
var mask_map = {
	"MASK_FIRE_KEY": MASK_FIRE,
	"MASK_DEATH_KEY": MASK_DEATH,
	"MASK_ANTIGRAVITY_KEY": MASK_ANTIGRAVITY
}

## Signals
signal mask_changed(current_mask: String);
