define [
    './cilantro/core'
    './cilantro/changelog'
    './cilantro/models'
    './cilantro/structs'
    './cilantro/ui'
], (c, changelog, models, structs, ui) ->

    c.changelog = changelog
    c.models = models
    c.structs = structs
    c.ui = ui

    # Set the current version
    c.version = changelog[0].version

    # Defines the minimum version of Serrano that this version of Cilantro is
    # 100% compatible with. While Cilantro will attempt to run normally despite
    # the version number received from the server, the user will be warned if
    # no version number is found or if it is less than this minimum to
    # prepare them in the case of missing or broken functionality.
    c.minimumSerranoVersion = [2, 0, 18]

    c.data =
        concepts: new models.ConceptCollection
        fields: new models.FieldCollection
        contexts: new models.ContextCollection
        views: new models.ViewCollection
        results: new models.Results
        exporters: new models.ExporterCollection
        shared_queries: new models.SharedQueryCollection

    if c.config.get('autoload')
        c.session.open(c.config.get('url'), c.config.get('credentials'))

    return (@cilantro = c)
