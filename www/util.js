
// checkbox start
var $j = jQuery.noConflict();
$j(document).ready(function() {
    // checkbox 绑定有click事件，需要手动处理时，需要增加 manualControl=“true"
    $j("[manualControl!=true].checkbox").live("click", function(event) {
        var $this = $j(this);
        if ($this.hasClass('disable')) {
            return false;
        }
        var checkbox = $this.find("input:checkbox");
        var haha = checkbox.prop('checked');
        if (checkbox.prop('checked')) {
            checkbox.attr("checked", "checked");
        } else {
            checkbox.removeAttr("checked");
            
        }
        checkCheckbox(checkbox);
        event.stopPropagation();
        return true;
    });
    $j('input[type="text"][noAction!="true"],input[type="password"][noAction!="true"],select').live("focusin", function(event) {
        $(this).addClass("focusIn");
    }).live("focusout", function(event) {
        $(this).removeClass("focusIn");
    });

    $j(".form-note .notes-title").live('click', function() {
        var $this = $(this);
        $this.siblings("ul.notes-content:first").slideToggle();
        $this.toggleClass("notes-dot");
    });
});

/**
 * 检查checkbox状态，重绘checkbox
 * @method renderCheckbox
 */
function renderCheckbox() {
    var checkboxToggle = $j(".checkboxToggle");

    checkboxToggle.each(function() {
		checkBoxesSize($(this));
	});

    var checkboxes = $j(".checkbox").not("[class*='checkboxToggle']").find("input:checkbox");
    if(checkboxes.length == 0){
        disableCheckbox(checkboxToggle);
    } else {
        enableCheckbox(checkboxToggle);
    }
    checkboxes.each(function() {
		checkCheckbox($(this));
	});
}

function checkBoxesSize(selectAll) {
	var target = selectAll.attr("target");
	var boxSize = $j("#" + target + " .checkbox input:checkbox").length;
	var checkedBoxSize = $j("#" + target + " .checkbox input:checkbox:checked").length;
	var checkbox = selectAll.find("input:checkbox");
	if (boxSize != 0 && boxSize == checkedBoxSize) {
		checkbox.attr("checked", "checked");
	} else {
		checkbox.removeAttr("checked");
	}
	checkP(checkbox);
}

function checkSelectAll(selectAll, target) {
    var theCheckbox = $j("#" + target + " .checkbox input:checkbox");
	if (selectAll.attr("checked")) {
        theCheckbox.attr("checked", "checked");
	} else {
        theCheckbox.removeAttr("checked");
	}
    theCheckbox.each(function() {
		checkCheckbox($j(this));
	});
}

function checkCheckbox(checkbox) {
	if (checkbox.closest("p.checkbox").hasClass("checkboxToggle")) {
		checkSelectAll(checkbox, checkbox.closest("p.checkbox").attr("target"));
	}
	checkP(checkbox);
	checkBoxesSize($j("#" + checkbox.attr("target")));
}

function checkP(checkbox) {
	if (checkbox.attr("checked")) {
		checkbox.closest("p.checkbox").addClass("checkbox_selected");
	} else {
		checkbox.closest("p.checkbox").removeClass("checkbox_selected");
	}
}

function removeChecked(id) {
	$j("#" + id).removeClass("checkbox_selected").find("input:checkbox").removeAttr("checked");
}

/**
 * 禁用checkbox
 * @method disableCheckbox
 * @param checkbox
 */
function disableCheckbox(checkbox){
    var chk = checkbox.find("input:checkbox");
    if (chk.attr("checked")) {
        checkbox.addClass('checked_disable');
    } else {
        checkbox.addClass('disable');
    }
}

/**
 * 启用checkbox
 * @method enableCheckbox
 * @param checkbox
 */
function enableCheckbox(checkbox){
    checkbox.removeClass('disable').removeClass("checked_disable");
}

/**
 * 尝试disable掉checkbox，如果len > 0就enable
 * @method tryToDisableCheckAll
 * @param checkbox
 * @param len
 */
function tryToDisableCheckAll(checkbox, len){
    if(len == 0){
        disableCheckbox(checkbox);
    } else {
        enableCheckbox(checkbox);
    }
}
// checkbox end

function getsms(){
	var sms = new Array();
	var j = 0;
	for(var i = 0; i < smsmonitor.length; ++i){
		
		sms[j] = new Array(5);
		
		sms[j][0] = smsmonitor[i][0];	// boxType
		sms[j][1] = smsmonitor[i][1];	// id
		sms[j][2] = smsmonitor[i][2]; 	// type
		sms[j][3] = smsmonitor[i][3];	// time
		sms[j][4] = smsmonitor[i][4];	// phonenumer
		sms[j][5] = smsmonitor[i][5];	// content

		++j;
	}

	return sms;
}
