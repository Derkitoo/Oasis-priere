import type { UserProfile } from '../store';
import './Profile.css';

interface Props { user: UserProfile; onBack: () => void; onReset: () => void; }

export default function Profile({ user, onBack, onReset }: Props) {
  const level = Math.floor(user.xp / 500) + 1;

  return (
    <div className="profile">
      <div className="profile-topbar">
        <button className="profile-back" onClick={onBack}>←</button>
        <div className="profile-title">Mon Profil</div>
        <span />
      </div>

      <div className="profile-body">
        <div className="profile-avatar">{user.name[0].toUpperCase()}</div>
        <div className="profile-name">{user.name}</div>
        <div className="profile-level">Niveau {level} · {user.level}</div>

        <div className="profile-stats">
          <div className="p-stat">
            <span className="p-val">{user.xp}</span>
            <span className="p-label">XP Total</span>
          </div>
          <div className="p-stat">
            <span className="p-val">{user.streak}</span>
            <span className="p-label">Série (jours)</span>
          </div>
          <div className="p-stat">
            <span className="p-val">{user.completedPrayers.length}</span>
            <span className="p-label">Prières</span>
          </div>
        </div>

        <button className="btn-reset" onClick={() => {
          if (confirm('Recommencer depuis le début ?')) onReset();
        }}>
          Recommencer
        </button>
      </div>
    </div>
  );
}
