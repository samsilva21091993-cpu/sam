# Evolution AI — Protótipo em Godot 3.5

## Visão geral

Este projeto é uma adaptação do conceito "Evolution AI" para uma engine mais acessível e prática para prototipagem rápida: Godot 3.5.

O objetivo é criar um simulador de civilização emergente em mundo aberto, em que uma inteligência artificial começa em um estado primitivo e evolui de forma autônoma através de aprendizado, memória, experimentação e tomada de decisão.

O foco inicial não é construir um jogo com todas as tecnologias futuristas de uma vez. O objetivo do primeiro ciclo é entregar um protótipo jogável, funcional e testável, que demonstre a lógica de sobrevivência, necessidades humanas, AI primitiva e evolução tecnológica inicial.

## Por que Godot 3.5?

Godot 3.5 é uma escolha sensata para um protótipo desta escala porque oferece:

- pipeline de desenvolvimento rápido
- editor acessível e leve
- suporte forte para 2D e 3D em protótipos
- scripting em GDScript, excelente para IA e sistemas de simulação
- boa produtividade para projetos de pesquisa, experimentação e iteração rápida

Para a primeira fase, priorizamos clareza, velocidade e testes reais sobre máxima fidelidade gráfica.

## Escopo do protótipo

### MVP funcional

1. Mundo procedural simples
2. Ciclo climático básico
3. Recursos naturais
4. Animais e vegetação básica
5. Primeiros habitantes
6. Necessidades humanas: fome, sede, sono, abrigo, segurança
7. IA básica com memória e objetivos
8. Primeiras descobertas: fogo, ferramentas, abrigo, coleta
9. Construções iniciais e sistemas sociais primitivos
10. Painel de observação da civilização

### Fase 2

- agricultura simples
- domesticação básica
- população crescente
- divisão de tarefas
- casas e aldeias
- tecnologia de metal e ferramentas melhores

### Fase 3

- indústria básica
- energia simples
- transporte e logística
- cidades e especialização
- sistemas de ciência e descoberta

### Fase 4

- era tecnológica
- automação
- robótica leve
- sistemas de cidade inteligente
- exploração espacial e futuro distante

## Arquitetura conceitual

### 1. Mundo

- geração procedural de terreno básico
- biomas: planície, floresta, deserto, montanha, água, pântano
- clima variável: sol, chuva, tempestade, calor, frio
- recursos: madeira, pedra, água, comida, metal bruto, plantas

### 2. Ecossistema

- fauna simples: herbívoros, predadores, insetos e peixes
- vegetação procedimental
- ciclo de reprodução, fome e sobrevivência
- dinâmica de caçada, fuga, alimentação e morte

### 3. Habitantes

Cada agente terá atributos:

- fome
- sede
- sono
- temperatura corporal
- saúde
- segurança
- energia
- felicidade/socialização
- conhecimento
- memória

E também:

- nome
- personalidade básica
- habilidades iniciais
- histórico de experiências
- objetivos atuais

### 4. IA autônoma

A IA será composta por módulos:

- percepção
- memória curto prazo
- memória longo prazo
- necessidades
- objetivos
- planejamento
- execução
- aprendizado por tentativa e erro
- registro de descobertas

A lógica não deve ser uma árvore tecnológica rígida. Em vez disso, a IA deve:

- analisar o ambiente
- identificar problemas
- escolher ações por necessidade
- testar combinações
- registrar sucesso/falha
- aprender com experiências
- ajustar seus objetivos

### 5. Sistema de tecnologia

A tecnologia será baseada em requisitos e descobertas, não em uma linha fixa.

Exemplo:

- encontrar pedra + observar corte = possibilidade de ferramenta simples
- observar faísca + madeira seca = começo de fogo
- abrigos = proteção contra frio e predadores
- recursos vegetais = possibilidade de agricultura

Cada descoberta deve gerar um novo conhecimento que pode ser reutilizado em futuras decisões.

