document.addEventListener("turbo:load", () => {
  const modal = document.getElementById("demo-modal");
  if (!modal) return;

  const closeBtn = modal.querySelector(".close-modal");
  if (closeBtn) {
    closeBtn.addEventListener("click", () => {
      modal.remove();
    });
  }
});
