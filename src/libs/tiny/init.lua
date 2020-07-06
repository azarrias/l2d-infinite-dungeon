--[[ 
   tiny v0.0.1
   tiny package that provides very simple game engine features, such as:
   Colliders, animations, sprites, state machines, vectors, etc.
   Implemented using the ECS pattern
   Depends on the class module, from the HUMP package by Matthias Richter
  ]]

local current_folder = (...):gsub('%.init$', '') -- "my package path"

local animation = require(current_folder .. '.Animation')
local animation_frame = require(current_folder .. '.AnimationFrame')
local animator_condition = require(current_folder .. '.AnimatorCondition')
local animator_controller = require(current_folder .. '.AnimatorController')
local animator_controller_parameter = require(current_folder .. '.AnimatorControllerParameter')
local animator_state = require(current_folder .. '.AnimatorState')
local animator_state_machine = require(current_folder .. '.AnimatorStateMachine')
local animator_state_transition = require(current_folder .. '.AnimatorStateTransition')
local collider = require(current_folder .. '.Collider')
local entity = require(current_folder .. '.Entity')
local scene = require(current_folder .. '.Scene')
local scene_manager = require(current_folder .. '.SceneManager')
local script = require(current_folder .. '.Script')
local sprite = require(current_folder .. '.Sprite')
local state_machine_behaviour = require(current_folder .. '.StateMachineBehaviour')
local vector2d = require(current_folder .. '.Vector2D')

local tiny = {
  Animation = animation,
  AnimationFrame = animation_frame,
  AnimatorCondition = animator_condition,
  AnimatorController = animator_controller,
  AnimatorControllerParameter = animator_controller_parameter,
  AnimatorState = animator_state,
  AnimatorStateMachine = animator_state_machine,
  AnimatorStateTransition = animator_state_transition,
  Collider = collider,
  Entity = entity,
  Scene = scene,
  SceneManager = scene_manager,
  Script = script,
  Sprite = sprite,
  StateMachineBehaviour = state_machine_behaviour,
  Vector2D = vector2d
}

return tiny