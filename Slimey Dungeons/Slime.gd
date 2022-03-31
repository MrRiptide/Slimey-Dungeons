extends KinematicBody


export var accel := 0.4
export var max_air_speed := 40.0
export var max_ground_speed := 30.0
export var jump_strength := 20.0
export var gravity := 50.0
export var friction := 0.1
export var max_size := 40
export var size := 20

var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN


func _ready():
	resize(size)


func resize(new_size):
	size = new_size
	self.scale = Vector3(size, size, size)


func init(size, origin, rotation):
	resize(size)
	self.rotation = rotation
	var move_direction = Vector3(1,0,0).rotated(Vector3.UP, rotation.y).normalized()
	self.global_transform.origin = origin - move_direction*0.9*size
	$CollisionShape.disabled = false
	#move_and_slide(Vector3.ZERO, Vector3.UP, true)


func _physics_process(delta):
	var is_focused := bool(get_parent().get_focused() == self)
	if is_focused:
		if Input.is_action_just_pressed("gameplay_split") and size > 1 and move_and_collide(Vector3(0, size, 0), true, true, true) == null:
			var new_slime = load("Slime.tscn").instance()
			get_parent().add_child(new_slime)
			new_slime.init(floor(size/2.0), global_transform.origin, rotation)
			resize(ceil(size/2.0))
			var move_direction = Vector3(1,0,0).rotated(Vector3.UP, rotation.y).normalized()
			self.global_transform.origin = self.global_transform.origin + move_direction*0.9*size
			get_parent().focus_slime(self)
		if Input.is_action_just_pressed("gameplay_merge"):
			var new_size = 0
			var new_location = Vector3.ZERO
			for node in $Area.get_overlapping_bodies():
				if node.get_parent() == self.get_parent():
					new_location += node.global_transform.origin * node.size
					new_size += node.size
					if node != self:
						node.get_parent().remove_child(node)
			resize(new_size)
			self.global_transform.origin = new_location / new_size
			get_parent().focus_slime(self)
	
	
	var move_direction := Vector3.ZERO
	if is_focused:
		move_direction.x = Input.get_action_strength("movement_right") - Input.get_action_strength("movement_left")
		move_direction.z = Input.get_action_strength("movement_back") - Input.get_action_strength("movement_forward")
		move_direction = move_direction.rotated(Vector3.UP, self.rotation.y).normalized()
	
	var max_speed = max_air_speed * (1 - size/(max_size+20))
	if is_on_floor():
		max_speed = max_ground_speed * (1 - size/(max_size+20))
	
	var accel_adjust = 1
	if !is_on_floor():
		accel_adjust = 0.1
	
	_velocity.x = lerp(_velocity.x, move_direction.x * max_speed, accel*accel_adjust)
	_velocity.z = lerp(_velocity.z, move_direction.z * max_speed, accel*accel_adjust)
	
	var horiz_vel = Vector2(_velocity.x, _velocity.z)
	if (horiz_vel.length() != 0):
		horiz_vel = horiz_vel / horiz_vel.length() * clamp(horiz_vel.length(), -max_speed, max_speed)
	
	if is_on_floor():
		horiz_vel.x = lerp(horiz_vel.x, 0, friction)
		horiz_vel.y = lerp(horiz_vel.y, 0, friction)
	
	_velocity = Vector3(horiz_vel.x, _velocity.y, horiz_vel.y)
	
	_velocity.y = clamp(_velocity.y - gravity * delta, -100, 100)
	
	var just_landed := is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping := is_focused and is_on_floor() and Input.is_action_pressed("movement_jump")
	
	if is_jumping:
		_velocity.y = jump_strength
		_snap_vector = Vector3.ZERO
	elif just_landed:
		_snap_vector = Vector3.DOWN
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, false, 100, 0.785398, false)
