// ブラウザバック時のリロード
window.onpageshow = function(event) {
  if (event.persisted) {
    window.location.reload();
  }
};

document.addEventListener("turbo:load", function() {
  if (performance.getEntriesByType("navigation")[0].type === "back_forward") {
    window.location.reload();
  }

//   // ホーム画面であればリロード
//   if (window.location.pathname === '/home' && !window.location.search.includes('reloaded=true')) {
//     const newUrl = window.location.pathname + window.location.search + (window.location.search ? '&' : '?') + 'reloaded=true';
//     window.location.replace(newUrl);
//   }
});
