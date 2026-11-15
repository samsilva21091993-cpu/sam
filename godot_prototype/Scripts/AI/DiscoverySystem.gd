extends Reference
class_name DiscoverySystem

# A simple experiment succeeds only when the agent has observed both materials
# nearby. This is a prototype rule, not a scripted technology timeline.
func try_discover_fire(agent) -> bool:
    if agent == null or agent.knows_fire:
        return false

    var world = agent.get_parent()
    if world == null or not world.has_method("find_nearby_resource"):
        return false

    var wood = world.find_nearby_resource(agent.global_transform.origin, "wood", 18.0)
    var stone = world.find_nearby_resource(agent.global_transform.origin, "stone", 18.0)
    if wood == null or stone == null:
        return false

    agent.knows_fire = true
    agent.memory.learn_technique("Fogo básico")
    agent.memory.remember_event("Após experimentar com madeira e pedra, descobriu como manter fogo.", "discovery")
    return true
