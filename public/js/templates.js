(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['home'] = template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<div class=\"splash\">\n  <div class=\"splash-content\">\n    <h1>"
    + container.escapeExpression(((helper = (helper = helpers.userName || (depth0 != null ? depth0.userName : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0,{"name":"userName","hash":{},"data":data}) : helper)))
    + " Library</h1>\n  </div>\n</div>\n";
},"useData":true});
})();