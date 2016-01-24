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
<script src="${${root}$}$js/admin.plan.js"></script>