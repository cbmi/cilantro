define [
    'underscore'
    'marionette'
    '../core'
    '../../models/query'
    'tpl!templates/query/dialog.html'
], (_, Marionette, c, query, templates...) ->

    templates = _.object ['dialog'], templates

    class QueryDialog extends Marionette.ItemView
        className: 'modal hide'

        template: templates.dialog

        options:
            header: 'Query Properties'

        events:
            'click [data-save]': 'saveQuery'

        ui:
            header: '.modal-header h4'
            alert: '.alert'
            name: '.query-name'
            description: '.query-description'
            email: '.query-emails'
            publicity: '.query-publicity'

        initialize: ->
            @data = {}
            if not (@data.context = @options.context)
                throw new Error 'context model required'
            if not (@data.view = @options.view)
                throw new Error 'view model required'

        showError: (message) ->
            @ui.alert.html(message).show()

        hideError: ->
            @ui.alert.hide()

        saveQuery: ->
            @hideError()

            # Make sure the name is valid, everything else can be left blank
            if not @ui.name.val()
                @showError('Please supply a name for the query')
                return

            # Extract data from form and session
            attrs =
                name: @ui.name.val()
                description: @ui.description.val()
                usernames_or_emails: @ui.email.val()
                public: @ui.publicity.prop('checked')
                context_json: @data.context.toJSON().json
                view_json: @data.view.toJSON().json

            # Create a new model if not defined
            if not @model
                @model = new @collection.model

            # Don't stomp on model's collection if it already exists in one
            if not @model.collection
                @collection.add(@model)

            # Re-open on failure and display error message. Closure reference
            # of model put to prevent re-opening with a new instance
            model = @model
            @model.save(attrs).fail (xhr, status, error) =>
                @open(model)
                # TODO evaluate the error and customize the message, e.g. don't
                # tell a user to try again if there is no hope.
                @showError('Sorry, there was an problem saving your query. Please try again.')

            @close()

        onRender: =>
            @ui.header.text(@options.header)

            @$el.modal
                show: false
                keyboard: false
                backdrop: 'static'

        open: (model) =>
            @hideError()

            # Repopulate modal with model attributes, otherwise initialize
            # with defaults
            if (@model = model)
                name = @model.get('name')
                description = @model.get('description')
                emails = _.pluck(@model.get('shared_users'), 'email').join(', ')
                publicity = @model.get('public')
            else
                # Remove timezone info from the current date and then use it as
                # the suffix for new query title.
                fields = Date().toString().split(' ')
                name = "Query on #{ fields[0] } #{ fields[1] } #{ fields[2] } #{ fields[3] } @ #{ fields[4] }"
                description = ''
                emails = ''
                publicity = false

            # Reset form fields
            @ui.name.val(name)
            @ui.description.val(description)
            @ui.email.val(emails)
            @ui.publicity.prop('checked', publicity)

            @$el.modal('show')

        close: =>
            delete @model
            @$el.modal('hide')

    { QueryDialog }