## Estrutura do projeto sugerida

```text
project/
  README.md
  docs/
    roadmap.md
    architecture.md
    ai_design.md
  src/
    autoload/
    core/
    world/
    entities/
    ai/
    economy/
    ui/
    save/
  assets/
    terrain/
    characters/
    props/
    ui/
  tests/
    test_ai_basic.gd
    test_world_generation.gd
```

## Sistema de decisão da IA

A IA ideal em protótipo deve operar com uma máquina simples de estados.

### Exemplo de fluxo

1. Atualiza necessidades.
2. Observa ambiente.
3. Avalia riscos e oportunidades.
4. Decide prioridade.
5. Cria ação ou objetivo.
6. Executa e registra resultado.
7. Atualiza memória.
8. Ajusta comportamento.

### Prioridades básicas

- sobrevivência
- abrigo
- alimento
- água
- segurança
- reprodução
- conhecimento
- desenvolvimento social

## MVP técnico

### World generation

- terreno 3D simples com ruído procedural
- altitude e vegetação baseadas em altura
- rios e lagos básicos
- temperatura e umidade por região

### Agents

- NPCs simples com locomação, interação e inteligência básica
- vários agentes simultâneos em LOD reduzido
- estado de simulação em tempo real

### UI

- população atual
- recursos disponíveis
- tecnologia em desenvolvimento
- objetivos ativos
- histórico de decisões
- log de descobertas
- painel do cérebro da civilização

## Desenvolvimento por etapas

### Etapa 1 — protótipo base

- terrain procedural
- clima básico
- recursos e animais simples
- 10 a 30 habitantes
- necessidades básicas
- IA primitiva

### Etapa 2 — sobrevivência e técnica inicial

- coleta
- abrigo
- fogo
- ferramentas simples
- memória de experiências
- primeiros registros

### Etapa 3 — comunidade

- casas
- divisão de tarefas
- aldeia
- crescimento populacional
- comércio simples

### Etapa 4 — civilização inicial

- agricultura básica
- ferramentas metálicas simples
- energia primitiva
- produção e armazenamento

### Etapa 5 — expansão futura

- automação
- cidade inteligente
- ciência e pesquisa
- transporte e infraestrutura
- exploração externa

## Regras de prioridade

Para a primeira entrega, deve valer:

- simulador funcional
- IA com comportamento real e objetivo
- aprendizado verificável
- população evoluindo autonomamente
- descoberta emergente

Não priorizar ainda:

- gráficos ultra-realistas
- renderização massiva de todos os habitantes
- enorme quantidade de biomas exóticos
- sistemas complexos demais para provar o conceito

## Critérios de sucesso do protótipo

O primeiro protótipo será considerado bem-sucedido se:

- a população conseguir sobreviver por tempo suficiente
- a IA tomar decisões reais de acordo com necessidades
- houver memória persistente de experiências
- ocorram descobertas e melhorias em sequência natural
- a civilização evolua sem scripts rígidos
- o observador consiga acompanhar decisões, objetivos e progresso

## Próximo passo recomendado

O próximo passo prático é montar a estrutura do projeto e implementar a fase 1 em Godot 3.5, com:

1. terreno procedural simples
2. agentes com necessidades
3. coleta, fome e abrigo
4. IA de planejamento básica
5. logs de decisões e descoberta
6. protótipo de painel de observação

## Conclusão

A ideia central do projeto não é "mostrar uma evolução bonita". A ideia é demonstrar uma civilização que aprende e cria seu próprio caminho.

Em Godot 3.5, o foco deve ser construir uma base sólida para essa autonomia, validando a lógica de sobrevivência, memória, descoberta e civilização antes de escalar para um mundo maior e mais complexo.

Este repositório agora inicia com esse direcionamento técnico e com a base para a construção do protótipo.


---

Projeto em desenvolvimento.
A arquitetura e a roadmap podem ser refinadas em iterações futuras.
