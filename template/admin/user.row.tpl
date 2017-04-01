<tr>
    <td style="display: none;"><input type="text" class="form-control user-originalname" value="${name}$"></td>
    <td><input type="text" class="form-control user-name" value="${name}$"></td>
    <td><input type="password" class="form-control user-password" value="" placeholder="leer um Passwort nicht zu ändern"></td>
    <td>
        <button type="button" class="btn btn-info" onclick="saveUser($(this).closest('tr'));" data-toggle="tooltip" data-placement="top" title="Speichern">
            <i class="fa fa-floppy-o" aria-hidden="true"></i>
        </button>
    </td>
    <td>
        <button type="button" class="btn btn-danger" onclick="deleteUser($(this).closest('tr'));" data-toggle="tooltip" data-placement="top" title="Löschen">
            <i class="fa fa-trash-o" aria-hidden="true"></i>
        </button>
    </td>
</tr>