Claro! Aqui está um README estilizado para o GitHub em duas línguas, PT-BR e EN-US, para o projeto QBxCore PvP Script.

## 🇺🇸 English

### Description
This project adds a PvP (Player vs Player) system to a FiveM server using the QBCore framework. Players can interact with a designated NPC to participate in battles within a specific PvP arena.

### Features
- **NPC Interaction:** Players can interact with an NPC to join PvP battles.
- **PvP Arena:** A dedicated area where players fight each other.
- **Weapon Distribution:** Players receive pre-configured weapons when entering the arena.
- **Queue System:** Manages multiple players entering the arena.
- **Customizable Settings:** Configure NPC location, arena, items, and messages.

### Requirements
- FiveM server with QBCore installed.
- ox_target for NPC interactions.

### Installation
Clone the repository:
```bash
git clone https://github.com/developerthug/QBxCore-PvP-Script.git npc-pvp
```
Add to `server.cfg`:
```ruby
ensure npc-pvp
```

### Configuration
Edit `config.lua` to adjust:
- **NPC Coordinates:** Define where the NPC will appear.
- **Arena Location:** Set the PvP battle area.
- **Item Distribution:** Configure the weapons and items given to players.
- **Custom Messages:** Change the texts displayed in-game.

### Usage
- **Interact with the NPC:** Approach the NPC and press `E`.
- **Enter the Arena:** Select the PvP option from the menu.
- **Exit the Arena:** Use `/sairpvp` in chat to leave.

### Contributing
Contributions are welcome! Feel free to open issues for bug reports or feature suggestions. Pull requests are encouraged.

### License
This project is licensed under the MIT License. See the LICENSE file for more details.

## 🇧🇷 Português (PT-BR)

### Descrição
Este projeto adiciona um sistema de PvP (Player vs Player) a um servidor FiveM utilizando o framework QBCore. Os jogadores podem interagir com um NPC específico para participar de batalhas dentro de uma arena PvP designada.

### Funcionalidades
- **Interação com NPC:** Os jogadores podem interagir com um NPC para entrar em batalhas PvP.
- **Arena PvP:** Uma área exclusiva onde os jogadores se enfrentam.
- **Distribuição de Armas:** Os jogadores recebem armas configuradas ao entrar na arena.
- **Sistema de Fila:** Gerencia múltiplos jogadores entrando na arena.
- **Configurações Personalizáveis:** Permite configurar localização do NPC, arena, itens e mensagens.

### Requisitos
- Servidor FiveM com QBCore instalado.
- ox_target para interação com NPCs.

### Instalação
Clone o repositório:
```bash
git clone https://github.com/developerthug/QBxCore-PvP-Script.git npc-pvp
```
Adicione ao `server.cfg`:
```ruby
ensure npc-pvp
```

### Configuração
Edite `config.lua` para ajustar:
- **Coordenadas do NPC:** Defina onde o NPC aparecerá.
- **Local da Arena:** Configure a área de batalha PvP.
- **Distribuição de Itens:** Escolha as armas e itens fornecidos aos jogadores.
- **Mensagens Personalizadas:** Modifique os textos exibidos no jogo.

### Uso
- **Interagir com o NPC:** Aproxime-se do NPC e pressione `E`.
- **Entrar na Arena:** Escolha a opção de PvP no menu.
- **Sair da Arena:** Use `/sairpvp` no chat para sair.

### Contribuição
Contribuições são bem-vindas! Sinta-se à vontade para abrir issues para relatar bugs ou sugerir melhorias. Pull requests são encorajados.

### Licença
Este projeto está licenciado sob a Licença MIT. Consulte o arquivo LICENSE para mais detalhes.

Pronto! Esse README.md está detalhado e pronto para uso no repositório. Caso queira ajustes ou mais informações, é só avisar! 🚀
