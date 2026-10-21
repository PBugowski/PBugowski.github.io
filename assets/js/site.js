/* English interface behavior. Profile data is loaded from content.js. */
(() => {
  'use strict';
  const data = window.PORTFOLIO;
  if (!data) return;
  const $ = (selector) => document.querySelector(selector);
  const escape = (value = '') => String(value).replace(/[&<>"']/g, character => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[character]));
  const icon = (name) => `<svg class="icon" aria-hidden="true"><use href="#${escape(name)}"></use></svg>`;
  const webLink = (value) => {
    try { const u = new URL(value); return ['https:', 'http:'].includes(u.protocol) ? u.href : ''; } catch { return ''; }
  };
  const fileLink = (value) => {
    if (!value || typeof value !== 'string') return '';
    if (/^(https?):\/\//i.test(value)) return webLink(value);
    return !/^[a-z][a-z0-9+.-]*:|^[\/\\]|[\x00-\x1f]/i.test(value) ? value : '';
  };
  const email = /^[^\s@<>]+@[^\s@<>]+\.[^\s@<>]+$/.test(data.email || '') ? data.email : '';
  const external = ' target="_blank" rel="noopener noreferrer"';
  document.querySelectorAll('[data-name]').forEach(element => { element.textContent = data.name; });
  document.title = `${data.name} — ${data.role}`;
  const socialTitle = $('meta[property="og:title"]');
  if (socialTitle) socialTitle.setAttribute('content', document.title);
  document.querySelectorAll('[data-role]').forEach(element => { element.textContent = data.role; });
  $('#about-text').textContent = data.about;
  const portrait = $('#portrait');
  portrait.src = fileLink(data.photo) || 'assets/images/avatar-placeholder.svg';
  portrait.alt = data.photoAlt || data.name;
  portrait.addEventListener('error', () => { portrait.src = 'assets/images/avatar-placeholder.svg'; }, {once:true});
  if (fileLink(data.cv)) {
    $('#cv-link').href = fileLink(data.cv);
    $('#cv-link').target = '_blank';
    $('#cv-link').rel = 'noopener noreferrer';
    $('#cv-link').hidden = false;
  }

  const social = [
    {name:'Email', icon:'mail', url:email ? `mailto:${email}` : '', detail:email},
    {name:'LinkedIn', icon:'linkedin', url:webLink(data.linkedin), detail:'Professional profile'},
    {name:'GitHub', icon:'github', url:webLink(data.github), detail:'Code and projects'}
  ];
  document.querySelectorAll('[data-social-links]').forEach(container => {
    container.innerHTML = social.map(item => {
      const body = `${icon(item.icon)}<span>${item.name}<small>${escape(item.url ? item.detail : 'Coming soon')}</small></span>`;
      return item.url ? `<a class="social-link" href="${escape(item.url)}"${item.icon === 'mail' ? '' : external}>${body}</a>` : `<span class="social-link social-link--inactive" aria-label="${item.name}: link not available yet">${body}</span>`;
    }).join('');
  });

  // Project action helpers: keep labels and missing-link behavior consistent.
  function projectAction(label, value, secondary = false) {
    const href = webLink(value);
    const classes = `button${secondary ? ' button--outline' : ''}`;
    if (href) {
      return `<a class="${classes}" href="${escape(href)}"${external}><span class="project-action__label">${escape(label)}</span>${icon('arrow-up-right')}</a>`;
    }
    return `<button type="button" class="${classes} project-action--pending" disabled aria-label="${escape(label)} — coming soon"><span class="project-action__label">${escape(label)}<small>Coming soon</small></span></button>`;
  }
  function projectActions(project, index) {
    return projectAction('View live report', project.url)
      + projectAction('View SQL', project.codeUrl, true)
      + (index === 0
        ? projectAction('Watch me talk on the PBI report', project.reportVideoUrl, true)
          + projectAction('Watch me talk on the SQL code', project.sqlVideoUrl, true)
        : '');
  }
  // End project action helpers.

  const projects = Array.isArray(data.projects) ? data.projects : [];
  $('#demo-label').hidden = !projects.some(project => project.demo);
  $('#project-grid').innerHTML = projects.map((project, index) => {
    const gallery = Array.isArray(project.gallery) ? project.gallery : [];
    return `<article class="project-card ${index === 0 ? 'project-card--featured' : ''}">
      <button type="button" class="project-image-button" data-project="${index}" data-image="0" aria-label="Open project cover: ${escape(project.title)}">
        <img src="${escape(fileLink(project.cover))}" width="1600" height="1000" alt="${escape(project.coverAlt)}" loading="lazy"><span class="image-hint">${icon('zoom')}</span>
      </button>
      ${gallery.length ? `<div class="gallery-block"><p class="gallery-label">Project gallery</p><div class="gallery-thumbnails">${gallery.map((image, imageIndex) => `<button type="button" data-project="${index}" data-image="${imageIndex + 1}" aria-label="Open: ${escape(image.alt)}"><img src="${escape(fileLink(image.thumb || image.src))}" width="480" height="300" alt="${escape(image.alt)}" loading="lazy"></button>`).join('')}</div></div>` : ''}
      <div class="project-content">${project.demo ? '<p class="demo-note">Demo project</p>' : ''}<h3>${escape(project.title)}</h3><p>${escape(project.description)}</p><div class="tool-tags">${(project.tools || []).map(tool => `<span class="tool-tag">${escape(tool)}</span>`).join('')}</div>
      <div class="project-actions">${projectActions(project, index)}</div></div></article>`;
  }).join('');

  $('#skills-grid').innerHTML = (data.skills || []).map(skill => `<article class="skill-card">${icon(skill.icon)}<h3>${escape(skill.name)}</h3><p>${escape(skill.description)}</p></article>`).join('');
  $('#experience-list').innerHTML = (data.experience || []).map(job => `<li><h4>${escape(job.title)}</h4><p class="career-meta">${escape(job.organization)}<br>${escape(job.period)}</p><p class="career-description">${escape(job.description)}</p></li>`).join('') || '<li><p class="career-description">Details coming soon.</p></li>';
  function qualifications(items, target, symbol) {
    const render = item => {
      const url = webLink(item.url);
      const heading = url ? `<a href="${escape(url)}"${external}>${escape(item.title)} ${icon('arrow-up-right')}</a>` : escape(item.title);
      return `<article class="qualification">${icon(symbol)}<div><h4>${heading}</h4><p class="career-meta">${escape(item.organization)}<br>${escape(item.period)}</p></div></article>`;
    };
    const shown = items.slice(0, 3).map(render).join('');
    const more = items.slice(3);
    target.innerHTML = shown + (more.length ? `<details class="more-items"><summary>Show more (${more.length})</summary>${more.map(render).join('')}</details>` : '') || '<p class="career-description">Details coming soon.</p>';
    const details = target.querySelector('details');
    details?.addEventListener('toggle', () => { details.querySelector('summary').textContent = details.open ? 'Show less' : `Show more (${more.length})`; });
  }
  qualifications(data.education || [], $('#education-list'), 'education');
  qualifications(data.certificates || [], $('#certificates-list'), 'certificate');

  const menuButton = $('.menu-toggle');
  const nav = $('#navigation');
  function closeMenu(returnFocus = false) {
    nav.classList.remove('is-open');
    menuButton.setAttribute('aria-expanded', 'false');
    menuButton.setAttribute('aria-label', 'Open menu');
    if (returnFocus) menuButton.focus();
  }
  menuButton.addEventListener('click', () => {
    const opened = menuButton.getAttribute('aria-expanded') === 'true';
    nav.classList.toggle('is-open', !opened);
    menuButton.setAttribute('aria-expanded', String(!opened));
    menuButton.setAttribute('aria-label', opened ? 'Open menu' : 'Close menu');
  });
  nav.querySelectorAll('a').forEach(link => link.addEventListener('click', () => closeMenu()));
  document.addEventListener('keydown', event => { if (event.key === 'Escape' && menuButton.getAttribute('aria-expanded') === 'true') closeMenu(true); });
  window.matchMedia('(min-width:781px)').addEventListener('change', event => { if(event.matches) closeMenu(); });

  // The top anchor belongs to the document body, not the sticky header.
  // Scroll explicitly so the action always reaches the real document origin.
  const backToTop = $('#back-to-top');
  if (backToTop) {
    backToTop.addEventListener('click', event => {
      event.preventDefault();
      closeMenu();
      $('#hero-title')?.focus({preventScroll: true});
      window.scrollTo({
        top: 0,
        left: 0,
        behavior: window.matchMedia('(prefers-reduced-motion: reduce)').matches ? 'auto' : 'smooth'
      });
    });
  }

  const dialog = $('#gallery-dialog');
  let currentImages = [], currentIndex = 0, opener = null;
  function showImage(index) {
    currentIndex = (index + currentImages.length) % currentImages.length;
    const image = currentImages[currentIndex];
    $('#gallery-image').src = fileLink(image.src);
    $('#gallery-image').alt = image.alt;
    $('#gallery-counter').textContent = `${currentIndex + 1} / ${currentImages.length}`;
    $('#gallery-original').href = fileLink(image.src);
  }
  function openGallery(projectIndex, imageIndex, button) {
    const project = projects[projectIndex];
    if (!project) return;
    currentImages = [{src:project.cover, alt:project.coverAlt}, ...(project.gallery || [])];
    opener = button;
    $('#gallery-title').textContent = project.title;
    showImage(imageIndex);
    if (typeof dialog.showModal !== 'function') { window.open(fileLink(currentImages[currentIndex].src), '_blank', 'noopener'); return; }
    dialog.showModal();
    document.body.style.overflow = 'hidden';
    $('#gallery-close').focus();
  }
  document.querySelectorAll('[data-project]').forEach(button => button.addEventListener('click', () => openGallery(Number(button.dataset.project), Number(button.dataset.image), button)));
  $('#gallery-close').addEventListener('click', () => dialog.close());
  $('#gallery-prev').addEventListener('click', () => showImage(currentIndex - 1));
  $('#gallery-next').addEventListener('click', () => showImage(currentIndex + 1));
  dialog.addEventListener('keydown', event => {
    if (event.key === 'ArrowLeft' || event.key === 'ArrowRight') { event.preventDefault(); showImage(currentIndex + (event.key === 'ArrowLeft' ? -1 : 1)); }
  });
  dialog.addEventListener('click', event => {
    if (event.target !== dialog) return;
    const bounds = dialog.getBoundingClientRect();
    if (event.clientX < bounds.left || event.clientX > bounds.right || event.clientY < bounds.top || event.clientY > bounds.bottom) dialog.close();
  });
  dialog.addEventListener('close', () => { document.body.style.overflow = ''; opener?.focus(); });

  const form = $('#contact-form');
  if (email) {
    $('#contact-submit').disabled = false;
    $('#contact-note').textContent = 'Your email app will open with a prepared message. You will send it from there.';
  } else {
    form.querySelectorAll('input,textarea').forEach(field => { field.disabled = true; });
  }
  form.addEventListener('submit', event => {
    event.preventDefault();
    if (!email || !form.reportValidity()) return;
    const name = $('#sender-name').value.trim();
    const senderEmail = $('#sender-email').value.trim();
    const message = $('#sender-message').value.trim();
    if (!name || !message) { $('#contact-status').textContent = 'Please enter your name and message.'; return; }
    const body = `Name: ${name}\nReply-to email: ${senderEmail}\n\n${message}`;
    const subject = `Portfolio inquiry — ${name.replace(/[\r\n]/g,' ')}`;
    window.location.href = `mailto:${encodeURIComponent(email)}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;
    $('#contact-status').textContent = 'If your email app did not open, use the Email link beside the form. This form does not send messages automatically.';
  });
})();
