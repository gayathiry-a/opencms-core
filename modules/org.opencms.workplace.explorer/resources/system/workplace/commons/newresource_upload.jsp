<%@ page import="org.opencms.workplace.explorer.*" %><%	

	// initialize the workplace class
	CmsNewResourceUpload wp = new CmsNewResourceUpload(pageContext, request, response);

//////////////////// start of switch statement 
	
switch (wp.getAction()) {

case CmsNewResourceUpload.ACTION_APPLET:
//////////////////// ACTION: use the upload applet
	
	wp.setParamAction(wp.DIALOG_SUBMITFORM2);

%><%= wp.htmlStart() %>
<%= wp.bodyStart("dialog") %>
<%@page import="org.opencms.main.OpenCms"%>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td>&nbsp;<br>&nbsp;</td></tr>
<tr><td align="center" valign="middle">

<%= wp.createAppletCode() %>

</td></tr>
</table>
<%= wp.bodyEnd() %>
<%= wp.htmlEnd() %>
<%
break;

case CmsNewResourceUpload.ACTION_CANCEL:
//////////////////// ACTION: cancel button pressed
	wp.actionCloseDialog();
break;


case CmsNewResourceUpload.ACTION_OK:
//////////////////// ACTION: ok button pressed
	wp.actionSelect();
break;


case CmsNewResourceUpload.ACTION_SUBMITFORM2:
//////////////////// ACTION: upload name specified and form submitted
	wp.actionUpdateFile();
	wp.actionEditProperties(); // redirects only if the edit properties option was checked
break;



case CmsNewResourceUpload.ACTION_SUBMITFORM:
//////////////////// ACTION: upload name specified and form submitted
	wp.actionUpload();
	if (wp.unzipUpload()) {
		if (wp.getAction() != CmsNewResourceUpload.ACTION_SHOWERROR) {
			wp.actionCloseDialog();
		}
		break;
	}
	if (wp.getAction() == CmsNewResourceUpload.ACTION_SHOWERROR) {
		// in case of an upload error, interrupt here
		break;
	}
	if(! OpenCms.getWorkplaceManager().getDefaultUserSettings().getShowUploadTypeDialog().booleanValue()) {
		wp.actionUpdateFile();
		wp.actionCloseDialog();
		break;
	}


case CmsNewResourceUpload.ACTION_NEWFORM2:
//////////////////// ACTION: show the form to specify the resource name and the edit properties checkbox
	
	wp.setParamAction(wp.DIALOG_SUBMITFORM2);

%><%= wp.htmlStart("help.explorer.new.file") %>
<script type="text/javascript">
<!--
	var labelFinish = "<%= wp.key(Messages.GUI_BUTTON_ENDWIZARD_0) %>";
	var labelNext = "<%= wp.key(Messages.GUI_BUTTON_CONTINUE_0) %>";

	function checkValue() {
		var resName = document.getElementById("newresfield").value;
		var theButton = document.getElementById("nextButton");
		if (resName.length == 0) { 
			if (theButton.disabled == false) {
				theButton.disabled =true;
			}
		} else {
			if (theButton.disabled == true) {
				theButton.disabled = false;
			}
		}
	}
	
	function toggleButtonLabel() {
		var theCheckBox = document.getElementById("newresedit");
		var theButton = document.getElementById("nextButton");
		if (theCheckBox.checked == true) {
			theButton.value = labelNext;
		} else {
			theButton.value = labelFinish;
		}
	}
//-->
</script>
<%= wp.bodyStart("dialog") %>
<%= wp.dialogStart() %>
<%= wp.dialogContentStart(wp.getParamTitle()) %>

<form name="main" action="<%= wp.getDialogUri() %>" method="post" class="nomargin" onsubmit="return submitAction('<%= wp.DIALOG_OK %>', null, 'main');">
<input type="hidden" name="<%= wp.PARAM_ACTION %>" value="<%= wp.getParamAction() %>">
<input type="hidden" name="<%= wp.PARAM_TITLE %>" value="<%= wp.getParamTitle() %>">
<input type="hidden" name="<%= wp.PARAM_RESOURCE %>" value="<%= wp.getParamResource() %>">
<input type="hidden" name="<%= wp.PARAM_DIALOGTYPE %>" value="<%= wp.getParamDialogtype() %>">
<input type="hidden" name="<%= wp.PARAM_FRAMENAME %>" value="">

<table border="0" width="100%">
<tr>
	<td style="white-space: nowrap;" unselectable="on"><%= wp.key(Messages.GUI_RESOURCE_NAME_0) %></td>
	<td class="maxwidth"><input name="<%= wp.PARAM_NEWRESOURCENAME %>" id="newresfield" type="text" value="<%= wp.getParamNewResourceName() %>" class="maxwidth" onkeyup="checkValue();"></td>
</tr> 
<tr>
	<td>&nbsp;</td>
	<td style="white-space: nowrap;" unselectable="on" class="maxwidth"><input name="<%= wp.PARAM_NEWRESOURCEEDITPROPS %>" id="newresedit" type="checkbox" value="true" checked="checked" onclick="toggleButtonLabel();">&nbsp;<%= wp.key(Messages.GUI_NEWFILE_EDITPROPERTIES_0) %></td>    
</tr>
</table>


<%= wp.dialogSpacer() %>

<%= wp.dialogBlockStart(wp.key(Messages.GUI_NEWRESOURCE_UPLOAD_TYPE_0)) %>

<%= wp.dialogWhiteBoxStart() %>
<table border="0">
<%= wp.buildTypeList() %> 
</table>
<%= wp.dialogWhiteBoxEnd() %>

<%= wp.dialogBlockEnd() %>

<%= wp.dialogContentEnd() %>

<%= wp.dialogButtonsNextCancel("id=\"nextButton\"", null) %>

</form>

<%= wp.dialogEnd() %>

<%= wp.bodyEnd() %>
<%= wp.htmlEnd() %>
<%
break;


case CmsNewResourceUpload.ACTION_NEWFORM:
case CmsNewResourceUpload.ACTION_DEFAULT:
default:
//////////////////// ACTION: show the form to specify the upload file and the unzip option
	
	wp.setParamAction(wp.DIALOG_SUBMITFORM);

%><%= wp.htmlStart("help.explorer.new.file") %>
<script type="text/javascript">
<!--
	var labelFinish = "<%= wp.key(Messages.GUI_BUTTON_ENDWIZARD_0) %>";
	var labelNext = "<%= wp.key(Messages.GUI_BUTTON_CONTINUE_0) %>";

	function checkValue() {
		var resName = document.getElementById("newresfield").value;
		var theButton = document.getElementById("nextButton");
		if (resName.length == 0) { 
			if (theButton.disabled == false) {
				theButton.disabled =true;
			}
		} else {
			if (theButton.disabled == true) {
				theButton.disabled = false;
			}
		}
	}
	
	function toggleButtonLabel() {
		var theCheckBox = document.getElementById("unzipfile");
		var theButton = document.getElementById("nextButton");
		if (theCheckBox.checked == true) {
			theButton.value = labelFinish;
		} else {
			theButton.value = labelNext;
		}
	}
	
	function startTimeOut() {
		// this is required for Mozilla since the onChange event doesn't work there for <input type="file">
		window.setTimeout("checkValue();startTimeOut();", 500);
	}
	
	startTimeOut();	
//-->
</script>
<%= wp.bodyStart("dialog") %>
<%= wp.dialogStart() %>
<%= wp.dialogContentStart(wp.getParamTitle()) %>

<form name="main" action="<%= wp.getDialogUri() %>" method="post" class="nomargin" onsubmit="return submitAction('<%= wp.DIALOG_OK %>', null, 'main');" enctype="multipart/form-data">
<%= wp.paramsAsHidden() %>
<input type="hidden" name="<%= wp.PARAM_FRAMENAME %>" value="">

<table border="0" width="100%">
<tr>
	<td style="white-space: nowrap;" unselectable="on"><%= wp.key(Messages.GUI_RESOURCE_NAME_0) %></td>
	<td class="maxwidth"><input name="<%= wp.PARAM_UPLOADFILE %>" id="newresfield" type="file" value="" size="60" class="maxwidth" onchange="checkValue();"></td>
</tr> 
<tr>
	<td>&nbsp;</td>
	<td style="white-space: nowrap;" unselectable="on" class="maxwidth"><input name="<%= wp.PARAM_UNZIPFILE %>" id="unzipfile" type="checkbox" value="true" onclick="toggleButtonLabel();">&nbsp;<%= wp.key(Messages.GUI_BUTTON_NEWRESOURCE_UPLOAD_UNZIP_0) %></td>    
</tr> 
</table>


<%= wp.dialogContentEnd() %>

<%= wp.dialogButtonsNextCancel("id=\"nextButton\" disabled=\"disabled\"", null) %>

</form>

<%= wp.dialogEnd() %>

<%= wp.bodyEnd() %>
<%= wp.htmlEnd() %>
<%
} 
//////////////////// end of switch statement 
%>