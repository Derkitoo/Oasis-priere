import { useState } from 'react';
import { createUser, saveUser } from '../store';
import type { UserProfile } from '../store';
import './Onboarding.css';

interface Props { onDone: (u: UserProfile) => void; }

export default function Onboarding({ onDone }: Props) {
  const [step, setStep] = useState(0);
  const [name, setName] = useState('');
  const [age, setAge] = useState(10);
  const [level, setLevel] = useState<UserProfile['level']>('debutant');
  const [readArabic, setReadArabic] = useState<UserProfile['readArabic']>('partial');

  const finish = () => {
    const u = createUser(name || 'Mon enfant', age, level, readArabic);
    saveUser(u);
    onDone(u);
  };

  return (
    <div className="onboard">
      <div className="onboard-card">

        {step === 0 && (
          <div className="onboard-step">
            <div className="mosque-icon">🕌</div>
            <h1>L'Oasis de la Prière</h1>
            <p>Apprends la prière pas à pas, avec amour et patience.</p>
            <button className="btn-gold" onClick={() => setStep(1)}>Commencer ✨</button>
          </div>
        )}

        {step === 1 && (
          <div className="onboard-step">
            <div className="step-num">1 / 4</div>
            <h2>Quel est ton prénom ?</h2>
            <input
              className="onboard-input"
              placeholder="Mon prénom..."
              value={name}
              onChange={e => setName(e.target.value)}
              autoFocus
            />
            <button className="btn-gold" onClick={() => setStep(2)} disabled={!name.trim()}>
              Suivant →
            </button>
          </div>
        )}

        {step === 2 && (
          <div className="onboard-step">
            <div className="step-num">2 / 4</div>
            <h2>Quel âge as-tu ?</h2>
            <div className="age-selector">
              <button className="age-btn" onClick={() => setAge(a => Math.max(7, a - 1))}>−</button>
              <span className="age-display">{age} ans</span>
              <button className="age-btn" onClick={() => setAge(a => Math.min(13, a + 1))}>+</button>
            </div>
            <button className="btn-gold" onClick={() => setStep(3)}>Suivant →</button>
          </div>
        )}

        {step === 3 && (
          <div className="onboard-step">
            <div className="step-num">3 / 4</div>
            <h2>Où en es-tu avec la prière ?</h2>
            <div className="level-choices">
              {([
                { id: 'debutant',      label: 'Débutant',      emoji: '🌱', desc: 'Je commence tout juste' },
                { id: 'intermediaire', label: 'Intermédiaire', emoji: '🌿', desc: 'Je connais les bases' },
                { id: 'avance',        label: 'Avancé',        emoji: '🌳', desc: 'Je veux perfectionner' },
              ] as const).map(l => (
                <button
                  key={l.id}
                  className={`level-card ${level === l.id ? 'selected' : ''}`}
                  onClick={() => setLevel(l.id)}
                >
                  <span className="level-emoji">{l.emoji}</span>
                  <strong>{l.label}</strong>
                  <small>{l.desc}</small>
                </button>
              ))}
            </div>
            <button className="btn-gold" onClick={() => setStep(4)}>Suivant →</button>
          </div>
        )}

        {step === 4 && (
          <div className="onboard-step">
            <div className="step-num">4 / 4</div>
            <h2>Tu sais lire l'arabe ?</h2>
            <p className="onboard-hint">Cela nous aide à adapter tes exercices.</p>
            <div className="level-choices">
              {([
                {
                  id: 'yes',
                  emoji: '✅',
                  label: "Oui, je lis l'arabe",
                  desc: 'Je reconnais les lettres et je lis',
                },
                {
                  id: 'partial',
                  emoji: '📖',
                  label: 'Un peu',
                  desc: "J'apprends, je connais quelques lettres",
                },
                {
                  id: 'no',
                  emoji: '🔤',
                  label: 'Non, je lis le français',
                  desc: "J'utilise la translittération pour prononcer",
                },
              ] as const).map(l => (
                <button
                  key={l.id}
                  className={`level-card ${readArabic === l.id ? 'selected' : ''}`}
                  onClick={() => setReadArabic(l.id)}
                >
                  <span className="level-emoji">{l.emoji}</span>
                  <strong>{l.label}</strong>
                  <small>{l.desc}</small>
                </button>
              ))}
            </div>
            <button className="btn-gold" onClick={finish}>C'est parti ! 🚀</button>
          </div>
        )}

      </div>
    </div>
  );
}
