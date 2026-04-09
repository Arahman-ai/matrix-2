/* BizAutomatrix — Matrix Rain Background */
(function () {
  // Create canvas if not already in HTML
  var c = document.getElementById('matrixCanvas');
  if (!c) {
    c = document.createElement('canvas');
    c.id = 'matrixCanvas';
    c.style.cssText = 'position:fixed;top:0;left:0;width:100%;height:100%;pointer-events:none;z-index:0;opacity:.13;';
    document.body.insertBefore(c, document.body.firstChild);
  }

  var x = c.getContext('2d');
  var ch = 'アイウエオカキクケコBIZAUTOMATRIX0123456789$%#@!';
  var fs = 14, cols, drops;

  function resize() {
    c.width  = window.innerWidth;
    c.height = window.innerHeight;
    cols  = Math.floor(c.width / fs);
    drops = [];
    for (var i = 0; i < cols; i++) drops.push(Math.random() * -50);
  }

  function draw() {
    x.fillStyle = 'rgba(7,9,13,0.04)';
    x.fillRect(0, 0, c.width, c.height);
    for (var i = 0; i < drops.length; i++) {
      var t = ch[Math.floor(Math.random() * ch.length)];
      x.fillStyle = Math.random() > .85 ? '#FF9F43' : '#00D4AA';
      x.font = fs + 'px monospace';
      x.fillText(t, i * fs, drops[i] * fs);
      if (drops[i] * fs > c.height && Math.random() > .975) drops[i] = 0;
      drops[i]++;
    }
  }

  resize();
  window.addEventListener('resize', resize);
  setInterval(draw, 45);
})();
