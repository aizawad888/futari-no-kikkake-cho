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

// ★★★ Service Worker の登録（追加）★★★
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/service-worker.js')
      .then(registration => {
        console.log('✅ Service Worker 登録成功:', registration.scope);
      })
      .catch(error => {
        console.error('❌ Service Worker 登録失敗:', error);
      });
  });
}


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



// 並べ替え絞り込み
document.addEventListener("turbo:load", () => {
  const toggleButtons = document.querySelectorAll("#filters-form button[type='button']");

  const labelMap = {
    "my-posts-field": { all: "すべて", self: "自分", partner: "相手" },
    "revealed-field": { all: "すべて", before: "答え合わせ前", after: "答え合わせ後" },
    "archived-field": { false: "公開中", true: "アーカイブ" }
  };

  const toggleMap = {
    "my-posts-field": ["all", "self", "partner"],
    "revealed-field": ["all", "before", "after"],
    "archived-field": ["false", "true"]
  };

  const bgMap = {
    "all": "bg-white",
    "false": "bg-white",
    "self": "bg-sage",
    "before": "bg-sage",
    "true": "bg-forest-green",
    "partner": "bg-forest-green",
    "after": "bg-forest-green"
  };

  toggleButtons.forEach(btn => {
    const targetId = btn.dataset.target;
    const hiddenField = document.getElementById(targetId);

    if (!hiddenField.value) hiddenField.value = targetId === "archived-field" ? "false" : "all";

    // 初期ラベルと色
    const labelSpan = btn.querySelector(".btn-label");
    if (labelSpan) labelSpan.textContent = labelMap[targetId][hiddenField.value];

    btn.classList.remove("bg-white", "bg-sage", "bg-forest-green", "text-white", "text-wood-dark");
    btn.classList.add(bgMap[hiddenField.value]);
    if (hiddenField.value === "true" || hiddenField.value === "partner" || hiddenField.value === "after") {
      btn.classList.add("text-white");
    } else {
      btn.classList.add("text-wood-dark");
    }

    btn.addEventListener("click", () => {
      const values = toggleMap[targetId];
      const currentIndex = values.indexOf(hiddenField.value);
      const nextIndex = (currentIndex + 1) % values.length;
      hiddenField.value = values[nextIndex];

      // ラベル更新（SVGは残る）
      const labelSpan = btn.querySelector(".btn-label");
      if (labelSpan) labelSpan.textContent = labelMap[targetId][hiddenField.value];

      // 背景色更新
      btn.classList.remove("bg-white", "bg-sage", "bg-forest-green", "text-white", "text-wood-dark");
      btn.classList.add(bgMap[hiddenField.value]);
      if (hiddenField.value === "true" || hiddenField.value === "partner" || hiddenField.value === "after") {
        btn.classList.add("text-white");
      } else {
        btn.classList.add("text-wood-dark");
      }

      // フォーム送信
      hiddenField.form.submit();
    });
  });
});


// プッシュ通知関係
import { subscribeToPushNotifications } from './push_notifications'

// ページ読み込み時に実行（ログインしている場合のみ）
document.addEventListener('DOMContentLoaded', () => {
  console.log('DOMContentLoaded イベント発火');
  console.log('userSignedIn:', document.body.dataset.userSignedIn);
  
  if (document.body.dataset.userSignedIn === 'true') {
    console.log('subscribeToPushNotifications を呼び出します'); // ← このログを追加
    subscribeToPushNotifications();
  }
});