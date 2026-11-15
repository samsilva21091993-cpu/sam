extends Reference
class_name ToolSystem

func can_craft_basic_tool(agent) -> bool:
    if agent == null or agent.has_basic_tool or not agent.knows_fire:
        return false
    var world = agent.get_parent()
    if world == null or not world.has_method("find_nearby_resource"):
        return false
    return world.find_nearby_resource(agent.global_transform.origin, "wood", 8.0) != null \
        and world.find_nearby_resource(agent.global_transform.origin, "stone", 8.0) != null

func craft_basic_tool(agent) -> bool:
    if not can_craft_basic_tool(agent):
        return false

    var world = agent.get_parent()
    var origin = agent.global_transform.origin
    var wood = world.find_nearby_resource(origin, "wood", 8.0)
    var stone = world.find_nearby_resource(origin, "stone", 8.0)
    if wood == null or stone == null:
        return false

    # The world method removes resources by identity and guards against reuse.
    if not world.consume_resource(wood):
        return false
    if not world.consume_resource(stone):
        return false

    agent.has_basic_tool = true
    agent.memory.learn_technique("Ferramenta de pedra")
    agent.memory.remember_event("Combinou madeira e pedra para fabricar uma ferramenta rudimentar.", "discovery")
    return true
