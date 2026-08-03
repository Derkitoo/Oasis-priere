import type { UserProfile } from '../store';
import { buyTheme, equipTheme } from '../store';
import './Profile.css';

interface Props {
  user: UserProfile;
  onBack: () => void;
  onReset: () => void;
  onUser?: (u: UserProfile) => void;
}

const THEMES = [
  { id: 'default', name: 'Oasis Émeraude 🌿', price: 0, preview: 'linear-gradient(135deg, #6FAE54, #5A9645)' },
  { id: 'night', name: 'Nuit Étoilée 🌌', price: 100, preview: 'linear-gradient(135deg, #1D2A44, #0B132B)' },
  { id: 'sunset', name: 'Coucher de Soleil 🌅', price: 200, preview: 'linear-gradient(135deg, #F2884B, #D9534F)' },
  { id: 'royal', name: 'Palais Royal 👑', price: 300, preview: 'linear-gradient(135deg, #D4AF37, #AA7C11)' },
];

export default function Profile({ user, onBack, onReset, onUser }: Props) {
  const level = Math.floor(user.xp / 500) + 1;
  const suraCount = Object.keys(user.suraStars ?? {}).length;
  const unlocked = user.unlockedThemes ?? ['default'];
  const selectedTheme = user.selectedTheme ?? 'default';
  const avatarSrc = `${import.meta.env.BASE_URL}avatars/${user.avatarChoice === 'girl' ? 'girl' : 'boy'}.png`;

  const badges = [
    { ico: '🌙', label: '1ère prière',   on: user.completedPrayers.length >= 1, cls: 'b-moon' },
    { ico: '💧', label: 'Ablutions',    on: user.xp >= 30,                      cls: 'b-water' },
    { ico: '🔥', label: 'Série 3j',      on: user.streak >= 3,                   cls: 'b-fire' },
    { ico: '⭐', label: '100 XP',        on: user.xp >= 100,                     cls: 'b-star' },
    { ico: '📖', label: '1 sourate',     on: suraCount >= 1,                     cls: 'b-book' },
    { ico: '🛡️', label: 'Al-Falaq',      on: Boolean(user.suraStars?.['falaq']), cls: 'b-shield' },
    { ico: '🕊️', label: 'An-Nas',        on: Boolean(user.suraStars?.['nas']),   cls: 'b-bird' },
    { ico: '⏳', label: 'Al-Asr',        on: Boolean(user.suraStars?.['asr']),   cls: 'b-time' },
    { ico: '📚', label: '7 sourates',    on: suraCount >= 7,                     cls: 'b-book' },
    { ico: '🕌', label: '10 prières',    on: user.completedPrayers.length >= 10, cls: 'b-moon' },
    { ico: '🏅', label: '500 XP',        on: user.xp >= 500,                     cls: 'b-star' },
    { ico: '👑', label: '1000 XP',       on: user.xp >= 1000,                    cls: 'b-crown' },
    { ico: '🌟', label: 'Série 7j',      on: user.streak >= 7,                   cls: 'b-fire' },
  ];

  // Calcul du calendrier des 30 derniers jours
  const today = new Date();
  const last30Days = Array.from({ length: 30 }, (_, i) => {
    const d = new Date();
    d.setDate(today.getDate() - (29 - i));
    const key = d.toDateString();
    const count = user.completedPrayers.filter(p => p.endsWith(key)).length;
    return { date: d, key, count };
  });

  const handleThemeAction = (t: typeof THEMES[number]) => {
    if (!onUser) return;
    if (unlocked.includes(t.id)) {
      onUser(equipTheme(user, t.id));
    } else {
      if (user.xp >= t.price) {
        onUser(buyTheme(user, t.id, t.price));
      } else {
        alert(`Il te faut ${t.price} XP pour débloquer ce thème ! (XP actuel : ${user.xp})`);
      }
    }
  };

  return (
    <div className="profile">
      <div className="profile-banner">
        <button className="profile-back" onClick={onBack}>←</button>
        <div className="profile-title">Mon Profil</div>
        <span style={{ width: 42 }} />
      </div>

      <div className="profile-body">
        <div className="profile-avatar">
          <img src={avatarSrc} alt={`Avatar de ${user.name}`} />
        </div>
        <div className="profile-name">{user.name}</div>
        <div className="profile-level">Niveau {level} · {user.level}</div>

        <div className="profile-stats">
          <div className="p-stat"><span className="p-val">{user.xp}</span><span className="p-label">XP total</span></div>
          <div className="p-stat"><span className="p-val">{user.streak}</span><span className="p-label">jours</span></div>
          <div className="p-stat"><span className="p-val">{user.completedPrayers.length}</span><span className="p-label">prières</span></div>
        </div>

        {/* ===== 🛍️ Boutique de l'Oasis ===== */}
        <div className="profile-section-title">Boutique de l'Oasis 🛍️</div>
        <div className="theme-store-grid">
          {THEMES.map(t => {
            const isUnlocked = unlocked.includes(t.id);
            const isEquipped = selectedTheme === t.id;
            return (
              <div key={t.id} className={`theme-card ${isEquipped ? 'equipped' : ''}`}>
                <div className="theme-preview" style={{ background: t.preview }} />
                <div className="theme-info">
                  <div className="theme-name">{t.name}</div>
                  <div className="theme-price">
                    {isUnlocked ? 'Débloqué ✅' : `${t.price} XP`}
                  </div>
                  <button
                    className={`btn-theme ${isEquipped ? 'btn-equipped' : isUnlocked ? 'btn-equip' : 'btn-buy'}`}
                    onClick={() => handleThemeAction(t)}
                  >
                    {isEquipped ? 'Équipé' : isUnlocked ? 'Équiper' : 'Acheter 🛍️'}
                  </button>
                </div>
              </div>
            );
          })}
        </div>

        {/* ===== 📅 Calendrier 30 Jours ===== */}
        <div className="profile-section-title" style={{ marginTop: 24 }}>Journal des 30 Derniers Jours 📅</div>
        <div className="calendar-30days-grid">
          {last30Days.map((d, i) => (
            <div
              key={i}
              className={`cal-day-cell ${d.count >= 5 ? 'full' : d.count > 0 ? 'partial' : 'empty'}`}
              title={`${d.date.toLocaleDateString('fr-FR')} : ${d.count}/5 prières`}
            >
              <span className="cal-day-num">{d.date.getDate()}</span>
              <span className="cal-day-ico">{d.count >= 5 ? '🌙' : d.count > 0 ? '⭐' : '•'}</span>
            </div>
          ))}
        </div>

        {/* ===== 🏅 Badges ===== */}
        <div className="profile-badges-title" style={{ marginTop: 24 }}>Mes récompenses 🏅 ({badges.filter(b => b.on).length}/{badges.length})</div>
        <div className="profile-badges">
          {badges.map((b, i) => (
            <div key={i} className={`p-badge ${b.on ? b.cls : 'locked'}`} title={b.label}>
              <span className="p-badge-ico">{b.on ? b.ico : '🔒'}</span>
              <span className="p-badge-label">{b.label}</span>
            </div>
          ))}
        </div>

        <button
          className="btn-reset"
          onClick={() => { if (confirm('Recommencer depuis le début ?')) onReset(); }}
        >
          Recommencer
        </button>
      </div>
    </div>
  );
}
