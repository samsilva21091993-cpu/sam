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

func _init() -> void:
    pass

func update(delta: float, weather: Dictionary) -> void:
    # Decaimento básico ao longo do tempo
    needs["hunger"] = clamp(needs["hunger"] - 1.2 * delta, 0.0, 100.0)
    needs["thirst"] = clamp(needs["thirst"] - 1.5 * delta, 0.0, 100.0)
    needs["fatigue"] = clamp(needs["fatigue"] - 0.8 * delta, 0.0, 100.0)
    needs["safety"] = clamp(needs["safety"] - 0.25 * delta, 0.0, 100.0)

    # Ajuste climático
    if weather.has("rain") and weather["rain"] > 0.6:
        needs["warmth"] = clamp(needs["warmth"] - 0.2 * delta, 0.0, 100.0)
    if weather.has("temperature") and weather["temperature"] < 15.0:
        needs["warmth"] = clamp(needs["warmth"] - 0.5 * delta, 0.0, 100.0)
    if weather.has("temperature") and weather["temperature"] > 32.0:
        needs["warmth"] = clamp(needs["warmth"] - 0.2 * delta, 0.0, 100.0)

    # Efeito da fome e sede
    if needs["hunger"] < 30.0:
        needs["health"] = clamp(needs["health"] - 0.4 * delta, 0.0, 100.0)
    if needs["thirst"] < 25.0:
        needs["health"] = clamp(needs["health"] - 0.7 * delta, 0.0, 100.0)

    # Recuperação de sono e segurança
    if needs["fatigue"] > 80.0:
        needs["health"] = clamp(needs["health"] - 0.2 * delta, 0.0, 100.0)

func restore(name: String, value: float) -> void:
    if needs.has(name):
        needs[name] = clamp(needs[name] + value, 0.0, 100.0)

func consume(name: String, value: float) -> void:
    if needs.has(name):
        needs[name] = clamp(needs[name] - value, 0.0, 100.0)

func get_priority() -> String:
    var strongest = "hunger"
    for key in needs.keys():
        if needs[key] < needs[strongest]:
            strongest = key
    return strongest

func stats_summary() -> Dictionary:
    return {
        "hunger": needs["hunger"],
        "thirst": needs["thirst"],
        "fatigue": needs["fatigue"],
        "safety": needs["safety"],
        "warmth": needs["warmth"],
        "health": needs["health"]
    }
