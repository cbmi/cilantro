define [
    'underscore'
    'marionette'
    '../base'
    '../core'
    'tpl!templates/query/item.html'
], (_, Marionette, base, c, templates...) ->

    templates = _.object ['item'], templates

    class LoadingQueryItem extends base.LoadView
        align: 'left'

    class QueryItem extends Marionette.ItemView
        className: 'row-fluid'

        template: templates.item

        ui:
            owner: '.owner'
            nonOwner: '.non-owner'
            shareCount: '.share-count'

        events:
            'click .delete-query': 'deleteQuery'
            'click [data-toggle=query-modal]': 'showQueryModal'
            'click .shared-query-name': 'openQuery'

        modelEvents:
            sync: 'render'

        initialize: ->
            @data = {}

            @editable = if @options.editable? then @options.editable else true

            if not (@data.context = @options.context)
                throw new Error 'context model required'
            if not (@data.view = @options.view)
                throw new Error 'view model required'

        # Custom serialize method to ensure the two nested objects exist for
        # use by the template.
        serializeData: ->
            attrs = @model.toJSON()
            attrs.shared_users ?= []
            attrs.user ?= {}
            return attrs

        # Set the query's context and view json on the session context
        # and view, navigate to the results to view results
        openQuery: =>
            @data.view.save('json', @model.get('view_json'))
            @data.context.save('json', @model.get('context_json'), reset: true)
            c.router.navigate('results', trigger: true)

        showQueryModal: ->
            @trigger('showQueryModal', @model)

        deleteQuery: ->
            @model.destroy({wait: true})

        onRender: ->
            if @model.get('is_owner')
                @ui.nonOwner.hide()

                emailHTML = _.pluck(@model.get('shared_users'), 'email').join('<br />')
                @ui.shareCount.attr('title', emailHTML)
                @ui.shareCount.tooltip({animation: false, html: true, placement: 'right'})
            else
                @ui.owner.hide()

            if not @editable
                @ui.nonOwner.hide()
                @ui.owner.hide()

    { LoadingQueryItem, QueryItem }
