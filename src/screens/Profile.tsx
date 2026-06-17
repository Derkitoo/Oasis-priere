import type { UserProfile } from '../store';
import './Profile.css';

interface Props { user: UserProfile; onBack: () => void; onReset: () => void; }

export default function Profile({ user, onBack, onReset }: Props) {
  const level = Math.floor(user.xp / 500) + 1;
  const suraCount = Object.keys(user.suraStars ?? {}).length;

  const badges = [
    { ico: '🌙', label: '1ère prière',  on: user.completedPrayers.length >= 1, cls: 'b-moon' },
    { ico: '💧', label: 'Wudu',         on: user.xp >= 30,                      cls: 'b-water' },
    { ico: '🔥', label: 'Série 3j',     on: user.streak >= 3,                   cls: 'b-fire' },
    { ico: '⭐', label: '100 XP',       on: user.xp >= 100,                     cls: 'b-star' },
    { ico: '📖', label: '1 sourate',    on: suraCount >= 1,                     cls: 'b-book' },
    { ico: '🕌', label: '10 prières',   on: user.completedPrayers.length >= 10, cls: 'b-moon' },
    { ico: '🏅', label: '500 XP',       on: user.xp >= 500,                     cls: 'b-star' },
    { ico: '🌟', label: 'Série 7j',     on: user.streak >= 7,                   cls: 'b-fire' },
  ];

  return (
    <div className="profile">
      <div className="profile-banner">
        <button className="profile-back" onClick={onBack}>←</button>
        <div className="profile-title">Mon Profil</div>
        <span style={{ width: 42 }} />
      </div>

      <div className="profile-body">
        <div className="profile-avatar">{user.name[0].toUpperCase()}</div>
        <div className="profile-name">{user.name}</div>
        <div className="profile-level">Niveau {level} · {user.level}</div>

        <div className="profile-stats">
          <div className="p-stat"><span className="p-val">{user.xp}</span><span className="p-label">XP total</span></div>
          <div className="p-stat"><span className="p-val">{user.streak}</span><span className="p-label">jours</span></div>
          <div className="p-stat"><span className="p-val">{user.completedPrayers.length}</span><span className="p-label">prières</span></div>
        </div>

        <div className="profile-badges-title">Mes récompenses 🏅</div>
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
