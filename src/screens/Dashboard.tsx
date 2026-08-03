import { useEffect, useState } from 'react';
import type { UserProfile } from '../store';
import { PRAYERS, getCurrentPrayer } from '../data/prayers';
import './Dashboard.css';

const KAABA = { latitude: 21.4225, longitude: 39.8262 };

const qiblaBearingFrom = (latitude: number, longitude: number) => {
  const toRad = (value: number) => value * Math.PI / 180;
  const toDeg = (value: number) => value * 180 / Math.PI;
  const lat1 = toRad(latitude);
  const lat2 = toRad(KAABA.latitude);
  const deltaLongitude = toRad(KAABA.longitude - longitude);
  const y = Math.sin(deltaLongitude) * Math.cos(lat2);
  const x = Math.cos(lat1) * Math.sin(lat2)
    - Math.sin(lat1) * Math.cos(lat2) * Math.cos(deltaLongitude);
  return (toDeg(Math.atan2(y, x)) + 360) % 360;
};

type CompassOrientationEvent = DeviceOrientationEvent & {
  webkitCompassHeading?: number;
};

interface Props {
  user: UserProfile;
  onPray: (prayerId: string) => void;
  onWudu: () => void;
  onLearn: () => void;
  onProfile: () => void;
  onTasbih: () => void;
  onDouas: () => void;
}

