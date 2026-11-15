extends KinematicBody
class_name CivilAgent

export var move_speed: float = 4.0
export var agent_name: String = "Agent"

var needs = NeedSystem.new()
var memory = MemorySystem.new()
var discovery = DiscoverySystem.new()
var tool_system = ToolSystem.new()
var current_goal: String = "explore"
var home_position: Vector3 = Vector3.ZERO
var target_position: Vector3 = Vector3.ZERO
var velocity: Vector3 = Vector3.ZERO
var decision_timer: float = 0.0
var age: float = 0.0
var alive: bool = true
var knows_fire: bool = false
var has_shelter: bool = false
var has_basic_tool: bool = false
var village_name: String = "Aldeia Primordial"
var role: String = "Explorador"
var social_need: float = 100.0
var _interacted_at_target: bool = false

func _ready() -> void:
    if agent_name == "Agent":
        agent_name = "Habitante_%d" % (randi() % 10000)
    home_position = global_transform.origin
    target_position = home_position
    _create_visual()
    memory.remember_event("Nasceu em um mundo novo.", "birth")

func _create_visual() -> void:
    var mesh_instance = MeshInstance.new()
    var mesh = CapsuleMesh.new()
    mesh.radius = 0.45
    mesh.mid_height = 0.8
    mesh_instance.mesh = mesh
    var material = SpatialMaterial.new()
    material.albedo_color = Color(0.75, 0.55, 0.34)
    mesh_instance.material_override = material
    mesh_instance.translation.y = 0.85
    add_child(mesh_instance)

    var collision = CollisionShape.new()
    var capsule = CapsuleShape.new()
    capsule.radius = 0.45
    capsule.height = 1.7
    collision.shape = capsule
    collision.translation.y = 0.85
    add_child(collision)

func _physics_process(delta: float) -> void:
    if not alive:
        return
    age += delta
    decision_timer -= delta
    _update_needs(delta)
    if decision_timer <= 0.0:
        _decide_and_act()
        decision_timer = 0.8
    _move_to_target(delta)
    if needs.needs["health"] <= 0.0:
        alive = false
        memory.remember_event("Morreu por falta de recursos e saúde.", "death")
        queue_free()

func _update_needs(delta: float) -> void:
    var world = get_parent()
    var weather = world.get_weather_state() if world != null and world.has_method("get_weather_state") else {}
    needs.update(delta, weather)
    social_need = clamp(social_need - 0.05 * delta, 0.0, 100.0)

func _decide_and_act() -> void:
    # Necessidades vitais têm prioridade; progresso vem depois da sobrevivência.
    if needs.needs["hunger"] < 35.0:
        current_goal = "search_food"
    elif needs.needs["thirst"] < 35.0:
        current_goal = "search_water"
    elif needs.needs["fatigue"] < 25.0:
        current_goal = "rest"
    elif needs.needs["warmth"] < 45.0 and not knows_fire:
        current_goal = "discover_fire"
    elif needs.needs["safety"] < 35.0 and not has_shelter:
        current_goal = "build_shelter"
    elif not knows_fire:
        current_goal = "discover_fire"
    elif not has_basic_tool:
        current_goal = "craft_tool"
    elif social_need < 30.0:
        current_goal = "socialize"
    else:
        current_goal = "gather"

    _interacted_at_target = false
    match current_goal:
        "search_food": _set_resource_target("food")
        "search_water": _set_resource_target("water")
        "discover_fire":
            target_position = _nearest_resource_position("wood")
            if target_position == Vector3.ZERO:
                _wander()
            if discovery.try_discover_fire(self):
                needs.restore("warmth", 35.0)
                needs.restore("safety", 10.0)
                current_goal = "build_shelter"
        "craft_tool":
            target_position = _nearest_resource_position("stone")
            if target_position == Vector3.ZERO:
                _wander()
            if tool_system.craft_basic_tool(self):
                current_goal = "gather"
        "build_shelter":
            target_position = home_position
            if global_transform.origin.distance_to(home_position) < 2.0:
                has_shelter = true
                needs.restore("safety", 30.0)
                needs.restore("warmth", 20.0)
                memory.remember_event("Preparou um abrigo simples no acampamento.", "shelter")
        "rest":
            target_position = home_position
            if global_transform.origin.distance_to(home_position) < 2.0:
                needs.restore("fatigue", 25.0)
                memory.remember_event("Descansou no acampamento.", "rest")
        "socialize":
            target_position = home_position
            if global_transform.origin.distance_to(home_position) < 3.0:
                social_need = 100.0
                memory.remember_event("Reuniu-se com outros membros da aldeia.", "social")
        _:
            _set_resource_target("wood")

func _set_resource_target(resource_type: String) -> void:
    target_position = _nearest_resource_position(resource_type)
    if target_position == Vector3.ZERO:
        _wander()

func _nearest_resource_position(resource_type: String) -> Vector3:
    var world = get_parent()
    if world == null or not world.has_method("find_nearby_resource"):
        return Vector3.ZERO
    var resource = world.find_nearby_resource(global_transform.origin, resource_type, INF)
    if resource == null:
        return Vector3.ZERO
    memory.remember_resource(resource_type, resource["position"])
    return resource["position"]

func _wander() -> void:
    target_position = home_position + Vector3(rand_range(-18.0, 18.0), 0.0, rand_range(-18.0, 18.0))

func _move_to_target(delta: float) -> void:
    var offset = target_position - global_transform.origin
    offset.y = 0.0
    if offset.length() > 1.0:
        velocity = offset.normalized() * move_speed
        move_and_slide(velocity, Vector3.UP)
    elif not _interacted_at_target:
        _interact_with_resource()

func _interact_with_resource() -> void:
    _interacted_at_target = true
    var world = get_parent()
    if world == null or not world.has_method("find_nearby_resource"):
        return
    var resource_type = ""
    if current_goal == "search_food": resource_type = "food"
    elif current_goal == "search_water": resource_type = "water"
    elif current_goal == "gather": resource_type = "wood"
    if resource_type == "":
        return

    var resource = world.find_nearby_resource(global_transform.origin, resource_type, 3.0)
    if resource == null or not world.consume_resource(resource):
        _wander()
        return

    if current_goal == "search_food":
        needs.restore("hunger", 45.0)
        memory.remember_event("Coletou alimento.", "food")
        if world.has_method("get_community_system"):
            world.get_community_system().deposit("food", 1.0)
    elif current_goal == "search_water":
        needs.restore("thirst", 45.0)
        memory.remember_event("Encontrou água potável.", "water")
    else:
        var community = world.get_community_system() if world.has_method("get_community_system") else null
        if community != null:
            community.deposit("wood", 1.0)
        memory.remember_event("Recolheu madeira para a comunidade.", "gather")
    current_goal = "explore"

func get_status() -> Dictionary:
    return {
        "name": agent_name,
        "goal": current_goal,
        "position": global_transform.origin,
        "needs": needs.stats_summary(),
        "techniques": memory.discovered_techniques,
        "knows_fire": knows_fire,
        "has_shelter": has_shelter,
        "has_basic_tool": has_basic_tool,
        "role": role,
        "village": village_name,
        "social_need": social_need
    }
