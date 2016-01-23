<div class="panel panel-default">
    <div class="panel-heading">
        <h3 class="panel-title">Neuen Plan erstellen</h3>
    </div>
    <div class="panel-body">
        <div class="form-group">
            <label>Name</label>
            <input type="textbox" class="form-control" style="width:350px;" id="name" />
        </div>
        <div class="form-group">
            <label>Öffentlich bis</label><br />
            <div class="input-group date" data-provide="datepicker" style="width:350px;">
                <input class="form-control datepicker" data-date-format="mm.dd.yyyy" id="public-to">
                <div class="input-group-addon">
                    <span class="glyphicon glyphicon-th"></span>
                </div>
            </div>
        </div>
        <div class="form-group">
            <label>Editierbar bis</label><br />
            <div class="input-group date" data-provide="datepicker" style="width:350px;">
                <input class="form-control datepicker" data-date-format="mm.dd.yyyy" id="edit-to">
                <div class="input-group-addon">
                    <span class="glyphicon glyphicon-th"></span>
                </div>
            </div>
        </div>
        
        <div class="pull-right">
            <button type="button" class="btn btn-primary" onclick="create();">Speichern</button>
        </div>
    </div>
</div>
<script>
    $('.datepicker').datepicker({
        format: 'dd.mm.yyyy'
    });
    
    function create(){        
        $.ajax({
            url: "ajax.createPlan.php",
            method: "POST",
            data: {
                "name": $("#name").val(),
                "public": $("#public-to").val(),
                "editable": $("#edit-to").val()
            },
            success: function(result) {
                if (result.substring(0, 7) == "SUCCESS") {
                    result = result.substr(7, result.length - 7); 
                    $("#name").val("");
                    $("#public-to").val("");
                    $("#edit-to").val("");
                    $("#nav-plans").prepend(result);
                    show("Plan erstellt", "Der Plan wurde erfolgreich angelegt.");
                }
                else
                    show("Fehler", result);
            }
        })
    }
</script>