#!/usr/bin/env python3
"""
Fix email obfuscation on all HTML files.
Run from inside your bridgebay-digital folder:
    python fix-email.py
"""
import os, re

EMAIL = 'info@bizautomatrix.com'

# JS that assembles email at runtime — Cloudflare cannot obfuscate this
EMAIL_JS = """
<script>
(function(){
  var u='info',d='bizautomatrix',t='com';
  var e=u+'@'+d+'.'+t;
  var m='mailto:'+e;
  document.querySelectorAll('[data-em="l"]').forEach(function(el){el.href=m;});
  document.querySelectorAll('[data-em="t"]').forEach(function(el){el.textContent=e;});
  document.querySelectorAll('[data-em="b"]').forEach(function(el){el.href=m;el.textContent=e;});
})();
</script>"""

files = [f for f in os.listdir('.') if f.endswith('.html')]
changed = 0

for fname in files:
    with open(fname, 'r', encoding='utf-8', errors='ignore') as f:
        html = f.read()
    original = html

    # 1. Remove Cloudflare email decode script
    html = re.sub(
        r'<script data-cfasync="false" src="/cdn-cgi/scripts/[^"]+"></script>\s*',
        '', html
    )

    # 2. Replace CF-obfuscated mailto hrefs
    html = re.sub(
        r'href="/cdn-cgi/l/email-protection#[a-f0-9]+"',
        'href="#" data-em="l"', html
    )

    # 3. Replace CF email spans with empty placeholder
    html = re.sub(
        r'<span class="__cf_email__"[^>]+>\[email[^<]+</span>',
        '<span data-em="t"></span>', html
    )

    # 4. Replace any raw mailto: links
    html = html.replace(
        f'href="mailto:{EMAIL}"',
        'href="#" data-em="l"'
    )

    # 5. Replace visible raw email text (not already in data-em spans)
    # Only replace if not already inside a data-em span
    html = re.sub(
        r'(?<!data-em="t">)' + re.escape(EMAIL) + r'(?!</span>)',
        f'<span data-em="t"></span>', html
    )

    # 6. Remove old email JS if present, add fresh one
    html = re.sub(
        r'\s*<script>\s*\(function\(\)\{[^<]*var u=.info.[^<]*</script>',
        '', html, flags=re.DOTALL
    )
    if 'data-em=' in html and 'var u=\'info\'' not in html:
        html = html.replace('</body>', EMAIL_JS + '\n</body>')

    if html != original:
        with open(fname, 'w', encoding='utf-8') as f:
            f.write(html)
        changed += 1
        print(f'✅ Fixed: {fname}')
    else:
        print(f'   Clean: {fname}')

print(f'\nDone — {changed} files updated.')
print('\nNow run:')
print('  git add -A')
print('  git commit -m "fix: email obfuscation across all pages"')
print('  git push')
