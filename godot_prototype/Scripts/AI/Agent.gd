extends KinematicBody
class_name CivilAgent

export var move_speed: float = 5.0
export var state_name: String = "wander"
export var agent_name: String = "Agent"

var needs: NeedSystem = NeedSystem.new()
var memory: MemorySystem = MemorySystem.new()
var current_goal: String = "explore"
var home_position: Vector3 = Vector3.ZERO
var target_position: Vector3 = Vector3.ZERO
var velocity: Vector3 = Vector3.ZERO
var action_cooldown: float = 0.0
var age: float = 0.0
var alive: bool = true

func _ready() -> void:
    randomize()
    agent_name = "Agent_%d" % randi() % 10000
    home_position = global_transform.origin
    target_position = home_position
    memory.remember_event("Nasci em um mundo novo.", "birth")
    set_physics_process(true)

func _physics_process(delta: float) -> void:
    if not alive:
        return

    age += delta
    _update_needs(delta)
    _choose_goal(delta)
    _move_to_target(delta)

func _update_needs(delta: float) -> void:
    var weather = {}
    if get_parent() and get_parent().has_method("get_weather_state"):
        weather = get_parent().get_weather_state()
    needs.update(delta, weather)

    if needs.needs["hunger"] < 30.0:
        current_goal = "search_food"
    elif needs.needs["thirst"] < 30.0:
        current_goal = "search_water"
    elif needs.needs["fatigue"] < 30.0:
        current_goal = "rest"
    elif needs.needs["safety"] < 35.0:
        current_goal = "seek_shelter"

func _choose_goal(delta: float) -> void:
    action_cooldown -= delta
    if action_cooldown > 0.0:
        return

    match current_goal:
        "search_food":
            target_position = _find_nearest_resource("food")
            if target_position == Vector3.ZERO:
                target_position = home_position + Vector3(rand_range(-20, 20), 0.0, rand_range(-20, 20))
            action_cooldown = 3.0
        "search_water":
            target_position = _find_nearest_resource("water")
            if target_position == Vector3.ZERO:
                target_position = home_position + Vector3(rand_range(-15, 15), 0.0, rand_range(-15, 15))
            action_cooldown = 3.0
        "rest":
            target_position = home_position
            if global_transform.origin.distance_to(home_position) < 2.0:
                needs.restore("fatigue", 25.0)
                needs.restore("health", 8.0)
                memory.remember_event("Descansou e recuperou energia.", "rest")
            action_cooldown = 2.5
        "seek_shelter":
            target_position = home_position
            if global_transform.origin.distance_to(home_position) < 2.0:
                needs.restore("safety", 20.0)
                needs.restore("warmth", 12.0)
            action_cooldown = 2.0
        _:
            target_position = home_position + Vector3(rand_range(-15, 15), 0.0, rand_range(-15, 15))
            action_cooldown = 2.0

func _find_nearest_resource(resource_type: String) -> Vector3:
    var nearest = Vector3.ZERO
    var best_distance = INF

    if get_parent() and get_parent().has_method("get_resources"):
        var resources = get_parent().get_resources()
        for resource in resources:
            if resource["type"] == resource_type:
                var d = global_transform.origin.distance_to(resource["position"])
                if d < best_distance:
                    best_distance = d
                    nearest = resource["position"]

    if nearest == Vector3.ZERO and best_distance == INF:
        return Vector3.ZERO

    memory.remember_resource(resource_type, nearest)
    return nearest

func _move_to_target(delta: float) -> void:
    if target_position == Vector3.ZERO:
        return

    var desired = target_position - global_transform.origin
    desired.y = 0.0
    if desired.length() > 0.5:
        desired = desired.normalized() * move_speed
        velocity = desired
        move_and_slide(velocity, Vector3.UP)

    if global_transform.origin.distance_to(target_position) < 2.0:
        _interact_with_target()

func _interact_with_target() -> void:
    if current_goal == "search_food":
        needs.restore("hunger", 30.0)
        needs.restore("health", 8.0)
        memory.remember_event("Coletou alimento e restaurou energia.", "food")
        current_goal = "explore"
    elif current_goal == "search_water":
        needs.restore("thirst", 28.0)
        memory.remember_event("Encontrou água potável.", "water")
        current_goal = "explore"
    elif current_goal == "rest":
        needs.restore("fatigue", 35.0)
        memory.remember_event("Descansou em um abrigo improvisado.", "rest")
        current_goal = "explore"
    elif current_goal == "seek_shelter":
        needs.restore("safety", 20.0)
        memory.remember_event("Procurou abrigo e reduziu vulnerabilidade.", "shelter")
        current_goal = "explore"

func get_status() -> Dictionary:
    return {
        "name": agent_name,
        "goal": current_goal,
        "position": global_transform.origin,
        "needs": needs.stats_summary(),
        "techniques": memory.discovered_techniques
    }
