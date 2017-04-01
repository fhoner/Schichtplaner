function saveUser(row) {
    var data = {};
    data['originalusername'] = row.find(".user-originalname").val();
    data['username'] = row.find(".user-name").val();
    data['password'] = row.find(".user-password").val();
    data['action'] = "update";
    
    $.ajax({
        url: root + "admin/ajax.user.php",
        method: "POST",
        data: data,
        success: function(res) {
            console.log(res);
            if (res.success) {
                row.find(".user-originalname").val(data['username']);
                row.find(".user-password").val('');
                Notify.success('Gespeichert', res.message);
            } else {
                Notify.error('Fehler', res.message);
            }
        }
    });
}

function deleteUser(row) {
    var data = {};
    data['originalusername'] = row.find(".user-originalname").val();
    data['username'] = row.find(".user-name").val();
    data['password'] = row.find(".user-password").val();
    data['action'] = "delete";
    
    iziToast.show({
        color: 'red',
        icon: 'question',
        position: 'topRight',
        title: 'Löschen',
        message: 'Soll der Benutzer <span style="font-weight: bold;">' + data['username'] + '</span> gelöscht werden?',
        buttons: [
            ['<button>Ok</button>', function(instance, toast) { 
                $.ajax({
                    url: root + "admin/ajax.user.php",
                    method: "POST",
                    data: data,
                    success: function(res) {
                        console.log(res);
                        if (res.success) {
                            row.find(".user-originalname").val(data['username']);
                            row.remove();
                            Notify.success('Gelöscht', res.message);
                        } else {
                            Notify.error('Fehler', res.message);
                        }
                    }
                });
                instance.hide({}, toast);
            }],
            ['<button>Abbrechen</button>', function(instance, toast) { 
                instance.hide({}, toast);
            }]
        ]
    });   
}

function createUser(ev) {
    var data = {};
    data['action'] = "create";
    data['username'] = $("#createUsername").val();
    data['password'] = $("#createPassword").val();
    
    console.log(data);
    $.ajax({
        url: root + "admin/ajax.user.php",
        method: "POST",
        data: data,
        success: function(res) {
            if (res.success) {
                Notify.success('Gespeichert', res.message);
                $("#tblUsers").html(res.html);
                $("#createUsername").val('');
                $("#createPassword").val('');
            } else {
                Notify.error('Fehler', res.message);
            }
        }
    });
}