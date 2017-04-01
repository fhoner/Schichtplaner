<div class="panel panel-default">
    <div class="panel-heading">
        <h3 class="panel-title">Benutzer</h3>
    </div>
    <div class="panel-body">
        <form autocomplete="off">
        <table>
            <tr>
                <td style="width:200px;">
                    <input type="text" id="createUsername" class="form-control" maxlength="20" placeholder="Benutzername">
                </td>
                <td style="width:5px;"></td>
                <td style="width:200px;">
                    <input type="password" id="createPassword" class="form-control" maxlength="20" placeholder="Passwort" autocomplete="new-password">
                </td>
                <td style="width:5px;"></td>
                <td>
                    <button type="button" class="btn btn-success" onclick="createUser($(this).closest('form'));">
                        <i class="fa fa-user" aria-hidden="true"></i> Benutzer erstellen
                    </button>
                </td>
            </tr>
        </table>
        </form>
    </div>
    <div class="panel-table">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th style="width: 50%;">Name</th>
                    <th>Passwort</th>
                    <th style="width:1px;"></th>
                    <th style="width:1px;"></th>
                </tr>
            </thead>
            <tbody id="tblUsers">
                ${users}$
            </tbody>
        </table>
    </div>
</div>