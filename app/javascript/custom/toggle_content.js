document.addEventListener("turbo:load", setupToggleContent);
document.addEventListener("turbo:frame-load", setupToggleContent);
document.addEventListener("turbo:render", setupToggleContent);

function setupToggleContent() {
  document.querySelectorAll('.toggle-content-btn').forEach(button => {
    button.addEventListener('click', () => {
      const content = button.nextElementSibling;
      const arrow = button.querySelector('.toggle-arrow');
      if (content.style.display === 'none') {
        content.style.display = 'block';
        arrow.textContent = '▲';
      } else {
        content.style.display = 'none';
        arrow.textContent = '▼';
      }
    });
  });
}