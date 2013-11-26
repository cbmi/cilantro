define [
    'underscore'
    'marionette'
    '../core'
    './item'
    './dialog'
    'tpl!templates/query/list.html'
], (_, Marionette, c, item, dialog, templates...) ->

    templates = _.object ['list'], templates

    class QueryList extends Marionette.CompositeView
        emptyView: item.LoadingQueryItem

        itemView: item.QueryItem

        itemViewContainer: '.items'

        template: templates.list

        itemViewOptions: (model, index) ->
            model: model
            view: @data.view
            context: @data.context
            index: index
            editable: @editable

        ui:
            title: '.title'

        collectionEvents:
            sync: 'onCollectionSynced'

        initialize: ->
            @data = {}

            @editable = if @options.editable? then @options.editable else true

            @emptyMessage = "You have not yet created any queries nor have had any shared with you. You can create a new query by navigating to the 'Results' page and clicking on the 'Save Query...' button. This will save a query with the current filters and column view."
            if @options.emptyMessage?
                @emptyMessage = @options.emptyMessage

            if not (@data.context = @options.context)
                throw new Error 'context model required'
            if not (@data.view = @options.view)
                throw new Error 'view model required'

            if not (@title = @options.title)
                @title = 'Queries'

            @queryModalRegion = @options.queryModalRegion

            @on 'itemview:showQueryModal', (options) ->
                @queryModalRegion.currentView.open(options.model)

            @queryModalRegion.show new dialog.QueryDialog
                header: 'Edit Query'
                collection: @collection
                context: @data.context
                view: @data.view

        onCollectionSynced: =>
            if this.collection.length == 0
                @$el.find('.load-view').html(@emptyMessage)

        onRender: ->
            @ui.title.html(@title)

    { QueryList }
