{View, $} = require 'space-pen'
_ = require 'underscore-plus'


class CoveringView extends View

  initialize: (@editor) ->
    @decoration = @editor.decorateMarker @cover(),
      type: 'overlay',
      item: this,
      position: 'tail'

  attached: ->
    rightPosition = if @editor.verticallyScrollable()
        @editor.getVerticalScrollbarWidth()
      else
        0

    @parent().css right: rightPosition

    @css 'margin-top': -@editor.getLineHeightInPixels()
    @height @editor.getLineHeightInPixels()

  remove: ->
    @decoration.destroy()

  # Override to specify the marker of the first line that should be covered.
  cover: -> null

  # Override to return the Conflict that this view is responsible for.
  conflict: -> null

  isDirty: -> false

  # Override to determine if the content of this Side has been modified.
  detectDirty: -> null

  # Override to apply a decoration to a marker as appropriate.
  decorate: -> null

  getModel: -> null

  buffer: -> @editor.getBuffer()

  includesCursor: (cursor) -> false

  deleteMarker: (marker) ->
    @buffer().delete marker.getBufferRange()
    marker.destroy()

  scrollTo: (positionOrNull) ->
    @editor.setCursorBufferPosition positionOrNull if positionOrNull?

  prependKeystroke: (eventName, element) ->
    bindings = atom.keymap.findKeyBindings command: eventName

    for e in bindings
      original = element.text()
      element.text(_.humanizeKeystroke(e.keystrokes) + " #{original}")

module.exports =
  CoveringView: CoveringView
