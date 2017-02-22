![Screenshot](https://samme.github.io/phaser-debug-emitter/screenshot.png)

[Demo](https://github.com/samme/phaser-debug-emitter)

Use ✨
---

```javascript
// Show center and area
// {color}, if null, depends on the emitter's `on` state
game.debug.emitter(emitter, color = null, filled = true)

// List properties
game.debug.emitterInfo(emitter, x, y, color = null)

// Count existing particles
// Bar is {width}px × {height}px
game.debug.emitterTotal(emitter, x, y, width = 100, height = 10, color = null, label = emitter.name)
```
