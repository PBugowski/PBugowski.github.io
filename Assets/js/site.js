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
  $('#about-title').innerHTML = escape(data.aboutTitle || 'About me').replace('From process engineering to data analysis', 'From process engineering<br>to data analysis');
  const aboutParagraphs = String(data.about || '').split(/\n\s*\n/).filter(Boolean);
  const aboutSteps = Array.isArray(data.aboutSteps) ? data.aboutSteps : [];
  const approach = aboutSteps.length ? `<ol class="about-steps" aria-label="My approach to analysis">${aboutSteps.map((step, index) => `<li><span class="about-step-number" aria-hidden="true">${index + 1}</span><span class="about-step-label">${escape(step)}</span>${index < aboutSteps.length - 1 ? '<span class="about-step-arrow" aria-hidden="true">&gt;&gt;&gt;</span>' : ''}</li>`).join('')}</ol>` : '';
  $('#about-text').innerHTML = aboutParagraphs.map((paragraph, index) => `<p>${escape(paragraph)}</p>${index === 0 ? approach : ''}`).join('');
  const portrait = $('#portrait');
  portrait.addEventListener('error', () => {
    portrait.src = 'Assets/images/avatar-placeholder.svg';
    portrait.alt = `Profile photo placeholder for ${data.name}`;
  }, {once:true});
  portrait.alt = data.photoAlt || data.name;
  portrait.src = fileLink(data.photo) || 'Assets/images/autor.png';
  if (fileLink(data.cv)) {
    $('#cv-link').href = fileLink(data.cv);
    $('#cv-link').target = '_blank';
    $('#cv-link').rel = 'noopener noreferrer';
    $('#cv-link').hidden = false;
    $('#cv-pending').hidden = true;
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
  function projectAction(label, value, note = '') {
    const href = webLink(value);
    const classes = 'button';
    const caption = `${escape(label)}${note ? `<small>${escape(note)}</small>` : ''}`;
    if (href) {
      return `<a class="${classes}" href="${escape(href)}"${external}><span class="project-action__label">${caption}</span>${icon('arrow-up-right')}</a>`;
    }
    return `<button type="button" class="${classes} project-action--pending" disabled><span class="project-action__label">${caption}<small>Coming soon</small></span></button>`;
  }
  function projectActions(project, index) {
    return projectAction('View live report', project.url)
      + projectAction('View SQL', project.codeUrl)
      + (index === 0
        ? projectAction('PBI report walkthrough', project.reportVideoUrl, 'Video in Polish')
          + projectAction('SQL code walkthrough', project.sqlVideoUrl, 'Video in Polish')
        : '');
  }
  // End project action helpers.

  // Keep a short introduction visible; longer descriptions use native disclosure.
  function projectDescription(project, expanded = false) {
    const text = String(project.description || '').trim();
    if (expanded) {
      const paragraphs = [text, project.descriptionDetails || ''].filter(Boolean).join('\n\n');
      return `<div class="project-description project-description--full">${paragraphs.split(/\n\s*\n/).filter(Boolean).map(paragraph => `<p>${escape(paragraph)}</p>`).join('')}</div>`;
    }
    let intro = text, rest = '';
    if (text.length > 220) {
      const space = text.lastIndexOf(' ', 220);
      const split = space > 100 ? space : 220;
      intro = text.slice(0, split).trimEnd();
      rest = text.slice(split).trimStart();
    }
    const paragraphs = [rest, project.descriptionDetails || ''].filter(Boolean).join('\n\n');
    return `<div class="project-description"><p>${escape(intro)}${rest ? '…' : ''}</p>${paragraphs ? `<details class="project-more"><summary>Read more</summary><div class="project-long-description">${paragraphs.split(/\n\s*\n/).filter(Boolean).map(paragraph => `<p>${escape(paragraph)}</p>`).join('')}</div></details>` : ''}</div>`;
  }

  const projects = Array.isArray(data.projects) ? data.projects : [];
  $('#demo-label').hidden = !projects.some(project => project.demo);
  $('#project-grid').innerHTML = projects.map((project, index) => {
    const gallery = Array.isArray(project.gallery) ? project.gallery : [];
    const tags = `<div class="tool-tags" aria-label="Technologies used">${(project.tools || []).map(tool => `<span class="tool-tag">${escape(tool)}</span>`).join('')}</div>`;
    const actions = `<div class="project-actions">${projectActions(project, index)}</div>`;
    return `<article class="project-card ${index === 0 ? 'project-card--featured' : ''}">
      <div class="project-media">
        <button type="button" class="project-image-button" data-project="${index}" data-image="0" aria-label="Open project cover: ${escape(project.title)}">
          <img src="${escape(fileLink(project.cover))}" width="${project.coverWidth || 1363}" height="${project.coverHeight || 767}" alt="${escape(project.coverAlt)}" loading="lazy"><span class="image-hint">${icon('zoom')}</span>
        </button>
        ${gallery.length ? `<div class="gallery-block"><div class="gallery-thumbnails">${gallery.map((image, imageIndex) => `<button type="button" data-project="${index}" data-image="${imageIndex + 1}" aria-label="Open: ${escape(image.alt)}"><img src="${escape(fileLink(image.thumb || image.src))}" width="480" height="270" alt="${escape(image.alt)}" loading="lazy"><span class="gallery-thumb-caption">${escape(image.title || image.alt)}</span></button>`).join('')}</div></div>` : ''}
        ${index === 0 ? actions : ''}
      </div>
      <div class="project-content">${project.demo ? '<p class="demo-note">Demo project</p>' : ''}<h3>${escape(project.title)}</h3>${projectDescription(project, index === 0)}${index === 0 ? tags : ''}</div>
      ${index === 0 ? '' : `<div class="project-footer">${tags}${actions}</div>`}
    </article>`;
  }).join('');
  document.querySelectorAll('.project-more').forEach(details => {
    details.addEventListener('toggle', () => { details.querySelector('summary').textContent = details.open ? 'Read less' : 'Read more'; });
  });

  // Toolkit groups use the existing technology icons and matching line icons.
  const toolkitIcons = {
    prepare: '<path d="M4 4h16l-6 7v7l-4 2v-9z"/>',
    validate: '<path d="M12 3 4 6v6c0 5 8 9 8 9s8-4 8-9V6z"/><path d="m8 12 3 3 5-6"/>',
    analyze: '<path d="M4 3v17h17M8 15v-4m5 4V7m5 8V4"/>',
    communicate: '<path d="M4 4h16v12h-6l-4 4v-4H4zM8 11V9m4 2V7m4 4V6"/>',
    document: '<path d="M6 3h8l4 4v14H6zM14 3v5h4M9 12h6m-6 4h6"/>'
  };
  function toolkitIcon(name) {
    return Object.hasOwn(toolkitIcons, name)
      ? `<svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${toolkitIcons[name]}</svg>`
      : icon(name);
  }
  const toolkitGroups = [
    {id:'tools', title:'Tools I work with'},
    {id:'workflow', title:'How I work with data'}
  ];
  $('#skills-grid').innerHTML = toolkitGroups.map(group => {
    const cards = (data.skills || []).filter(skill => skill.group === group.id);
    return `<section class="toolkit-group" aria-labelledby="toolkit-${group.id}-title"><h3 class="toolkit-group-title" id="toolkit-${group.id}-title">${group.title}</h3><div class="toolkit-row toolkit-row--${group.id}">${cards.map(skill => `<article class="skill-card">${toolkitIcon(skill.icon)}<h4>${escape(skill.name)}</h4><ul class="skill-list">${(skill.items || []).map(item => `<li>${escape(item)}</li>`).join('')}</ul></article>`).join('')}</div><p class="toolkit-more toolkit-more--${group.id}">...and much more!</p></section>`;
  }).join('');
  function experienceBullets(items, className = '') {
    return Array.isArray(items) && items.length
      ? `<ul class="experience-bullets ${className}">${items.map(item => `<li>${escape(item)}</li>`).join('')}</ul>`
      : '';
  }
  $('#experience-list').innerHTML = (data.experience || []).map(job => {
    const achievements = experienceBullets(job.achievements, 'experience-achievements');
    const responsibilities = experienceBullets(job.responsibilities);
    const details = responsibilities || achievements ? `<details class="experience-more"><summary><span class="experience-toggle">Read about</span><span class="experience-toggle-description">my responsibilities and achievements</span></summary>${responsibilities}${achievements ? `<div class="experience-highlights"><h5>Selected achievements</h5>${achievements}</div>` : ''}</details>` : '';
    return `<li><h4>${escape(job.title)}</h4><p class="career-meta">${escape(job.organization)}<br>${escape(job.period)}</p>${job.description ? `<p class="career-description">${escape(job.description)}</p>` : ''}${details}</li>`;
  }).join('') || '<li><p class="career-description">Details coming soon.</p></li>';
  function qualifications(items, target, symbol) {
    const render = item => {
      const url = webLink(item.url);
      const heading = url ? `<a href="${escape(url)}"${external}>${escape(item.title)} ${icon('arrow-up-right')}</a>` : escape(item.title);
      const images = symbol === 'certificate' && Array.isArray(item.gallery) ? item.gallery : [];
      const certificateIndex = items.indexOf(item);
      const certificateButton = images.length ? `<button type="button" class="button certificate-view-button" data-certificate="${certificateIndex}" data-image="0" aria-label="View certificate: ${escape(item.title)}">View certificate ${icon('arrow-up-right')}</button>` : '';
      const metadata = `<p class="career-meta">${escape(item.organization)}<br>${escape(item.period)}</p>`;
      return `<article class="qualification${images.length ? ' qualification--certificate' : ''}">${icon(symbol)}<div class="qualification-content"><h4>${heading}</h4>${images.length ? `<div class="certificate-row">${metadata}${certificateButton}</div>` : metadata}</div></article>`;
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
  window.matchMedia('(min-width:1051px)').addEventListener('change', event => { if(event.matches) closeMenu(); });

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
    $('#gallery-caption').textContent = image.title || image.alt;
    $('#gallery-counter').textContent = `${currentIndex + 1} / ${currentImages.length}`;
    $('#gallery-original').href = fileLink(image.pdf || image.src);
    $('#gallery-original').textContent = image.pdf ? 'Open original certificate PDF ↗' : 'Open full-size image in a new tab ↗';
    $('#gallery-image').width = image.width || 1363;
    $('#gallery-image').height = image.height || 767;
    $('#gallery-prev').hidden = currentImages.length < 2;
    $('#gallery-next').hidden = currentImages.length < 2;
    $('#gallery-counter').hidden = currentImages.length < 2;
  }
  function openImageViewer(title, images, imageIndex, button, certificate = false) {
    if (!images.length) return;
    currentImages = images;
    opener = button;
    $('#gallery-title').textContent = title;
    dialog.classList.toggle('gallery-dialog--certificate', certificate);
    showImage(imageIndex);
    if (typeof dialog.showModal !== 'function') { window.open(fileLink(currentImages[currentIndex].pdf || currentImages[currentIndex].src), '_blank', 'noopener'); return; }
    dialog.showModal();
    document.body.style.overflow = 'hidden';
    $('#gallery-close').focus();
  }
  function openGallery(projectIndex, imageIndex, button) {
    const project = projects[projectIndex];
    if (!project) return;
    openImageViewer(project.title, [{src:project.cover, alt:project.coverAlt, title:project.coverTitle, width:project.coverWidth, height:project.coverHeight}, ...(project.gallery || [])], imageIndex, button);
  }
  document.querySelectorAll('[data-project]').forEach(button => button.addEventListener('click', () => openGallery(Number(button.dataset.project), Number(button.dataset.image), button)));
  document.querySelectorAll('[data-certificate]').forEach(button => button.addEventListener('click', () => {
    const certificate = data.certificates?.[Number(button.dataset.certificate)];
    if (certificate) openImageViewer(certificate.title, certificate.gallery || [], Number(button.dataset.image), button, true);
  }));
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
