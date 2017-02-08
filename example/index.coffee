{extend} = Phaser.Utils

emitterMethods =
  explodeWithMaxParticles: -> @explode @lifespan, @maxParticles
  flowWithDefaultArgs:     -> @flow()
  flowWithQuantity:        -> @flow      @lifespan, @frequency, 10
  startFlow:               -> @start no, @lifespan, @frequency
  startForceQuantity:      -> @start no, @lifespan, @frequency, @maxParticles, yes

emitter = null

gui = null

preload = ->
  game.load.baseURL = 'http://examples.phaser.io/assets/'
  game.load.crossOrigin = 'anonymous'
  game.load.image 'bubble', 'particles/bubble.png'
  game.load.image 'water', 'skies/sunset.png'
  return

create = ->
  {debug} = game

  debug.font = '16px monospace'
  debug.lineHeight = 25

  game.add.image 0, 0, 'water'
  #	Emitters have a center point and a width/height, which extends from their center point to the left/right and up/down
  emitter = game.add.emitter game.world.centerX, 200, 100
  emitter.name = 'bubbles'
  #	This emitter will have a width of 400px, so a particle can emit from anywhere in the range emitter.x += emitter.width / 2
  emitter.width = 400
  emitter.height = 64
  emitter.makeParticles 'bubble'
  emitter.minParticleSpeed.set 0, 300
  emitter.maxParticleSpeed.set 0, 400
  emitter.setRotation 0, 0
  emitter.setAlpha 0.3, 0.8
  emitter.setScale 0.5, 0.5, 1, 1
  emitter.gravity = -200

  emitter.flow emitter.lifespan, emitter.frequency
  # emitter.start false, 5000, 100
  # emitter.explode 2000, emitter.length

  extend emitter, emitterMethods
  createGui()
  return

shutdown = ->
  gui.destroy()
  return

render = ->
  game.debug.emitter      emitter
  game.debug.emitterInfo  emitter, 20, 40
  game.debug.emitterTotal emitter, 0,  580, game.width, 20
  debugText "game.debug.emitter(emitter)", emitter.left, -5 + emitter.top
  debugText "game.debug.emitterInfo(emitter, x, y)", 0, 20
  debugText "game.debug.emitterTotal(emitter, x, y)", 0, 570
  return

createGui = ->
  gui = new dat.GUI width: 400
  {world} = emitter.game

  gui.add emitter, "flow"
  gui.add emitter, "kill"
  gui.add emitter, "removeAll"
  gui.add emitter, "revive"

  for methodName, method of emitterMethods
    gui.add emitter, methodName

  gui.add(emitter, "emitX", world.left, world.right, 10).listen()
  gui.add(emitter, "emitY", world.top, world.bottom, 10).listen()
  gui.add(emitter, "exists").listen()
  gui.add(emitter, "frequency", 0, 1000, 50).listen()
  gui.add(emitter, "height", 0, world.height, 10).listen()
  gui.add(emitter, "lifespan", 0, 10000, 1000).listen()
  gui.add(emitter, "on").listen()
  gui.add(emitter, "visible").listen()
  gui.add(emitter, "width", 0, world.width, 10).listen()
  gui.add(emitter, "x").listen()
  gui.add(emitter, "y").listen()

  return

debugText = (text, x, y, color = '#999', font = game.debug.font) ->
  game.debug.text text, x, y, color, font
  return


game = new (Phaser.Game)(800, 600, Phaser.CANVAS, 'phaser-example',
  preload: preload
  create: create
  render: render)
