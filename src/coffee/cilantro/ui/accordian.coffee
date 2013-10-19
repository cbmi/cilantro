define [
    'underscore'
    'marionette'
    './base'
    'tpl!templates/accordian/group.html'
    'tpl!templates/accordian/section.html'
    'tpl!templates/accordian/item.html'
], (_, Marionette, base, templates...) ->

    templates = _.object ['group', 'section', 'item'], templates


    class Item extends Marionette.ItemView
        tagName: 'li'

        template: templates.item


    class Section extends Marionette.CompositeView
        className: 'section'

        itemView: Item

        template: templates.section

        itemViewContainer: '.items'

        # Represents the current collapsed/expanded state of the group.
        isCollapsed: true

        # Represents the previous collapsed/expanded state of the group.
        # This is especially useful when restoring the state of the group
        # after a search is cleared.
        wasCollapsed: true

        option:
            collapsable: true

        ui:
            heading: '.heading'
            icon: '.heading span'
            inner: '.inner'

        events:
            'click > .heading': 'toggleCollapse'
            'shown > .inner': 'showCollapse'
            'hidden > .inner': 'hideCollapse'

        onRender: ->
            if not @options.collapsable
                @$('.inner').removeClass('collapse')
                @ui.icon.hide()

        # Returns true if this group is *empty*
        isEmpty: ->
            not @collection.length

        onCompositeCollectionRendered: ->
            @$el.toggle(not @isEmpty())

        _setIsCollapsed: (newIsCollapsed) ->
            @wasCollapsed = @isCollapsed
            @isCollapsed = newIsCollapsed

        toggleCollapse: ->
            if @options.collapsable
                @wasCollapsed = @isCollapsed
                @isCollapsed = not @isCollapsed
                @ui.inner.collapse('toggle')

        showCollapse: (event) ->
            # Stop the event here so it doesn't reach the group handler. Since
            # it is possible to trigger this programmatically, we only stop
            # propagation when the event is valid.
            if event?
                event.stopImmediatePropagation()

            @ui.icon.text('-')

        hideCollapse: (event) ->
            # Stop the event here so it doesn't reach the group handler. Since
            # it is possible to trigger this programmatically, we only stop
            # propagation when the event is valid.
            if event?
                event.stopImmediatePropagation()

            @ui.icon.text('+')

        expand: ->
            if @options.collapsable
                @_setIsCollapsed(false)

                @ui.inner.collapse('show')
                @showCollapse()

        collapse: ->
            if @options.collapsable
                @_setIsCollapsed(true)

                @ui.inner.collapse('hide')
                @hideCollapse()

        revertToLastState: ->
            if @options.collapsable
                if @wasCollapsed
                    @ui.inner.collapse('hide')
                    @hideCollapse()
                else
                    @ui.inner.collapse('show')
                    @showCollapse()

                @isCollapsed = @wasCollapsed


    class Group extends Marionette.CompositeView
        className: 'group'

        template: templates.group

        itemView: Section

        itemViewContainer: '.sections'

        itemSectionItems: 'items'

        # Represents the current collapsed/expanded state of the group.
        isCollapsed: true

        # Represents the previous collapsed/expanded state of the group.
        # This is especially useful when restoring the state of the group
        # after a search is cleared.
        wasCollapsed: true

        options:
            collapsable: true

        itemViewOptions: (model, index) ->
            model: model
            index: index
            collection: model[@itemSectionItems]
            collapsable: @options.collapsable

        ui:
            heading: '.heading'
            icon: '.heading span'
            inner: '.inner'

        events:
            'click > .heading': 'toggleCollapse'
            'shown > .inner': 'showCollapse'
            'hidden > .inner': 'hideCollapse'

        onRender: ->
            if not @options.collapsable
                @$('.inner').removeClass('collapse')
                @ui.icon.hide()

        # Returns true if this group is *empty* which includes having no
        # sections or having sections without any items.
        isEmpty: ->
            if @collection.length
                return false
            for model in @collection.models
                if model.items.length
                    return false
            return true

        onCompositeCollectionRendered: ->
            @$el.toggle(not @isEmpty())

            # Hide the first heading i
            if (length = @collection.length)
                # Get the first model and view for toggle conditions
                view = @children.findByModel(model = @collection.at(0))

                isMultiChild = length > 1 or model.id >= 0

                # If it is a sinlge child then we turn off the collapsable
                # flag on the view since it cannot be expanded/collapsed
                # without a visible header. We need to re-render because
                # chaning the options doesn't automatically trigger a render
                # call so we do it manually here.
                if not isMultiChild
                    view.options.collapsable = false
                    view.render()

                # If only a single child is present, hide the heading unless it
                # is using an explicit heading
                view.ui.heading.toggle(isMultiChild)

        _setIsCollapsed: (newIsCollapsed) ->
            @wasCollapsed = @isCollapsed
            @isCollapsed = newIsCollapsed

        toggleCollapse: ->
            if @options.collapsable
                @_setIsCollapsed(not @isCollapsed)

                @ui.inner.collapse('toggle')

        showCollapse: ->
            @ui.icon.text('-')

        hideCollapse: ->
            @ui.icon.text('+')

        expand: ->
            if @options.collapsable
                @_setIsCollapsed(false)

                @ui.inner.collapse('show')
                @showCollapse()

                @children.each((view) ->
                    view.expand()
                )

        collapse: ->
            if @options.collapsable
                @_setIsCollapsed(true)

                @ui.inner.collapse('hide')
                @hideCollapse()

                @children.each((view) ->
                    view.collapse()
                )

        revertToLastState: ->
            if @options.collapsable
                @children.each((view) ->
                    view.revertToLastState()
                )

                if @wasCollapsed
                    @ui.inner.collapse('hide')
                    @hideCollapse()
                else
                    @ui.inner.collapse('show')
                    @showCollapse()

                @isCollapsed = @wasCollapsed


    class Accordian extends Marionette.CollectionView
        className: 'accordian'

        itemView: Group

        emptyView: base.EmptyView

        itemGroupSections: 'sections'

        options:
            collapsable: true

        itemViewOptions: (model, index) ->
            model: model
            index: index
            collection: model[@itemGroupSections]
            collapsable: @options.collapsable

        expand: ->
            if @options.collapsable
                @children.each((view) ->
                    view.expand()
                )

        collapse: ->
            if @options.collapsable
                @children.each((view) ->
                    view.collapse()
                )

        revertToLastState: ->
            if @options.collapsable
                @children.each((view) ->
                    view.revertToLastState()
                )


    { Accordian, Group, Section, Item }
