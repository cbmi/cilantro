define(['cilantro','text!/mock/concepts.json', 'text!/mock/contexts.json'], function (c, mockConcepts, mockContexts) {

    var concepts = JSON.parse(mockConcepts),
        contexts = JSON.parse(mockContexts);

    describe('ConceptForm', function () {
        var form, model, context;

        beforeEach(function () {
            $('#arena').remove();
            $('body').append('<div id=arena />');

            model = new c.models.ConceptModel(concepts[0]);
            context = new c.models.ContextModel(contexts[0]);

            form = new c.ui.ConceptForm({
                model: model,
                context: context
            });
        });

        describe('Chart', function() {
            model = new c.models.ConceptModel(concepts[0]);
            context = new c.models.ContextModel(contexts[0]);

            form = new c.ui.ConceptForm({
                model: model,
                context: context
            });

            /*
            it('maintains size across renderings when removed from dom', function() {
                model.fields.fetch();

                waitsFor(function() {
                    return !!model.fields.length;
                });

                runs(function() {
                    form.render();
                    var el = form.fields.currentView.children.first().$el;
                    $('#arena').html(form.el);

                    var t1 = false,
                        t2 = false,
                        width1, width2;

                    waitsFor(function() {
                        return t1;
                    });

                    setTimeout(function() {
                        t1 = true;

                        runs(function() {
                            width1 = $('.highcharts-container', el).css('width');

                            expect(width1).toBeDefined();
                            form.close();
                            form.render();
                            $('#arena').html(form.el);
                            el = form.fields.currentView.children.first().$el;
                        });

                        waitsFor(function() {
                            return t2;
                        });

                        setTimeout(function(){
                            t2 = true;

                            runs(function() {
                                width2 = $('.highcharts-container', el).css('width');
                                expect(width2).toBeDefined();
                                expect(width1).toEqual(width2);
                                form.close();
                            });

                        }, 1000);

                    }, 1000);
                });

            });
            */
        });
    });

    describe('ConceptIndex', function() {
        var view, collection;

        beforeEach(function() {
            collection = new c.models.ConceptCollection(concepts);
            view = new c.ui.ConceptIndex({
                collection: collection
            });
        });

        it('should not define the groups on init', function() {
            expect(view.groups).toBeUndefined();
        });

        it('should group by category and order', function() {
            view.resetGroups();
            expect(view.groups).toBeDefined();
            expect(view.groups.length).toEqual(4);
            expect(view.groups.pluck('order')).toEqual([2, 3, 4, 5]);
        });

        it('should have sections per group', function() {
            view.resetGroups();
            var group = view.groups.at(0);
            expect(group.sections.length).toEqual(1);
            expect(group.sections.pluck('name')).toEqual(['Other']);
            expect(group.sections.pluck('id')).toEqual([-1]);
        });

        it('should have items per section', function() {
            view.resetGroups();
            var section = view.groups.at(0).sections.at(0);
            expect(section.items.length).toEqual(1);
        });
    });
});
