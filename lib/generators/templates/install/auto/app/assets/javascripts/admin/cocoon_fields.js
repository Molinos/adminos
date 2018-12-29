// Отображение полей в завиисимости от выбранной опции в селекте при использование Cocoon
$(function() {
  function toggleFields() {
    $('.toggle-fields').each(function() {
      var selected = $(this).val(),
          root = $(this).closest('.toggle-fields-container').first();

      if (selected) {
        root.find('.options__item').hide();
        root.find('.options__item').each(function() {
          var types = $(this).data('type').split(' ');
          if ($.inArray(selected, types) != -1) {
            $(this).show();
          }
        });
      }
    });
  }

  function initToggleFields() {
    $(document).on('change', '.toggle-fields', function(e) {
      toggleFields();
    });

    $(document).on('cocoon:after-insert', function() {
      toggleFields();
    });
  }

  $(window).on('turbolinks:load', function() {
    toggleFields();
    initToggleFields();
  });
});

$(document).on('click', '.nav-tabs .nav-link, .nav-pills .nav-link', function(e) {
  e.preventDefault();
  $(this).closest('.pills_container').find(".nav-link.active").removeClass("active");
  $(this).addClass("active");
  $(this).closest('.pills_container').find(".tab-pane.active").removeClass("in active");
  var target = $(e.target).attr("href");
  $(this).closest('.pills_container').find(target).addClass("in active");
});
