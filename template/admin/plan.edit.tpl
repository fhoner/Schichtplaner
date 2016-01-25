<div class="pull-right" style="color:gray;">Sie bearbeiten: <strong>${name}$</strong></div><br />
<ul class="nav nav-tabs" role="tablist" style="margin:10px;" id="plan-tabs">
    <li role="presentation" class="active">
        <a href="#Allgemein" aria-controls="Allgemein" role="tab" data-toggle="tab">
            <strong>Allgemein</strong>
        </a>
    </li>
    <li role="presentation">
        <a href="#Produktionen" aria-controls="Produktionen" role="tab" data-toggle="tab">
            <strong>Produktionen</strong>
        </a>
    </li>
    <li role="presentation">
        <a href="#Schichten" aria-controls="Schichten" role="tab" data-toggle="tab">
            <strong>Schichten</strong>
        </a>
    </li>
</ul>
<div class="tab-content">
    <div role="tabpanel" class="tab-pane active" id="Allgemein" style="margin:25px;">
        <div class="col-md-12" style="margin:0px; padding:0px;">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Allgemein</h3>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <label>Name</label>
                        <input type="hidden" id="name-original" value="${name}$" />
                        <input type="textbox" class="form-control" style="width:350px;" id="name" value="${name}$" />
                    </div>
                    <div class="form-group">
                        <label>Öffentlich bis</label><br />
                        <div class="input-group date" data-provide="datepicker" style="width:350px;">
                            <input class="form-control datepicker" data-date-format="mm.dd.yyyy" id="public-to" value="${public}$">
                            <div class="input-group-addon">
                                <span class="glyphicon glyphicon-th"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Editierbar bis</label><br />
                        <div class="input-group date" data-provide="datepicker" style="width:350px;">
                            <input class="form-control datepicker" data-date-format="mm.dd.yyyy" id="edit-to" value="${editable}$">
                            <div class="input-group-addon">
                                <span class="glyphicon glyphicon-th"></span>
                            </div>
                        </div>
                    </div>   
                    <div class="form-group">
                        <label>E-Mail Abonnenten</label><small>(eine Adresse pro Zeile)</small><br />
                        <textarea class="form-control" id="email-subscribers" style="height:120px; width:350px;">${emailSubscribers}$</textarea>
                    </div>        
                    <div class="pull-right">
                        <button type="button" class="btn btn-primary" onclick="savePlanGeneral(this);">Speichern</button>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Löschen</h3>
                </div>
                <div class="panel-body">
                    Dieser Plan wird unwideruflich gelöscht.
                    <div>
                        <button type="button" class="btn btn-danger pull-right" onclick="deletePlan('${name}$');">Löschen</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div role="tabpanel" class="tab-pane" id="Produktionen" style="margin:25px;">
        <div class="col-md-12" style="margin:0px; padding:0px;">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Hinzufügen</h3>
                </div>
                <div class="panel-body">                    
                    <div class="form-group">
                        Füllen Sie alle Felder aus und bestätigen Sie mit <strong>Hinzufügen</strong>, um eine neue Produktion anzulegen.<br><br>
                        <label>Name</label>
                        <input type="textbox" class="form-control" style="width:350px;" id="prod-name" />
                    </div>
                    <div style="margin-top:10px;">
                        <button type="button" class="btn btn-primary pull-right" onclick="createProduction(this);">Hinzufügen</button>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Bearbeiten</h3>
                </div>
                <div class="panel-body">
                    <div class="alert alert-info" role="alert">
                        Hinweis: Von einer Produktion können keine Schichten entfernt werden, denen Helfer zugewiesen sind.
                    </div>
                </div>
                <div class="panel-table">
                    <table class="table table-bordered table-striped" id="table-productions">
                        <thead>
                            <th class="td-debug">UID</th>
                            <th>Name</th>
                            <th>Verantwortlich</th>
                            <th>Schichten</th>
                            <th></th>
                        </thead>
                        <tbody>
                            ${shifts}$
                        </tbody>
                    </table>
                </div>
                <div class="panel-body">      
                    <div class="pull-right">
                        <button type="button" class="btn btn-primary" onclick="saveProductions(this);" id="save-productions">Speichern</button>
                    </div>        
                </div>
            </div>
        </div>
    </div>
    <div role="tabpanel" class="tab-pane" id="Schichten" style="margin:25px;">
        <div class="col-md-12" style="margin:0px; padding:0px;">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Hinzufügen</h3>
                </div>     
                <div class="panel-body">       
                    Füllen Sie alle Felder aus und bestätigen Sie mit <strong>Hinzufügen</strong>, um eine neue Schicht anzulegen.<br><br>
                    <div class="form-group">
                        <label>Von</label>
                        <div class="bfh-timepicker" style="width:350px;" data-time="00:00" id="new-shift-from"></div>
                    </div>
                    <div>
                        <label>Bis</label>
                        <div class="bfh-timepicker" style="width:350px;" data-time="00:00" id="new-shift-to"></div>
                    </div>
                    <div style="margin-top:10px;">
                        <button type="button" class="btn btn-primary pull-right" onclick="createShift(this);">Hinzufügen</button>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Bearbeiten</h3>
                </div>
                <div class="panel-body">
                    <div class="alert alert-info" role="alert">
                        Hinweis: Schichten, denen mindestens eine Produktion zugewiesen ist, können nicht entfernt werden.
                    </div>
                </div>
                <div class="panel-table">
                    <table class="table table-bordered table-striped" id="table-shifts">
                        <thead>
                            <th class="td-debug">UID</th>
                            <th>Von</th>
                            <th>Bis</th>
                            <th></th>
                        </thead>
                        <tbody>
                            ${times}$
                        </tbody>
                    </table>
                </div>
                <div class="panel-body">      
                    <div class="pull-right">
                        <button type="button" class="btn btn-primary" onclick="saveShifts(this);" id="save-shifts">Speichern</button>
                    </div>        
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${${root}$}$js/admin.plan.js"></script>
<script src="${${root}$}$sources/bootstrapformhelpers/js/bootstrap-formhelpers.js"></script>
<script>
$(".datepicker").datepicker({
    format: "dd.mm.yyyy" 
});
</script>