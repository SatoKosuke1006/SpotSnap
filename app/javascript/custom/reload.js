// リロード
window.onpageshow = function(event) {
	if (event.persisted) {
		 window.location.reload();
	}
};

document.addEventListener("turbo:load", function() {
	if (performance.getEntriesByType("navigation")[0].type === "back_forward") {
	  window.location.reload();
	}
  });