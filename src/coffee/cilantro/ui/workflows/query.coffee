define [
    'underscore'
    'marionette'
    '../core'
    '../base'
    '../concept'
    '../context'
    'tpl!templates/workflows/query.html'
], (_, Marionette, c, base, concept, context, templates...) ->

    templates = _.object ['query'], templates

    ###
    The QueryWorkflow provides an interface for navigating and viewing
    concepts that are deemed 'queryable'. This includes browsing the
    available concepts in the index, viewing details about the
    concept in the workspace as well as adding or modifying filters,
    and viewing the list of filters in the context panel.
    TODO: break out context panel as standalone view

    This view requires the following options:
    - concepts: a collection of concepts that are deemed queryable
    - context: the session/active context model
    ###
    class QueryWorkflow extends Marionette.Layout
        className: 'query-workflow'

        template: templates.query

        regions:
            context: '.context-panel-region'
            concepts: '.concept-panel-region'
            workspace: '.concept-workspace-region'

        initialize: ->
            @data = {}
            if not (@data.context = @options.context)
                throw new Error 'context model required'
            if not (@data.concepts = @options.concepts)
                throw new Error 'concept collection required'

        onRender: ->
            @workspace.show new concept.ConceptWorkspace
                context: @data.context
                concepts: @data.concepts

            @concepts.show new concept.ConceptPanel
                collection: @data.concepts

            @concepts.currentView.$el.stacked
                fluid: '.index-region'

            @context.show new context.ContextPanel
                model: @data.context

            @context.currentView.$el.stacked
                fluid: '.tree-region'


    { QueryWorkflow }
