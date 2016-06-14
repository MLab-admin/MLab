$( document ).ready(function() {

  $("#searchthis").click(function() {
      document.location="matlab:fprintf('Searching for %s ...\\n', '"+$("#searchfield").val()+"');";
  });

});


