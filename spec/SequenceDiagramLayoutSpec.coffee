require "core"
require "jquery.ext"
utils = require "./jasmine-utils"
SequenceDiagramLayout = require "SequenceDiagramLayout"
SequenceDiagram = require "SequenceDiagram"
SequenceObject = require "SequenceObject"
SequenceDiagramBuilder = require "SequenceDiagramBuilder"

describe "SequenceDiagramLayout", ->

  div = utils.div this

  beforeEach ->
    @layout = new SequenceDiagramLayout

  it "has layout", ->
    expect(typeof @layout.layout).toBe "function"
  
  utils.unless_node ->
    it "determines the size", ->
      diag = new SequenceDiagram
      diag.append obj = new SequenceObject "foobar"
      div.append diag
      @layout.layout diag
      expect(diag.width()).toBeGreaterThan 0
      expect(diag.height()).toBeGreaterThan 0

  beforeEach ->
    @builder = new SequenceDiagramBuilder

  describe "found", ->
    utils.unless_node ->

      it "looks centering" #, ->
        #div.append @builder.build "@found 'foundee'"
        #@layout.layout diag = @builder.diagram()

  """
  @found "You", ->
    @message "open", "Front Cover"
    @loop ->
      @alt
        "[page > 0]": -> @message "flip", "Page"
        "[page = 0]": -> @message "stop reading"
      @message "read", "Page"
    @message "close", "Front Cover"
    @ref "Tidy up book at shelf"
  """

  describe "message", ->

    describe "self-message", ->

      it "works without args after 2nd", ->
        diag = @builder.build """
          @found "a", ->
            @message "msg to myself"
          """
        div.append diag
        @layout.layout diag

    it "works", ->
      diag = @builder.build """
        @found "That", ->
          @message "finds", "it"
        """
      div.append diag
      @layout.layout diag

  describe "showcase", ->
  
    it "has full functions", ->
      diag = @builder.build """
        @found "User", ->
          @message "search", "Browser", ->
            @message "http request", "HTTP Server", ->
              @create "HTTP Session"
              @message "save state", "HTTP Session"
              @message "do something"
              @message "query", "Database", ->
              @reply "", "Browser"
            @loop @message "request resources", "HTTP Server", ->
              @alt {
                "[found]": -> @message "update", "Database"
                "[missing]": -> @message "scratch", "HTTP Session"
              }
            @ref "Rendering page"
            @reactivate "disconnect", "HTTP Server", ->
              @destroy "HTTP Session"
          
          ###
          @before (e, d) ->
            d.user.iconify "actor"
            d.browser.iconify "view"
            d["http_session"].iconify "controller"
            d["http_server"].iconify "controller"
            d.database.iconify("entity").css("margin-left":-80)
            d["http_session"].lost()
          
          @after (e, diag)->
            f = (e)-> $(e.currentTarget).addClass "focused-hovered"
            g = (e)-> $(e.currentTarget).removeClass "focused-hovered"
            $(".object .name, .message .name").hover f, g
          ###
        """
      div.append diag
      @layout.layout diag
