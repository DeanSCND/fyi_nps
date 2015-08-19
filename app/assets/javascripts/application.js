// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap
//= require stupidtable
//= require bootstrap-file-input

$(function() {
  $('#run-link').click(function(e) {
		window.location	= "/reports?run=" + $("#run-name").val();
	})

  $('#survey_label').blur(function(e) {
    var monthNames = ["January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];

    parts = $(this).val().split("_");

    if (parts.length == 2) {
      $(this).val($(this).val().toUpperCase()+"_RUN");
      $('#month_label').val(parts[0].toLowerCase().charAt(0).toUpperCase()+parts[0].toLowerCase().substr(1))
      $('#year_label').val(parts[1])

      date = new Date(Number(parts[1]), new Date(Date.parse(parts[0] +" 1, 2012")).getMonth());
      var firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
      var lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);

      $('#start_date').val(monthNames[firstDay.getMonth()] + " " + firstDay.getDate() + ", " + firstDay.getFullYear());
      $('#end_date').val(monthNames[lastDay.getMonth()] + " " + lastDay.getDate() + ", " + lastDay.getFullYear());
    }

  })

    // Helper function to convert a string of the form "Mar 15, 1987" into a Date object.
    var date_from_string = function(str) {
      var months = ["jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"];
      var pattern = "^([a-zA-Z]{3})\\s*(\\d{1,2}),\\s*(\\d{4})$";
      var re = new RegExp(pattern);
      var DateParts = re.exec(str).slice(1);

      var Year = DateParts[2];
      var Month = $.inArray(DateParts[0].toLowerCase(), months);
      var Day = DateParts[1];

      return new Date(Year, Month, Day);
    }

    var table = $("#report-table").stupidtable({
      "date": function(a,b) {
        // Get these into date objects for comparison.
        aDate = date_from_string(a);
        bDate = date_from_string(b);
        return aDate - bDate;
      }
    });

    table.on("beforetablesort", function (event, data) {
      // Apply a "disabled" look to the table while sorting.
      // Using addClass for "testing" as it takes slightly longer to render.
      $("#msg").text("Sorting...");
      $("#report-table").addClass("disabled");
    });

    table.on("aftertablesort", function (event, data) {
      // Reset loading message.
      $("#msg").html("&nbsp;");
      $("#report-table").removeClass("disabled");

      var th = $(this).find("th");
      th.find(".arrow").remove();
      var dir = $.fn.stupidtable.dir;

      var arrow = data.direction === dir.ASC ? "&uarr;" : "&darr;";
      th.eq(data.column).append('<span class="arrow">' + arrow +'</span>');
    });

	$(".report-table-row").click(function(){
		document.location = $(this).attr("data-url");
	});
	
	$('input[type=file]').bootstrapFileInput();
	$('.file-inputs').bootstrapFileInput();
	
});
