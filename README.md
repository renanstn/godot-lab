# Godot Mechanics Lab

[![Godot Engine](https://img.shields.io/badge/GODOT-%23FFFFFF.svg?style=flat&logo=godot-engine)](https://godotengine.org/)

All examples in this repo runs in Godot **v3.3.2**

# Description

This project contains a series of experiments, scripts and studies I've made in Godot through all this years.

Every [DemoScene](https://github.com/renanstn/godot-mechanics/tree/master/Mechanics%20Lab/DemoScenes) implements one mechanic I've created, or a mechanic existing in another game that I tried to replicate.

I hope you can use my scripts as an example or as a base for your studies in this amazing engine 😃

Enjoy! 👾

# Demo scenes

## 001 - Parallax Background

- No scripts required, you can make parallax effects in Godot only using the `ParallaxBackground` and `ParallaxLayer` nodes

![Parallax background example](Images/ParallaxBackground.gif)

## 002 - Look at Mouse Position

- It's simple to make a Node always "look" at the mouse position, just use the `look_at()` function

```gd
func _process(delta):
	look_at(get_global_mouse_position())
```

![Look at mouse example](Images/LookAtMouse.gif)

## 003 - Create Tilesets

- To create a tileset, create your Nodes in a separate scene, and convert the whole scene in menu `Scene -> Convert To -> TileSet`

![Scene tree tilemap](Images/SetupTileset.png)
![Create tilemap example](Images/CreateTileset.gif)

## 004 - Using Tilesets

- To use a tilemap to create your levels, add a `Tilemap` Node in your scene, and load the tileset created in last step

![Load your tileset](Images/LoadTileset.png)
![Using a tilemap example](Images/UsingTileset.gif)

## 005 - Basic Player

- This is the most simple and basic 2D platform player you can have. He can walk, he can jump, and have Idle, walking, and jumping animations. You can check the code [here](https://github.com/renanstn/godot-mechanics/blob/master/Mechanics%20Lab/Scripts/SimplePlayer.gd)

![Basic player example](Images/BasicPlayer.gif)

## 006 - Slow Motion Effect

- In this example, I tried to simulate a slow motion effect, just changing gradativally the `time_scale` value of the engine. You can check the code [here](https://github.com/renanstn/godot-mechanics/blob/master/Mechanics%20Lab/Scripts/SlowMotionEffect.gd)

![Slow motion effect example](Images/SlowMotionEffect.gif)

## 007 - Arcade Car 3D

- This example implements a 3D arcade race car mechanic. This technique uses a sphere to run all the physics, and visually replace the sphere for the car 3D model
- This technique I've learned from [this](https://kidscancode.org/godot_recipes/3d/3d_sphere_car/) amazing tutorial

![Arcade car example](Images/CarSphere.gif)

## 008 - Advanced Player

- In this new character script, gravity is not a fixed value randomly chosen by you. Instead, you set the blocks `UNIT_SIZE` of your tilemap, and all values will be calculated according to your blocks
- This way, it's easier to control how high (in blocks) and how much distance (in blocks) your character can reach in a jump
- Holding the "jump" button will make your character jump higher
- This player also had a `Tween` node to make some cool animations when you're jumping and when you're landing. You can configure how much the character will "deform" changing the "squash" value.
- And [here's the code](https://github.com/renanstn/godot-mechanics/blob/master/Mechanics%20Lab/Scripts/AdvancedPlayer.gd)

![Advanced player example](Images/AdvancedPlayer.gif)

## 009 - Boomerang

- A simple and smooth boomerang
- Go towards mouse click coordinates
- Always return to the player
- [Code here](https://github.com/renanstn/godot-mechanics/blob/master/Mechanics%20Lab/Scripts/Boomerang.gd)

**Tips and tricks**

- To get the direction (`Vector2`) between 2 positions (`Vector2`)

```gd
var direction = (target - start_position).normalized()
```

- To move your object towards this direction

```gd
position += direction.rotated(rotation) * speed * delta
```

- To calc the distance between 2 positions

```gd
var distance_to_target = position.distance_to(target)
```

![Boomerang example](Images/Boomerang.gif)

## 010 - The Messenger Jump

- In this demo, I tried to reproduce the "3 steps jump animation" used in [The Messenger](https://themessengergame.com/)
- This jump uses 3 animations, one when the character is upping, one when he's on top, and another when he's falling.
- I made this script to obtain this result

```gd

func animate():
    if !is_on_floor():
        if abs(motion.y) > JUMP / 2:
            if motion.y < 0:
                animator.play("Jump_up")
            else:
                animator.play("Jump_down")
        else:
            animator.play("Jump_roll")
```

![The Messenger jump example](Images/TheMessenger.gif)

## 011 - Rolling Ball

- With [this simple script](https://github.com/renanstn/godot-mechanics/blob/master/Mechanics%20Lab/Scripts/RollingBall.gd) you can control a rolling ball through a 2D scenario
- You can roll to the left, right, and you can jump

![Rolling ball example](Images/RollingBall.gif)

## 012 - Full screen Shader

- This is a simple example of a shader covering the whole screen
- How I make:
  - Add a `TextureRect` node
  - Add a simple [white image](https://github.com/renanstn/godot-mechanics/blob/master/Mechanics%20Lab/Sprites/white.png) as a texture to your `TextureRect` node
  - Check the `expand` option
  - Adjust the `rect` size to fill your whole window (you can check your window size in `Project → Project settings → Window`)
  - In `Material` section, add a `ShaderMaterial`
  - Load your shader
- For this example, I used [this](https://github.com/renanstn/godot-mechanics/blob/master/Mechanics%20Lab/Shaders/ScreenGlitch.shader) screen glitch shader
- You can find some amazing shaders ready to use in your game in [Godot Shaders](https://godotshaders.com/) website, or in [Shadertoy](https://www.shadertoy.com/)  (but shaders from Shadertoy need to be [converted](https://docs.godotengine.org/en/stable/tutorials/shading/migrating_to_godot_shader_language.html?highlight=shadertoy#shadertoy))

![Full screen shader example](Images/FullScreenShader.gif)

## 013 - Olija Spear

- In this example, I tried to reproduce the [Olija](https://olija.com/) spear effect
- You can throw your spear in any direction using the `Mouse Left`
- The spear sticks to any physic body it hits
- If you press `R`, you pick you spear back
- If you press `Mouse Right`, your character teleports to spear position
- You can check how I made this effect [here](https://github.com/renanstn/godot-mechanics/blob/master/Mechanics%20Lab/Scripts/SpearLauncher.gd)

![Olija spear example](Images/OlijaSpear.gif)

## 014 - Raycast Weapon

- A 2D raycast weapon, with some nice bullet trail, animation hit, and cartridge ejection effects
- Shoots in mouse direction
- Automatic and semi automatic modes
- Emit signals when it shoot, reload, hit, etc
- Shoot, reload, and empty bullets sounds
- Adjustable `damage`, `spread rate`, `recoil time`, `bullets` and `reload time`
- Script [here](https://github.com/renanstn/godot-mechanics/blob/master/Mechanics%20Lab/Scripts/RaycastWeapon.gd)

![Raycast weapon example](Images/RaycastWeapon.gif)

# Assets:

- [Kenney](https://www.kenney.nl/assets/simplified-platformer-pack)
- [The Spriters Resource](https://www.spriters-resource.com/)
- [Sound Bible](http://soundbible.com/)
- [Screen Glitch Shader](https://github.com/ashima/webgl-noise)
