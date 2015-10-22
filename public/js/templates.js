(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['library'] = template({"1":function(container,depth0,helpers,partials,data) {
    var alias1=container.lambda, alias2=container.escapeExpression;

  return "      <tr class=\"book-item\">\n        <td>"
    + alias2(alias1((depth0 != null ? depth0.title : depth0), depth0))
    + "</td>\n        <td>"
    + alias2(alias1((depth0 != null ? depth0.author : depth0), depth0))
    + "</td>\n        <td>"
    + alias2(alias1((depth0 != null ? depth0.location : depth0), depth0))
    + "</td>\n      </tr>\n";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<div class=\"main-container\">\n  <h1>Your Library</h1>\n\n  <div class=\"button\">Add Book</div>\n\n  <table class=\"library-list\">\n"
    + ((stack1 = helpers.each.call(depth0,(depth0 != null ? depth0.books : depth0),{"name":"each","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "  </table>\n</div>\n";
},"useData":true});
})();