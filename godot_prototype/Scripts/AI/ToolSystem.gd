extends Reference
class_name ToolSystem

# Protótipo de experimentação: o agente precisa conhecer fogo e ter madeira e
# pedra próximas. Os materiais são consumidos ao concluir a fabricação.
var attempts: int = 0

func can_craft_basic_tool(agent) -> bool:
    if agent == null or not is_instance_valid(agent):
        return false
    if agent.has_basic_tool or not agent.knows_fire:
        return false

    return _find_nearby_resource(agent, "wood", 8.0) != null \
        and _find_nearby_resource(agent, "stone", 8.0) != null

func craft_basic_tool(agent) -> bool:
    if not can_craft_basic_tool(agent):
        return false

    var world = agent.get_parent()
    var wood = _find_nearby_resource(agent, "wood", 8.0)
    var stone = _find_nearby_resource(agent, "stone", 8.0)
    if wood == null or stone == null:
        return false

    # Consome ambos apenas se o controlador oferecer a operação segura.
    if not world.has_method("consume_resource"):
        return false
    if not world.consume_resource(wood) or not world.consume_resource(stone):
        return false

    attempts += 1
    agent.has_basic_tool = true
    agent.memory.learn_technique("Ferramenta de pedra")
    agent.memory.remember_event(
        "Combinou madeira, pedra e conhecimento do fogo para fabricar uma ferramenta.",
        "discovery"
    )
    return true

func _find_nearby_resource(agent, resource_type: String, radius: float):
    var world = agent.get_parent()
    if world == null or not world.has_method("get_resources"):
        return null

    var nearest = null
    var best_distance = radius
    for resource in world.get_resources():
        if resource["type"] != resource_type:
            continue
        var distance = agent.global_transform.origin.distance_to(resource["position"])
        if distance <= best_distance:
            nearest = resource
            best_distance = distance
    return nearest
