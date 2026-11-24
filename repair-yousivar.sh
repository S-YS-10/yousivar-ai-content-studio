#!/data/data/com.termux/files/usr/bin/bash

set -Eeuo pipefail

ROOT="$HOME/yousivar-ai-content-studio"
APP="$ROOT/apps/studio"
DATE="$(date +%Y%m%d-%H%M%S)"
BACKUP="$ROOT/backups/repair-$DATE"

echo "=========================================="
echo "       YOUSIVAR AI STUDIO REPAIR"
echo "=========================================="

# 1. Verify environment
command -v node >/dev/null || {
  echo "ERROR: Node.js is not installed."
  exit 1
}

command -v npm >/dev/null || {
  echo "ERROR: npm is not installed."
  exit 1
}

echo "[1/8] Checking environment..."
node -v
npm -v

# 2. Create backup
echo "[2/8] Creating backup..."
mkdir -p "$BACKUP"
mkdir -p "$APP"

for FILE in package.json package-lock.json vite.config.ts \
            tsconfig.json capacitor.config.ts index.html; do
  if [ -f "$APP/$FILE" ]; then
    cp -a "$APP/$FILE" "$BACKUP/"
  fi
done

if [ -d "$APP/src" ]; then
  cp -a "$APP/src" "$BACKUP/src"
fi

echo "Backup: $BACKUP"

cd "$APP"

# 3. Create package.json
echo "[3/8] Rebuilding package.json..."

cat > package.json <<'JSON'
{
  "name": "yousivar-ai-content-studio",
  "private": true,
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite --host 0.0.0.0",
    "build": "tsc --noEmit && vite build",
    "preview": "vite preview --host 0.0.0.0",
    "cap:sync": "cap sync android",
    "cap:open": "cap open android"
  },
  "dependencies": {
    "@capacitor/android": "^8.6.2",
    "@capacitor/core": "^8.6.2",
    "react": "^19.1.0",
    "react-dom": "^19.1.0"
  },
  "devDependencies": {
    "@capacitor/cli": "^8.6.2",
    "@types/node": "^24.0.0",
    "@types/react": "^19.1.0",
    "@types/react-dom": "^19.1.0",
    "@vitejs/plugin-react": "^4.7.0",
    "typescript": "^5.8.3",
    "vite": "^6.4.1"
  }
}
JSON

# 4. Create Vite configuration
echo "[4/8] Creating Vite configuration..."

cat > vite.config.ts <<'EOFV'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',
    port: 5173,
    strictPort: true
  },
  build: {
    outDir: 'dist',
    sourcemap: false
  }
})
EOFV

# 5. Create TypeScript configuration
cat > tsconfig.json <<'EOFT'
{
  "compilerOptions": {
    "target": "ES2022",
    "useDefineForClassFields": true,
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "Bundler",
    "allowImportingTsExtensions": true,
    "verbatimModuleSyntax": true,
    "moduleDetection": "force",
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "types": ["vite/client", "node"]
  },
  "include": ["src", "vite.config.ts", "capacitor.config.ts"]
}
EOFT

# 6. Create Capacitor configuration
echo "[5/8] Creating Capacitor configuration..."

cat > capacitor.config.ts <<'EOFC'
import type { CapacitorConfig } from '@capacitor/cli'

const config: CapacitorConfig = {
  appId: 'com.yousivar.aistudio',
  appName: 'YOUSIVAR AI Studio',
  webDir: 'dist',
  bundledWebRuntime: false,
  server: {
    androidScheme: 'https'
  }
}

export default config
EOFC

# 7. Create React application
echo "[6/8] Creating React application..."

mkdir -p src

cat > index.html <<'EOFI'
<!doctype html>
<html lang="ar" dir="rtl">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="theme-color" content="#080b12" />
    <meta name="description" content="YOUSIVAR AI Faceless Content Studio" />
    <title>YOUSIVAR – Ω | AI Studio</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOFI

cat > src/main.tsx <<'EOFM'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './style.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
)
EOFM

cat > src/App.tsx <<'EOFA'
import { useState } from 'react'

const features = [
  {
    icon: '🎭',
    title: 'تحريك الشخصيات',
    description: 'إنشاء شخصيات افتراضية وتحريك الوجه والجسم'
  },
  {
    icon: '🎙️',
    title: 'استوديو الصوت',
    description: 'توليد الأصوات والتعليق الصوتي ومزامنة الشفاه'
  },
  {
    icon: '🎬',
    title: 'إنتاج الفيديو',
    description: 'تجميع المشاهد وإضافة الترجمة والمؤثرات'
  },
  {
    icon: '🚀',
    title: 'إدارة المحتوى',
    description: 'إدارة المشاريع وتجهيز المحتوى للنشر'
  }
]

