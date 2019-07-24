
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
    $(document).on('ajax:success', 'form.create', function(e) {
        $('.clear').val('')
    })
})
$(document).on("ready turbolinks:load", function() {

    $(function(){
        //画像ファイルプレビュー表示のイベント追加 fileを選択時に発火するイベントを登録
        $('form').on('change', 'input[type="file"]', function(e) {
            console.log('toritori')
            var file = e.target.files[0],
                reader = new FileReader(),
                $upload_view = $(".upload_view");
            t = this;

            // 画像ファイル以外の場合は何もしない
            if(file.type.indexOf("image") < 0){
                return false;
            }

            // ファイル読み込みが完了した際のイベント登録
            reader.onload = (function(file) {
                return function(e) {
                    //既存のプレビューを削除
                    $upload_view.empty();
                    // .prevewの領域の中にロードした画像を表示するimageタグを追加
                    $upload_view.append($('<img>').attr({
                        src: e.target.result,
                        width: "150px",
                        class: "upload_view",
                        title: file.name
                    }));
                };
            })(file);

            reader.readAsDataURL(file);
        });
    })

    onPageLoad('follows#show', function() {

        if(typeof $.cookie("tab_on_num") === 'undefined'){
            $.cookie("tab1_query", "",{path:"/"})
            $.cookie("tab2_query", "",{path:"/"})
            $('div#follower').fadeIn(1000)
        }else if ($.cookie("tab_on_num") === "0"){
            $(".tab1").addClass("active")
            $(".tab2").removeClass("active")
            $('div#follower').fadeIn(1000)
        }else{
            $(".tab2").addClass("active")
            $(".tab1").removeClass("active")
            $('div#follow').fadeIn(1000)
        }

        $(document).on('click',".tab1 > a",(function(){
            $.cookie("tab_on_num", 0,{path:"/"})
            $.cookie("tab2_query", $(location).attr('search'),{path:"/"})
            window.location.href = "http://localhost:3000/follows/1"+$.cookie("tab1_query")
        }))

        $(document).on('click',".tab2 > a",(function(){
            $.cookie("tab_on_num", 1,{path:"/"})
            $.cookie("tab1_query", $(location).attr('search'),{path:"/"})
            window.location.href = "http://localhost:3000/follows/1"+$.cookie("tab2_query")
        }))

    })

})



