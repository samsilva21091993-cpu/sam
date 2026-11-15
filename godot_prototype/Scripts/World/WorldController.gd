extends Spatial
class_name WorldController

export var world_size: int = 64
export var agent_count: int = 8
export var resource_count: int = 72

var resource_nodes: Array = []
var agents: Array = []
var weather = {"time": 12.0, "temperature": 20.0, "rain": 0.0}
var community_system = CommunitySystem.new()
var _day_light = null

func _ready() -> void:
    randomize()
    community_system.setup(self)
    generate_world()
    spawn_resources()
    spawn_agents(agent_count)
    _setup_camera_and_light()
    var hud = CanvasLayer.new()
    hud.set_script(preload("res://godot_prototype/Scripts/UI/CivilizationHUD.gd"))
    add_child(hud)

func _process(delta: float) -> void:
    weather["time"] = fmod(float(weather["time"]) + delta * 0.4, 24.0)
    weather["temperature"] = 18.0 + sin(float(weather["time"]) / 24.0 * PI * 2.0) * 13.0
    weather["rain"] = clamp(0.25 + sin(float(weather["time"]) / 24.0 * PI * 2.0 + 1.5) * 0.25, 0.0, 1.0)
    community_system.update(delta)
    if _day_light != null:
        _day_light.rotation_degrees.x = -35.0 + float(weather["time"]) * 15.0

func _setup_camera_and_light() -> void:
    var camera = Camera.new()
    camera.translation = Vector3(0.0, 75.0, 85.0)
    camera.look_at(Vector3.ZERO, Vector3.UP)
    add_child(camera)
    camera.current = true

    _day_light = DirectionalLight.new()
    _day_light.rotation_degrees = Vector3(-45.0, -30.0, 0.0)
    _day_light.light_energy = 1.0
    add_child(_day_light)

func generate_world() -> void:
    var terrain = Spatial.new()
    terrain.name = "Terrain"
    add_child(terrain)
    for x in range(-world_size, world_size, 8):
        for z in range(-world_size, world_size, 8):
            var block = MeshInstance.new()
            var cube = CubeMesh.new()
            cube.size = Vector3(8.0, 1.0, 8.0)
            block.mesh = cube
            block.translation = Vector3(x + 4.0, -0.5, z + 4.0)
            var material = SpatialMaterial.new()
            var shade = rand_range(0.0, 0.08)
            material.albedo_color = Color(0.20 + shade, 0.46 + shade, 0.20 + shade)
            block.material_override = material
            terrain.add_child(block)

func spawn_resources() -> void:
    var types = ["food", "water", "wood", "stone"]
    for i in range(resource_count):
        var kind = types[randi() % types.size()]
        var node = Spatial.new()
        node.name = "Resource_%s_%d" % [kind, i]
        var x = rand_range(-world_size + 8.0, world_size - 8.0)
        var z = rand_range(-world_size + 8.0, world_size - 8.0)
        var position = Vector3(x, 0.5, z)
        node.translation = position

        var mesh_instance = MeshInstance.new()
        var mesh = CubeMesh.new()
        mesh.size = Vector3(1.2, 1.0, 1.2)
        mesh_instance.mesh = mesh
        var material = SpatialMaterial.new()
        match kind:
            "food": material.albedo_color = Color(0.25, 0.85, 0.20)
            "water": material.albedo_color = Color(0.15, 0.50, 0.95)
            "wood": material.albedo_color = Color(0.48, 0.28, 0.12)
            "stone": material.albedo_color = Color(0.55, 0.57, 0.60)
        mesh_instance.material_override = material
        node.add_child(mesh_instance)
        add_child(node)
        resource_nodes.append({"type": kind, "position": position, "node": node})

func spawn_agents(amount: int) -> void:
    var script = preload("res://godot_prototype/Scripts/AI/Agent.gd")
    for i in range(amount):
        var agent = script.new()
        agent.name = "Agent_%d" % i
        agent.agent_name = "Habitante_%d" % (i + 1)
        agent.translation = Vector3(rand_range(-10.0, 10.0), 0.0, rand_range(-10.0, 10.0))
        add_child(agent)
        agents.append(agent)
        community_system.register_member(agent)

func find_nearby_resource(origin: Vector3, resource_type: String, radius: float):
    var nearest = null
    var best_distance = radius
    for resource in resource_nodes:
        if resource["type"] != resource_type:
            continue
        var distance = origin.distance_to(resource["position"])
        if distance <= best_distance:
            nearest = resource
            best_distance = distance
    return nearest

func consume_resource(resource) -> bool:
    var index = resource_nodes.find(resource)
    if index < 0:
        return false
    resource_nodes.remove(index)
    var node = resource.get("node", null)
    if node != null and is_instance_valid(node):
        node.queue_free()
    return true

func spawn_house(position: Vector3) -> void:
    var house = MeshInstance.new()
    house.name = "CommunityHouse_%d" % community_system.houses.size()
    var mesh = CubeMesh.new()
    mesh.size = Vector3(4.0, 3.0, 4.0)
    house.mesh = mesh
    house.translation = position + Vector3(0.0, 1.5, 0.0)
    var material = SpatialMaterial.new()
    material.albedo_color = Color(0.48, 0.28, 0.12)
    house.material_override = material
    add_child(house)

func get_resources() -> Array:
    return resource_nodes

func get_weather_state() -> Dictionary:
    return weather

func get_community_system():
    return community_system

func get_population_count() -> int:
    var count = 0
    for agent in agents:
        if is_instance_valid(agent) and agent.alive:
            count += 1
    return count

func get_agents() -> Array:
    return agents
