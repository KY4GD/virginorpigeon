document.addEventListener('DOMContentLoaded', function() {
  const toggle = document.getElementById('nav-toggle');
  const offcanvas = document.getElementById('offcanvas');
  const overlay = document.getElementById('site-overlay');
  const close = document.getElementById('offcanvas-close');

  function openMenu() {
    offcanvas.classList.add('open');
    overlay.classList.add('active');
    document.body.style.overflow = 'hidden';
  }
  function closeMenu() {
    offcanvas.classList.remove('open');
    overlay.classList.remove('active');
    document.body.style.overflow = '';
  }

  if (toggle) toggle.addEventListener('click', openMenu);
  if (close) close.addEventListener('click', closeMenu);
  if (overlay) overlay.addEventListener('click', closeMenu);

  // Sticky header shadow on scroll
  const header = document.getElementById('site-header');
  window.addEventListener('scroll', function() {
    if (window.scrollY > 20) {
      header.style.boxShadow = '0 2px 12px rgba(0,0,0,0.5)';
    } else {
      header.style.boxShadow = '';
    }
  });
});
