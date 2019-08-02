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
- Mecânica de arma sem projétil, onde um raycast é utilizado para verificar o acerto, e já instancia a explosão no local de colisão.
- Tempo de recoil da arma e animação de hit onde o tiro acerta.
- Adicionado um inimigo utilizando o sistema de group para identificá-lo como "enemy", para que seja possível saber onde a bala acertou.
- Mais em breve...

Cena 1
![Cena 1](https://github.com/Doc-McCoy/godot_mechanics/blob/master/prints/print1.PNG)

Cena 2
![Cena 2](https://github.com/Doc-McCoy/godot_mechanics/blob/master/prints/print2.png)

Cena 3
![Cena 3](https://github.com/Doc-McCoy/godot_mechanics/blob/master/prints/print3.png)

Cena 4
![Cena 4](https://github.com/Doc-McCoy/godot_mechanics/blob/master/prints/print4.png)

*Assets utilizados:

- [Kenney](https://www.kenney.nl/assets/simplified-platformer-pack)*
- [Sound Bible](http://soundbible.com/)
