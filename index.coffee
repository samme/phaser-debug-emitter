{Phaser} = this

{isArray} = Array

COLOR_LENGTH = 'rgba(127,127,127,0.4)'

COLOR_OFF = 'rgba(255,0,0,0.4)'

COLOR_ON = 'rgba(0,255,0,0.4)'

KEYS = [
  "area"
  "emitX"
  "emitY"
  "exists"
  "frequency"
  "length"
  "lifespan"
  "maxParticles"
  "name"
  "on"
  "total"
  "visible"
  "_counter"
  "_explode"
  "_flowQuantity"
  "_flowTotal"
  "_frames"
  "_id"
  "_quantity"
  "_timer"
]

KEYS_LONG = [
  "alive"
  "alphaData"
  "angularDrag"
  "area"
  "autoAlpha"
  "autoScale"
  "bounce"
  "emitX"
  "emitY"
  "exists"
  "frequency"
  "gravity"
  "lifespan"
  "maxParticleAlpha"
  "maxParticles"
  "maxParticleScale"
  "maxParticleSpeed"
  "maxRotation"
  "minParticleAlpha"
  "minParticleScale"
  "minParticleSpeed"
  "minRotation"
  "name"
  "on"
  "particleAnchor"
  "particleBringToTop"
  "particleClass"
  "particleDrag"
  "particleSendToBack"
  "scaleData"
  "visible"
  "_counter"
  "_explode"
  "_flowQuantity"
  "_flowTotal"
  "_frames"
  "_id"
  "_maxParticleScale"
  "_minParticleScale"
  "_quantity"
  "_timer"
]

emitterColor = (emitter, color) ->
  if emitter.on then COLOR_ON
  else               COLOR_OFF

emitterNext = (emitter) ->
  emitter._timer - emitter.game.time.time

stringValueForKey = (key, emitter) ->
  val = emitter[key]
  typ = typeof val

  switch
    when isArray val
      val = "(#{val.length})"
    when typ is "number"
      val = if val % 1 then val.toFixed 1 else val
    when val?.constructor?.name
      val.constructor.name
    when typeof val is "function"
      "[Function]"
    when val?.toString
      val = val.toString()

  val

_areaRect = new Phaser.Rectangle

Phaser.Utils.Debug::emitter = (emitter, color, filled = yes) ->
  {debug} = @game

  color ?= emitterColor emitter

  if emitter.width > 1 or emitter.height > 1
    _areaRect.setTo emitter.left, emitter.top, emitter.width, emitter.height
    debug.geom _areaRect, color, filled

  debug.pixel emitter.emitX, emitter.emitY, color

  return

Phaser.Utils.Debug::emitterInfo = (emitter, x, y, color, long = no) ->
  {debug} = @game

  debug.start x, y, color

  debug.line emitter.name

  for key in (if long then KEYS_LONG else KEYS)
    debug.line "#{key}: #{stringValueForKey key, emitter}"

  debug.stop()

  return

_lengthRect = new Phaser.Rectangle
_totalRect  = new Phaser.Rectangle

Phaser.Utils.Debug::emitterTotal = (emitter, x, y, width = 100, height = 10, color, label = emitter.name) ->
  {debug} = @game
  {length, total} = emitter

  color ?= emitterColor emitter

  _lengthRect.setTo x, y, ~~ width, height
  debug.geom _lengthRect, COLOR_LENGTH

  _totalRect.setTo  x, y, ~~(width * total / length), height
  debug.geom _totalRect, color

  debug.text label, x, y + ~~(debug.lineHeight / 2) if label

  return
