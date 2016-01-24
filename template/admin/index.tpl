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
        <link rel="stylesheet" href="${${root}$}$template/admin/main.css" crossorigin="anonymous">
        <script>
            root = "${${root}$}$";
        </script>
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
                            <a href="${${url}$}$/admin/index.php?v=email" class="create-plan">Rundmail</a>
                        </li>
                    </ul>
                </li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="${${root}$}$index.php" target="_blank">Schichtplan öffnen</a></li>
                </ul>
            </div>
        </div>
    </nav>
        
    <div class="container">
        <div class="row">
            <div class="col-md-1"></div>
            <div class="col-md-10" id="content">                
                <div id="loading"><img src="${${root}$}$template/loading.gif" alt="loading" /></div>
                
            </div>
            <div class="col-md-1"></div>
        </div>    
    </div>
    <script src="${${root}$}$js/admin.main.js"></script>
    </body>
</html>