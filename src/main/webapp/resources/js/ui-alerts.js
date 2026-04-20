(function () {
  if (window.EverlyUI && window.EverlyUI.notify) {
    return;
  }

  var queue = [];
  var showing = false;

  function ensureStyles() {
    if (document.getElementById('everly-alert-style')) return;
    var style = document.createElement('style');
    style.id = 'everly-alert-style';
    style.textContent = '' +
      '.ev-alert-overlay{position:fixed;inset:0;background:rgba(15,23,42,.45);display:flex;align-items:center;justify-content:center;z-index:99999;padding:16px;}' +
      '.ev-alert-modal{width:min(480px,100%);background:#fff;border-radius:16px;box-shadow:0 20px 50px rgba(15,23,42,.25);overflow:hidden;font-family:var(--font-primary,\"Plus Jakarta Sans\",sans-serif);animation:evAlertIn .18s ease-out;}' +
      '.ev-alert-head{padding:18px 20px 0 20px;display:flex;align-items:center;gap:10px;}' +
      '.ev-alert-dot{width:10px;height:10px;border-radius:50%;background:#9A74D8;flex:0 0 auto;}' +
      '.ev-alert-title{font-size:18px;font-weight:700;color:#111827;margin:0;line-height:1.3;}' +
      '.ev-alert-body{padding:10px 20px 0 20px;color:#4B5563;font-size:14px;line-height:1.6;white-space:pre-wrap;}' +
      '.ev-alert-actions{padding:18px 20px 20px;display:flex;justify-content:flex-end;}' +
      '.ev-alert-btn{background:#9A74D8;color:#fff;border:none;border-radius:10px;padding:10px 16px;font-weight:600;font-size:14px;cursor:pointer;transition:background .16s ease;}' +
      '.ev-alert-btn:hover{background:#8a64c8;}' +
      '@keyframes evAlertIn{from{opacity:0;transform:translateY(6px) scale(.98)}to{opacity:1;transform:translateY(0) scale(1)}}';
    document.head.appendChild(style);
  }

  function inferTitle(message) {
    var text = String(message || '').toLowerCase();
    if (!text) return 'Notice from Everly';
    if (/(success|created|saved|copied|uploaded|done)/.test(text)) return 'Success';
    if (/(error|failed|invalid|unable|cannot|can\'t|could not)/.test(text)) return 'Something went wrong';
    if (/(please|must|required|enter|select)/.test(text)) return 'Action needed';
    if (/(security|warning|careful|risk|expired)/.test(text)) return 'Heads up';
    return 'Notice from Everly';
  }

  function closeCurrent(overlay, resolve) {
    if (!overlay || !overlay.parentNode) {
      showing = false;
      resolve();
      flush();
      return;
    }
    overlay.parentNode.removeChild(overlay);
    showing = false;
    resolve();
    flush();
  }

  function showAlert(payload) {
    showing = true;
    ensureStyles();

    var title = payload.title || inferTitle(payload.message);
    var message = payload.message == null ? '' : String(payload.message);

    var overlay = document.createElement('div');
    overlay.className = 'ev-alert-overlay';

    var modal = document.createElement('div');
    modal.className = 'ev-alert-modal';
    modal.setAttribute('role', 'dialog');
    modal.setAttribute('aria-modal', 'true');

    var head = document.createElement('div');
    head.className = 'ev-alert-head';

    var dot = document.createElement('span');
    dot.className = 'ev-alert-dot';

    var titleEl = document.createElement('h3');
    titleEl.className = 'ev-alert-title';
    titleEl.textContent = title;

    var body = document.createElement('div');
    body.className = 'ev-alert-body';
    body.textContent = message;

    var actions = document.createElement('div');
    actions.className = 'ev-alert-actions';

    var okBtn = document.createElement('button');
    okBtn.type = 'button';
    okBtn.className = 'ev-alert-btn';
    okBtn.textContent = payload.okText || 'Got it';

    head.appendChild(dot);
    head.appendChild(titleEl);
    actions.appendChild(okBtn);
    modal.appendChild(head);
    modal.appendChild(body);
    modal.appendChild(actions);
    overlay.appendChild(modal);

    return new Promise(function (resolve) {
      function onKeydown(e) {
        if (e.key === 'Escape' || e.key === 'Enter') {
          e.preventDefault();
          cleanupAndClose();
        }
      }

      function cleanupAndClose() {
        document.removeEventListener('keydown', onKeydown);
        closeCurrent(overlay, resolve);
      }

      okBtn.addEventListener('click', cleanupAndClose);
      overlay.addEventListener('click', function (e) {
        if (e.target === overlay) {
          cleanupAndClose();
        }
      });

      document.body.appendChild(overlay);
      document.addEventListener('keydown', onKeydown);
      setTimeout(function () { okBtn.focus(); }, 0);
    });
  }

  function flush() {
    if (showing || queue.length === 0) return;
    var next = queue.shift();
    showAlert(next);
  }

  function notify(message, options) {
    queue.push({
      message: message,
      title: options && options.title,
      okText: options && options.okText
    });
    flush();
  }

  window.EverlyUI = {
    notify: notify,
    inferTitle: inferTitle
  };

  window.alert = function (message) {
    notify(message, { title: inferTitle(message) });
  };
})();
