# Godot Mechanics

*Este repositório trata-se de um projeto de exemplo onde eu utilizo todas as mecânicas que já desenvolvi na GodotEngine. Para fins de consultas futuras.*

Mecânicas implementadas até agora:
> Cena 1
- Movimentação básica em plataforma
- Animação básica do personagem
- Câmera seguindo player + efeito de olhar um pouco à frente do mesmo
- Emissão e conexão de **signals** entre scripts e objetos
- Objeto sempre olhando na direção do **mouse**
- Fundo parallax em camadas
- Efeito de **Slow Motion**
- Efeito de **voltar no tempo**
> Cena 2
- Mecânica de pulo que faz com que o player vá mais alto se **segurar o botão**, ou mais baixo se **soltar o botão**
- Nova forma de programar pulo/gravidade, que utiliza fórmulas para tornar mais fácil o controle de movimento e de pulo. O valor da gravidade e do mov_speed passam a ser dinâmicos de acordo com a configuração de pulo/movimentação escolhida.
> Cena 3
- Mecânica onde você controla uma bola, e aplica aceleração ou desaceleração a ela.
- Função de pulo baseada em raycast para verificar se a bola está no chão.
> Cena 4
- Mecânica de arma sem projétil, onde um raycast é utilizado para verificar o acerto, e já instancia a animação de hit no local de colisão.
- Tempo de cooldown da arma e animação de hit onde o tiro acerta.
- Adicionado um inimigo utilizando o sistema de group para identificá-lo como "enemy", para que seja possível saber onde a bala acertou.
- Adicionado um efeito de "rastro", uma linha que indica a direção que a bala percorreu. O rastro some rapidamente. Para isso foi utilizado uma função de **setup** na cena do rastro que recebe como argumento a posição inicial e final do mesmo.
> Cena 5 - **Steering Behaviours**
- Steering Behaviours são scripts que visam ajudar NPCs autônomos a se movimentarem de maneira mais realista. Os seguintes movimentos podem ser implementados com esses scripts:
  - Perseguir
  - Fugir
  - Vagar aleatoriamente
  - Perseguir e Evadir com maior "inteligência", considerando o movimento do player para fazer antecipações
  - Evitar colisão
  - Seguir caminho pré-definido
  - Seguir líder
  - Fazer fila
  - Flocking (comportamento de bando)
- Steering Behaviour Seek e Flee implementados. O NPC persegue ou foge do ponteiro do mouse.
- Comentados no código algumas diferenças entre as versões 2 e 3 da Godot.
- Mais em breve...


![Cena 1](https://github.com/Doc-McCoy/godot_mechanics/blob/master/prints/print1.PNG)
![Cena 2](https://github.com/Doc-McCoy/godot_mechanics/blob/master/prints/print2.png)
![Cena 3](https://github.com/Doc-McCoy/godot_mechanics/blob/master/prints/print3.png)
![Cena 4](https://github.com/Doc-McCoy/godot_mechanics/blob/master/prints/print4.png)


*Assets utilizados:

- [Kenney](https://www.kenney.nl/assets/simplified-platformer-pack)*
- [Sound Bible](http://soundbible.com/)
