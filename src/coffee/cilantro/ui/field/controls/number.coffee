define [
    '../../core'
    '../../controls'
    '../../button'
    'tpl!templates/controls/number-range-input.html'
], (c, controls, button, templates...) ->

    templates = c._.object ['number'], templates

    class NumberControl extends controls.Control
        template: templates.number

        events: ->
            'keyup .range-from, .range-to': 'change'
            'change .btn-select': 'change'
            'click .range-help-button': 'toggleHelpText'

        initialize: (options) ->
            @model = options.model

        ui:
            inOutSelect: '.btn-select'

        onRender: ->
            @inOutSelect = new button.ButtonSelect
                collection: [
                    value: 'between'
                    label: 'between'
                    selected: true
                ,
                    value: 'not_between'
                    label: 'not between'
                ]

            @inOutSelect.render().$el.prependTo(@$el)
            @$('.help-block').hide()

            @set(@context)

        toggleHelpText: (event) ->
            @$('.help-block').toggle()
            event.preventDefault()

        isBetweenSelected: ->
            return @inOutSelect.getSelection() == 'between'

        getField: ->
            return @model.id

        getOperator: ->
            from = @$('.range-from').val()
            to = @$('.range-to').val()
            operator = ''

            if from != "" and to != ""
                operator = if @isBetweenSelected() then 'range' else '-range'
            else if from != ""
                operator = if @isBetweenSelected() then 'gte' else 'lte'
            else if to != ""
                operator = if @isBetweenSelected() then 'lte' else 'gte'
            else
                operator = if @isBetweenSelected() then 'range' else '-range'

            return operator

        getValue: ->
            from_text = @$('.range-from').val()
            from_num = new Number(from_text)

            to_text = @$('.range-to').val()
            to_num = new Number(to_text)

            value = []

            if from_text != "" and to_text != ""
                value = [from_num, to_num]
            else if from_text != ""
                value = from_num
            else if to_text != ""
                value = to_num
            # If both fields are emtpy, return null to invalidate this range
            else
                value = null

            return value

        setOperator: (operator) ->
            @operator = operator

            if operator == '-range'
                @inOutSelect.setSelection("not_between")
            else
                @inOutSelect.setSelection("between")

        setValue: (value) ->
            switch @operator
                when 'range', '-range'
                    if value[0]?
                        @$('.range-from').val(value[0])
                    else
                        @$('.range-from').val('')
                    if value[1]?
                        @$('.range-to').val(value[1])
                    else
                        @$('.range-to').val('')
                when 'gte'
                    @$('.range-from').val(value)
                when 'lte'
                    @$('.range-to').val(value)

    { NumberControl }
