var index = 0;
var isRunning = true;
var results=null;

$(document).ready(function() {
	$("#instruct").hide();
	$("#winner").hide();
	$("#signature").hide();

	url = document.URL;
	console.debug("HERE");
	$.ajax({
		type: "GET",
		url: url.replace("/draws", "/survey_results.json"),
		format: 'js',
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(data){
			$(".loading-message").hide();
			$("#instruct").show();
			results = data;
			setTimeout(iterate, 20);
			$(document).keyup(function(e) {
				if (isRunning)
					isRunning=false;

					$("#winner_patient_id").val(results[index].patient_id)
					$("#winner_practice_id").val(results[index].patient.practice_id)
					
			});
		},
		error: function () {
			console.log(url, arguments)
		}
	});

});


function iterate() {
	if (isRunning) {
		index++;
		$("#name-display").html(results[index].patient.email);
		if(index == results.length)
		{	
			index = 0;
			console.debug("Reset counter");
		}

		setTimeout(iterate, 20);
	}
	else {
		$("#instruct").hide();
		$("#winner").fadeIn();
		$("#signature").fadeIn();
		$("#winner_name").focus();

	}
}



