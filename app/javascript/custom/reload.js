// リロード
// window.addEventListener('popstate', function (e) {
//     window.location.reload();
// });

window.addEventListener('pageshow',()=>{
	if(window.performance.navigation.type==2) location.reload();
});