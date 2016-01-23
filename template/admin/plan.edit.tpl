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
                    <input type="checkbox" id="delete-confirm" />
                    &nbsp;Ich bestätige, dass alle Daten dieses Plans werden unwiderruflich gelöscht werden<br>
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
<script>        
    var deletedShifts = [];
    planname = getParameterByName('p');
    
    $('#table-productions').editableTableWidget();
    
    function deletePlan(name){
        bootbox.dialog({
            message: "Soll der Plan <strong>" + planname + "</strong> mit allen Daten gelöscht werden? ",
            title: "Löschen des Plans <strong>" + planname + "</strong> bestätigen",
            buttons: {
                main: {
                    label: "Abbrechen",
                    className: "btn-default",
                    callback: function() { }
                },
                danger: {
                    label: "Löschen",
                    className: "btn-danger",
                    callback: function() {
                        $.ajax({
                           url: root + "admin/ajax.removePlan.php",
                            method: "POST",
                            data: {
                                plan: planname
                            },
                            success: function(result) {
                                if(result == "SUCCESS") {
                                    $(".nav-plan").each(function(){   // remove plan from nav
                                        if($(this).html() == planname)
                                            $(this).closest("li").remove();
                                    });
                                    history.pushState('data', '', root + "admin/index.php?v=dashboard");
                                    loadContent();
                                }
                                else
                                    show("Fehler", result);
                            }
                        });
                    }
                }
            }
        });
    }
    
    function createShift(el){
        $(el).prop("disabled", true);
        var obj = {};
        obj.from = $("#new-shift-from").find("input").val();
        obj.to = $("#new-shift-to").find("input").val();
        
        $.ajax({
            url: root + "admin/ajax.createShift.php",
            method: "POST",
            data: {
                data: obj,
                plan: planname
            },
            success: function(result){
                if(result == "SUCCESS")
                    window.location.reload(true);
                else {
                    show("Fehler", result);
                    $(el).prop("disabled", false);
                }
            }
        });
    }
    
    function saveShifts(el){
        $(el).prop("disabled", true);
        
        var obj = {};
        var updated = [];
        obj.deleted = deletedShifts;
        $(".tr-shift").each(function(){
            var t = {};
            t['id'] = $(this).find(".tr-shift-uid").html();
            t['from'] = $(this).find(".tr-shift-from").find("input").val();
            t['to'] = $(this).find(".tr-shift-to").find("input").val();
            
            updated.push(t);
        });
        obj.updated = updated;
        
        $.ajax({
            url: root + "admin/ajax.updateShifts.php",
            method: "POST",
            data: {
                data: obj
            },
            success: function(result){
                if(result == "SUCCESS")
                    loadContent();
                else {
                    show("Fehler", result);
                    $(el).prop("disabled", false);
                }
            }
        });
    }
    
    function createProduction(el) {
        $(el).prop("disabled", true);
        $.ajax({
            url: root + "admin/ajax.createProduction.php",
            method: "POST",
            data: {
                plan: planname,
                name: $("#prod-name").val()
            },
            success: function(result){
                if(result == "SUCCESS")
                    loadContent();
                else
                    show("Fehler", result);
            }
        });
    }
    
    function toggle(el) {
        var cb = $(el).find("input");
        if($(cb).is(":checked")) {
            $(cb).prop("checked", false);
        }
        else {
            $(cb).prop("checked", true);
        }
    }
    
    $(function(){
        var hash = window.location.hash;
        hash && $('ul.nav a[href="' + hash + '"]').tab('show');

        $('.nav-tabs a').click(function (e) {
            $(this).tab('show');
            var scrollmem = $('body').scrollTop();
            window.location.hash = this.hash;
            $('html,body').scrollTop(scrollmem);
        });
    });
    
    function savePlanGeneral(el) {
        $(el).prop("disabled", true);
        
        var lines = $('#email-subscribers').val().split(/\n/);
        var texts = [];
        for (var i = 0; i < lines.length; i++) {
            if (/\S/.test(lines[i])) {
                texts.push($.trim(lines[i]));
            }
        }
        
        $.ajax({
            url: root + "admin/ajax.updatePlan.php",
            method: "POST",
            data: {
                originalName:   $("#name-original").val(),
                name:           $("#name").val(),
                public:         $("#public-to").val(),
                editable:       $("#edit-to").val(),
                subscribers:    lines
            },
            success: function(result){
                if(result == "SUCCESS") {                    
                    $("#nav-plans li").each(function(){
                        if($(this).find("a").html() == $("#name-original").val()){
                            $(this).find("a")
                                .html($("#name").val())
                                .attr("src", root + "admin/index.php?v=plan&p=" + $("#name").val());
                        }
                    });
                    
                    history.pushState('data', '', root + "admin/index.php?v=plan&p=" + $("#name").val());
                    loadContent();
                    
                    planname = $("#name").val();
                    $("#name-original").val(planname);
                    //show("Änderungen gespeichert", "Die Änderungen wurden erfolgreich gespeichert.");*/
                }
                else {
                    show("Fehler", result);
                    $(el).prop("disabled", false);
                }
            }
        });
    }
    
    function saveProductions(el) {
        $(el).prop("disabled", true);
        var checked = [];
        $(".tr-production").each(function(){
            var shifts = {};
            var arr = [];
            shifts.uid = $(this).find(".tr-production-uid").html();
            shifts.name = $(this).find(".tr-production-name").html();
            
            var master = {};
            master.name = $(this).find(".tr-production-master-name").html();
            master.email = $(this).find(".tr-production-master-email").html();
            shifts.master = master;
            
            $(this).find(".tr-production-shifts").each(function(){
                $(this).find(".production-shift-entry").each(function(){
                    var temp = {};
                    temp['id'] = $(this).find(".production-shift-entry-name").val();
                    temp['checked'] = $(this).find(".production-shift-entry-name").is(":checked");
                    temp['max'] = $(this).find(".production-shift-entry-required").val();
                    arr.push(temp); 
                });
            });
            shifts.shifts = arr;
            checked.push(shifts);
        });        
        
        $.ajax({
            url: root + "admin/ajax.updateProductions.php",
            method: "POST",
            data: {
                data: checked,
                plan: planname
            },
            success: function(result){
                if(result == "SUCCESS")
                    loadContent();
                else {
                    show("Fehler", result);
                    $(el).prop("disabled", false);
                }
            }
        });
    }
    
    $("body").on("click", ".tr-production-delete", function() {
        var el = $(this);
        $(this).closest("tr")
            .css({
                "background-color":     "#f3dede",
                "cursor":               "not-allowed"
            })
            .find("td").addClass("readonly")
            .closest("tr").find("table")
                .css({
                    "background-color":     "#f3dede",
                    "cursor":               "not-allowed"
                });
        setTimeout(function(){
            $(el).closest("tr").remove();
        }, 1000);        
    });
    
    $("body").on("click", ".tr-shift-delete", function() {
        var el = $(this);
        deletedShifts.push($(this).closest("tr").find(".tr-shift-uid").html());
        
        $(this).closest("tr")
            .css({
                "background-color":     "#f3dede",
                "cursor":               "not-allowed"
            })
        $(this).closest("tr")
                .css({
                    "background-color":     "#f3dede",
                    "cursor":               "not-allowed"
                });
        setTimeout(function(){
            $(el).closest("tr").remove();
        }, 250);        
    });

</script>

<script src="${${root}$}$sources/bootstrapformhelpers/js/bootstrap-formhelpers.js"></script>