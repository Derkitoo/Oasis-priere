import type { UserProfile } from '../store';
import { PRAYERS, getCurrentPrayer } from '../data/prayers';
import './Dashboard.css';

interface Props {
  user: UserProfile;
  onPray: (prayerId: string) => void;
  onWudu: () => void;
  onLearn: () => void;
  onProfile: () => void;
}

export default function Dashboard({ user, onPray, onWudu, onLearn, onProfile }: Props) {
  const next = getCurrentPrayer();
  const todayKey = new Date().toDateString();
  const todayPrayers = PRAYERS.filter(p => user.completedPrayers.includes(`${p.id}_${todayKey}`));
  const xpToNext = 500;
  const xpPct = Math.min(100, (user.xp % xpToNext) / xpToNext * 100);
  const level = Math.floor(user.xp / xpToNext) + 1;

  return (
    <div className="dash">
      {/* Header */}
      <header className="dash-header">
        <div>
          <div className="dash-greeting">Salam, {user.name} 👋</div>
          <div className="dash-date">{new Date().toLocaleDateString('fr-FR', { weekday: 'long', day: 'numeric', month: 'long' })}</div>
        </div>
        <button className="avatar-btn" onClick={onProfile}>
          <div className="avatar">{user.name[0].toUpperCase()}</div>
        </button>
      </header>

      {/* XP Bar */}
      <div className="xp-bar-wrap">
        <div className="xp-info">
          <span>Niveau {level}</span>
          <span>{user.xp} XP</span>
        </div>
        <div className="xp-track">
          <div className="xp-fill" style={{ width: `${xpPct}%` }} />
        </div>
      </div>

      {/* Stats */}
      <div className="stats-row">
        <div className="stat-card">
          <span className="stat-icon">🔥</span>
          <span className="stat-val">{user.streak}</span>
          <span className="stat-label">Jours de suite</span>
        </div>
        <div className="stat-card">
          <span className="stat-icon">🕌</span>
          <span className="stat-val">{todayPrayers.length}/5</span>
          <span className="stat-label">Prières aujourd'hui</span>
        </div>
        <div className="stat-card">
          <span className="stat-icon">⭐</span>
          <span className="stat-val">{user.xp}</span>
          <span className="stat-label">Points XP</span>
        </div>
      </div>

      {/* Next Prayer */}
      <div className="next-prayer-card">
        <div className="next-prayer-label">Prochaine prière</div>
        <div className="next-prayer-name">
          <span className="next-arabic">{next.arabicName}</span>
          <span className="next-fr">{next.name} · {next.rakats} raka'at</span>
        </div>
        <button className="btn-pray" onClick={() => onPray(next.id)}>
          Commencer la prière →
        </button>
      </div>

      {/* Prayers today */}
      <div className="prayers-today">
        <h3>Prières du jour</h3>
        <div className="prayers-grid">
          {PRAYERS.map(p => {
            const done = user.completedPrayers.includes(`${p.id}_${todayKey}`);
            return (
              <button
                key={p.id}
                className={`prayer-pill ${done ? 'done' : ''}`}
                onClick={() => onPray(p.id)}
              >
                <span className="pill-arabic">{p.arabicName}</span>
                <span className="pill-name">{p.name}</span>
                {done && <span className="pill-check">✓</span>}
              </button>
            );
          })}
        </div>
      </div>

      {/* Action buttons */}
      <div className="dash-actions">
        <button className="btn-wudu" onClick={onWudu}>
          💧 Ablutions (Wudu)
        </button>
        <button className="btn-learn" onClick={onLearn}>
          📚 Apprentissage
        </button>
      </div>
    </div>
  );
}
