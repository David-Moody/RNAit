(function() {
  'use strict';
  window.addEventListener('load', function() {
    var forms = document.getElementsByClassName('needs-validation');
    var validation = Array.prototype.filter.call(forms, function(form) {
      form.addEventListener('submit', function(event) {
        if (form.checkValidity() === false) {
          event.preventDefault();
          event.stopPropagation();
        }
        //standard validation doesnt' seem to support 'or' operations between fields
        if (document.getElementById('seqpaste').value=='' && document.getElementById('upload').value=='') {
          document.getElementById('seqpaste').setCustomValidity("Invalid field.");
          document.getElementById('upload').setCustomValidity("Invalid field.");
          event.preventDefault();
          event.stopPropagation();
        } else {
          document.getElementById('seqpaste').setCustomValidity("");
          document.getElementById('upload').setCustomValidity("");
        }
        form.classList.add('was-validated');
      }, false);
    });
  }, false);
})();
function display_vals() {
  melting_temp_out.value=melting_temp.value + "ºC";
  string_min_out.value=string_min.value + "%";
  string_max_out.value=string_max.value + "%";
}
function helpToggle(x,button) {
  div=document.getElementById(x);
 if (div.style.display=='none'){
   div.style.display='block';
   button.style.color='4365e2';}
 else {
  div.style.display='none';button.style.color="#000";
  }
 }