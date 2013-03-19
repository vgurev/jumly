_STYLES =
  lineWidth    : 1.5
  fillStyle    : 'white'
  strokeStyle  : 'gray'
  shadowBlur   : 12
  shadowColor  : 'rgba(0,0,0,0.22)' # 'transparent black'
  shadowOffsetX: 8
  shadowOffsetY: 5

Path = $.g2d.path

_actor = (ctx, styles) ->
  r    = styles.radius || 12
  r2   = r*2
  exth = r*0.25                        # 25% of radius
  lw   = Math.round(styles.lineWidth)  # lw: line-width
  
  # Render a head
  r0 = ->
    ctx.arc lw + r, lw + r, r, 0, Math.PI*2, true
    ctx.fill()
    ctx.shadowColor = 'transparent'
    ctx.stroke()
  
  # Render a body
  r1 = ->
    dh = 3*lw
    dv = r2*0.77
    new Path(ctx)
        .moveTo(0, r2 + lw + exth).line(lw + r2 + lw, 0)  # actor's arms (h-line) 
        .moveTo(lw + r, r2 + lw).line(0, r2*0.35)         # actor's body (v-line)
        .line(-r, dv).move(r, -dv)  # actor's right leg, and back to the groin :)
        .line( r, dv)                     # actor's left leg
    ctx.shadowColor = styles.shadowColor
    ctx.stroke()

  
  ret =
    size:
      width : lw + r2   + lw
      height: lw + r2*2 + lw
    paths: [r0, r1]
          
_view = (ctx, styles) ->
  r    = styles.radius || 16
  r2   = r*2
  extw = r*0.4              # 40% of r
  lw   = styles.lineWidth  # lw: line-width

  r0 = ->
    ctx.arc lw + r + extw, lw + r, r, 0, Math.PI*2, true
    ctx.fill()
    ctx.shadowColor = 'transparent'
    ctx.stroke()
 
  r1 = ->
    new Path(ctx)
        .moveTo(lw, r)
        .line(extw, 0)
        .moveTo(lw, 0)
        .line(0, r2)
    #ctx.shadowColor = styles.shadowColor
    ctx.stroke()

  ret =
    size:
      width :lw + r2 + extw + lw
      height:lw + r2 +        lw
    paths: [r0, r1]

_controller = (ctx, styles) ->
  r    = styles.radius || 16
  r2   = r*2
  exth = r*0.4              # 40% of r
  lw   = lh = styles.lineWidth  # lw: line-width
  dy   = 0
  effectext = 0

  r0 = ->
    ctx.arc lw + r, lw + r + exth, r, 0, Math.PI*2, true
    ctx.fill()
    ctx.shadowColor = 'transparent'
    ctx.stroke()
 
  r1 = ->
    new Path(ctx)
        .moveTo(lw + r,     lh + exth)
        .lineTo(lw + r*1.4, lh + exth/4)
        .moveTo(lw + r,     lh + exth)
        .lineTo(lw + r*1.4, lh + exth*7/4)
    ctx.stroke()

  ret =
    size:
        width :lw + r2 + lw + effectext
        height:lw + r2 + lw + effectext + exth
    paths: [r0, r1]

_entity = (ctx, styles) ->
  r    = styles.radius || 16
  r2   = r*2
  exth = r*0.4             # 40% of r
  lw   = styles.lineWidth  # lw: line-width

  r0 = ->
    ctx.arc lw + r, lw + r, r, 0, Math.PI*2, true
    ctx.fill()
    ctx.shadowColor = 'transparent'
    ctx.stroke()
  
  r1 = ->
    ctx.shadowColor = styles.shadowColor
    new Path(ctx)
        .moveTo(lw + r,  r2)         # v-line (short)
        .lineTo(lw + r,  r2 + exth)  # 
        .moveTo(0,       r2 + exth)  # h-line (long)
        .lineTo(r2 + lw, r2 + exth)  # 
    ctx.stroke()
  
  ret =
    size:
      width :lw + r2 + lw
      height:lw + r2 + exth + lw
    paths: [r0, r1]

_size = (canvas, size, styles) ->
  dw = (styles.shadowOffsetX || 0) + (styles.shadowBlur/2 || 0)
  dh = (styles.shadowOffsetY || 0) + (styles.shadowBlur/2 || 0)
  $(canvas).attr width:size.width + dw, height:size.height + dh

_render = (canvas, renderer, args) ->
  styles = $.extend _STYLES, args

  ctx = canvas.getContext '2d'
  {size, paths} = renderer ctx, styles
  _size canvas, size, styles
  $(canvas).attr "data-actual-width":size.width, "data-actual-height":size.height

  $.extend ctx, styles
  for e in paths
    ctx.beginPath()
    e()

class Icon
  @render = (type)->
    r =
      actor: _actor
      view: _view
      controller: _controller
      entity: _entity
    (canvas, styles) -> _render canvas, r[type], styles

core = require "core"
if core.env.is_node
  module.exports = Icon
else
  core.exports Icon
