<!DOCTYPE html>
<html>

<head>
    <title>Schichtplan ${organisation}$</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1, user-scalable=0">
    <script src="dist/js/schichtplaner.js" type="text/javascript"></script>    
    <link rel="stylesheet" href="dist/css/schichtplaner.css">
    <script>const loginRevisit = ${loggedIn}$;</script>
</head>

<body>
    <!-- navbar -->
    <div class="navbar navbar-default navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <button class="navbar-toggle" type="button" data-toggle="collapse" data-target="#navbar-main">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">Schichtplaner</a>
            </div>
            <center>
                <div class="navbar-collapse collapse" id="navbar-main">
                    <form class="navbar-form navbar-right" role="search" id="loginForm">
                        <span id="loggedInAs" ${logout-input-visible}$>Angemeldet als: <strong>ausschuss</strong></span>
                        <div class="form-group login-input" ${login-input-visible}$>
                            <input type="text" class="form-control" name="loginUsername" id="loginUsername" placeholder="Benutzername">
                        </div>
                        <div class="form-group login-input" ${login-input-visible}$>
                            <input type="password" class="form-control" name="password" id="loginPassword" placeholder="Passwort">
                        </div>
                        <button class="btn btn-default" id="loginButton" ${login-input-visible}$>
                            <i class="fa fa-sign-in" aria-hidden="true"></i> Anmelden
                        </button>
                        <button class="btn btn-default" id="logoutButton" ${logout-input-visible}$>
                            <i class="fa fa-sign-out" aria-hidden="true"></i> Abmelden
                        </button>
                    </form>
                </div>
            </center>
        </div>
    </div>


    <div style="width: 100%; text-align:right;"></div>

    <div class="spinner" id="plansLoading">
        <div class="bounce1"></div>
        <div class="bounce2"></div>
        <div class="bounce3"></div>
    </div>
    <div id="plansContent">
    </div>

    <!-- Edit shift modal -->
    <div class="modal fade" tabindex="-1" role="dialog" id="editEntry">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    <h4 class="modal-title">{empty}</h4>
                </div>
                <div class="modal-body" id="editUserLoading">
                    <div class="spinner">
                        <div class="bounce1"></div>
                        <div class="bounce2"></div>
                        <div class="bounce3"></div>
                    </div>
                </div>
                <div class="modal-body" id="editUserContent">
                    <strong>Hinweis: </strong>Durch Klicken in eine Zelle kann der jeweilige Eintrag bearbeitet werden.<br><br>
                    <table class="table table-condensed table-bordered" id="table-edit">
                        <thead>
                            <tr>
                                <th class="tr-debug">UID</th>
                                <th id="thSortUsers"></th>
                                <th style="width:50%;">Name</th>
                                <th style="width:50%;">E-Mail</th>
                                <th style="width:50%;">Fix</th>
                                <th class="tr-debug">Action</th>
                                <th class="tr-delete-worker" style="width:10px;"></th>
                            </tr>
                        </thead>
                        <tbody id="table-edit-tbody">
                            <!-- filled by js -->
                        </tbody>
                    </table>
                    <div style="display:none;">
                        <label>Historie</label>
                        <textarea class="form-control" id="shift-comment" rows="4" readonly></textarea>
                        <input type="text" class="form-control" placeholder="Kommentar hinzufügen..." />
                        <hr />
                    </div>
                    <h4>Helfer hinzufügen</h4> 
                    <div class="form-group">
                        <label for="add-name">Name</label>
                        <input type="text" class="form-control add-worker" placeholder="Vorname Nachname" id="add-name">
                    </div>
                    <div class="form-group">
                        <label for="add-email">E-Mail</label>
                        <input type="text" class="form-control add-worker" placeholder="name@domain.com" id="add-email">
                    </div>
                    <button type="button" class="btn btn-default pull-right add-worker" id="btn-add-user">
                        <i class="fa fa-user-plus"></i> Hinzufügen
                    </button>
                    <br /><br />
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Abbrechen</button>
                    <button type="button" class="btn btn-primary" id="save-shift">
                            <img src="template/loading.gif" alt="loading-animation" id="save-loading" />
                            <i class="fa fa-floppy-o"></i>&nbsp;Speichern
                        </button>
                </div>
            </div>
        </div>
    </div>

    <div style="clear:both;"></div>
    <footer class="footer">
        <p class="text-muted">
            <small>
                Schichtplaner by Felix Honer - 
                <i class="fa fa-github" aria-hidden="true"></i> 
                <a href="https://github.com/fhoner/Schichtplaner" target="_blank">fhoner/schichtplaner</a>
            </small>
        </p>
    </footer>
    

    <!-- Shift cell template -->
    <script id="cellTpl" type="text/template">
    {{#workers}}
        <div class="worker {{^isFixed}}not-fixed{{/isFixed}}" data-name="{{name}}" data-email="{{#hasEmail}}true{{/hasEmail}}{{^hasEmail}}false{{/hasEmail}}">
            <div class="user-name">
                <span class="glyphicon glyphicon-question-sign not-fixed-hint" aria-hidden="true" data-toggle="tooltip" title="Vorläufig"></span>
                <span class="glyphicon glyphicon-ok-sign is-fixed-hint" aria-hidden="true" data-toggle="tooltip" title="Fix"></span>
                <span class="glyphicon glyphicon-envelope missing-email-hint" data-toggle="tooltip" title="Fehlende E-Mail Adresse" aria-hidden="true" style="{{#hasEmail}}display:none;{{/hasEmail}}"></span>
                <span class="name-inline">{{name}}</span>
            </div>
            <div class="user-email">{{#hasEmail}}true{{/hasEmail}}{{^hasEmail}}false{{/hasEmail}}</div>
        </div>
    {{/workers}}
    <div class="td-user-max"><!-- calculated by js --></div>
    <div class="td-comment" style="display:none;"></div>
    </script>

    <!-- Plan tabs and content panes template -->
    <script id="tableTpl" type="text/template">
        <ul class="nav nav-tabs" role="tablist" style="margin:10px;">
            {{#plans}}
            <li role="presentation" class="">
                <a href="#{{uid}}" aria-controls="{{uid}}" role="tab" data-toggle="tab"><strong>{{name}}</strong></a>
            </li>
            {{/plans}}
        </ul>

        <div class="tab-content">
        {{#plans}}
            <div role="tabpanel" class="tab-pane" id="{{uid}}">
                {{#readonly}}
                <div class="alert alert-info closed-hint" role="alert">
                    Dieser Plan ist geschlossen und kann nicht mehr bearbeitet werden.
                </div>
                {{/readonly}}
                <div style="width:100%; text-align:right; margin-bottom:20px;">
                    <a class="btn btn-primary" href="export.php?plan={{urlencoded}}" target="_blank">
                        <span class="glyphicon glyphicon-save" aria-hidden="true"></span> PDF herunterladen
                    </a>
                </div>
                {{^mobile}}
                    {{#groups}}
                    <table class="table table-striped table-bordered table-shifts {{#readonly}}plan-readonly{{/readonly}}" style="float:left;" data-plan-name="{{name}}">
                        <thead>
                            <tr style="height:70px;">
                            <th style="width:60px;"></th>
                            {{#productions}}
                                <th style="vertical-align:middle;">
                                    {{productionName}}<br>
                                    <small>
                                        <a href="mailto:{{masterEmail}}?subject=‹Schichtplaner›&nbsp;Frage&nbsp;zu&nbsp;{{name}}&nbsp;am&nbsp;Donnerstag%202016&amp;body=%0D%0A%0D%0A%0D%0AGesendet&nbsp;über&nbsp;Schichtplaner">
                                            {{masterName}}
                                        </a>&nbsp;
                                    </small>
                                </th>
                            {{/productions}}
                            </tr>
                        </thead>
                        <tbody>
                        {{#shifts}}
                            <tr style="height: 97px;">
                                <td class="td-time">{{from}}<br>-<br>{{to}}</td>
                                {{#productions}}
                                    <td class="td-user" id="{{uid}}-{{productionUid}}-{{from}}-{{to}}" data-shift-name="{{productionName}}" data-unique="{{uid}}-{{productionUid}}-{{from}}-{{to}}">
                                {{/productions}}
                            </tr>
                        {{/shifts}}
                        </tbody>
                    </table>
                    {{/groups}}
                {{/mobile}}
                {{#mobile}}
                    {{#groups}}
                        {{#productions}}
                        <table class="table table-striped table-bordered table-shifts {{#readonly}}plan-readonly{{/readonly}}" style="float:left;" data-plan-name="{{name}}">
                            <thead>
                                <tr style="height:70px;">
                                    <th style="width:60px;"></th>
                                    <th style="vertical-align:middle;">
                                        {{productionName}}<br>
                                        <small>
                                            <a href="mailto:{{masterEmail}}?subject=‹Schichtplaner›&nbsp;Frage&nbsp;zu&nbsp;{{name}}&nbsp;am&nbsp;Donnerstag%202016&amp;body=%0D%0A%0D%0A%0D%0AGesendet&nbsp;über&nbsp;Schichtplaner">
                                                {{masterName}}
                                            </a>&nbsp;
                                        </small>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                            {{#shifts}}
                                <tr style="height: 97px;">
                                    <td class="td-time">{{from}}<br>-<br>{{to}}</td>
                                        <td class="td-user" id="{{uid}}-{{productionUid}}-{{from}}-{{to}}" data-shift-name="{{productionName}}" data-unique="{{uid}}-{{productionUid}}-{{from}}-{{to}}">
                                </tr>
                            {{/shifts}}
                            </tbody>
                        </table>
                        {{/productions}}
                    {{/groups}}
                {{/mobile}}
            </div>
        {{/plans}}
        </div>
    </script>
</body>

</html>