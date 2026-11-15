extends CanvasLayer

var stats_label: Label
var goal_label: Label
var discovery_label: Label
var history_label: Label
var _refresh_timer: float = 0.0

func _ready() -> void:
    var panel = Panel.new()
    panel.rect_position = Vector2(12, 12)
    panel.rect_size = Vector2(350, 260)
    add_child(panel)

    var margin = MarginContainer.new()
    margin.anchor_right = 1.0
    margin.anchor_bottom = 1.0
    margin.set("custom_constants/margin_left", 12)
    margin.set("custom_constants/margin_top", 10)
    margin.set("custom_constants/margin_right", 12)
    margin.set("custom_constants/margin_bottom", 10)
    panel.add_child(margin)

    var column = VBoxContainer.new()
    margin.add_child(column)
    var title = Label.new()
    title.text = "CÉREBRO DA CIVILIZAÇÃO"
    column.add_child(title)
    stats_label = Label.new()
    column.add_child(stats_label)
    goal_label = Label.new()
    column.add_child(goal_label)
    discovery_label = Label.new()
    column.add_child(discovery_label)
    history_label = Label.new()
    history_label.rect_min_size.y = 80
    column.add_child(history_label)

func _process(delta: float) -> void:
    _refresh_timer -= delta
    if _refresh_timer > 0.0:
        return
    _refresh_timer = 0.5

    var world = get_parent()
    if world == null:
        return
    var weather = world.get_weather_state()
    var community = world.get_community_system().get_summary()
    stats_label.text = "População: %d | Casas: %d\nClima: %.1f°C | Chuva: %.2f\nEstoque — comida %.0f, madeira %.0f, pedra %.0f" % [
        world.get_population_count(), community["houses"], weather["temperature"], weather["rain"],
        community["food"], community["wood"], community["stone"]
    ]

    var agents = world.get_agents()
    var first = null
    for agent in agents:
        if is_instance_valid(agent):
            first = agent
            break
    if first == null:
        goal_label.text = "Sem habitantes ativos."
        discovery_label.text = "Descobertas: nenhuma"
        history_label.text = "Histórico vazio."
        return

    goal_label.text = "%s (%s)\nObjetivo: %s\nFome %.0f | Sede %.0f | Saúde %.0f" % [
        first.agent_name, first.role, first.current_goal,
        first.needs.needs["hunger"], first.needs.needs["thirst"], first.needs.needs["health"]
    ]
    discovery_label.text = "Descobertas: %s" % str(first.memory.discovered_techniques)
    var events = first.memory.recent_events
    var lines = []
    for i in range(max(0, events.size() - 3), events.size()):
        lines.append("• " + events[i]["message"])
    history_label.text = "Histórico:\n" + "\n".join(lines)
