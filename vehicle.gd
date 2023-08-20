extends VehicleBody

const STEER_SPEED = 1.5
const STEER_LIMIT = 0.4
var is_swipe=""
const SWIPE_SPEED=5
var steer_target = 0
onready var motor_sound=$"../motor_noise"
onready var tire_sound=$"../tire_noise"
onready var smoke_1=$CPUParticles
onready var smoke_2=$CPUParticles2

export var engine_force_value = 40
func _ready():
	if self.name=="Body_sport":
		engine_force_value=80
	
func _physics_process(delta):
#	wing.rotation.y=$Wheel3.rotation.y
	var speed = linear_velocity.length()
	if self.steering>=0.3 or self.steering<=-0.3:
		if speed>=5:
			print("bern")
			print(self.rotation)
			tire_sound.play()
	if speed<=10 or self.steering==0:
		
		tire_sound.stop()
		
	if self.linear_velocity.length()>10:
		motor_sound.pitch_scale=self.linear_velocity.length()/8
		smoke_1.lifetime=0.15
		smoke_2.lifetime=0.15
		
	if self.linear_velocity.length()>1.5 and self.linear_velocity.length()<12:
		motor_sound.pitch_scale=self.linear_velocity.length()/4
		smoke_1.lifetime=0.5
		smoke_2.lifetime=0.5
#		print($"../motor_noise".pitch_scale)
	if self.linear_velocity.length()<0.5:
		smoke_1.lifetime=1
		smoke_2.lifetime=1
		motor_sound.pitch_scale=0.85	
	var fwd_mps = transform.basis.xform_inv(linear_velocity).x
	if is_swipe=="left" or Input.is_action_pressed("ui_left"):
		steer_target = 1
	if is_swipe=="right" or Input.is_action_pressed("ui_right"):
			steer_target = -1
	steer_target *= STEER_LIMIT

	if is_swipe=="forward" or Input.is_action_pressed("ui_up"):
		
		# Increase engine force at low speeds to make the initial acceleration faster.
		
		if speed < 5 and speed != 0:
			engine_force = clamp(engine_force_value * 5 / speed, 0, 100)
			
		else:
			engine_force = engine_force_value

			
	else:
		engine_force = 0
	if is_swipe=="back" or Input.is_action_pressed("ui_down"):	
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			
			if speed < 5 and speed != 0:
				engine_force = -clamp(engine_force_value * 5 / speed, 0, 100)
				
			else:
				engine_force = -engine_force_value
			
		else:
			brake = 1

	else:
		brake = 0.0

	steering = move_toward(steering, steer_target, STEER_SPEED * delta)
func _input(event):
	if event is InputEventScreenDrag:
		if event.relative.x > SWIPE_SPEED:
			is_swipe="right"
			
			
		if event.relative.x < -SWIPE_SPEED:
			is_swipe="left"	
			
		if event.relative.y < -SWIPE_SPEED:	
			is_swipe="forward"	
						
		if event.relative.y > SWIPE_SPEED:	
			is_swipe="back"		
	elif event is InputEventScreenTouch:
		
		if !event.pressed:
			is_swipe=""	


func _on_Body_body_entered(body):
	if body:
		print(body.name)
	pass # Replace with function body.
