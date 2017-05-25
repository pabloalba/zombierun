extends Node

const ZOMBIE_SPEED_X = 400
const ZOMBIE_SPEED_Y = 700
const ZOMBIE_GRAVITY = 1500
const WIDTH = 1280
const HEIGHT = 720
const TILE_SIZE = 64


var enemies = []
var spikes = []
var brains = []
var help_signs = []
var zombie
var head
var tile_map
var end_sign
var current_level = 1
var max_level = 1
var ninja_allowed = false
var cowboy_allowed = false



