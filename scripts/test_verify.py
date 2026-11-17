import requests
import re

s = requests.Session()
r = s.post('http://127.0.0.1:8027/login', data={'user_id': 'admin', 'password': 'admin123'}, allow_redirects=True)
print('Login status:', r.status_code)

r1 = s.get('http://127.0.0.1:8027/visit-plan/create')
print('visit-plan/create status:', r1.status_code)
print('Type to search PSR found:', 'Type to search PSR' in r1.text)

r2 = s.get('http://127.0.0.1:8027/depot-rack-stock-balance')
print('depot-rack-stock-balance status:', r2.status_code)
print('Depot Rack Stock in r2:', 'Depot Rack Stock' in r2.text)
print('Has Create button:', '/depot-rack-stock-balance/create' in r2.text)
print('Has Upload button:', '/depot-rack-stock-balance/upload' in r2.text)

# Direct access to create/edit/delete should redirect
r_create = s.get('http://127.0.0.1:8027/depot-rack-stock-balance/create', allow_redirects=False)
print('Direct create redirect status:', r_create.status_code, r_create.headers.get('location'))

# Parse sidebar items
pattern = r'<div class="nav-group"[^>]*>.*?<div class="nav-group-title">(.*?)</div>(.*?)</div>\s*<!--'
for m in re.finditer(r'<div class="nav-group" data-key="([^"]+)">\s*<div class="nav-group-title">([^<]+)</div>(.*?)</div>', r2.text, re.DOTALL):
    gname = m.group(2).strip()
    links = re.findall(r'<a[^>]*href="([^"]+)"[^>]*>\s*<i[^>]*></i>\s*<span>([^<]+)</span>', m.group(3))
    print(f"Group: {gname}")
    for href, text in links:
        print(f"   - {text.strip()} ({href})")
