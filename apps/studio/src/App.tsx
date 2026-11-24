import { useState } from 'react'

const features = [
  {
    icon: '🎭',
    title: 'تحريك الشخصيات',
    description: 'إنشاء الشخصيات الافتراضية وتحريك الوجه والجسم'
  },
  {
    icon: '🎙️',
    title: 'استوديو الصوت',
    description: 'توليد الأصوات والتعليق الصوتي ومزامنة الشفاه'
  },
  {
    icon: '🎬',
    title: 'إنتاج الفيديو',
    description: 'إنشاء المشاهد وإضافة الترجمة والمؤثرات السينمائية'
  },
  {
    icon: '🚀',
    title: 'إدارة المحتوى',
    description: 'تنظيم المشاريع وتجهيز المحتوى للنشر'
  }
]

const navigation = [
  { id: 'dashboard', icon: '◈', label: 'لوحة التحكم' },
  { id: 'projects', icon: '◫', label: 'مشاريعي' },
  { id: 'studio', icon: '◉', label: 'استوديو الإنتاج' },
  { id: 'settings', icon: '⚙', label: 'الإعدادات' }
]

export default function App() {
  const [active, setActive] = useState('dashboard')

  return (
    <main className="app-shell" dir="rtl">
      <aside className="sidebar">
        <div className="brand">
          <div className="brand-symbol">
            <img src="/assets/yousivar-icon.jpg" alt="YOUSIVAR" />
          </div>

          <div className="brand-copy">
            <strong>YOUSIVAR</strong>
            <span>BEYOND INTELLIGENCE</span>
          </div>
        </div>

        <div className="nav-caption">WORKSPACE</div>

        <nav>
          {navigation.map((item) => (
            <button
              key={item.id}
              className={`nav-item ${active === item.id ? 'selected' : ''}`}
              onClick={() => setActive(item.id)}
            >
              <span className="nav-icon">{item.icon}</span>
              {item.label}
              {active === item.id && <span className="nav-indicator" />}
            </button>
          ))}
        </nav>

        <div className="sidebar-bottom">
          <span className="status-dot" />
          <span>النظام جاهز للتطوير</span>
          <span className="online-label">ONLINE</span>
        </div>
      </aside>

      <section className="workspace">
        <header className="topbar">
          <div>
            <span className="eyebrow">AI CONTENT ECOSYSTEM</span>
            <h1>استوديو صناعة المحتوى الذكي</h1>
            <p className="topbar-subtitle">
              مساحة إبداعية موحدة لتحويل أفكارك إلى تجارب سينمائية
            </p>
          </div>

          <div className="avatar">
            <img src="/assets/yousivar-icon.jpg" alt="YOUSIVAR icon" />
          </div>
        </header>

        <section className="hero">
          <div className="hero-content">
            <span className="hero-tag">
              <span className="hero-tag-dot" />
              YOUSIVAR – Ω / CREATIVE INTELLIGENCE
            </span>

            <h2>
              حوّل أفكارك إلى
              <span> محتوى سينمائي</span>
            </h2>

            <p>
              منصة موحدة لإنشاء الشخصيات الافتراضية وتحريكها،
              وإنتاج الفيديوهات وإدارة مشاريع المحتوى من مساحة
              عمل واحدة.
            </p>

            <button
              className="primary-button"
              onClick={() => setActive('studio')}
            >
              ابدأ مشروعاً جديداً
              <span>←</span>
            </button>
          </div>

          <div className="hero-orb">
            <img src="/assets/yousivar-icon.jpg" alt="" />
          </div>

          <div className="hero-decoration">Ω</div>
          <div className="hero-bottom-line" />
        </section>

        <div className="section-heading">
          <div>
            <span className="eyebrow">CREATIVE WORKSPACE</span>
            <h2>أدوات الاستوديو</h2>
          </div>
          <span className="feature-count">04 MODULES</span>
        </div>

        <section className="feature-grid">
          {features.map((feature, index) => (
            <article className="feature-card" key={feature.title}>
              <div className="feature-card-top">
                <div className="feature-icon">{feature.icon}</div>
                <span className="feature-number">
                  0{index + 1}
                </span>
              </div>

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
