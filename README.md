# Evolution AI — Godot 3.5 Prototype

A small runnable 3D prototype for autonomous survival, resource gathering, basic memory, fire/tool discovery, and a first shared settlement.

## Requirements and run

1. Install Godot 3.5 (the scripts use Godot 3.x APIs such as `Spatial`, `KinematicBody`, and `GLES3`).
2. Open this repository folder (`project.godot`) in Godot.
3. Run the project with **F6/F5** or select `godot_prototype/Scenes/Main.tscn` as the main scene.

The world is deliberately a prototype: its terrain and climate are simplified, resource interaction is local, and the technology experiments are rule-based demonstrations rather than general machine learning.

## Included systems

- Procedural-looking tiled terrain and randomly distributed food, water, wood, and stone.
- Day/time temperature and rain values.
- Autonomous inhabitants with hunger, thirst, fatigue, warmth, health, and simple decision priorities.
- Bounded event and resource memory.
- Fire discovery by finding wood and stone; tool crafting consumes nearby wood and stone.
- Community membership, shared resource stocks, and house construction after gathering sufficient materials.
- Observer HUD with population, weather, stocks, an agent's current goal, discoveries, and recent events.

## Project layout

```text
project.godot
README.md
godot_prototype/
  Scenes/Main.tscn
  Scripts/AI/Agent.gd
  Scripts/AI/CommunitySystem.gd
  Scripts/AI/DiscoverySystem.gd
  Scripts/AI/MemorySystem.gd
  Scripts/AI/NeedSystem.gd
  Scripts/AI/ToolSystem.gd
  Scripts/UI/CivilizationHUD.gd
  Scripts/World/WorldController.gd
```

## Limitations

This is a code foundation, not a complete civilization simulator. There is no animal ecosystem, saving/loading, pathfinding, real learning model, or population reproduction yet. Next, add test scenes and automated simulation checks before expanding the technology set.