export default function Dashboard({ user, onPray, onWudu, onLearn, onProfile, onTasbih, onDouas }: Props) {
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

  const [animXp, setAnimXp] = useState(0);
  const [barPct, setBarPct] = useState(0);
  const [showQibla, setShowQibla] = useState(false);
  const [qiblaBearing, setQiblaBearing] = useState<number | null>(null);
  const [deviceHeading, setDeviceHeading] = useState<number | null>(null);
  const [qiblaMessage, setQiblaMessage] = useState('Recherche de ta position…');

  // Étape de l'Arbre de la Foi
  const treeLeaves = user.xp + (user.completedPrayers.length * 10);
  const getTreeStage = () => {
    if (treeLeaves < 100) return { title: 'Jeune Pousse 🌱', emoji: '🌱', desc: 'Arrose ton arbre avec tes prières !' };
    if (treeLeaves < 300) return { title: 'Arbrisseau 🌿', emoji: '🌿', desc: 'Tes feuilles verdissent au soleil !' };
    if (treeLeaves < 600) return { title: 'Grand Arbre 🌳', emoji: '🌳', desc: 'Un feuillage abondant et protecteur !' };
    return { title: 'L\'Arbre Céleste 🌴', emoji: '🌴', desc: 'Ton Oasis resplendit de lumière !' };
  };
  const treeStage = getTreeStage();

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

  useEffect(() => {
    if (!showQibla) return;

    if (!navigator.geolocation) return;
    navigator.geolocation.getCurrentPosition(
      ({ coords }) => {
        setQiblaBearing(qiblaBearingFrom(coords.latitude, coords.longitude));
        setQiblaMessage('Tourne doucement le téléphone pour aligner la flèche.');
      },
      error => {
        const message = error.code === error.PERMISSION_DENIED
          ? 'Autorise la localisation pour trouver la Qibla.'
          : 'Position introuvable. Vérifie le GPS puis réessaie.';
        setQiblaMessage(message);
      },
      { enableHighAccuracy: true, timeout: 12000, maximumAge: 300000 },
    );

    const updateHeading = (event: Event) => {
      const orientation = event as CompassOrientationEvent;
      const heading = typeof orientation.webkitCompassHeading === 'number'
        ? orientation.webkitCompassHeading
        : typeof orientation.alpha === 'number'
          ? (360 - orientation.alpha) % 360
          : null;
      if (heading !== null) setDeviceHeading(heading);
    };

    window.addEventListener('deviceorientationabsolute', updateHeading);
    window.addEventListener('deviceorientation', updateHeading);
    return () => {
      window.removeEventListener('deviceorientationabsolute', updateHeading);
      window.removeEventListener('deviceorientation', updateHeading);
    };
  }, [showQibla]);

  const openQibla = async () => {
    setQiblaBearing(null);
    setDeviceHeading(null);
    setQiblaMessage(navigator.geolocation
      ? 'Recherche de ta position…'
      : 'La localisation n’est pas disponible sur cet appareil.');
    const orientationApi = window.DeviceOrientationEvent as (typeof DeviceOrientationEvent & {
      requestPermission?: () => Promise<'granted' | 'denied'>;
    }) | undefined;
    if (typeof orientationApi?.requestPermission === 'function') {
      try {
        await orientationApi.requestPermission();
      } catch {
        // La direction fixe reste disponible même si le capteur est refusé.
      }
    }
    setShowQibla(true);
  };

  const needleRotation = qiblaBearing === null
    ? 0
    : qiblaBearing - (deviceHeading ?? 0);
  const alignment = qiblaBearing !== null && deviceHeading !== null
    ? Math.abs(((qiblaBearing - deviceHeading + 540) % 360) - 180)
    : null;

  const characterImg = `${import.meta.env.BASE_URL}postures/${user.avatarChoice === 'girl' ? 'girl' : 'boy'}_ruku_2.png`;
  const characterAvatar = user.avatarChoice === 'girl'
    ? `${import.meta.env.BASE_URL}avatars/girl.png`
    : `${import.meta.env.BASE_URL}avatars/boy.png`;

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
            <img src={characterAvatar} alt={user.name} className="dash-avatar-img" />
          </button>
        </div>
        <div className="dash-banner-subrow">
          <div className="dash-streak">
            <span className="dash-streak-ico">🔥</span>
            <span>{user.streak} jour{user.streak > 1 ? 's' : ''} de suite !</span>
          </div>
          <button className="qibla-btn" onClick={openQibla}>
            🧭 Qibla
          </button>
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

        {/* ===== Arbre de la Foi ===== */}
        <div className="tree-card">
          <div className="tree-icon">{treeStage.emoji}</div>
          <div className="tree-info">
            <div className="tree-title">{treeStage.title}</div>
            <div className="tree-sub">{treeLeaves} feuilles d'Oasis · {treeStage.desc}</div>
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

        {/* ===== Prochaine prière ===== */}
        <div className="next-card">
          <img className="next-mascot" src={characterImg} alt={user.name} />
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
        <div className="dash-actions-grid">
          <button className="btn-action btn-wudu" onClick={onWudu}>💧 Ablutions</button>
          <button className="btn-action btn-tasbih" onClick={onTasbih}>📿 Tasbih</button>
          <button className="btn-action btn-douas" onClick={onDouas}>🤲 Douas</button>
          <button className="btn-action btn-learn" onClick={onLearn}>📚 Apprendre</button>
        </div>

        {/* ===== Badges ===== */}
        <div className="badges-title">Mes badges 🏅</div>
        <div className="badges" onClick={onProfile}>
          <div className="badge b-moon">🌙</div>
          <div className="badge b-water">💧</div>
          <div className="badge b-fire">🔥</div>
          <div className="badge b-shield">🛡️</div>
        </div>
      </div>

      {/* ===== Qibla Modal ===== */}
      {showQibla && (
        <div className="qibla-modal-overlay" onClick={() => setShowQibla(false)}>
          <div className="qibla-modal" onClick={e => e.stopPropagation()}>
            <button className="qibla-close" onClick={() => setShowQibla(false)}>✕</button>
            <h3>Boussole Qibla 🧭</h3>
            <p>Direction vers la Ka'aba à La Mecque</p>
            <div className="qibla-compass">
              <span className="compass-north">N</span>
              <div className="compass-ring">
                <div className="compass-needle" style={{ transform: `rotate(${needleRotation}deg)` }}>
                  <span className="needle-arrow">▲</span>
                  <span className="needle-kaaba">🕋</span>
                </div>
              </div>
            </div>
            <div className={`qibla-status ${alignment !== null && alignment < 8 ? 'aligned' : ''}`}>
              {alignment !== null && alignment < 8
                ? '✨ Alignement parfait vers la Qibla'
                : qiblaMessage}
            </div>
            {qiblaBearing !== null && (
              <div className="qibla-bearing">
                Direction : {Math.round(qiblaBearing)}° depuis le nord
                {deviceHeading === null && <span> · active le capteur de mouvement pour la boussole en direct</span>}
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
