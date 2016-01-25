/*
 * plan management javascript file
 * Felix Honer
 * 2016/01/24
 */

/*
 * CREATE PLAN
 */

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


/*
 * EDIT PLAN
 */

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
            
            $(el).prop("disabled", false);
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