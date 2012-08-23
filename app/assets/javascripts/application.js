// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//= http://download.skype.com/share/skypebuttons/js/skypeCheck.js
//= http://maps.google.com/maps/api/js?sensor=false
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require bootstrap
//= require_tree .

$(function() {


	/////////////////// MAP PAGE AJAX //////////////////
	// Surely I can put this in some map specific location?

	// initial post load
	// PUT THIS IN POSTS INDEX.JS.ERB???
	updateposts();

	// live search reload function	
  	// NB RAILSCASTS RECOMMENDS USING 'LIVE SEARCH GEM' instead of this
	$("#posts_search_form input").keyup(function() {
		updateposts();
	});

	// update on change radio buttons in filter
	// COMBINE WITH FUNCTION ABOVE?
	$("input[name=type]").change(function () {
		updateposts();
	});

	// function that submits search form, for all above
	function updateposts () {
		$.get($("#posts_search_form").attr("action"), $("#posts_search_form").serialize(), null, "script");
	  return false;
	}

	// ajax pagination
	$("#posts th a, #posts .nexus_pagination a").live("click", function() {
		$.getScript(this.href);
		return false;
	});

	// check box when click on menu item link
	// TBD
	// $(".filter_pulldown_item").click(function(){
	// 	$(this).find("input").attr('checked', 'checked');
	// });



	/////////////////// THROUGHOUT SITE /////////////////

	// random background color generator
	var bgcolorlist = new Array("#FFFFBF", "#93ff93", "#C9FFA8","#9bd6ff", "#feabc3", "#b46cfd", "#fdcf6c");
	document.body.style.background = bgcolorlist[Math.floor(Math.random()*bgcolorlist.length)]



});