export default function App() {
  const [active, setActive] = useState('dashboard')

  return (
    <main className="app-shell">
      <aside className="sidebar">
        <div className="brand">
          <div className="brand-symbol">Ω</div>
          <div>
            <strong>YOUSIVAR</strong>
            <span>BEYOND INTELLIGENCE</span>
          </div>
        </div>

        <nav>
          <button
            className={active === 'dashboard' ? 'nav-item selected' : 'nav-item'}
            onClick={() => setActive('dashboard')}
          >
            ◈ لوحة التحكم
          </button>
          <button
            className={active === 'projects' ? 'nav-item selected' : 'nav-item'}
            onClick={() => setActive('projects')}
          >
            ◫ مشاريعي
          </button>
          <button
            className={active === 'studio' ? 'nav-item selected' : 'nav-item'}
            onClick={() => setActive('studio')}
          >
            ◉ استوديو الإنتاج
          </button>
          <button
            className={active === 'settings' ? 'nav-item selected' : 'nav-item'}
            onClick={() => setActive('settings')}
          >
            ⚙ الإعدادات
          </button>
        </nav>

        <div className="sidebar-bottom">
          <span className="status-dot"></span>
          النظام جاهز للتطوير
        </div>
      </aside>

      <section className="workspace">
        <header className="topbar">
          <div>
            <span className="eyebrow">AI CONTENT ECOSYSTEM</span>
            <h1>استوديو صناعة المحتوى الذكي</h1>
          </div>
          <div className="avatar">Ω</div>
        </header>

        <section className="hero">
          <div className="hero-content">
            <span className="hero-tag">YOUSIVAR – Ω</span>
            <h2>حوّل أفكارك إلى محتوى سينمائي</h2>
            <p>
              منصة موحدة لإنشاء الشخصيات الافتراضية وتحريكها
              وإنتاج الفيديوهات وإدارة مشاريع المحتوى.
            </p>
            <button
              className="primary-button"
              onClick={() => setActive('studio')}
            >
              ابدأ مشروعاً جديداً <span>←</span>
            </button>
          </div>
          <div className="hero-orb">Ω</div>
        </section>

        <div className="section-heading">
          <div>
            <span className="eyebrow">CREATIVE WORKSPACE</span>
            <h2>أدوات الاستوديو</h2>
          </div>
          <span className="feature-count">04 MODULES</span>
        </div>

        <section className="feature-grid">
          {features.map((feature) => (
            <article className="feature-card" key={feature.title}>
              <div className="feature-icon">{feature.icon}</div>
              <h3>{feature.title}</h3>
              <p>{feature.description}</p>
              <span className="card-arrow">←</span>
            </article>
          ))}
        </section>

        <footer>
          <span>𝐘𝐎𝐔𝐒𝐈𝐕𝐀𝐑 – Ω</span>
          <span>Beyond Intelligence. Beyond Limits.</span>
        </footer>
      </section>
    </main>
  )
}
EOFA

cat > src/style.css <<'EOFCSS'
@import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+Arabic:wght@400;500;600;700&display=swap');

:root {
  font-family: 'IBM Plex Sans Arabic', system-ui, sans-serif;
  color: #f4f5fa;
  background: #080b12;
  font-synthesis: none;
  text-rendering: optimizeLegibility;
}

* {
  box-sizing: border-box;
}

