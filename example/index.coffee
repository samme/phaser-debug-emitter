"use strict"

{dat, Phaser} = this

{extend} = Phaser.Utils

emitterMethods =
  explodeWithMaxParticles: -> @explode @lifespan, @maxParticles
  flowWithDefaultArgs:     -> @flow()
  flowWithQuantity:        -> @flow      @lifespan, @frequency, 10
  startFlow:               -> @start no, @lifespan, @frequency
  startForceQuantity:      -> @start no, @lifespan, @frequency, @maxParticles, yes

window.GAME = new (Phaser.Game)
  antialias: no
  # height: 600
  renderer: Phaser.CANVAS
  # resolution: 1
  # scaleMode: Phaser.ScaleManager.NO_SCALE
  # transparent: false
  # width: 800
  state:

    init: ->
      {debug} = @game
      debug.font = '14px monospace'
      debug.lineHeight = 20
      return

    preload: ->
      @load.baseURL = 'http://examples.phaser.io/assets/'
      @load.crossOrigin = 'anonymous'
      @load.image 'bubble', 'particles/bubble.png'
      @load.image 'bg', 'skies/cavern2.png'
      return

    create: ->
      @add.image 0, 0, 'bg'
      #	Emitters have a center point and a width/height, which extends from their center point to the left/right and up/down
      @emitter = @add.emitter @world.centerX, 200, 100
      @emitter.name = 'bubbles'
      #	This emitter will have a width of 400px, so a particle can emit from anywhere in the range emitter.x += emitter.width / 2
      @emitter.width = 400
      @emitter.height = 64
      @emitter.makeParticles 'bubble'
      @emitter.minParticleSpeed.set 0, 300
      @emitter.maxParticleSpeed.set 0, 400
      @emitter.setRotation 0, 0
      @emitter.setAlpha 0.3, 0.8
      @emitter.setScale 0.5, 0.5, 1, 1
      @emitter.gravity = -200

      @emitter.flow @emitter.lifespan, @emitter.frequency
      # emitter.start false, 5000, 100
      # emitter.explode 2000, emitter.length

      extend @emitter, emitterMethods

      @gui = @createGui @emitter
      return

    render: ->
      {debug} = @game
      debug.emitter      @emitter
      debug.emitterInfo  @emitter, 20, 40
      debug.emitterTotal @emitter, 0,  580, @game.width, 20
      @debugText "game.debug.emitter(emitter)", @emitter.left, -5 + @emitter.top
      @debugText "game.debug.emitterInfo(emitter, x, y)", 10, 20
      @debugText "game.debug.emitterTotal(emitter, x, y)", 10, 560
      return

    shutdown: ->
      @gui.destroy()
      return

    # Helpers

    createGui: (emitter) ->
      {world} = @game

      gui = new dat.GUI width: 400

      gui.add emitter, "flow"
      gui.add emitter, "kill"
      gui.add emitter, "removeAll"
      gui.add emitter, "revive"

      for methodName in Object.keys emitterMethods
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

      gui

    debugText: (text, x, y, color = '#999') ->
      @game.debug.text text, x, y, color, @game.debug.font
      return
