document.addEventListener("turbo:load", setupToggleContent);
document.addEventListener("turbo:frame-load", setupToggleContent);
document.addEventListener("turbo:render", setupToggleContent);

function setupToggleContent() {
  document.querySelectorAll('.toggle-content-btn').forEach(button => {
    button.removeEventListener('click', toggleContent); // 既存のイベントリスナーを削除
    button.addEventListener('click', toggleContent); // 新しいイベントリスナーを追加
  });
}

function toggleContent(event) {
  const button = event.currentTarget;
  const content = button.nextElementSibling;
  const arrow = button.querySelector('.toggle-arrow');
  if (content.style.display === 'none') {
    content.style.display = 'block';
    arrow.textContent = '▲';
  } else {
    content.style.display = 'none';
    arrow.textContent = '▼';
  }
}