body {
  margin: 0;
  min-width: 320px;
  min-height: 100vh;
  background:
    radial-gradient(ellipse at 80% 0%, #202b4838, transparent 42%),
    #080b12;
}

button {
  font: inherit;
  cursor: pointer;
}

.app-shell {
  min-height: 100vh;
  display: grid;
  grid-template-columns: 245px minmax(0, 1fr);
}

.sidebar {
  border-left: 1px solid #ffffff12;
  background: #0d111bdc;
  padding: 28px 18px;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.brand {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 5px 8px 42px;
}

.brand-symbol,
.avatar {
  display: grid;
  place-items: center;
  width: 43px;
  height: 43px;
  border: 1px solid #b6a5ff70;
  border-radius: 14px;
  color: #d4caff;
  background: linear-gradient(145deg, #9d82ff30, #ffffff08);
  font-size: 25px;
}

.brand strong,
.brand span {
  display: block;
}

.brand strong {
  letter-spacing: 2px;
  font-size: 15px;
}

.brand span,
.eyebrow {
  color: #9298ac;
  font-size: 10px;
  letter-spacing: 1.5px;
}

.sidebar nav {
  display: grid;
  gap: 9px;
}

.nav-item {
  text-align: right;
  padding: 13px 14px;
  border: 1px solid transparent;
  border-radius: 12px;
  color: #aeb4c5;
  background: transparent;
}

.nav-item.selected,
.nav-item:hover {
  color: #e5dfff;
  border-color: #a78bfa30;
  background: #9b83ff16;
}

.sidebar-bottom {
  margin-top: auto;
  color: #9ca5b7;
  font-size: 12px;
  padding: 18px 8px 4px;
}

.status-dot {
  display: inline-block;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  margin-left: 8px;
  background: #62d6a2;
  box-shadow: 0 0 12px #62d6a277;
}

.workspace {
  width: min(1200px, 100%);
  margin: auto;
  padding: 34px clamp(18px, 4vw, 55px);
}

.topbar,
.section-heading {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 18px;
}

.topbar h1 {
  font-size: clamp(19px, 3vw, 27px);
  margin: 7px 0 0;
}

.hero {
  position: relative;
  overflow: hidden;
  min-height: 275px;
  margin: 32px 0 42px;
  padding: 38px;
  display: flex;
  align-items: center;
  border: 1px solid #b7a4ff2b;
  border-radius: 25px;
  background:
    radial-gradient(circle at 78% 50%, #8b6cff30, transparent 34%),
    linear-gradient(120deg, #171b2b, #101521 70%);
}

.hero-content {
  position: relative;
  z-index: 1;
  max-width: 590px;
}

.hero-tag {
  color: #c9baff;
  letter-spacing: 2px;
  font-size: 11px;
}

.hero h2 {
  font-size: clamp(25px, 4vw, 38px);
  margin: 13px 0;
}

.hero p {
  color: #aeb4c5;
  line-height: 2;
  max-width: 540px;
}

.primary-button {
  margin-top: 13px;
  padding: 12px 20px;
  border: 1px solid #c4b4ff66;
  border-radius: 12px;
  color: white;
  background: linear-gradient(120deg, #8065d8, #5744a7);
}

.primary-button span {
  margin-right: 12px;
}

.hero-orb {
  position: absolute;
  left: 7%;
  top: 50%;
  transform: translateY(-50%);
  width: 180px;
  height: 180px;
  border: 1px solid #c1aaff55;
  border-radius: 50%;
  display: grid;
  place-items: center;
  color: #d7caff;
  font-size: 100px;
  text-shadow: 0 0 35px #a78bfa;
  box-shadow: 0 0 70px #8b6cff20, inset 0 0 45px #8b6cff18;
}

.section-heading {
  margin-bottom: 19px;
}

.section-heading h2 {
  margin: 5px 0 0;
  font-size: 22px;
}

.feature-count {
  color: #9298ac;
  font-size: 10px;
  letter-spacing: 1px;
}

.feature-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 15px;
}

.feature-card {
  position: relative;
  min-height: 170px;
  padding: 22px;
  border: 1px solid #ffffff13;
  border-radius: 19px;
  background: linear-gradient(145deg, #171d2b, #10141e);
  transition: .2s ease;
}

.feature-card:hover {
  transform: translateY(-3px);
  border-color: #b49bff66;
}

.feature-icon {
  font-size: 25px;
}

.feature-card h3 {
  margin: 15px 0 6px;
  font-size: 16px;
}

.feature-card p {
  color: #9da5b8;
  font-size: 12px;
  line-height: 1.9;
}

.card-arrow {
  position: absolute;
  left: 19px;
  bottom: 18px;
  color: #bbaaff;
}

footer {
  display: flex;
  justify-content: space-between;
  gap: 15px;
  flex-wrap: wrap;
  border-top: 1px solid #ffffff12;
  margin-top: 40px;
  padding-top: 20px;
  color: #777f93;
  font-size: 11px;
}

@media (max-width: 720px) {
  .app-shell {
    display: block;
  }

  .sidebar {
    min-height: auto;
    padding: 14px;
    border-left: 0;
    border-bottom: 1px solid #ffffff12;
  }

  .brand {
    padding: 3px 5px 15px;
  }

  .sidebar nav {
    display: flex;
    overflow-x: auto;
  }

  .nav-item {
    white-space: nowrap;
    font-size: 12px;
  }

  .sidebar-bottom {
    display: none;
  }

  .workspace {
    padding: 24px 16px;
  }

  .hero {
    padding: 25px 20px;
    min-height: 280px;
  }

  .hero-orb {
    width: 100px;
    height: 100px;
    font-size: 55px;
    left: -20px;
    top: 25px;
    transform: none;
    opacity: .35;
  }

  .feature-grid {
    grid-template-columns: 1fr;
  }
}
EOFCSS

# 8. Install dependencies and build
echo "[7/8] Installing project dependencies..."

npm install

echo "[8/8] Testing production build..."

npm run build

echo
echo "=========================================="
echo "       REPAIR COMPLETED"
echo "=========================================="
echo "Project: $APP"
echo "Backup:  $BACKUP"
echo
echo "Start development server:"
echo "cd $APP && npm run dev"
echo
echo "Build output:"
echo "$APP/dist"
echo "=========================================="
