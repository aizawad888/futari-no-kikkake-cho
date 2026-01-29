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


const showLoading = () => {
  document.getElementById("global-loading")?.classList.remove("hidden");
};

const hideLoading = () => {
  document.getElementById("global-loading")?.classList.add("hidden");
};

document.addEventListener("turbo:submit-start", (e) => {
  showLoading();
  e.target.querySelectorAll("button").forEach(b => b.disabled = true);
});

document.addEventListener("turbo:submit-end", hideLoading);

document.addEventListener("turbo:visit", showLoading);
document.addEventListener("turbo:load", hideLoading);


function togglePresets() {
  const extraButtons = document.querySelectorAll('.extra-preset');
  extraButtons.forEach(btn => btn.classList.toggle('hidden'));

  // ボタンの文言も切り替える
  const toggleBtn = document.getElementById('toggle-presets');
  if (toggleBtn) {
    toggleBtn.textContent = toggleBtn.textContent === '＋ もっと見る' ? '閉じる' : '＋ もっと見る';
  }
}

// グローバルにして ERB から呼べるようにする
window.togglePresets = togglePresets;

// ページ読み込み時にクリックイベントを設定
document.addEventListener('DOMContentLoaded', () => {
  const toggleBtn = document.getElementById('toggle-presets');
  if (toggleBtn) toggleBtn.addEventListener('click', togglePresets);
});


