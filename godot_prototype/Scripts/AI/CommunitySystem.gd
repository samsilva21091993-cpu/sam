extends Reference
class_name CommunitySystem

var community_name: String = "Aldeia Primordial"
var members: Array = []
var houses: Array = []
var food_stock: float = 0.0
var wood_stock: float = 0.0
var stone_stock: float = 0.0
var build_timer: float = 0.0
var world = null

func setup(world_controller) -> void:
    world = world_controller

func register_member(agent) -> void:
    if agent != null and not members.has(agent):
        members.append(agent)
        agent.village_name = community_name
        agent.role = "Coletor" if members.size() % 2 == 0 else "Explorador"

func deposit(resource_type: String, amount: float) -> void:
    match resource_type:
        "food": food_stock += amount
        "wood": wood_stock += amount
        "stone": stone_stock += amount

func update(delta: float) -> void:
    build_timer += delta
    if build_timer >= 5.0:
        build_timer = 0.0
        _build_house_if_possible()

func _build_house_if_possible() -> void:
    if members.size() < 3 or wood_stock < 5.0 or stone_stock < 2.0:
        return
    wood_stock -= 5.0
    stone_stock -= 2.0
    var position = Vector3(rand_range(-8.0, 8.0), 1.0, rand_range(-8.0, 8.0))
    houses.append({"position": position, "type": "house"})
    if world != null and world.has_method("spawn_house"):
        world.spawn_house(position)
    for member in members:
        if is_instance_valid(member):
            member.memory.remember_event("A comunidade construiu uma casa coletiva.", "community")

func get_summary() -> Dictionary:
    return {
        "name": community_name,
        "members": members.size(),
        "houses": houses.size(),
        "food": food_stock,
        "wood": wood_stock,
        "stone": stone_stock
    }
