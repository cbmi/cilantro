define [
    '../core'
    '../structs'
    './paginator'
], (c, structs, paginator) ->


    class ResultsPage extends structs.Frame
        idAttribute: 'page_num'

        url: ->
            "#{ @collection.url() }?page=#{ @id }&limit=#{ @collection.limit }"


    # Array of result frames (pages). The first fetch sets the state
    # of the collection including the frame size, number of possible
    # frames, etc. A refresh resets the collection as well as changes
    # to the frame size.
    class Results extends structs.FrameArray
        url: ->
            c.getSessionUrl('preview')

        initialize: ->
            super
            # Initially resolve to trigger pending on refresh
            # TODO this logic is odd and should be changed
            @resolve()
            c.subscribe c.SESSION_OPENED, @refresh, @
            c.subscribe c.SESSION_CLOSED, @reset, @
            c.subscribe c.CONTEXT_SYNCED, @refresh, @
            c.subscribe c.VIEW_SYNCED, @refresh, @

        fetch: (options={}) ->
            options.cache ?= false
            super(options)

    c._.extend Results::, paginator.PaginatorMixin

    # Set the custom model for this Paginator
    Results::model = ResultsPage


    { Results }
