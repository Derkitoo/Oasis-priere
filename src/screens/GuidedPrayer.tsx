import React, { useState } from 'react';
import { PRAYERS } from '../data/prayers';
import { completePrayer } from '../store';
import type { UserProfile } from '../store';
import Confetti from './Confetti';
import './GuidedPrayer.css';

interface Props {
  prayerId: string;
  user: UserProfile;
  onUser: (u: UserProfile) => void;
  onBack: () => void;
}

const MASCOT = `${import.meta.env.BASE_URL}postures/takbir_3.png`;

export default function GuidedPrayer({ prayerId, user, onUser, onBack }: Props): React.ReactElement {
  const prayer = PRAYERS.find(p => p.id === prayerId) ?? PRAYERS[0];
  const [idx, setIdx] = useState(0);
  const [done, setDone] = useState(false);
  const [showDesc, setShowDesc] = useState(false);

  const step = prayer.steps[idx];
  const rakatNum = prayer.steps.slice(0, idx + 1).filter(s => s.isRakatStart).length;
  const total = prayer.steps.length;
  const pct = ((idx + 1) / total) * 100;

  const encouragement =
    idx === 0 ? 'Bismillah, on commence ! 🤲'
    : idx >= total - 2 ? 'Plus que quelques étapes 💪'
    : pct >= 50 ? 'Super, continue ! 🌟'
    : "Tu gères, Masha'Allah !";

  const next = () => {
    setShowDesc(false);
    if (idx < total - 1) {
      setIdx(i => i + 1);
    } else {
      const updated = completePrayer(user, prayer.id);
      onUser(updated);
      setDone(true);
    }
  };

  if (done) return (
    <div className="gp-done">
      <Confetti />
      <img className="celebrate-mascot" src={MASCOT} alt="" />
      <div className="done-icon">🌙</div>
      <h2>Masha'Allah !</h2>
      <p>Tu as accompli la prière {prayer.name}</p>
      <div className="done-xp">+50 XP</div>
      <button className="btn-gold" onClick={onBack}>Retour au tableau de bord</button>
    </div>
  );

  return (
    <div className="gp">
      {/* Barre supérieure */}
      <div className="gp-topbar">
        <button className="gp-back" onClick={onBack}>←</button>
        <div className="gp-title">{prayer.name} · Raka'at {rakatNum}/{prayer.rakats}</div>
        <span className="gp-count">{idx + 1}/{total}</span>
      </div>

      {/* Barre de progression */}
      <div className="gp-progress">
        <div className="gp-fill" style={{ width: `${pct}%` }} />
      </div>

      {/* Mascotte coach */}
      <div className="gp-coach">
        <img className="gp-coach-mascot" src={MASCOT} alt="" />
        <div className="gp-coach-bubble">{encouragement}</div>
      </div>

      {/* Contenu principal */}
      <div className="gp-content">
        {/* Image de posture */}
        <div className="gp-posture-wrap">
          <img
            className="gp-posture-img"
            src={`${import.meta.env.BASE_URL}postures/${step.image}`}
            alt={step.label}
          />
        </div>

        {/* Label de l'étape */}
        <div className="gp-step-label">{step.label}</div>

        {/* Texte arabe */}
        <div className="gp-arabic">{step.arabic}</div>

        {/* Translittération */}
        {step.transliteration && (
          <div className="gp-translit">{step.transliteration}</div>
        )}

        {/* Description (accordéon) */}
        <button className="gp-desc-toggle" onClick={() => setShowDesc(s => !s)}>
          {showDesc ? '▲ Masquer les instructions' : '▼ Voir les instructions'}
        </button>
        {showDesc && (
          <div className="gp-description">{step.description}</div>
        )}

        {/* Bouton suivant */}
        <button className="gp-next-btn" onClick={next}>
          {idx < total - 1 ? 'Suivant →' : 'Terminer la prière ✓'}
        </button>
      </div>

      {/* Points de navigation */}
      <div className="gp-dots">
        {prayer.steps.map((_, i) => (
          <div
            key={i}
            className={`gp-dot ${i === idx ? 'active' : i < idx ? 'past' : ''}`}
          />
        ))}
      </div>
    </div>
  );
}
