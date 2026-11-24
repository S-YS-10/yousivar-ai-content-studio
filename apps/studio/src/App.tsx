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
