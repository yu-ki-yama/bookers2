
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require bootstrap-sprockets
//= require_tree .

$(function() {
    $(document).on('ajax:success', 'form', function(e) {
        $('.clear').val('');
    })
})

onPageLoad('follows#show', function() {

    console.log($.cookie("tab_on_num"))

    if(typeof $.cookie("tab_on_num") === 'undefined'){
        console.log('hatu')
        $.cookie("tab1_query", "",{path:"/"})
        $.cookie("tab2_query", "",{path:"/"})
        $('div#follower').fadeIn(1000)
    }else if ($.cookie("tab_on_num") === "0"){
        console.log("tab1")
        $(".tab1").addClass("active")
        $(".tab2").removeClass("active")
        $('div#follower').fadeIn(1000)
    }else if($.cookie("tab_on_num") === "1"){
        console.log("tab2")
        $(".tab2").addClass("active")
        $(".tab1").removeClass("active")
        $('div#follow').fadeIn(1000)
    }else{
        console.log('error')
    }

    $(document).on('click',".tab1 > a",(function(){
        $.cookie("tab_on_num", 0,{path:"/"})
        $.cookie("tab2_query", $(location).attr('search'),{path:"/"})
        window.location.href = "http://localhost:3000/follows/1"+$.cookie("tab1_query")
    }))

    $(document).on('click',".tab2 > a",(function(){
        console.log("tab2を押した")
        $.cookie("tab_on_num", 1,{path:"/"})
        $.cookie("tab1_query", $(location).attr('search'),{path:"/"})
        window.location.href = "http://localhost:3000/follows/1"+$.cookie("tab2_query")
    }))

});