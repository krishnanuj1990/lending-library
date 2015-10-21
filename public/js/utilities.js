function ajaxInsertTemplate(elementId, templateName, path) {
  var request = new XMLHttpRequest();
  var response;
  request.open('GET', path, true);

  request.onload = function() {
    if(this.status >=200 && this.status < 400) {
      response = this.response;
      insertTemplate(elementId, templateName, response);
    }
    else {
      response = 'An error occurred';
    }
  };

  request.onerror = function() {
    response = 'An error has occurred';
  };

  request.send();
}

// Data is passed as a string
// Inserts into elementName, a template populated by data
function insertTemplate(elementId, templateName, data) {
  var element = document.getElementById(elementId);
  var template = Handlebars.templates[templateName];
  var jsonData = JSON.parse(data);
  element.innerHTML = template(jsonData);
}

function insertTemplateJSON(elementId, templateName, json) {
  var element = document.getElementById(elementId);
  var template = Handlebars.templates[templateName];
  element.innerHTML = template(json);
}
