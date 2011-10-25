define [
        'common/models/polling'
    ],
        
    (polling) ->

        class SessionPerspective extends polling.Model
            url: App.urls.session.perspective

            initialize: ->
                super

                App.hub.subscribe 'report/revert', @revert

            # Currently, the session perspective is managed via the session
            # report thus this needs to only fetch itself to update
            revert: => @fetch()


        return {
            Session: SessionPerspective
        }
