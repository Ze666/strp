
window.addEventListener('message', function(e) {
	$("#container").stop(false, true);
    if (e.data.displayWindow == 'true') {
        $("#container").css('display', 'flex');
  		
        $("#container").animate({
			bottom: "27%",
        	opacity: "2.0"
        	},
        	700, function() {

        });

    } else {
    	$("#container").animate({
        	bottom: "-50%",
        	opacity: "0.0"
        	},
        	700, function() {
        		$("#container").css('display', 'none');
	         	
        });
    }
});

