// Called when the url of a tab changes.

function checkForValidUrl(tabId, changeInfo, tab) {
	// If the letter 'g' is found in the tab's URL...
	if (tab.url.indexOf('http://www.verycd.com/topics/') == 0) {
		// Successful match
		chrome.pageAction.show(tabId);
	}
};
// 
// Listen for any changes to the URL of any tab.
chrome.tabs.onUpdated.addListener(checkForValidUrl);