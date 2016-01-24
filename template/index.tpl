<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <script src="sources/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
        <link rel="stylesheet" href="sources/bootstrap/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" href="sources/bootstrap/bootstrap-theme.min.css" crossorigin="anonymous">
        <script src="sources/bootstrap/bootstrap.min.js" crossorigin="anonymous"></script>
        <script src="sources/bootstrap/bootbox.js"></script>
        <script src="sources/bootstrap/mindmup-editabletable.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="template/main.css">
    </head>
    <body>

        <ul class="nav nav-tabs" role="tablist" style="margin:10px;">
            ${plansTab}$
        </ul>
        <div class="tab-content">
            ${plansContent}$
        </div>

        <div class="modal fade" tabindex="-1" role="dialog" id="editEntry">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h4 class="modal-title"></h4>
                    </div>
                    <div class="modal-body">
                        <strong>Hinweis: </strong>Durch Klicken in eine Zelle kann der jeweilige Eintrag bearbeitet werden.<br><br>
                        <table class="table table-hover table-condensed table-bordered" id="table-edit">
                            <thead>
                                <tr>
                                    <th class="tr-debug">UID</th>
                                    <th style="width:50%;">Name</th>
                                    <th style="width:50%;">E-Mail</th>
                                    <th class="tr-debug">Action</th>
                                    <th class="tr-delete-worker" style="width:10px;"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- filled by js -->
                            </tbody>
                        </table>     
                        <hr />
                        Name
                        <div>
                            <input type="text" class="form-control add-worker" placeholder="Vorname Nachname" id="add-name">		
                        </div>
                        E-Mail
                        <div>
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
                            <img src="template/loading.gif" id="save-loading" />
                            <i class="fa fa-floppy-o"></i>&nbsp;Speichern
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div style="clear:both;"></div>
        <footer class="footer">
            <div class="container">
                <p class="text-muted"><small>v1.0 &copy; 2016 Felix Honer, MV Öschelbronn e.V.</small></p>
            </div>
        </footer>        
        <script src="js/user.main.js"></script>
    </body>
</html>