function fixFileName(fileName) {
	var INVALID_CHARS_IN_FILE_NAME = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 34, 42, 47, 58, 60, 62, 63, 92, 124];
	var len = fileName.length;
	var result = "";
	for (var i = 0; i < fileName.length; i++) {
		if ($.inArray(fileName.charCodeAt(i), INVALID_CHARS_IN_FILE_NAME) >= 0) {
			result = result + ".";
		} else {
			result = result + fileName[i];
		}
	};
	return result;
}

function downloadFile(filename, content) {
	var blob = new Blob([content]);
	var url = webkitURL.createObjectURL(blob);
	$('<a>', {
		download: filename,
		href: url
	}).click(function() {
		window.setTimeout(function() {
			URL.revokeObjectURL(url);
		}, 0)
	})[0].click();
}

$("div.emulemain table").find("tr:last td:first").append('<input type="button" class="button downall" value="下载清单"></input>');
$("div.emulemain table").find("tr:last td:first :button:last").click(function(event) {
	var table = $(event.target).parents("table")

	var ed2kContent = {
		scriptVersion: 1,
		date: new Date(),
		title: $("#topicstitle").text(),
		url: window.location.href,
		files: [],
		folders: []
	};

	var currentFolder = ed2kContent;
	table.find("tr").each(function() {
		if ($(this).find("td.needemule").length > 0) {
			// 第一行。
			return;
		}

		if ($(this).find("label").length > 0) {
			// 最后一行。
			return;
		}

		if ($(this).find("td.ed2khr,td.ed2khr2").length > 0) {
			// 文件夹。
			var folderName = $(this).find("td.ed2khr,td.ed2khr2").text();
			var folder = {
				name: folderName,
				files: []
			}
			ed2kContent.folders.push(folder);
			currentFolder = folder;
		} else if ($(this).find("td.post,td.post2,td.new,td.new2").length > 0 && $(this).find("td.post,td.post2,td.new,td.new2").find("input")[0].checked) {
			// 文件。
			var fileName = $(this).find("a[ed2k]").text();
			var ed2k = $(this).find("a[ed2k]").attr("ed2k");
			currentFolder.files.push({
				name: fileName,
				ed2k: ed2k
			});
		}
	});

	var jsonString = JSON.stringify(ed2kContent, null, "\t");
	console.log(jsonString);
	downloadFile(fixFileName(ed2kContent.title) + ".manifest.json", jsonString);
	/*
	$(document.body).append('<div id="json_message" style="display: none; margin: 0; padding: 0;">' +
		'<textarea id="json_message_text" style="text-align: left; width: 99%; height: 100%; overflow: hidden; border: 0px;" cols="100%" rows="100%"><span class="ui-icon ui-icon-alert" style="float: left; margin: 0 7px 20px 0;">' +
		'</textarea></p></div>');
	$("#json_message_text").text(jsonString);
	$("#json_message").dialog({
		modal: true,
		width: 800,
		maxHeight: 300,
		title: ed2kContent.title,
		show: "slide",
	});
*/
});