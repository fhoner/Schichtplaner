/*
 * main js file
 * Felix Honer
 * 2017/03/09
 */

var editObject = null; // save editing object to store changed into it
var deletedArr = new Array();   // stores deleted objects
var max = 0;    // required user count for one shift
var planname = "${name}$";  // can change when user renames the plan; so use js variable instead of template engine
var isLoggedIn = false; // boolean whether user is logged in or not

function login() {
    $(".login-input").find("input, button").prop("disabled", true);
    $("#loginButton").prop("disabled", true);
    setTimeout(function() {
        $.ajax({
            url: "ajax.login.php",
            method: "POST",
            data: {
                "username": $("#loginUsername").val(),
                "password": $("#loginPassword").val()
            },
            success: function(res) {
                res = JSON.parse(res);
                if (res.success) {
                    setIsLoggedIn(true);
                    $("body").stop().hide().fadeIn();
                    $("#logoutButton").html('<i class="fa fa-sign-out" aria-hidden="true"></i>Abmelden');
                    $("#loggedInAs").find("strong").html(res.username);
                    $(".login-input").hide();
                } else {
                    setIsLoggedIn(false);
                    bootbox.alert('<strong>Anmeldung fehlgeschlagen</strong><br><br><p>' + res.message + '</p>');
                    $("#loginUsername, #loginPassword").val('');
                }

                $(".login-input").find("input, button").prop("disabled", false);
                $("#loginButton").prop("disabled", false);
            }
        });
    }, 250);
}

function setIsLoggedIn(loggedIn) {
    isLoggedIn = loggedIn;

    if (isLoggedIn) {
        $(".td-user").css("cursor", "pointer");
        $("#loginButton, .login-input").hide();
        $("#logoutButton").show();
        $("#loggedInAs").show();
    } else {
        $(".td-user").css("cursor", "auto");
        $("#logoutButton").hide();
        $("#loginButton, .login-input").show();
        $("#loggedInAs").hide();
    }
}

function updateWorkersFixedInfo(cell) {
    if (cell == typeof undefined || cell == null) {	 // update all cells 
        $(".worker").each(function () {
            if ($(this).hasClass("not-fixed")) {
                $(this).find(".is-fixed-hint").hide();
                $(this).find(".not-fixed-hint").show();
            } else {
                $(this).find(".is-fixed-hint").show();
                $(this).find(".not-fixed-hint").hide();
            }

            if ($(this).data("email") != "") {
                $(this).find(".missing-email-hint").hide();
            } else {
                $(this).find(".missing-email-hint").show();
            }
        });
    } else {
        $(cell).find(".worker").each(function () {
            if ($(this).hasClass("not-fixed")) {
                $(this).find(".is-fixed-hint").hide();
                $(this).find(".not-fixed-hint").show();
            } else {
                $(this).find(".is-fixed-hint").show();
                $(this).find(".not-fixed-hint").hide();
            }

            if ($(this).data("email") != "") {
                $(this).find(".missing-email-hint").hide();
            } else {
                $(this).find(".missing-email-hint").show();
            }
        });
    }
}

function escapeHtml(unsafe) {
    return unsafe
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/'/g, "&#039;");
}

function show(title, message, callback) {
    bootbox.dialog({
        title: title,
        message: message,
        buttons: {
            main: {
                label: "Schließen",
                className: "btn-default",
                callback: callback
            }
        }
    });
}

function updateCells() {
    $(".td-user").each(function (index, el) {
        var userCount = $(this).find(".worker").length;

        if ($(this).hasClass("shift-disabled"))
            $(this).addClass("info");

        if ($(this).data("required") > userCount) {
            if (userCount > 0) {
                $(this).removeClass("success danger");
                $(this).addClass("warning");
            }
            else {
                $(this).removeClass("success warning");
                $(this).addClass("danger");
            }
        }
        else {
    $("#loginResult").hide();
            $(this).removeClass("warning danger");
            $(this).addClass("success");
        }

        // update missing worker count
        var missingCount = $(this).data("required") - userCount;
        $(this).find(".td-user-max").html(missingCount);
    });

    $(".plan-readonly").each(function () {
        $(this).find(".td-user").each(function () {
            $(this).removeClass("success warning danger info");
            $(this).addClass("td-disabled");
        });
    });
}

