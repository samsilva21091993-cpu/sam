extends CanvasLayer

onready var population_label = $Panel/Margin/Stats/Population
onready var goal_label = $Panel/Margin/Stats/Goal
onready var danger_label = $Panel/Margin/Stats/Danger
onready var discovery_label = $Panel/Margin/Stats/Discovery

func _ready() -> void:
    set_process(true)

func _process(delta: float) -> void:
    if get_parent() and get_parent().has_method("get_population_count"):
        population_label.text = "População: %d" % get_parent().get_population_count()

    if get_parent() and get_parent().has_method("get_weather_state"):
        var weather = get_parent().get_weather_state()
        danger_label.text = "Clima: %.1f°C / Chuva: %.2f" % [weather["temperature"], weather["rain"]]

    if get_parent() and get_parent().has_method("get_agents"):
        var agents = get_parent().get_agents()
        if agents.size() > 0:
            var first = agents[0]
            goal_label.text = "Objetivo atual: %s" % first.current_goal
            discovery_label.text = "Técnicas: %s" % str(first.memory.discovered_techniques)
