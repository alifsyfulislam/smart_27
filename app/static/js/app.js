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
  // depth-0 nodes start open (server-side class); expanding a node collapses
  // the other open nodes in the SAME level (accordion per level)
  document.querySelectorAll(".tree-row button.tw").forEach(function (btn) {
    btn.addEventListener("click", function (ev) {
      ev.preventDefault();
      var node = btn.closest(".tree-node");
      if (node.classList.contains("open")) {
        node.classList.remove("open");
        return;
      }
      node.parentElement.querySelectorAll(":scope > .tree-node.open").forEach(function (sib) {
        if (sib !== node) sib.classList.remove("open");
      });
      node.classList.add("open");
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

  // --- searchable single-select (any <select data-searchable>) ------------
  // Keeps the native select as the value holder; a text input + filtered
  // dropdown is injected in front of it so the user can type to search.
  document.querySelectorAll("select[data-searchable]").forEach(function (sel) {
    sel.style.display = "none";
    var box = document.createElement("div");
    box.className = "searchselect";
    var input = document.createElement("input");
    input.type = "text";
    input.className = "searchselect-input";
    input.autocomplete = "off";
    input.placeholder = sel.getAttribute("data-search-placeholder") || "Type to search…";
    var list = document.createElement("div");
    list.className = "searchselect-list";
    box.appendChild(input);
    box.appendChild(list);
    sel.parentNode.insertBefore(box, sel);

    function opts() { return Array.prototype.slice.call(sel.options); }
    function currentLabel() {
      var o = sel.options[sel.selectedIndex];
      return o ? o.textContent : "";
    }
    function close() { list.classList.remove("open"); }
    function choose(o) {
      sel.value = o.value;
      input.value = o.textContent;
      close();
      sel.dispatchEvent(new Event("change", { bubbles: true }));
    }
    function render(filter) {
      list.innerHTML = "";
      var f = (filter || "").trim().toLowerCase();
      var shown = 0;
      opts().forEach(function (o) {
        var hay = (o.textContent + " " + o.value).toLowerCase();
        if (f && hay.indexOf(f) === -1) return;
        var item = document.createElement("div");
        item.className = "searchselect-item" + (sel.value === o.value ? " selected" : "");
        item.textContent = o.textContent;
        item.dataset.value = o.value;
        item.addEventListener("mousedown", function (ev) {  // before input blur
          ev.preventDefault();
          choose(o);
        });
        list.appendChild(item);
        shown++;
      });
      if (!shown) {
        var none = document.createElement("div");
        none.className = "searchselect-item muted";
        none.textContent = "No match found";
        list.appendChild(none);
      }
    }
    function open() { render(input.value); list.classList.add("open"); }

    input.value = currentLabel();
    input.addEventListener("focus", open);
    input.addEventListener("input", open);
    input.addEventListener("blur", function () { setTimeout(close, 130); });
    input.addEventListener("keydown", function (ev) {
      var items = Array.prototype.slice.call(list.querySelectorAll(".searchselect-item:not(.muted)"));
      var active = list.querySelector(".searchselect-item.active");
      var idx = items.indexOf(active);
      if (ev.key === "ArrowDown" || ev.key === "ArrowUp") {
        ev.preventDefault();
        if (!list.classList.contains("open")) open();
        if (!items.length) return;
        idx = ev.key === "ArrowDown" ? Math.min(idx + 1, items.length - 1)
                                     : Math.max(idx - 1, 0);
        items.forEach(function (i) { i.classList.remove("active"); });
        items[idx].classList.add("active");
        items[idx].scrollIntoView({ block: "nearest" });
      } else if (ev.key === "Enter") {
        ev.preventDefault();                       // never submit the form from here
        if (list.classList.contains("open") && active) {
          var o = opts().filter(function (op) { return op.value === active.dataset.value; })[0];
          if (o) choose(o); else close();
        } else {
          close();
        }
      } else if (ev.key === "Escape") {
        close();
        input.value = currentLabel();
      }
    });
  });
})();
