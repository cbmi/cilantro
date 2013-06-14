define [
    '../core'
    './index'
    './search'
    'tpl!templates/views/concept-panel.html'
], (c, index, search, templates...) ->

    templates = c._.object ['panel'], templates


    class ConceptPanel extends c.Marionette.Layout
        className: 'concept-panel'

        template: templates.panel

        regions:
            search: '.search-region'
            index: '.index-region'

        onRender: ->
            @search.show new search.ConceptSearch
                collection: @collection

            @index.show new index.ConceptIndex
                collection: @collection

            # TODO document
            # Defer focus of concept search until end of event loop
            c._.defer =>
                @search.currentView.ui.input.focus()

    { ConceptPanel }
