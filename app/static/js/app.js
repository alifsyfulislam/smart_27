/* SSMS shared UI helpers */
(function () {
  "use strict";

  // --- flash auto-hide ------------------------------------------------
  document.querySelectorAll(".flash").forEach(function (el) {
    setTimeout(function () {
      el.style.transition = "opacity .4s ease";
      el.style.opacity = "0";
      setTimeout(function () { el.remove(); }, 450);
    }, 3800);
  });

  // --- accordion sidebar: opening a group collapses the others --------
  var groups = Array.prototype.slice.call(document.querySelectorAll(".nav-group > button"));
  groups.forEach(function (btn) {
    btn.addEventListener("click", function () {
      var group = btn.parentElement;
      var wasOpen = group.classList.contains("open");
      groups.forEach(function (other) { other.parentElement.classList.remove("open"); });
      if (!wasOpen) group.classList.add("open");
      try { localStorage.setItem("ssms.openGroup", group.dataset.key || ""); } catch (e) {}
    });
  });
  // restore last open group (or open the group with the active item)
  var activeItem = document.querySelector(".nav-group ul li a.active");
  if (activeItem) {
    var g = activeItem.closest(".nav-group");
    if (g) g.classList.add("open");
  } else {
    try {
      var key = localStorage.getItem("ssms.openGroup");
      if (key) {
        var g2 = document.querySelector('.nav-group[data-key="' + key + '"]');
        if (g2) g2.classList.add("open");
      }
    } catch (e) {}
  }

  // --- sidebar collapse / mobile drawer --------------------------------
  var sidebar = document.getElementById("sidebar");
  var main = document.getElementById("main");
  var toggle = document.getElementById("sidebar-toggle");
  var overlay;
  function isMobile() { return window.innerWidth <= 900; }
  if (toggle && sidebar) {
    toggle.addEventListener("click", function () {
      if (isMobile()) {
        sidebar.classList.toggle("mobile-open");
        if (sidebar.classList.contains("mobile-open")) {
          overlay = document.createElement("div");
          overlay.className = "overlay";
          overlay.addEventListener("click", function () {
            sidebar.classList.remove("mobile-open");
            overlay.remove();
          });
          document.body.appendChild(overlay);
        } else if (overlay) { overlay.remove(); }
      } else {
        sidebar.classList.toggle("collapsed");
        main.classList.toggle("shift");
      }
    });
  }
  // on phone the sidebar starts hidden and needs the hamburger to open

  // --- hierarchy tree (brand module): expand / collapse -------------------
  document.querySelectorAll(".tree-row button.tw").forEach(function (btn) {
    btn.addEventListener("click", function (ev) {
      ev.preventDefault();
      btn.closest(".tree-node").classList.toggle("open");
    });
  });

  // --- confirm dialogs --------------------------------------------------
  document.querySelectorAll("[data-confirm]").forEach(function (el) {
    el.addEventListener("click", function (ev) {
      if (!window.confirm(el.getAttribute("data-confirm"))) ev.preventDefault();
    });
  });

  // --- keep per-page size selection --------------------------------------
  document.querySelectorAll("select[name=page_size]").forEach(function (sel) {
    sel.addEventListener("change", function () { sel.form && sel.form.submit(); });
  });
})();
