define [
    '../core'
    'tpl!templates/context/actions.html'
], (c, templates...) ->

    templates = c._.object ['actions'], templates


    # Provides a set of actions for manipulating a ContextModel object
    class ContextActions extends c.Marionette.ItemView
        template: templates.actions

        ui:
            count: '.count'

        events:
            'click [data-role=remove]': 'clickRemoveAll'

        modelEvents:
            'change:count': 'renderCount'

        serializeData: ->
            attrs = c._.clone(@model.attributes)
            delete attrs.json
            attrs.count = c.utils.prettyNumber(attrs.count)
            return attrs

        renderCount: (model, value, options) ->
            @ui.count.text(c.utils.prettyNumber(value))

        clickRemoveAll: ->
            c.publish c.CONTEXT_CLEAR


    { ContextActions }
