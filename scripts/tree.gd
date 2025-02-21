extends Node2D

const ROOM_SPACING_X = 300
const ROOM_SPACING_Y = 300
const MAX_HEIGHT = 15
const CHAR_SPACING = Vector2(20, 0)

var node_scene = preload("res://scenes/room.tscn")
var fv
var root: Node2D
var current_room_node: Node2D
var height = 1
var battle_scene
var is_in_battle := false

@onready var hero = get_node("../Hero")
@onready var villain = get_node("../Villain")
@onready var camera = get_node("../PlayerCamera")
@onready var ar = get_node("../CanvasLayer/Ar")
@onready var fogo = get_node("../CanvasLayer/Fogo")
@onready var agua = get_node("../CanvasLayer/Agua")
@onready var raio = get_node("../CanvasLayer/Raio")
@onready var terra = get_node("../CanvasLayer/Terra")
@onready var elements_assets = [fogo, agua, ar, terra, raio]


# Textos específicos para cada altura par
var textos_por_altura = {
	2: "Capítulo 1: O prólogo
		Tempos sombrios se alastram por todo o reino, forças superiores aproveitam-se de seus poderes para espalhar males por toda a população...",
	4: "Capítulo 2: O chamado
		Como uma última opção, o último mensageiro de Renova Éden, o reino dos últimos primordiais, foi enviado pela corte, antes de seu 
		Rei Jafé, filho de Noé, descendente de Adão, ser amaldiçoado e capturado pelo mal superior...",
	6: "Capítulo 3: Guerra
		200 anos. Amaldiçoados por uma eterna e falsa esperança de vitória, após 200 anos do início da guerra, as tropas de Renova Éden começam a ceder. 
		Culminados pela dor, todos os miseráveis sobreviventes sabem que o último resquício de mudança... depende da profecia.",
	8: "Capítulo 4: A profecia
		Rez a lenda que em um futuro próximo, um herói despertará a Honra do Elysium, herdada por aqueles dignos e merecedores...",
	10: "Capítulo 5: Motivações
		O mal superior, Erebus, deus da região escura do submundo, conhecia as histórias sobre tal figura heroica. 
		Perturbado pela insegurança, ele enviou todas as suas tropas para o reino mais provável de possuir a Honra do Elysium. 
		Guiado pela ganância, uma vontade inexplicável por dominação e poder, sua única opção era um massacre...",
	12: "Capítulo 6: Despertar
		O mensageiro tinha uma missão: chegar ao Oráculo de Júpiter, afim de alcançar aquele que herdaria a vontade e a honra dos descendentes de Adão. 
		Sua resposta: o filho pródigo. Atraído pela avareza, cegado pela herança e inconsciente de suas capacidades, Perseu, 
		o filho que abandonou suas obrigações para viver no luxo, despreocupadamente, recebeu em forma de visões, o pedido do último mensageiro. 
		Guiado pela angustia de ter fugido por toda a sua vida, ele parte em busca de libertar o reino.",
	14: "Capítulo 7: Bem e Mal
		Inimigos derrotados, desafios superados. Porém, um formidável rival o espera... o último cavaleiro de Erebus. 
		O que é essa sensação de piedade? O que incomoda nosso herói? Por que o próximo combate parece tão difícil, tão distante, tão... pessoal?",
	16: ["Capítulo 8: A verdade

		*A figura de Erebus aparece e o último capítulo é um diálogo*",
		"Erebus: Muito bem... herói. Você passou por todas as salas da masmorra, venceu todos que estavam no seu caminho",

		"Herói: É isso mesmo, seu deus egoísta. Eu vim acabar com esses seus jogos de dominação. Depois de tanta destruição, não espere um pingo sequer de piedade de mim!",

		"Erebus: HAHAHAHAHA! VOCÊ NÃO ENTENDE MESMO, NÃO É!? Uma criança que tinha tudo: família, casa, conforto... mas mesmo assim, 
		você decidiu ir embora e deixar tudo isso de lado, simplesmente porque mais riquezas, mais poder... era tentador, não era? 
		E você ainda acha que tem o direito de me julgar!",

		"Herói: Eu não me importo com o que você pensa, eu errei no passado e vim compensar todas as minhas falhas! Você perdeu!",


		"Erebus: Isso é sempre divertido, esse diálogo fica cada vez melhor!",

		"Herói: Como assim? Que diálogo, seu maldito!?",

		"Erebus: O diálogo o qual eu finalmente revelo que você não passa de uma peça no meu teatro. O diálogo em que você descobre que tudo isso é só um passatempo para mim. 
		Você realmente não tem nenhuma ideia do porquê o seu 'rival' era tão parecido com você? HAHAHAHAHAHA! Você nunca foi o único a despertar a Honra do Elysium. 
		Outro antes de você tentaram, várias e várias vezes. O primeiro candidato a me derrotar me divertiu tanto, que eu decidi usá-lo como marionete para estimular o próximo.
		Pode demorar quantos anos, ou até mesmo séculos para nascer outro, mas sempre que alguém desperta a Honra, eu envio um dos meus lacaios, disfarçado de mensageiro do reino, 
		para chamá-lo até aqui. HAHAHAHAHAHA! ISSO SEMPRE ME ANIMA",

		"Herói: O QUE!? Como isso... então eu...",

		"Erebus: Sim, isso mesmo, você não é capaz de nada, a vida não é uma peça em que o vilão sempre perde no final. 
		Mas chega de conversa, a partir daqui, você é só mais um dos meus soldados, e irá aguardar o próximo candidato chegar para tirar a sua vida, 
		e consequentemente, me divertir um pouco mais... Adeus."]
}


func _ready():
	fv = FontVariation.new()
	fv.set_base_font(load("res://assets/Minecraft.ttf"))
	root = node_scene.instantiate()
	root.initialize(Vector2(400, 100), 1)
	root.get_node("Button").disabled = true
	add_child(root)
	current_room_node = root
	hero.history.append(current_room_node)
	update_elements(hero, root.room_element)
	#update_elements(villain, root.room_element)
	hero.position = root.position - CHAR_SPACING
	villain.room = root
	villain.history.append(current_room_node)
	villain.position = root.position + CHAR_SPACING
	camera.position = root.position
	generate_tree(root)
		

func generate_tree(node):
	if height == MAX_HEIGHT:  
		var final_room = node_scene.instantiate()
		final_room.initialize(Vector2(root.position.x, node.position.y+ROOM_SPACING_Y), height)
		draw_connection(node.position, final_room.position, Color(1, 1, 1))
		final_room.get_node("Button").pressed.connect(_on_button_pressed_from_node_scene.bind(final_room))
		add_child(final_room)
		camera.position = Vector2(root.position.x, node.position.y+ROOM_SPACING_Y)
		final_room.connect("battle_ended", _on_battle_ended)
		final_room.connect("game_over", _on_game_over)
		return

	var child_positions = []
	var y_position = node.position.y + ROOM_SPACING_Y
	var orders := []
	
	hero.history.append(node)

	# Calcula as posições dos filhos com base na estrutura do nível
	if height == 1:
		# Primeiro ramo com duas salas (tipo 1)
		child_positions = [
			node.position + Vector2(-ROOM_SPACING_X, ROOM_SPACING_Y),
			node.position + Vector2(ROOM_SPACING_X, ROOM_SPACING_Y)
		]
		orders = ["Left", "Right"]
	else:
		# Níveis subsequentes (Tipo 2)
		child_positions = [
			Vector2(root.position.x-ROOM_SPACING_X, (height) * ROOM_SPACING_Y + root.position.y),
			Vector2(root.position.x, (height)*ROOM_SPACING_Y + root.position.y),
			Vector2(root.position.x+ROOM_SPACING_X, (height) * ROOM_SPACING_Y + root.position.y)
		]
		orders = ["Left", "Middle", "Right"]

	# Cria e conecta os nós filhos
	for pos in child_positions:
		var child = node_scene.instantiate()
		child.initialize(pos, height, orders.pop_front())
		# villain.room.children.append(child)
		node.children.append(child)
		child.get_node("Button").pressed.connect(_on_button_pressed_from_node_scene.bind(child))
		add_child(child)

	
	# Linhas para nós que não podem ser alcançados
	for child in node.children:
		draw_connection(node.position, child.position, Color(0.4, 0.4, 0.4))
	
	for child in current_room_node.children:
		draw_connection(current_room_node.position, child.position, Color(0.4, 0.4, 0.4))
	
	for i in range(0, len(hero.history)-1):
		draw_connection(hero.history[i].position, hero.history[i+1].position, Color(0, 0, 1))
	
	for i in range(0, len(villain.history)-1):
		draw_connection(villain.history[i].position, villain.history[i+1].position, Color(1, 0, 0))
	
	# Linhas para nós que podem ser alcançados
	match node.order:
		"Left":
			draw_connection(node.position, node.children[0].position)
			draw_connection(node.position, node.children[1].position)
			if len(node.children) > 2:
				node.children[2].get_node("Button").disabled = true
		"Middle":
			draw_connection(node.position, node.children[0].position)
			if len(node.children) == 3:
				draw_connection(node.position, node.children[2].position)
				node.children[1].get_node("Button").disabled = true
			else:
				draw_connection(node.position, node.children[1].position)
		"Right":
			draw_connection(node.position, node.children[1].position)
			draw_connection(node.position, node.children[2].position)
			if len(node.children) > 2:
				node.children[0].get_node("Button").disabled = true
	
	# Verifica se a altura é par e exibe o texto correspondente
	if height % 2 == 0:
		var texto = textos_por_altura.get(height, "Mensagem padrão para altura par.")
		await display_text_box(texto)  # Usa await para garantir que o diálogo seja exibido antes de continuar

	
	current_room_node = node


# Desenha uma linha para representar uma conexão
func draw_connection(from_position: Vector2, to_position: Vector2, color: Color = Color(1, 1, 1)):
	var line = Line2D.new()
	line.default_color = color
	line.add_point(from_position)
	line.add_point(to_position)
	line.show_behind_parent = true
	add_child(line)


# Limpa a cena antes de renderizar o próximo conjunto de salas
func clear_scene():
	for child in get_children():
		child.queue_free()


func update_elements(entity: Node2D, element: int) -> void:
	if element >= 1 and element <= 5:
		var index = element - 1
		entity.elements[index] = min(entity.elements[index] + 1, 4)
		
		if entity == hero:
			elements_assets[index].set_frame(hero.elements[index])
		print("Entity elements: ", entity.elements)
	else:
		print("Element out of range.")


# Exibe uma caixa de texto com um fundo retangular
func display_text_box(text: String):
	# Pausa o jogo
	get_tree().paused = true

	# Cria um fundo retangular
	var background = ColorRect.new()
	background.color = Color(0, 0, 0, 0.8)  # Preto com 80% de opacidade
	background.size = Vector2(1400, 250)  # Tamanho do retângulo
	background.position = Vector2(hero.position.x - 700, hero.position.y - 400)  # Posição do retângulo (ajuste conforme necessário)
	add_child(background)

	# Cria o texto
	var label = Label.new()
	label.text = text + "\n\n\n(Pressione espaço para avançar)"
	label.add_theme_font_override("font", fv)
	label.modulate = Color(1, 1, 1)  # Cor do texto (branco)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER  # Centraliza o texto horizontalmente
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER  # Centraliza o texto verticalmente
	label.size = background.size  # Faz o texto ocupar o mesmo espaço do fundo
	background.add_child(label)

	# Espera o jogador pressionar a tecla de espaço
	await get_tree().create_timer(0.1).timeout  # Pequeno delay para evitar leitura imediata do input
	while true:
		if Input.is_action_just_pressed("ui_accept"):  # "ui_accept" é geralmente mapeado para a tecla de espaço
			background.queue_free()
			break
		await get_tree().process_frame  # Espera o próximo frame
	
	# Retoma o jogo
	get_tree().paused = false


# Função chamada quando o botão de uma sala é pressionado
func _on_button_pressed_from_node_scene(node: Node2D):
	if !is_in_battle:
		height += 1
		camera.position = node.position

		# Boss
		if (node.height == MAX_HEIGHT):
			villain.room = node
			villain.position = node.position + CHAR_SPACING
			hero.position = node.position - CHAR_SPACING

		# Normal rooms
		else:
			hero.position = node.position
			var available_rooms := []
		
			for room in current_room_node.children:
				print(room)
				if room != node:
					available_rooms.append(room)

			villain.room = villain.pick_room(available_rooms, hero.elements)
			villain.position = villain.room.position + CHAR_SPACING
			villain.history.append(villain.room)
			update_elements(villain, villain.room.room_element)
			update_elements(hero, node.room_element)
			for child in get_children():
				if child.has_node("Button"):
					child.get_node("Button").disabled = true
			await generate_tree(node)

		#for child in node.children:
		#	child.get_node("Button").disabled = true

		battle_scene = load("res://scenes/battle_scene.tscn").instantiate()
		get_tree().root.add_child(battle_scene)
		battle_scene.initialize(hero, node.height, villain)
		battle_scene.position.y = node.position.y-ROOM_SPACING_Y
		camera.position = Vector2(root.position.x, node.position.y+ROOM_SPACING_Y/2)
		is_in_battle = true
		battle_scene.connect("battle_ended", _on_battle_ended)
		battle_scene.connect("game_over", _on_game_over)


func _on_battle_ended():
	is_in_battle = false
	get_tree().root.remove_child(battle_scene)
	
	print("HEIGHT: ", height)

	if((height-1) == MAX_HEIGHT):
		print("AAAA")
		get_tree().change_scene_to_file("res://scenes/ending.tscn")


func _on_game_over():
	get_tree().root.remove_child(battle_scene)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
