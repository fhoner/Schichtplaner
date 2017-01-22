/*
 * admin mail js functionality
 * Felix Honer
 * 2016/01/24
 */

/**
 * Updates the recipient selection. Recipient will be selected when he sits in
 * one of the given plans.
 * 
 * @param plans Array of the checked plans.
 */
function updateRecSelection(plans) {
    $(".tr-mail-recipient").each(function () {
        $(this).find(".recipient-selection input").prop("checked", false);
        var tr = $(this);
        $(this).find(".recipient-plans").find("input").each(function () {
            if ($.inArray($(this).val(), plans) > -1 && $(this).is(":checked")) {
                $(tr).find(".recipient-selection").find("input").prop("checked", true);
            }
        });
    });
}

/**
 * Determines all checked recipients and writes them into the textarea. Also
 * disabled the copy recipients button if textarea is empty.
 */
function updateRecipientsList() {
    var all = "";
    var checkedCount = 0;

    $(".recipient-checked").each(function (index) {
        if ($(this).is(":checked"))
            checkedCount++;
    });

    $(".recipient-checked").each(function (index) {
        if ($(this).is(":checked")) {
            var str = "";
            str += $(this).val();
            str += " <" + $(this).closest("tr").find(".recipient-email").html() + ">;";
            all += str;
        }
    });

    $("#all-recipients").html(all);
    if (all == "")
        $("#copy-recipients").prop("disabled", true);
    else
        $("#copy-recipients").prop("disabled", false);
}

/**
 * Adds the handlers for all user controls like checkboxes, buttons.
 */
function addMailHandlers() {
    $("input[name=selectionmode]").change(function () {
        if ($(this).attr("id") == "select-manual") {
            $(".plan-check").prop("checked", false);
        }
        else {
            $(".recipient-checked").prop("checked", false);
        }
    });

    $(".plan-check").change(function () {
        $("#select-plan").prop("checked", true);
        var selectedPlans = [];
        $(".plan-check").each(function () {
            if ($(this).is(":checked"))
                selectedPlans.push($(this).val());
        });
        updateRecSelection(selectedPlans);
        updateRecipientsList();
    });

    $(".recipient-checked").change(function () {
        $("#select-manual").prop("checked", true);
        $(".plan-check").prop("checked", false);
        updateRecipientsList();
    });

    $("#all-recipients").focus(function () {
        var $this = $(this);
        $this.select();

        // Work around Chrome's little problem
        $this.mouseup(function () {
            // Prevent further mouseup intervention
            $this.unbind("mouseup");
            return false;
        });
    });

    $("#copy-recipients").click(function () {
        copyToClipboard("#all-recipients");
        $("#all-recipients").focus();
    });
}
