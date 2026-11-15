extends Reference
class_name MemorySystem

var recent_events = []
var resource_positions = {}
var known_dangers = []
var discovered_techniques = []

func remember_event(message: String, event_type: String = "general") -> void:
    recent_events.append({"type": event_type, "message": message, "tick": OS.get_system_time_msecs()})
    if recent_events.size() > 50:
        recent_events.pop_front()

func remember_resource(resource_type: String, position: Vector3) -> void:
    if not resource_positions.has(resource_type):
        resource_positions[resource_type] = []
    if not resource_positions[resource_type].has(position):
        resource_positions[resource_type].append(position)

func remember_danger(position: Vector3, danger_name: String) -> void:
    known_dangers.append({"position": position, "danger": danger_name})
    if known_dangers.size() > 20:
        known_dangers.pop_front()

func learn_technique(name: String) -> void:
    if not discovered_techniques.has(name):
        discovered_techniques.append(name)

func has_technique(name: String) -> bool:
    return discovered_techniques.has(name)

func describe() -> Dictionary:
    return {
        "recent_events": recent_events.duplicate(true),
        "resource_positions": resource_positions.duplicate(true),
        "known_dangers": known_dangers.duplicate(true),
        "discovered_techniques": discovered_techniques.duplicate()
    }
