import { useEffect, useState } from 'react';
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

const MASCOT = `${import.meta.env.BASE_URL}postures/takbir_3.png`;

export default function Dashboard({ user, onPray, onWudu, onLearn, onProfile }: Props) {
  const next = getCurrentPrayer();
  const todayKey = new Date().toDateString();
  const isDone = (id: string) => user.completedPrayers.includes(`${id}_${todayKey}`);
  const todayCount = PRAYERS.filter(p => isDone(p.id)).length;

  const xpToNext = 500;
  const xpPct = Math.min(100, ((user.xp % xpToNext) / xpToNext) * 100);
  const level = Math.floor(user.xp / xpToNext) + 1;
  const dateStr = new Date().toLocaleDateString('fr-FR', {
    weekday: 'long', day: 'numeric', month: 'long',
  });

  // ----- compteurs animés (XP qui monte + barre qui se remplit) -----
  const [animXp, setAnimXp] = useState(0);
  const [barPct, setBarPct] = useState(0);

  useEffect(() => {
    const target = user.xp;
    const start = performance.now();
    const dur = 900;
    let raf = 0;
    const tick = (t: number) => {
      const k = Math.min(1, (t - start) / dur);
      const eased = 1 - Math.pow(1 - k, 3);
      setAnimXp(Math.round(target * eased));
      if (k < 1) raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);
    const id = window.setTimeout(() => setBarPct(xpPct), 90);
    return () => { cancelAnimationFrame(raf); clearTimeout(id); };
  }, [user.xp, xpPct]);

  return (
    <div className="dash">
      {/* ===== Bandeau coloré ===== */}
      <header className="dash-banner">
        <div className="dash-banner-row">
          <div>
            <div className="dash-hello">Salam, {user.name} 👋</div>
            <div className="dash-date">{dateStr}</div>
          </div>
          <button className="dash-avatar" onClick={onProfile}>
            {user.name[0].toUpperCase()}
          </button>
        </div>
        <div className="dash-streak">
          <span className="dash-streak-ico">🔥</span>
          <span>{user.streak} jour{user.streak > 1 ? 's' : ''} de suite !</span>
        </div>
      </header>

      <div className="dash-body">
        {/* ===== XP / niveau ===== */}
        <div className="xp-card">
          <div className="xp-top">
            <span>Niveau {level}</span>
            <span className="xp-num">{user.xp % xpToNext} / {xpToNext} XP</span>
          </div>
          <div className="xp-track">
            <div className="xp-fill" style={{ width: `${barPct}%` }} />
          </div>
        </div>

        {/* ===== Stats ===== */}
        <div className="stats-row">
          <div className="stat stat-y">
            <span className="stat-ico">🔥</span>
            <span className="stat-val">{user.streak}</span>
            <span className="stat-lab">jours</span>
          </div>
          <div className="stat stat-g">
            <span className="stat-ico">🕌</span>
            <span className="stat-val">{todayCount}/5</span>
            <span className="stat-lab">prières</span>
          </div>
          <div className="stat stat-o">
            <span className="stat-ico">⭐</span>
            <span className="stat-val">{animXp}</span>
            <span className="stat-lab">points</span>
          </div>
        </div>

        {/* ===== Prochaine prière + mascotte ===== */}
        <div className="next-card">
          <img className="next-mascot" src={MASCOT} alt="" />
          <div className="next-label">Prochaine prière</div>
          <div className="next-name">{next.name}</div>
          <div className="next-meta">{next.arabicName} · {next.rakats} raka'at</div>
          <button className="btn-pray" onClick={() => onPray(next.id)}>
            Commencer →
          </button>
        </div>

        {/* ===== Chemin du jour ===== */}
        <div className="path-title">Ton chemin du jour</div>
        <div className="path">
          {PRAYERS.map((p, i) => {
            const done = isDone(p.id);
            const current = !done && p.id === next.id;
            const cls = done ? 'done' : current ? 'current' : 'todo';
            return (
              <div className="path-node-wrap" key={p.id}>
                {i > 0 && <span className="path-link" />}
                <button className={`path-node ${cls}`} onClick={() => onPray(p.id)}>
                  {done ? '✓' : <span className="path-ar">{p.arabicName}</span>}
                </button>
                <span className="path-name">{p.name}</span>
              </div>
            );
          })}
        </div>

        {/* ===== Actions ===== */}
        <div className="dash-actions">
          <button className="btn-wudu" onClick={onWudu}>💧 Ablutions</button>
          <button className="btn-learn" onClick={onLearn}>📚 Apprendre</button>
        </div>

        {/* ===== Badges ===== */}
        <div className="badges-title">Mes badges 🏅</div>
        <div className="badges">
          <div className="badge b-moon">🌙</div>
          <div className="badge b-water">💧</div>
          <div className="badge b-fire">🔥</div>
          <div className="badge locked">🔒</div>
        </div>
      </div>
    </div>
  );
}
