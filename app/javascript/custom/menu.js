// // メニュー

//続きを見る
// document.addEventListener("turbo:load", function() {
//   document.querySelectorAll(".toggle-content").forEach(function(element) {
//     element.addEventListener("click", function(event) {
//       event.preventDefault();
//       const content = event.target.dataset.content;
//       const truncatedContent = content.substring(0, 25) + '...';
//       if (event.target.textContent === "▼") {
//         event.target.parentElement.innerHTML = content + ' <a href="#" class="toggle-content" data-content="' + truncatedContent + '">▲</a>';
//         document.querySelector('.post-user').style.display = 'none';
//         document.querySelector('.post-like').style.display = 'none';
//       } else {
//         event.target.parentElement.innerHTML = truncatedContent + ' <a href="#" class="toggle-content" data-content="' + content + '">▼</a>';
//         document.querySelector('.post-user').style.display = 'block';
//         document.querySelector('.post-like').style.display = 'block';
//       }
//     });
//   });
// });
