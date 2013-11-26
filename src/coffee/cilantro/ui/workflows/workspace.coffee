define [
    'underscore'
    'marionette'
    '../core'
    '../base'
    '../query'
    'tpl!templates/workflows/workspace.html'
], (_, Marionette, c, base, query, templates...) ->

    templates = _.object ['workspace'], templates

    class WorkspaceWorkflow extends Marionette.Layout
        className: 'workspace-workflow'

        template: templates.workspace

        regions:
            queries: '.query-region'
            publicQueries: '.public-query-region'
            queryModal: '.save-query-modal'

        regionViews:
            queries: query.QueryList

        initialize: ->
            @data = {}
            if c.isSupported('2.2.0') and not (@data.public_queries = @options.public_queries)
                throw new Error 'public queries collection required'
            if not (@data.queries = @options.queries)
                throw new Error 'queries collection required'
            if not (@data.context = @options.context)
                throw new Error 'context model required'
            if not (@data.view = @options.view)
                throw new Error 'view model required'

        onRender: ->
            @queries.show new @regionViews.queries
                queryModalRegion: @queryModal
                collection: @data.queries
                context: @data.context
                view: @data.view

            if c.isSupported('2.2.0')
                # When the queries are synced we need to manually update the
                # public queries collection so that any changes to public
                # queries are reflected there. Right now, this is done lazily
                # rather than checking if the changed model is public or had
                # its publicity changed. If this becomes too slow we can
                # perform these checks but for now this is snappy enough.
                @data.queries.on 'sync', (model, resp, options) =>
                    @publicQueries.currentView.collection.fetch()
                    @publicQueries.currentView.collection.reset()

                # We explicitly set the editable option to false below because
                # users should not be able to edit the public queries
                # collection.
                @publicQueries.show new @regionViews.queries
                    queryModalRegion: @queryModal
                    collection: @data.public_queries
                    context: @data.context
                    view: @data.view
                    title: 'Public Queries'
                    editable: false

    { WorkspaceWorkflow }
