define [
    '../../core'
    '../field'
    '../charts'
    'tpl!templates/views/concept-form.html'
], (c, field, charts, templates...) ->

    templates = c._.object ['form'], templates


    class ManagedContextMapper
        constructor: (@context, @fields) ->

        # For a given field id, return the ContextNode
        # in the ContextTree if it exists
        getNodes: (fieldId) ->
            nodes = @context.getNodes(fieldId)
            if nodes.length == 0
                nodes = [new c.models.ContextNodeModel(id:fieldId)]
                @context.add(nodes[0])
            nodes[0]


    class ConceptForm extends c.Marionette.Layout
        className: 'concept-form'

        template: templates.form

        constructor: (model) ->
            super model
            @context = c.data.contexts.getSession()
            @manager = new ManagedContextMapper(@context, @model.fields)

        regions:
            main: '.concept-main'
            chart: '.concept-chart'
            fields: '.concept-fields'

        onRender: ->
            ungraphedFieldsStart = 0
            mainField = @model.fields[0]

            if mainField.urls.distribution?
                ungraphedFieldsStart = 1
                mainChart = new charts.FieldChart
                    parentView: @
                    model: mainField
                    data:
                        context: @manager.getNodes(mainField.id)

            mainForm = new field.FieldForm
                model: mainField
                context: @manager.getNodes(mainField.id)
                showChart: false

            fields = new c.Marionette.CollectionView
                itemView: field.FieldForm

                itemViewOptions: (model) =>
                   showChart: false
                   context: @manager.getNodes(model.id)

                collection: new c.Backbone.Collection(@model.fields[ungraphedFieldsStart..])


            @main.show(mainForm)
            @chart.show(mainChart) if mainChart?
            @fields.show(fields)


    { ConceptForm }