function levelRows() {
    $("table tbody tr").css("height", "auto");

    $("table").each(function () {
        var maxHeight = 0;
        $(this).find("tbody").find("tr").each(function () {
            if ($(this).height() > maxHeight)
                maxHeight = $(this).height();
        });
        $(this).find("tbody").find("tr").each(function () {
            $(this).css("height", maxHeight + "px");
        });
    });


}

$.urlParam = function (name) {
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results == null) {
        return null;
    }
    else {
        return results[1] || 0;
    }
}

$(function () {
    var hash = window.location.hash;
    hash && $('ul.nav a[href="' + hash + '"]').tab('show');

    $('.nav-tabs a').click(function (e) {
        $(this).tab('show');
        var scrollmem = $('body').scrollTop();
        window.location.hash = this.hash;
        $('html,body').scrollTop(scrollmem);
    });
});

$(document).ready(function () {
    updateCells();
    levelRows();
    updateWorkersFixedInfo(null);

    if (loginRevisit) {
        setIsLoggedIn(true);
    }

    $(".top").tooltip({
        placement: "top"
    });

    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        levelRows();
    });

    $("body").on("click", "td", function () {
        if ($(this).find(".delete-user").length > 0) {
            $(this).find(".delete-user").trigger("click");
        }
    });

    $("#loginButton").click(function() {
        $("#loginResult").hide();
        $("#loginModal").modal("toggle");
    });

    $("#loginForm").submit(function(ev) {
        ev.preventDefault();
        login();
    });

    $("#logoutButton").click(function() {
        $(this).prop("disabled", true);
        $.ajax({
            url: "ajax.logout.php",
            method: "POST",
            success: function(res) {
                res = JSON.parse(res);
                console.log(res);
                if (res.success) {
                    setIsLoggedIn(false);
                    $("body").stop().hide().fadeIn("fast");
                } else {
                    alert("Unbekannter Fehler");
                }
                $("#logoutButton").prop("disabled", false);
            }
        });
    });

    $("body").on("click", ".delete-user", function () {
        var el = {};
        el.name = $(this).closest("tr").find(".user-edit-name").html();
        el.email = $(this).closest("tr").find(".user-edit-email").html();
        deletedArr.push(el);

        $(this).closest("tr").remove();
        $("#save-shift").focus();

        if (max <= $("#table-edit tbody tr").length)
            $(".add-worker").prop("disabled", "disabled");
        else
            $(".add-worker").removeAttr("disabled");
    });

    $("#btn-add-user").click(function () {
        var err = false;
        if ($("#add-name").val().length < 5) {
            $("#add-name").parent().addClass("has-error");
            err = true;
        }
        else
            $("#add-name").parent().removeClass("has-error");

        if (!err) {
            $("#table-edit tbody").append("<tr><td class=\"tr-debug user-edit-uid\">" + escapeHtml($("#add-name").val()) +
                "\n" + escapeHtml($("#add-email").val()) + "</td>" +
                "<td class=\"user-sort readonly\" tabindex=\"1\"><i class=\"fa fa-arrows\"></i></td>" +
                "<td class=\"user-edit-name\">" + escapeHtml($("#add-name").val()) +
                "</td><td class=\"user-edit-email\">" + escapeHtml($("#add-email").val()) + "</td>" +
                "<td class=\"readonly user-edit-is-fixed-td\" style=\"text-align:center;\">" +
                "<input type=\"checkbox\" class=\"mgc-switch mgc-sm user-edit-is-fixed\" checked></td>" +
                "<td class=\"tr-debug user-edit-action\">create</td>" +
                "<td><div class=\"delete-user\"><i class=\"fa fa-trash\"></i></div></td></tr>");
            $("#add-name").val("");
            $("#add-email").val("");
            $('#table-edit').editableTableWidget();

            if (max <= $("#table-edit tbody tr").length)
                $(".add-worker").prop("disabled", "disabled");
            else
                $(".add-worker").removeAttr("disabled");
        }
    });

    $("#save-shift").click(function () {

        /*
         * Check for unadded user and ask to discard or go back
         */
        if ($("#add-name").val().trim() != "" || $("#add-email").val().trim() != "") {

            $("#editEntry").modal("hide");
            bootbox.dialog({
                title: "Bestätigen",
                message: "Die Felder <strong>Name</strong> und <strong>E-Mail</strong> sind nicht leer. " +
                "Der Eintrag wurde nicht hinzugefügt. Soll der Eintrag vor dem Speichern verworfen werden?",
                buttons: {
                    main: {
                        label: "Zurück",
                        className: "btn-default",
                        callback: function () {
                            $("#editEntry").modal("show");
                            return;
                        }
                    },
                    save: {
                        label: "Verwerfen und Speichern",
                        className: "btn-primary",
                        callback: function () {
                            $("#add-name").val("");
                            $("#add-email").val("");
                            $("#editEntry").modal("show");
                            $("#save-shift").click();
                        }
                    }
                }
            });

            return;
        }

        /*
         * save changes now and update the td cell
         */
        $("#save-loading").show();
        $("#editEntry input").prop("disabled", true);
        $("#editEntry button").prop("disabled", true);

        setTimeout(function () {
            var obj = {};
            var workers = [];
            obj['deleted'] = deletedArr;
            obj['shiftId'] = $(editObject).data("shift-id");
            obj['production'] = $(editObject).data("shift-name");
            obj['comment'] = $("#shift-comment").val();

            $("#table-edit tbody tr").each(function () {
                var user = {};
                user['name'] = $(this).find(".user-edit-name").text();
                user['email'] = $(this).find(".user-edit-email").text();
                user['action'] = $(this).find(".user-edit-action").text();
                user['isFixed'] = $(this).find(".user-edit-is-fixed").is(":checked");
                user['uid'] = $(this).find(".user-edit-uid").text();
                workers.push(user);
            });

            obj['workers'] = workers;

            $.ajax({
                url: "ajax.updateProductionShift.php",
                method: "POST",
                data: {
                    plan: $(".nav-tabs").find(".active").find("a").text(),
                    data: obj
                },
                success: function (result) {
                    result = JSON.parse(result);

                    if (result['result'] != "SUCCESS") {
                        $("#editEntry").modal("hide");
                        show("Fehler", "Die Änderungen wurden nicht gespeichert:<br/><br/>" + result['message'], function () {
                            $("#editEntry").modal("show");
                        });
                    }
                    else {
                        // update cell html both in desktop and mobile section                    
                        $("td").each(function () {
                            if ($(this).data("unique") == $(editObject).data("unique")) {
                                $(this).find(".worker").remove();
                                $(this).html($(this).html() + result['html']);
                            }
                        });

                        $("#editEntry").modal("hide");
                        updateCells();
                        levelRows();
                        updateWorkersFixedInfo(editObject);
                    }

                    $("#save-loading").hide();
                    $("#editEntry input").removeAttr("disabled");
                    $("#editEntry button").removeAttr("disabled");
                }
            });

        }, 500);

    });

    $(".td-user")
        .mouseenter(function () {
            if (!$(this).hasClass("info") && isLoggedIn) {
                $(this).stop().fadeTo("fast", 0.3, function () { });
            }
        })
        .mouseleave(function () {
            $(this).stop().fadeTo("fast", 1.0, function () { });
        })
        .click(function () {
            if ($(this).hasClass("info") || !isLoggedIn) return;

            var newUrl = "";
            if (window.location.href.indexOf("s=") >= 0)
                newUrl = location.href.replace("s=" + $(editObject).data("unique"), "s=" + $(this).data("unique"));
            else
                newUrl = location.href.indexOf("?") >= 0 ?
                    window.location.href + "s=" + $(this).data("unique") :
                    window.location.href + "?s=" + $(this).data("unique");
            history.pushState('data', '', newUrl);

            $("#editUserLoading").show();
            $("#editUserContent").hide();

            max = $(this).data("required");
            editObject = $(this);
            deletedArr = new Array();

            $("#add-name").parent().removeClass("has-error");
            $("#add-email").parent().removeClass("has-error");
            $("#add-name").val("");
            $("#add-email").val("");
            $("#editEntry").find(".modal-title").html($(this).data("shift-name") + " | " +
                $(this).closest("tr").find(".td-time").html() + " <small>max. " + $(this).data("required") + " Personen</small>");

            $("#shift-comment").val($(this).find(".td-comment").text());

            $("#editEntry").modal();

            $.ajax({
                url: "ajax.getWorkers.php",
                type: "POST",
                data: {
                    plan: editObject.closest("table").data("plan-name"),
                    shiftId: editObject.data("shift-id"),
                    production: editObject.data("shift-name")
                },
                success: function(res) {
                    console.log(res);

                    var tblBody = "";
                    res.workers.forEach(function (el, index) {
                        tblBody += "<tr><td class=\"tr-debug user-edit-uid\">" + el.name + "\n" +
                            el.email + "</td>" +
                            "<td class=\"user-sort readonly\"><i class=\"fa fa-arrows\"></i></td>" +
                            "<td class=\"user-edit-name\">" +
                            el.name +
                            "</td><td class=\"user-edit-email\">" +
                            el.email + "</td>" +
                            "<td class=\"readonly user-edit-is-fixed-td\">" +
                            "<label><input type=\"checkbox\" class=\"mgc-switch mgc-sm user-edit-is-fixed\" " +
                            (el.isFixed ? "checked" : "") + "></label></td>" +
                            "<td class=\"tr-debug user-edit-action\">update</td>" +
                            "<td><div class=\"delete-user\"><i class=\"fa fa-trash\"></i></div></td></tr>";
                    });
                    $("#table-edit tbody").html(tblBody);
                    
                    var el = document.getElementById('table-edit-tbody');
                    var sortable = Sortable.create(el, {
                        handle: ".user-sort",
                        animation: 150
                    });

                    // enable all controls
                    $('#table-edit').editableTableWidget();
                    $(".add-worker").removeAttr("disabled");
                    $("#save-shift").prop("disabled", false);
                    $("#table-edit").find(".tr-delete-worker").show();
                    $('#table-edit').editableTableWidget();
                    $("#btn-add-user").prop("disabled", false);
                    $("#save-shift").prop("disabled", false);

                    if ($(editObject).closest("table").hasClass("plan-readonly")) {
                        $(".add-worker").prop("disabled", true);
                        $("#save-shift").prop("disabled", true);
                        $("#table-edit input").prop("disabled", true);
                        $("input[type=checkbox]").prop("readonly", true);
                        $("#table-edit").find(".tr-delete-worker").hide();  // hide delete icons
                        $("#table-edit").find(".delete-user").closest("td").remove();
                        $("#btn-add-user").prop("disabled", true);
                        $("#save-shift").prop("disabled", true);

                        $("#table-edit tbody").find("td").addClass("readonly"); // make cells readonly
                    }
                    if (max <= $(editObject).find(".worker").length) {
                        $(".add-worker").prop("disabled", true);
                    }

                    $("#editUserContent").show();
                    $("#editUserLoading").hide();
                }
            });
            
        });

    $('#editEntry').on('hidden.bs.modal', function () {
        var newUrl = location.href.replace(/&?s=([^&]$|[^&]*)/i, "");

        while (newUrl[newUrl.length - 1] == '?') {
            newUrl = newUrl.substr(0, newUrl.length - 1);
        }

        history.pushState('data', '', newUrl);
    });


    // opens the shift dialog when the url contains a unique identifier
    if (window.location.href.indexOf("#") < 0) {
        $(".nav-tabs").find("li").find("a").first().trigger("click");
    }
    else {
        var shift = $.urlParam("s");
        var opened = false;
        $(".td-user").each(function () {
            if ($(this).data("unique") == shift) {
                if (!opened) {
                    $(this).click();
                }
                opened = true;
            }
        });
    }
});