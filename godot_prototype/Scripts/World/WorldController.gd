extends Spatial
class_name WorldController

export var world_size: int = 80
export var agent_count: int = 10
export var resource_types = ["food", "water", "wood", "stone"]

var resource_nodes = []
var agents = []
var weather = {
    "time": 12.0,
    "temperature": 25.0,
    "rain": 0.2
}

func _ready() -> void:
    randomize()
    generate_world()
    spawn_resources()
    spawn_agents(agent_count)
    set_process(true)

func _process(delta: float) -> void:
    weather["time"] += delta * 0.4
    if weather["time"] > 24.0:
        weather["time"] = 0.0

    weather["temperature"] = 20.0 + sin(weather["time"] / 24.0 * PI * 2.0) * 12.0
    weather["rain"] = 0.2 + sin(weather["time"] / 24.0 * PI * 2.0 + 1.5) * 0.3
    weather["rain"] = clamp(weather["rain"], 0.0, 1.0)

    for agent in agents:
        if is_instance_valid(agent):
            agent._physics_process(delta)

func generate_world() -> void:
    var terrain = Spatial.new()
    terrain.name = "Terrain"

    for x in range(-world_size, world_size, 8):
        for z in range(-world_size, world_size, 8):
            var block = MeshInstance.new()
            var cube = CubeMesh.new()
            cube.size = Vector3(8, 1.5, 8)
            block.mesh = cube

            var height_offset = sin(float(x) * 0.2) * 2.0 + cos(float(z) * 0.15) * 2.0
            block.translation = Vector3(x, height_offset, z)

            var mat = SpatialMaterial.new()
            mat.albedo_color = Color(0.3 + randf() * 0.3, 0.5 + randf() * 0.2, 0.25 + randf() * 0.2)
            block.material_override = mat

            terrain.add_child(block)

    add_child(terrain)

func spawn_resources() -> void:
    for i in range(30):
        var resource = Spatial.new()
        resource.name = "Resource_%d" % i

        var type = resource_types[randi() % resource_types.size()]
        resource.set_meta("type", type)
        resource.translation = Vector3(rand_range(-world_size, world_size), 0.5, rand_range(-world_size, world_size))

        var mesh = CubeMesh.new()
        mesh.size = Vector3(1.0, 1.0, 1.0)
        var mesh_instance = MeshInstance.new()
        mesh_instance.mesh = mesh

        var mat = SpatialMaterial.new()
        if type == "food":
            mat.albedo_color = Color(0.2, 0.7, 0.2)
        elif type == "water":
            mat.albedo_color = Color(0.1, 0.5, 0.9)
        elif type == "wood":
            mat.albedo_color = Color(0.6, 0.4, 0.2)
        else:
            mat.albedo_color = Color(0.5, 0.5, 0.5)
        mesh_instance.material_override = mat

        resource.add_child(mesh_instance)
        add_child(resource)
        resource_nodes.append({
            "type": type,
            "position": resource.translation,
            "node": resource
        })

func spawn_agents(amount: int) -> void:
    for i in range(amount):
        var agent = preload("res://godot_prototype/Scripts/AI/Agent.gd").new()
        agent.name = "Agent_%d" % i
        agent.translation = Vector3(rand_range(-15, 15), 1.0, rand_range(-15, 15))
        agent.home_position = agent.translation
        add_child(agent)
        agents.append(agent)

func get_resources() -> Array:
    return resource_nodes

func get_weather_state() -> Dictionary:
    return weather

func get_population_count() -> int:
    return agents.size()
