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
    {name:'E-mail', icon:'mail', url:email ? `mailto:${email}` : '', detail:email},
    {name:'LinkedIn', icon:'linkedin', url:webLink(data.linkedin), detail:'Profil zawodowy'},
    {name:'GitHub', icon:'github', url:webLink(data.github), detail:'Kod i projekty'}
  ];
  document.querySelectorAll('[data-social-links]').forEach(container => {
    container.innerHTML = social.map(item => {
      const body = `${icon(item.icon)}<span>${item.name}<small>${escape(item.url ? item.detail : 'Wkrótce')}</small></span>`;
      return item.url ? `<a class="social-link" href="${escape(item.url)}"${item.icon === 'mail' ? '' : external}>${body}</a>` : `<span class="social-link social-link--inactive" aria-label="${item.name}: link jeszcze niedostępny">${body}</span>`;
    }).join('');
  });

  const projects = Array.isArray(data.projects) ? data.projects : [];
  $('#demo-label').hidden = !projects.some(project => project.demo);
  $('#project-grid').innerHTML = projects.map((project, index) => {
    const gallery = Array.isArray(project.gallery) ? project.gallery : [];
    const url = webLink(project.url);
    const code = webLink(project.codeUrl);
    return `<article class="project-card ${index === 0 ? 'project-card--featured' : ''}">
      <button type="button" class="project-image-button" data-project="${index}" data-image="0" aria-label="Otwórz okładkę projektu ${escape(project.title)}">
        <img src="${escape(fileLink(project.cover))}" width="1600" height="1000" alt="${escape(project.coverAlt)}" loading="lazy"><span class="image-hint">${icon('zoom')}</span>
      </button>
      ${gallery.length ? `<div class="gallery-block"><p class="gallery-label">Galeria projektu</p><div class="gallery-thumbnails">${gallery.map((image, imageIndex) => `<button type="button" data-project="${index}" data-image="${imageIndex + 1}" aria-label="Otwórz: ${escape(image.alt)}"><img src="${escape(fileLink(image.thumb || image.src))}" width="480" height="300" alt="${escape(image.alt)}" loading="lazy"></button>`).join('')}</div></div>` : ''}
      <div class="project-content">${project.demo ? '<p class="demo-note">Projekt demonstracyjny</p>' : ''}<h3>${escape(project.title)}</h3><p>${escape(project.description)}</p><div class="tool-tags">${(project.tools || []).map(tool => `<span class="tool-tag">${escape(tool)}</span>`).join('')}</div>
      <div class="project-actions">${url ? `<a class="button" href="${escape(url)}"${external}>Zobacz projekt ${icon('arrow-up-right')}</a>` : `<button type="button" class="button" data-project="${index}" data-image="0">Zobacz galerię ${icon('arrow-up-right')}</button>`}${code ? `<a class="text-link" href="${escape(code)}"${external}>Kod ${icon('github')}</a>` : ''}</div></div></article>`;
  }).join('');

  $('#skills-grid').innerHTML = (data.skills || []).map(skill => `<article class="skill-card">${icon(skill.icon)}<h3>${escape(skill.name)}</h3><p>${escape(skill.description)}</p></article>`).join('');
  $('#experience-list').innerHTML = (data.experience || []).map(job => `<li><h4>${escape(job.title)}</h4><p class="career-meta">${escape(job.organization)}<br>${escape(job.period)}</p><p class="career-description">${escape(job.description)}</p></li>`).join('') || '<li><p class="career-description">Informacje wkrótce.</p></li>';
  function qualifications(items, target, symbol) {
    const render = item => {
      const url = webLink(item.url);
      const heading = url ? `<a href="${escape(url)}"${external}>${escape(item.title)} ${icon('arrow-up-right')}</a>` : escape(item.title);
      return `<article class="qualification">${icon(symbol)}<div><h4>${heading}</h4><p class="career-meta">${escape(item.organization)}<br>${escape(item.period)}</p></div></article>`;
    };
    const shown = items.slice(0, 3).map(render).join('');
    const more = items.slice(3);
    target.innerHTML = shown + (more.length ? `<details class="more-items"><summary>Pokaż więcej (${more.length})</summary>${more.map(render).join('')}</details>` : '') || '<p class="career-description">Informacje wkrótce.</p>';
    const details = target.querySelector('details');
    details?.addEventListener('toggle', () => { details.querySelector('summary').textContent = details.open ? 'Pokaż mniej' : `Pokaż więcej (${more.length})`; });
  }
  qualifications(data.education || [], $('#education-list'), 'education');
  qualifications(data.certificates || [], $('#certificates-list'), 'certificate');

  const menuButton = $('.menu-toggle');
  const nav = $('#navigation');
  function closeMenu(returnFocus = false) {
    nav.classList.remove('is-open');
    menuButton.setAttribute('aria-expanded', 'false');
    menuButton.setAttribute('aria-label', 'Otwórz menu');
    if (returnFocus) menuButton.focus();
  }
  menuButton.addEventListener('click', () => {
    const opened = menuButton.getAttribute('aria-expanded') === 'true';
    nav.classList.toggle('is-open', !opened);
    menuButton.setAttribute('aria-expanded', String(!opened));
    menuButton.setAttribute('aria-label', opened ? 'Otwórz menu' : 'Zamknij menu');
  });
  nav.querySelectorAll('a').forEach(link => link.addEventListener('click', () => closeMenu()));
  document.addEventListener('keydown', event => { if (event.key === 'Escape' && menuButton.getAttribute('aria-expanded') === 'true') closeMenu(true); });
  window.matchMedia('(min-width:781px)').addEventListener('change', event => { if(event.matches) closeMenu(); });

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
    $('#contact-note').textContent = 'Otworzę Twój program pocztowy z gotową treścią. Wiadomość wyślesz w nim samodzielnie.';
  } else {
    form.querySelectorAll('input,textarea').forEach(field => { field.disabled = true; });
  }
  form.addEventListener('submit', event => {
    event.preventDefault();
    if (!email || !form.reportValidity()) return;
    const name = $('#sender-name').value.trim();
    const senderEmail = $('#sender-email').value.trim();
    const message = $('#sender-message').value.trim();
    if (!name || !message) { $('#contact-status').textContent = 'Wpisz imię i treść wiadomości.'; return; }
    const body = `Imię: ${name}\nE-mail zwrotny: ${senderEmail}\n\n${message}`;
    const subject = `Kontakt z portfolio — ${name.replace(/[\r\n]/g,' ')}`;
    window.location.href = `mailto:${encodeURIComponent(email)}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;
    $('#contact-status').textContent = 'Jeśli program pocztowy się nie otworzył, skorzystaj z linku E-mail obok. Formularz nie wysyła wiadomości automatycznie.';
  });
})();
