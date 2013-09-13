define [
    '../core'
    '../base'
    './item'
    './info'
    './actions'
    'tpl!templates/context.html'
    'tpl!templates/context/empty.html'
    'tpl!templates/context/tree.html'
], (c, base, item, info, actions, templates...) ->

    templates = c._.object ['context', 'empty', 'tree'], templates


    class ContextEmptyTree extends base.EmptyView
        template: templates.empty


    class ContextTree extends c.Marionette.CompositeView
        className: 'context-tree'

        template: templates.tree

        itemViewContainer: '.branch-children'

        itemView: item.ContextItem

        emptyView: ContextEmptyTree


    class ContextPanel extends c.Marionette.Layout
        className: 'context'

        template: templates.context

        errorView: base.ErrorOverlayView

        modelEvents:
            request: 'showLoadView'
            sync: 'hideLoadView'
            error: 'showErrorView'

        regions:
            info: '.info-region'
            tree: '.tree-region'
            actions: '.actions-region'

        regionViews:
            info: info.ContextInfo
            tree: ContextTree
            actions: actions.ContextActions

        showLoadView: ->
            @$el.addClass('loading')

        hideLoadView: ->
            @$el.removeClass('loading')

        showErrorView: ->
            # Show an overlay for the whole tree region
            (new @errorView(target: @$el)).render()

        onRender: ->
            @info.show new @regionViews.info
                model: @model

            @actions.show new @regionViews.actions
                model: @model

            @tree.show new @regionViews.tree
                model: @model
                collection: @model.manager.upstream.children


    { ContextPanel }
