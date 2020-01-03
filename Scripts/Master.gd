extends KinematicBody

var camera_angle = 0
var mouse_sensitivity = 0.3
var camera_change = Vector2()

# Camera shake variables
var time = 0 
var period = 0.1 
var magnitude = 0.2


var velocity = Vector3()
var direction = Vector3()

#Fly variables
const Fly_speed = 40 
const Fly_Accel = 4 

#Walk variables 
export var walk_speed = 7
export var running_speed = 10
var gravity = -9.8 * 3
#const MAX_SPEED = 0
#const MAX_RUNNING_SPEED = 0
const ACCEL = 10 
const DEACCEL = 10


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.



func _physics_process(delta):
  aim()
  GroundMovement(delta)
    
func _input(event): 
  if event is InputEventMouseMotion:
    camera_change = event.relative 
    
      

func GroundMovement(delta): 
  #reset the direction of the player
  direction = Vector3()
  
  #get the rotation of the camera
  var aim = $Head/Camera.get_camera_transform().basis
  #check input and change direction
  if Input.is_action_pressed("move_forward"): 
    direction -= aim.z
  if Input.is_action_pressed("move_backward"): 
    direction += aim.z  
  if Input.is_action_pressed("move_left"): 
    direction -= aim.x
  if Input.is_action_pressed("move_right"): 
    direction += aim.x  
  direction.y = 0  
  direction = direction.normalized()  
  
  velocity.y += gravity * delta 
  
  var temp_velocity = velocity 
  temp_velocity.y = 0
  
  var speed 
  if Input.is_action_pressed("sprint"):
    speed = running_speed
  else: 
    speed = walk_speed
  
  #where would the player go at max speed
  var target = direction * speed
  
  var acceleration 
  if direction.dot(temp_velocity) > 0: 
    acceleration = ACCEL 
  else: 
    acceleration = DEACCEL
  
  # calculate a portion of the distance to go 
  temp_velocity = temp_velocity.linear_interpolate(target, acceleration * delta)
  
  velocity.x = temp_velocity.x
  velocity.z = temp_velocity.z
  
  # move 
  velocity = move_and_slide(velocity, Vector3(0,1,0)) 
  


func fly(delta): 
  #reset the direction of the player
  direction = Vector3()
  
  #get the rotation of the camera
  var aim = $Head/Camera.get_global_transform().basis
  #check input and change direction
  if Input.is_action_pressed("move_forward"): 
    direction -= aim.z
    
  if Input.is_action_pressed("move_backward"): 
    direction += aim.z  
  if Input.is_action_pressed("move_left"): 
    direction -= aim.x
  if Input.is_action_pressed("move_right"): 
    direction += aim.x  
  

  direction = direction.normalized()  
  
  #where would the player go at max speed
  var target = direction * Fly_speed
  
  # calculate a portion of the distance to go 
  velocity = velocity.linear_interpolate(target, Fly_Accel * delta)
  
  #move 
  move_and_slide(velocity)
  
  
func aim():
  if camera_change.length() > 0:
    $Head.rotate_y(deg2rad(-camera_change.x * mouse_sensitivity))
    
    var change = -camera_change.y * mouse_sensitivity
    if change + camera_angle < 90 and change + camera_angle > -90:
      $Head/Camera.rotate_x(deg2rad(change))
      camera_angle += change
    camera_change = Vector2() 
    
  
func shake_camera(delta): 
  var campos = $Head/Camera.get_translation() 
  while time < period:
    time += get_process_delta_time() 
    time = min(time,period)
    
    #ShakeCamera 
    var offset = Vector3()
    offset.x = rand_range(-period, period)
    offset.y = rand_range(-period, period)
    offset.z = 0
    
    var newcampos = campos 
    newcampos += offset 
    $Head/Camera.set_translation(newcampos) 
    
    yield(get_tree(), "idle_frame")
  $Head/Camera.set_translation(campos) 
  
