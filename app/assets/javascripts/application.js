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

	// ajax pagination
	$("#posts th a, #posts .pagination a").live("click", function() {
		$.getScript(this.href);
		return false;
	});

	// PUT THIS IN POSTS INDEX.JS.ERB???
	// initial post load NEED TO REPLACE THIS WITH CLEANER ACTION?
	$.get($("#posts_search").attr("action"), $("#posts_search").serialize(), null, "script");

	// RAILS CASTS RECOMMENDS USING 'LIVE SEARCH GEM'
	$("#posts_search input").keyup(function() {
		$.get($("#posts_search").attr("action"), $("#posts_search").serialize(), null, "script");
		return false;
	});

	// ajax load posts on click submit button
	// $("#posts_search").submit(function() {
	// 	$.get(this.action, $(this).serialize(), null, "script");
	// 	return false;
	// });

	// random background color generator
	var bgcolorlist = new Array("#DFDFFF", "#FFFFBF", "#80FF80", "#EAEAFF", "#C9FFA8", "#F7F7F7", "#DDDD00")
	document.body.style.background = bgcolorlist[Math.floor(Math.random()*bgcolorlist.length)]

});

