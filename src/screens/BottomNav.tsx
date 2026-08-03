import './BottomNav.css';

interface Props {
  active: 'dashboard' | 'learning' | 'profile';
  onHome: () => void;
  onPray: () => void;
  onLearn: () => void;
  onProfile: () => void;
}

export default function BottomNav({ active, onHome, onPray, onLearn, onProfile }: Props) {
  const tabs = [
    { id: 'home',    ico: '🏠', label: 'Accueil',   on: onHome,    on2: active === 'dashboard' },
    { id: 'pray',    ico: '🤲', label: 'Prier',     on: onPray,    on2: false },
    { id: 'learn',   ico: '📚', label: 'Apprendre', on: onLearn,   on2: active === 'learning' },
    { id: 'profile', ico: '👤', label: 'Profil',    on: onProfile, on2: active === 'profile' },
  ];

  return (
    <nav className="bnav-shell">
      <div className="bnav">
        {tabs.map(t => (
          <button key={t.id} className={`bnav-item ${t.on2 ? 'active' : ''}`} onClick={t.on}>
            <span className="bnav-ico">{t.ico}</span>
            <span className="bnav-label">{t.label}</span>
          </button>
        ))}
      </div>
    </nav>
  );
}
