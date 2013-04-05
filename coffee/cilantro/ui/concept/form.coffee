define [
    '../../core'
    '../field'
    '../charts'
    'tpl!templates/views/concept-form.html'
], (c, field, charts, templates...) ->

    templates = c._.object ['form'], templates


    class ConceptContextManager
        constructor: (model, options={}) ->
            @model = model
            @options = options

        setContext: (context) ->
            # Fetch the branch relative to the concept.id
            if not (@context = context.fetch(concept: @model.id))
                # Create a branch-style node to put all field-level nodes inside,
                # mark it with the concept_id so it can be found later
                @context = new c.models.BranchNodeModel
                    concept: @model.id
                    type: 'and'
                    children: []

                # Add to parent context
                context.add @context
            @model.context = @context
            return

        getFieldContext: (id) ->
            if not (node = @context.fetch(field: id))
                # Create a branch-style node to put all field-level nodes inside,
                # mark it with the concept_id so it can be found later
                node = new c.models.ConditionNodeModel
                    field: id
                    concept: @model.id

                # Add to parent context
                @context.add node

            return node


    class ConceptForm extends c.Marionette.Layout
        className: 'concept-form'

        template: templates.form

        options:
            managed: true
            showChart: true
            chartField: null

        constructor: (model) ->
            super model
            @manager = new ConceptContextManager(@model)
            # Base the context off the current session
            @manager.setContext(c.data.contexts.getSession())

        events:
            'click .concept-actions [data-toggle=add]': 'save'
            'click .concept-actions [data-toggle=update]': 'save'
            'click .concept-actions [data-toggle=remove]': 'clear'

        ui:
            actions: '.concept-actions'
            add: '.concept-actions [data-toggle=add]'
            remove: '.concept-actions [data-toggle=remove]'
            update: '.concept-actions [data-toggle=update]'

        regions:
            main: '.concept-main'
            chart: '.concept-chart'
            fields: '.concept-fields'

        onRender: ->
            conceptFields = @model.fields[..]

            # Optionally render the chart if a distribution is available
            if @options.showChart
                idx = 0

                if (chartField = @options.chartField)?
                    # Get the index of the field and ensure it exists for this
                    # concept
                    if (idx = conceptFields.indexOf(chartField)) is -1
                        throw new Error('Field not associated with concept')

                    # Throw an error for an explicitly defined field if it
                    # does not support distributions
                    if not chartField.urls.distribution?
                        throw new Error('Field does not support distributions')

                if chartField or (chartField = @model.fields[idx]).urls.distribution?
                    # Remove from remaining concept fields
                    conceptFields.splice(idx, 1)

                    context = @manager.getFieldContext(chartField.id)

                    # TODO this could display it's own chart.. so there would
                    # be no need to construct a separate chart here.
                    mainFieldForm = new field.FieldForm
                        showChart: false
                        model: chartField
                        context: context

                    fieldChart = new charts.FieldChart
                        parentView: @
                        model: chartField
                        context: context

                    @main.show(mainFieldForm)
                    @chart.show(fieldChart)


            fieldForms = new c.Marionette.CollectionView
                itemView: field.FieldForm

                # New collection for locally managing the fields..
                collection: new c.Backbone.Collection(conceptFields)

                itemViewOptions: (model) =>
                    showChart: false
                    context: @manager.getFieldContext(model.id)

            @fields.show(fieldForms)

            @setDefaultState()

        setDefaultState: ->
            # If this is valid field-level context update the state
            # of the concept form. Only one of the fields need to be
            # valid to update the context
            if @context?.isValid()
                @setUpdateState()
            else
                @setNewState()

        setUpdateState: ->
            @ui.add.hide()
            @ui.update.show()
            @ui.remove.show()

        setNewState: ->
            @ui.add.show()
            @ui.update.hide()
            @ui.remove.hide()

        # Saves the current state of the context which enables it to be
        # synced with the server.
        save: (options) ->
            options = c._.extend(deep: @options.managed, options)
            @context?.save(options)
            @setUpdateState()

        # Clears the local context of conditions
        clear: (options) ->
            options = c._.extend(deep: @options.managed, options)
            @context?.clear(options)
            @context?.save(options)
            @setNewState()


    { ConceptForm }
