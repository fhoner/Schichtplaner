<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <script src="sources/jquery/jquery-1.11.1.min.js" type="text/javascript"></script>
        <link rel="stylesheet" href="sources/bootstrap/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" href="sources/bootstrap/bootstrap-theme.min.css" crossorigin="anonymous">
        <script src="sources/bootstrap/bootstrap.min.js" crossorigin="anonymous"></script>
        <script src="sources/bootstrap/bootbox.js"></script>
        <script src="sources/bootstrap/mindmup-editabletable.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
        <style>
            html {
                position: relative;
                min-height: 100%;
            }
            body {
                margin-top:25px;
                margin-bottom: 80px;
            }
            table.table-shifts {
                table-layout: fixed;
                border-left:4px solid #dddddd !important;
            }
            .short {
                width:60px;
            }
            .very-short {
                25px;
            }
            td.td-time {
                text-align: center;
                vertical-align: middle !important;
            }
            td.td-user {
                cursor: pointer;
            }
            .td-user .user-email {
                display: none;
            }
            .delete-user {
                width:20px;
                text-align: center;
            }
            .tr-debug {
                display:none;
            }
            .form-control {
                margin-top:5px;
                margin-bottom:15px;
            }
            .shift-disabled {
                cursor: not-allowed !important;
            }
            #save-loading {
                display:none;
                width: 15px;
                margin-left:3px;
                margin-right:3px;
            }
            .footer {
                position: absolute;
                bottom: 0;
                width: 100%;
                /* Set the fixed height of the footer here */
                height: 60px;
                background-color: #f5f5f5;
            }
            body > .container {
                padding: 60px 15px 0;
            }
            .container .text-muted {
                margin: 20px 0;
            }
            .footer > .container {
                padding-right: 15px;
                padding-left: 15px;
            }
        </style>
    </head>
    <body>

        <ul class="nav nav-tabs" role="tablist" style="margin:10px;">
            ${plansTab}$
        </ul>
        <div class="tab-content">
            ${plansContent}$
        </div>

        <div class="modal fade" tabindex="-1" role="dialog" id="editEntry">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h4 class="modal-title"></h4>
                    </div>
                    <div class="modal-body">
                        <table class="table table-hover table-condensed table-bordered" id="table-edit">
                            <thead>
                                <tr>
                                    <th class="tr-debug">UID</th>
                                    <th style="width:50%;">Name</th>
                                    <th style="width:50%;">E-Mail</th>
                                    <th class="tr-debug">Action</th>
                                    <th style="width:10px;"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- filled by js -->
                            </tbody>
                        </table>     
                        <hr />
                        Name
                        <div>
                            <input type="text" class="form-control add-worker" placeholder="Vorname Nachname" id="add-name">		
                        </div>
                        E-Mail
                        <div>
                            <input type="text" class="form-control add-worker" placeholder="name@domain.com" id="add-email">
                        </div>
                        <button type="button" class="btn btn-default pull-right add-worker" id="btn-add-user">
                            <i class="fa fa-user-plus"></i> Hinzufügen
                        </button>
                        <br /><br />
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Abbrechen</button>
                        <button type="button" class="btn btn-primary" id="save-shift">
                            <img src="template/loading.gif" id="save-loading" />
                            <i class="fa fa-floppy-o"></i>&nbsp;Speichern
                        </button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->
        <div style="clear:both;"></div>
        <footer class="footer">
            <div class="container">
                <p class="text-muted"><small>v1.0 &copy; 2016 Felix Honer, MV Öschelbronn e.V.</small></p>
            </div>
        </footer>


        <script>
        var editObject = null; // save editing object to store changed into it
        var deletedArr = new Array();   // stores deleted objects
        var max = 0;    // required user count for one shift
        var planname = "${name}$";  // can change when user renames the plan; so use js variable instead of template engine

        function updateCells(){
            $(".td-user").each(function(index, el){
                var userCount = $(this).children().length;

                if($(this).hasClass("shift-disabled")) {
                    $(this).addClass("info");
                }

                if($(this).data("required") > userCount) {
                    if(userCount > 0) {
                        $(this).removeClass("success");
                        $(this).removeClass("danger");
                        $(this).addClass("warning");
                    }
                    else {
                        $(this).removeClass("success");
                        $(this).removeClass("warning");
                        $(this).addClass("danger");
                    }
                }
                else {
                    $(this).removeClass("warning");
                    $(this).removeClass("danger");
                    $(this).addClass("success");
                }
            });
        }
            
        function levelRows(){
            var maxHeight = 0;
            $("table tbody tr").css("height", "auto");
            $("table tbody tr").each(function(){
                if($(this).height() > maxHeight)
                    maxHeight = $(this).height();
            });
            $("table tbody tr").each(function(){
                $(this).css("height", maxHeight + "px");
            });            
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

        $(document).ready(function(){
            updateCells();
            levelRows();

            $("body").on("click", "td", function(){
                if($(this).find(".delete-user").length > 0)
                {
                    $(this).find(".delete-user").trigger("click");
                }
            });
            
            $("body").on("click", ".delete-user", function(){
                var el = {};
                el.name = $(this).closest("tr").find(".user-edit-name").html();
                el.email = $(this).closest("tr").find(".user-edit-email").html();
                deletedArr.push(el);
                
                $(this).closest("tr").remove();
                $("#save-shift").focus();
                
                if(max <= $("#table-edit tbody tr").length)
                     $(".add-worker").prop("disabled", "disabled");
                else
                    $(".add-worker").removeAttr("disabled");
            });

            $("#btn-add-user").click(function(){
                var err = false;
                if($("#add-name").val().length < 5) {
                    $("#add-name").parent().addClass("has-error");
                    err = true;
                }
                else
                    $("#add-name").parent().removeClass("has-error");
                if($("#add-email").val().length < 5) {
                    $("#add-email").parent().addClass("has-error");
                    err = true;
                }
                else
                    $("#add-email").parent().removeClass("has-error");
                if(!err){
                    $("#table-edit tbody").append("<tr><td class=\"tr-debug user-edit-uid\">" + $("#add-name").val() + 
                                                    "\n" + $("#add-email").val() + "</td>" +
                                                    "<td class=\"user-edit-name\">" + $("#add-name").val() + 
                                                    "</td><td class=\"user-edit-email\">" + $("#add-email").val() + "</td>" +
                                                    "<td class=\"tr-debug user-edit-action\">create</td>" +
                                                    "<td><div class=\"delete-user\"><i class=\"fa fa-trash\"></i></div></td></tr>");
                    $("#add-name").val("");
                    $("#add-email").val("");
                    $('#table-edit').editableTableWidget();
                    
                    if(max <= $("#table-edit tbody tr").length)
                         $(".add-worker").prop("disabled", "disabled");
                    else
                        $(".add-worker").removeAttr("disabled");
                }
            });

            $("#save-shift").click(function(){

                $("#save-loading").show();
                $("#editEntry input").prop("disabled", true);
                $("#editEntry button").prop("disabled", true);

                setTimeout(function(){

                    var obj = {};
                    var workers = [];
                    obj['deleted'] = deletedArr;
                    obj['shiftId'] = $(editObject).data("shift-id");
                    obj['production'] = $(editObject).data("shift-name");

                    $("#table-edit tbody tr").each(function(){
                        var user = {};
                        user['name'] = $(this).find(".user-edit-name").html();
                        user['email'] = $(this).find(".user-edit-email").html();
                        user['action'] = $(this).find(".user-edit-action").html();
                        user['uid'] = $(this).find(".user-edit-uid").html();
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
                        success: function(result) {

                            if(result != "SUCCESS")
                            {
                                alert("ERROR! Debug out: " + result);
                            }

                            $("#save-loading").hide();
                            $("#editEntry input").removeAttr("disabled");
                            $("#editEntry button").removeAttr("disabled");
                        }
                    })

                    var tdhtml = "";

                    $("#table-edit tbody tr").each(function(){
                        tdhtml += "<div class=\"worker\"><div class=\"user-name\">" + $(this).find(".user-edit-name").html() + "</div>" + 
                                    "<div class=\"user-email\">" + $(this).find(".user-edit-email").html() + "</div></div>";
                    });
                    
                    $(editObject).html(tdhtml);
                    $("#editEntry").modal("hide");
                    updateCells();
                    levelRows();

                }, 500);

            });

            $(".td-user")
                .mouseenter(function(){
                    if(!$(this).hasClass("info"))
                        $(this).stop().fadeTo("fast", 0.3, function(){});
                })
                .mouseleave(function(){
                    $(this).stop().fadeTo("fast", 1.0, function(){});
                })
                .click(function(){
                    if($(this).hasClass("info")) return;
                
                    max = $(this).data("required");
                    editObject = $(this);
                    deletedArr = new Array();
                
                    $("#add-name").parent().removeClass("has-error");
                    $("#add-email").parent().removeClass("has-error");                
                    $("#editEntry").find(".modal-title").html($(this).data("shift-name") + " | " + 
                        $(this).closest("tr").find(".td-time").html() + " <small>max. " + $(this).data("required") + " Personen</small>");

                    var tblBody = "";
                    $(this).children().each(function(){
                        tblBody += "<tr><td class=\"tr-debug user-edit-uid\">" + $(this).find(".user-name").html() + "\n" + 
                                    $(this).find(".user-email").html() + "</td>" +
                                    "<td class=\"user-edit-name\">" + 
                                    $(this).find(".user-name").html() + 
                                    "</td><td class=\"user-edit-email\">" +
                                    $(this).find(".user-email").html() + "</td>" +
                                    "<td class=\"tr-debug user-edit-action\">update</td>" +
                                    "<td><div class=\"delete-user\"><i class=\"fa fa-trash\"></i></div></td></tr>";
                    });

                    $("#table-edit tbody").html(tblBody);
                    $("#editEntry").modal();
                    $('#table-edit').editableTableWidget();
                
                    if(max <= $(this).find(".worker").length)
                         $(".add-worker").prop("disabled", "disabled");
                    else
                        $(".add-worker").removeAttr("disabled");
                });
        });
        </script>
    </body>
</html>