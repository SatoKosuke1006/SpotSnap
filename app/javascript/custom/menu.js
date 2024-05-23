// メニュー

// トグルリスナーを追加する
function addToggleListener(selected_id, menu_id, toggle_class) {
  let selected_element = document.querySelector(`#${selected_id}`);

  if (selected_element) {
    selected_element.addEventListener("click", function(event) {
      event.preventDefault();
      let menu = document.querySelector(`#${menu_id}`);
      if (menu) {
        menu.classList.toggle(toggle_class);
      }
    });
  }
}

// クリックをリッスンするトグルリスナーを追加する
document.addEventListener("turbo:load", function() {
  addToggleListener("hamburger", "navbar-menu",   "collapse");
  addToggleListener("account",   "dropdown-menu", "active");
});

//続きを見る
document.addEventListener("turbo:load", function() {
  document.querySelectorAll(".toggle-content").forEach(function(element) {
    element.addEventListener("click", function(event) {
      event.preventDefault();
      const content = event.target.dataset.content;
      const truncatedContent = content.substring(0, 25) + '...';
      if (event.target.textContent === "▼") {
        event.target.parentElement.innerHTML = content + ' <a href="#" class="toggle-content" data-content="' + truncatedContent + '">▲</a>';
        document.querySelector('.post-user').style.display = 'none';
        document.querySelector('.post-like').style.display = 'none';
      } else {
        event.target.parentElement.innerHTML = truncatedContent + ' <a href="#" class="toggle-content" data-content="' + content + '">▼</a>';
        document.querySelector('.post-user').style.display = 'block';
        document.querySelector('.post-like').style.display = 'block';
      }
    });
  });
});
