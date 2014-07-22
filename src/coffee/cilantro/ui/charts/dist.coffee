define [
    'jquery'
    'underscore'
    '../base'
    './core'
    './utils'
], ($, _, base, charts, utils) ->

    class ChartLoading extends base.LoadView
        message: 'Chart loading...'


    class FieldChart extends charts.Chart
        template: 'charts/chart'

        loadView: ChartLoading

        ui:
            chart: '[data-target=chart]'
            heading: '.heading'
            status : '.heading [data-target=status]'

        showLoadView: ->
            (view = new @loadView).render()
            @ui.chart.html(view.el)

        chartClick: (event) =>
            category = event.point.category ? event.point.name
            event.point.select(not event.point.selected, true)
            @change()

        interactive: (options) ->
            if (type = options.chart?.type) is 'pie'
                return true
            else if type is 'column' and options.xAxis.categories?
                return true
            return false

        getChartOptions: (resp) ->
            options = utils.processResponse(resp, [@model])

            if options.clustered
                @ui.status.text('Clustered').show()
            else
                @ui.status.hide()

            if @interactive(options)
                @setOption('plotOptions.series.events.click', @chartClick)

            $.extend true, options, @chartOptions
            options.chart.renderTo = @ui.chart[0]
            return options

        getField: -> @model.id

        getValue: (options) ->
            points = @chart.getSelectedPoints()
            return (point.category for point in points)

        getOperator: -> 'in'

        removeChart: (event) ->
            super
            if @node then @node.destroy()

        onRender: ->
            # Explicitly set the width of the chart so Highcharts knows
            # how to fill out the space. Otherwise if this element is
            # not in the DOM by the time the distribution request is finished,
            # the chart will default to an arbitrary size..
            if @options.parentView?
                @ui.chart.width(@options.parentView.$el.width())

            @showLoadView()
            @model.distribution (resp) =>
                # Do not attempt to render if the view has been closed in
                # the meantime
                if @isClosed then return
                options = @getChartOptions(resp)
                if resp.size
                    @renderChart(options)
                else
                    @showEmptyView(options)

        setValue: (value) =>
            if not _.isArray(value) then value = []
            if @chart?
                points = @chart.series[0].points
                point.select(point.name ? point.category in value, true) for point in points
            return


    { FieldChart }
