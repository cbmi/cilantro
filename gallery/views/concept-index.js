define(['cilantro', 'cilantro/ui'], function(c) {
    var view = new c.ui.views.ConceptIndex({
        collection: c.data.concepts
    });
    return view;
});
