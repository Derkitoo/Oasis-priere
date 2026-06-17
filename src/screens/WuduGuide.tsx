import React, { useState } from 'react';
import { WUDU_STEPS } from '../data/wudu';
import { addXP } from '../store';
import type { UserProfile } from '../store';
import Confetti from './Confetti';
import './WuduGuide.css';

interface Props {
  user: UserProfile;
  onUser: (u: UserProfile) => void;
  onBack: () => void;
}

const MASCOT = `${import.meta.env.BASE_URL}postures/takbir_3.png`;

export default function WuduGuide({ user, onUser, onBack }: Props): React.ReactElement {
  const [idx, setIdx] = useState(0);
  const [showDesc, setShowDesc] = useState(false);
  const [done, setDone] = useState(false);

  const step = WUDU_STEPS[idx];
  const total = WUDU_STEPS.length;
  const pct = ((idx + 1) / total) * 100;

  const encouragement =
    idx === 0 ? 'On se purifie, bismillah ! 💧'
    : idx >= total - 2 ? 'Presque fini, bravo ! 💪'
    : pct >= 50 ? 'Tu fais ça très bien ! 🌟'
    : 'Continue doucement 💦';

  const next = () => {
    setShowDesc(false);
    if (idx < total - 1) {
      setIdx(i => i + 1);
    } else {
      const updated = addXP(user, 30);
      onUser(updated);
      setDone(true);
    }
  };

  if (done) return (
    <div className="wudu-done">
      <Confetti />
      <img className="celebrate-mascot" src={MASCOT} alt="" />
      <div className="wudu-done-icon">💧</div>
      <h2>Alhamdulillâh !</h2>
      <p>Tu es en état de pureté.<br />Tu peux maintenant faire la prière.</p>
      <div className="wudu-done-xp">+30 XP</div>
      <button className="btn-gold" onClick={onBack}>Retour</button>
    </div>
  );

  return (
    <div className="wudu">
      {/* Barre supérieure */}
      <div className="wudu-topbar">
        <button className="wudu-back" onClick={onBack}>←</button>
        <div className="wudu-title">💧 Wudu (Ablutions)</div>
        <span className="wudu-count">{idx + 1}/{total}</span>
      </div>

      {/* Barre de progression */}
      <div className="wudu-progress">
        <div className="wudu-fill" style={{ width: `${pct}%` }} />
      </div>

      {/* Mascotte coach */}
      <div className="wudu-coach">
        <img className="wudu-coach-mascot" src={MASCOT} alt="" />
        <div className="wudu-coach-bubble">{encouragement}</div>
      </div>

      {/* Contenu */}
      <div className="wudu-content">
        {/* Image */}
        {step.image ? (
          <div className="wudu-img-wrap">
            <img className="wudu-img" src={`${import.meta.env.BASE_URL}wudu/${step.image}`} alt={step.label} />
          </div>
        ) : (
          <div className="wudu-img-placeholder">💧</div>
        )}

        {/* Répétitions */}
        {step.times && (
          <div className="wudu-times">
            {Array.from({ length: step.times }).map((_, i) => (
              <div key={i} className="wudu-drop">💧</div>
            ))}
          </div>
        )}

        {/* Label */}
        <div className="wudu-step-label">{step.label}</div>

        {/* Arabe */}
        <div className="wudu-arabic">{step.arabic}</div>

        {/* Translittération */}
        <div className="wudu-translit">{step.transliteration}</div>

        {/* Accordéon description */}
        <button className="wudu-desc-toggle" onClick={() => setShowDesc(s => !s)}>
          {showDesc ? '▲ Masquer' : '▼ Comment faire ?'}
        </button>
        {showDesc && (
          <div className="wudu-description">{step.description}</div>
        )}

        {/* Bouton suivant */}
        <button className="wudu-next-btn" onClick={next}>
          {idx < total - 1 ? 'Suivant →' : 'Terminer ✓'}
        </button>
      </div>

      {/* Points de navigation */}
      <div className="wudu-dots">
        {WUDU_STEPS.map((_, i) => (
          <div key={i} className={`wudu-dot ${i === idx ? 'active' : i < idx ? 'past' : ''}`} />
        ))}
      </div>
    </div>
  );
}
