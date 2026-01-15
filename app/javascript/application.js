// Entry point for the build script in your package.json

// ★★★ ネイティブfetchを保護（最優先）★★★
(function() {
  const originalFetch = window.fetch;
  
  if (originalFetch) {
    Object.defineProperty(window, 'fetch', {
      get: function() {
        return originalFetch;
      },
      set: function(value) {
        console.warn('Attempt to override native fetch was blocked');
      },
      configurable: false,
      enumerable: true
    });
  }
})();

// 既存のimport文
import "@hotwired/turbo-rails"
import "@hotwired/stimulus"
import "./controllers"
import "./notifications"
import "./demo_modal"

document.addEventListener('turbo:load', () => {
  const menuButton = document.getElementById('mobile-menu-button');
  const mobileMenu = document.getElementById('mobile-menu');

  if (menuButton && mobileMenu) {
    menuButton.addEventListener('click', () => {
      mobileMenu.classList.toggle('hidden');
    });
  }
});

document.addEventListener("turbo:load", () => {
  const select = document.getElementById("category-select");
  const hint = document.getElementById("category-hint");

  if (!select || !hint) return;

  select.addEventListener("change", () => {
    const selected = select.options[select.selectedIndex];
    const text = selected.dataset.hint;

    hint.textContent =
      text || "カテゴリを選ぶと、相手に表示されるヒントが出ます";
  });
});

