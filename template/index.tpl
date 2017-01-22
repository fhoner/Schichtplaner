<!DOCTYPE html>
<html>

<head>
    <title>Schichtplan ${organisation}$</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1, user-scalable=0">
    <script src="dist/js/schichtplaner.js" type="text/javascript"></script>
    <link rel="stylesheet" href="dist/css/schichtplaner.css">
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
                    <h4 class="modal-title">{empty}</h4>
                </div>
                <div class="modal-body">
                    <strong>Hinweis: </strong>Durch Klicken in eine Zelle kann der jeweilige Eintrag bearbeitet werden.<br><br>
                    <table class="table table-hover table-condensed table-bordered" id="table-edit">
                        <thead>
                            <tr>
                                <th class="tr-debug">UID</th>
                                <th style="width:50%;">Name</th>
                                <th style="width:50%;">E-Mail</th>
                                <th style="width:50%;">Fix</th>
                                <th class="tr-debug">Action</th>
                                <th class="tr-delete-worker" style="width:10px;"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- filled by js -->
                        </tbody>
                    </table>
                    <div style="display:none;">
                        <label>Historie</label>
                        <textarea class="form-control" id="shift-comment" rows="4" readonly></textarea>
                        <input type="text" class="form-control" placeholder="Kommentar hinzufügen..." />
                        <hr />
                    </div>
                    <h4>Helfer hinzufügen</h4> Name
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
                            <img src="template/loading.gif" alt="loading-animation" id="save-loading" />
                            <i class="fa fa-floppy-o"></i>&nbsp;Speichern
                        </button>
                </div>
            </div>
        </div>
    </div>
    <div style="clear:both;"></div>
    <footer class="footer">
        <div class="container"><br>
            <p class="text-muted"><small>v1.0 &copy; 2016 Felix Honer, MV Öschelbronn e.V.</small></p>
        </div>
    </footer>
</body>

</html>
<!-- page creation duration was ${creationTime}$ms -->