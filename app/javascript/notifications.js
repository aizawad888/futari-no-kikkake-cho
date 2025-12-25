document.addEventListener('turbo:load', () => {
  const notificationsPage = document.querySelector('[data-controller="notifications"]');
  
  if (notificationsPage) {
    // ページを離れる時に未読を全て既読にする
    document.addEventListener('turbo:before-visit', () => {
      fetch('/notifications/mark_all_as_read', {
        method: 'PATCH',
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
          'Content-Type': 'application/json'
        },
        // ページ遷移を待たずに送信（非同期）
        keepalive: true
      });
    }, { once: true }); // 一度だけ実行
  }
});