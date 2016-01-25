<div class="panel panel-default">
    <div class="panel-heading">
        Rundmail senden
    </div>
    <div class="panel-body">
        <div class="alert alert-info" role="alert">
            <strong>Info: </strong> Es ist nicht möglich, über diese Webanwendung eine Rundmail zu verschicken. 
            Daher wird empfohlen, die generierte Empfängerliste am unteren Ende dieser Ansicht in die Adresszeile
            ihres Mail-Clients zu kopieren.<br>
            Tipp: Nutzen Sie das BCC-Feld, um den Empfängern nicht die 
            Adressliste bekanntzugeben.
        </div>
        Wählen Sie die Empfänger der Rundmail. Es besteht die Möglichkeit, 
        eine Auswahl von Benutzern nach Plänen zu setzen.<br><br>
        <div class="form-group">
            <input type="radio" name="selectionmode" id="select-manual" checked />&nbsp;Manuelle Auswahl<br />
        </div>
        <div class="form-group">
            <input type="radio" name="selectionmode" id="select-plan" />&nbsp;Plan wählen
            <div style="margin:10px;">
                ${plans}$
            </div>
        </div>
    </div>
    <table class="table table-striped">
        <thead>
            <tr>
                <th></th>
                <th>Name</th>
                <th>Adresse</th>
                <th>Pläne</th>
            </tr>
        </thead>
        <tbody>
            ${recipients}$
        </tbody>
    </table>
    <div class="panel-body">
        <br />
        <label>E-Mail Empfänger Adressen</label>
        <table style="width:100%;">
            <tr>
                <td><textarea class="form-control" style="height:100px;" id="all-recipients"></textarea></td>
                <td style="width:10px;"></td>
                <td style="width:10px;">
                    <button class="btn btn-primary" disabled style="height:100%; padding:0px; width:100px;" id="copy-recipients">
                        Kopieren
                    </button>
                </td>
            </tr>
        </table>        
    </div>
</div>
<script src="${${root}$}$js/admin.mail.js"></script>
   