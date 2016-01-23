<!DOCTYPE html>
<html>
    <head>
        <title>Schichtplaner Admin</title>
    	<meta charset="utf-8">
    	<script src="${${root}$}$sources/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
		<link rel="stylesheet" href="${${root}$}$sources/bootstrap/bootstrap.min.css" crossorigin="anonymous">
		<link rel="stylesheet" href="${${root}$}$sources/bootstrap/bootstrap-theme.min.css" crossorigin="anonymous">
		<link rel="stylesheet" href="${${root}$}$sources/datepicker/css/datepicker.css" crossorigin="anonymous">
		<script src="${${root}$}$sources/bootstrap/bootstrap.min.js" crossorigin="anonymous"></script>
	    <script src="${${root}$}$sources/bootstrap/bootbox.js"></script>
	    <script src="${${root}$}$sources/bootstrap/mindmup-editabletable.js"></script>
	    <script src="${${root}$}$sources/datepicker/js/bootstrap-datepicker.js"></script>
        <script src="${${root}$}$sources/bootstrap/mindmup-editabletable.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="${${root}$}$sources/bootstrapformhelpers/css/bootstrap-formhelpers.min.css" crossorigin="anonymous">
        <script>
            root = "${${root}$}$";
        </script>
        <style>
            body {
                margin-top:75px;
            }
            .table {
                font-size:100%;
            }
            td {
                vertical-align: middle !important;
            }
            .td-debug {
                display:none;
            }
            #loading {
                text-align:center; 
                margin-top:50px;
            }
            #loading img {
                width:80px;
            }
            .tr-shift-delete {
                cursor:pointer;
            }
        </style>
    </head>
    <body>
        
    <nav class="navbar navbar-default navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="${${url}$}$/admin/index.php?v=dashboard">Verwaltung</a>
            </div>
            <div id="navbar" class="navbar-collapse collapse">
                <ul class="nav navbar-nav">
                <li class="${homeActive}$"><a href="${${url}$}$/admin/index.php?v=dashboard">Home</a></li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                        Pläne <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu" id="nav-plans">
                        ${navPlans}$
                        <li role="separator" class="divider"></li>
                        <li class="nav-plan">
                            <a href="${${url}$}$/admin/index.php?v=newplan" id="nav-new-plan" class="create-plan">Neuen Plan erstellen</a>
                        </li>
                    </ul>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                        Sonstiges <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu">
                        <li class="nav-plan">
                            <a href="${${url}$}$/admin/index.php?v=history" class="create-plan">Historie</a>
                            <a href="${${url}$}$/admin/index.php?v=email" class="create-plan">Rund-Email</a>
                        </li>
                    </ul>
                </li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="${${root}$}$index.php" target="_blank">Schichtplan öffnen</a></li>
                </ul>
            </div><!--/.nav-collapse -->
        </div>
    </nav>
        
    <div class="container">
        <div class="row">
            <div class="col-md-1"></div>
            <div class="col-md-10" id="content">                
                <div id="loading"><img src="${${url}$}$/template/loading.gif" alt="loading" /></div>
                
            </div>
            <div class="col-md-1"></div>
        </div>    
    </div>
        
    <script>
    var planname = null;
    function getQueryStrings() { 
        var assoc  = {};
        var decode = function (s) { return decodeURIComponent(s.replace(/\+/g, " ")); };
        var queryString = location.search.substring(1); 
        var keyValues = queryString.split('&'); 

        for(var i in keyValues) { 
            var key = keyValues[i].split('=');
            if (key.length > 1) {
                assoc[decode(key[0])] = decode(key[1]);
            }
        } 

        return assoc; 
    } 
        
    function placeContent(content){
        $("#loading").hide();
        $("#content").html(content).hide().fadeIn("fast");
    }
        
    function resetContent(){
        $("#content").html("<div id=\"loading\"><img src=\"${${url}$}$/template/loading.gif\" alt=\"loading\" /></div>").hide().fadeIn("fast");
    }

    function loadContent(){
        resetContent();
        setTimeout(function(){
            $.ajax({
                url: root + "admin/ajax.getContent.php",
                method: "POST",
                data: getQueryStrings(),
                success: function(result) {
                    placeContent(result);
                }
            });
            
            var hash = window.location.hash;
            hash && $('ul.nav a[href="' + hash + '"]').tab('show');
        }, 500);        
    }
        
    function show(title, message){
        bootbox.dialog({
            title: title,
            message: message,
            buttons: {
                main: {
                    label: "Schließen",
                    className: "btn-default"
                }
            }
        });
    }
        
    function getParameterByName(name) {
        name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
        return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
    }
        
    $(function(){
        var hash = window.location.hash;
        hash && $('ul.nav a[href="' + hash + '"]').tab('show');

        $('.nav-tabs a').click(function (e) {
            $(this).tab('show');
            var scrollmem = $('body').scrollTop();
            window.location.hash = this.hash;
            $('html,body').scrollTop(scrollmem);
        });
    });

    $(document).ready(function(){
        $("body").on("click", "a", function(event) {
            if($(this).attr("target") == "_blank")
                return;
            
            event.preventDefault();
            
            if($(this).hasClass("go-new-plan")) {
                $("#nav-new-plan").trigger("click");
                history.pushState('data', '', root + "/admin/index.php?v=newplan");
                loadContent();
            }
            else if($(this).attr("href")[0] != "#") {
                history.pushState('data', '', $(this).attr("href"));
                loadContent();
            }
            
        });
        
        $(".nav a").on("click", function() {
            var attr = $(this).attr('target');
            if(attr == "_blank")
                return;
            
            $("nav").find(".active").removeClass("active");
            $(this).parent().addClass("active");
            if($(this).parent().hasClass("nav-plan")){
                $(this).parent().parent().parent().addClass("active");
            }
        });
        
        loadContent();
    });
    </script>
    </body>
</html>