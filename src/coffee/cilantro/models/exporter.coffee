define [
    '../core'
    './base'
], (c, base) ->


    class ExporterModel extends base.Model


    class ExporterCollection extends base.Collection
        model: ExporterModel

        # Versions greater than or equal to this version are considered to
        # support notification on completion.
        minSerranoVersionProgressFeature: '2.0.16'

        notifiesOnComplete: ->
            c.isSupported(@minSerranoVersionProgressFeature)

        parse: (attrs) ->
            if attrs? and attrs._links?
                # Ignore the exporter endpoint itself
                return (value for key, value of attrs._links when key isnt "self")


    { ExporterModel, ExporterCollection }
