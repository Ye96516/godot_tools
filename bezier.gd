class_name Bezier extends Node

signal reach_target

## 抛掷高度
@export var throw_height: int = 400
## 抛掷的速度
@export var throw_speed: float = 1.5
## 抛掷最高点的位置偏移。数值越大最高点越靠近目标点上方,保守范围[code](0-1)[/code]，越界会出现回旋
@export_range(-1, 2) var max_height_offset: float = 0.75

"""private"""
# 起始的位置
var begin_pos: Vector2
# 结束的位置
var end_pos: Vector2
# 行进位置
var bezier_pos: Vector2
# 时间控制
var time: float:
	set(value):
		if value >= 1:
			time = 1
		else :
			time = value
# 是否开始抛掷
var start_throw: bool
# 控制的目标
var target: Node2D

func _ready() -> void:
	target = get_parent()
	begin_pos = target.global_position
	
func _process(delta: float) -> void:
	if start_throw:
		target.global_position = _bezier(time)
		time += delta * throw_speed
		if target.global_position.distance_to(end_pos) <= 0.1:
			time = 0
			reach_target.emit()
			start_throw = false
		
# 外部调用的方法，参数为目标点的世界坐标
func throw(_end_pos: Vector2):
	if _end_pos != begin_pos:
		self.end_pos = _end_pos
		var bezier_x = (begin_pos.x + _end_pos.x) * max_height_offset
		var bezier_y = begin_pos.y - throw_height
		bezier_pos = Vector2(bezier_x, bezier_y)
		time = 0
		start_throw = true
		
# 辅助计算
func _bezier(_time: float)-> Vector2:
	var _p1 = begin_pos.lerp(bezier_pos, _time)
	var _p2 = begin_pos.lerp(end_pos, _time)
	return _p1.lerp(_p2, _time)
