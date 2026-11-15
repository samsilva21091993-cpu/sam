# Arquitetura Técnica do Protótipo em Godot 3.5

## Visão geral

A arquitetura do projeto deve ser modular e escalável, mantendo a lógica central em scripts Godot e separando responsabilidades por domínio.

## Camadas principais

### 1. World

Responsável pela geração do terreno, clima e recursos.

Módulos:

- TerrainGenerator
- WeatherSystem
- ResourceSpawner
- BiomeManager

### 2. Entities

Responsável por todos os agentes vivos.

Módulos:

- AgentBase
- HumanAgent
- AnimalAgent
- WorkerAgent
- BuilderAgent

### 3. AI

Responsável pela percepção, planejamento e aprendizagem.

Módulos:

- PerceptionSystem
- NeedSystem
- MemorySystem
- GoalPlanner
- DiscoverySystem
- LearningSystem

### 4. Civilization

Responsável por população, cultura e progresso.

Módulos:

- PopulationManager
- SocietyManager
- TechnologyManager
- DiscoveryLog
- BuildManager

### 5. UI

Responsável pela interface do observador.

Módulos:

- CivilizationPanel
- LogPanel
- BrainPanel
- WorldStatsPanel

### 6. SaveSystem

Responsável pela persistência do estado do mundo.

Módulos:

- SaveGame
- LoadGame
- WorldStateSerializer

## Estrutura de dados

### NeedState

- hunger
- thirst
- fatigue
- safety
- warmth
- health
- social
- knowledge

### AgentMemory

- recent_events
- landmark_memory
- resource_positions
- known_dangers
- discovered_techniques

### DiscoveryRecord

- name
- conditions
- result
- confidence
- timestamp

## Regras de design

- a lógica de IA deve ser regra-based com memória e aprendizado leve
- cada agente deve ter status próprios e decisões dependentes do contexto
- a tecnologia deve ser descoberta por tentativa e erro, não por árvore rígida
- o mundo deve continuar evoluindo mesmo sem input do jogador
- o observador deve ser capaz de monitorar o estado geral da civlização

## Recomendação para implementação inicial

Para o MVP, priorizar:

- 3D simples com terreno e instâncias básicas
- agentes com relações de necessidade
- coleta e abrigo
- nomes, objetivos e registros
- tubo de logs e objetivos ativos
- testes focados em sobrevivência e descoberta

## Princípio central

A evolução deve ser emergente.

Não é suficiente um sistema de "upgrade automático". O núcleo do projeto deve mostrar que os agentes aprendem com o mundo, experimentam, erram, ajustam objetivos e constroem uma civilização organicamente.


---

Documentação técnica inicial.
