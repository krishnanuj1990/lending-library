window.onload = function() {
  document.getElementById('splash-login-button').addEventListener('click', showForm, false);
}


function showForm() {
  var form = document.getElementById('form-container');
  form.className = form.className.replace('hidden', '');

  var button = document.getElementById('splash-login-button');
  button.removeEventListener('click', showForm);
  button.className += ' hidden';
}
