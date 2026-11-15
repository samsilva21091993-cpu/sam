extends Reference
class_name NeedSystem

var needs = {
    "hunger": 100.0,
    "thirst": 100.0,
    "fatigue": 100.0,
    "safety": 100.0,
    "warmth": 100.0,
    "health": 100.0
}

func update(delta: float, weather: Dictionary) -> void:
    needs["hunger"] = clamp(needs["hunger"] - 1.2 * delta, 0.0, 100.0)
    needs["thirst"] = clamp(needs["thirst"] - 1.5 * delta, 0.0, 100.0)
    needs["fatigue"] = clamp(needs["fatigue"] - 0.8 * delta, 0.0, 100.0)

    var temperature = float(weather.get("temperature", 20.0))
    var rain = float(weather.get("rain", 0.0))
    if temperature < 15.0:
        needs["warmth"] = clamp(needs["warmth"] - 0.5 * delta, 0.0, 100.0)
    elif temperature > 32.0:
        needs["warmth"] = clamp(needs["warmth"] - 0.2 * delta, 0.0, 100.0)
    else:
        needs["warmth"] = clamp(needs["warmth"] + 0.1 * delta, 0.0, 100.0)
    if rain > 0.6 and temperature < 20.0:
        needs["warmth"] = clamp(needs["warmth"] - 0.2 * delta, 0.0, 100.0)

    if needs["hunger"] < 25.0:
        needs["health"] = clamp(needs["health"] - 0.4 * delta, 0.0, 100.0)
    if needs["thirst"] < 25.0:
        needs["health"] = clamp(needs["health"] - 0.7 * delta, 0.0, 100.0)
    if needs["fatigue"] < 10.0:
        needs["health"] = clamp(needs["health"] - 0.2 * delta, 0.0, 100.0)

func restore(name: String, value: float) -> void:
    if needs.has(name):
        needs[name] = clamp(needs[name] + value, 0.0, 100.0)

func consume(name: String, value: float) -> void:
    if needs.has(name):
        needs[name] = clamp(needs[name] - value, 0.0, 100.0)

func stats_summary() -> Dictionary:
    return needs.duplicate()
