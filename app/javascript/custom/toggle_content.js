//　投稿内の説明文の表示/非表示切り替え
document.addEventListener("turbo:load", setupToggleContent);
document.addEventListener("turbo:frame-load", setupToggleContent);
document.addEventListener("turbo:render", setupToggleContent);

function setupToggleContent() {
  document.querySelectorAll('.toggle-content-btn').forEach(button => {
    button.removeEventListener('click', toggleContent); 
    button.addEventListener('click', toggleContent); 
  });
}

function toggleContent(event) {
  const button = event.currentTarget;
  const content = button.nextElementSibling;
  const arrow = button.querySelector('.toggle-arrow');
  const placeName = button.querySelector('.place-name');
  if (content.style.display === 'none') {
    content.style.display = 'block';
    arrow.textContent = '▲';
    placeName.style.display = 'none';
  } else {
    content.style.display = 'none';
    arrow.textContent = '▼';
    placeName.style.display = 'inline';
  }
}

// サイドバーの表示/非表示切り替え
document.addEventListener("turbo:load", function() {
  const hamburgerMenu = document.querySelector('.hamburger-menu');
  const sidebar = document.querySelector('.sidebar');
  const overlay = document.querySelector('.overlay');

  hamburgerMenu.addEventListener('click', function() {
    sidebar.classList.toggle('active');
    overlay.classList.toggle('active');
  });

  overlay.addEventListener('click', function() {
    sidebar.classList.remove('active');
    overlay.classList.remove('active');
  });
});
