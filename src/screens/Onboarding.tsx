import { useState } from 'react';
import { createUser, saveUser } from '../store';
import type { UserProfile } from '../store';
import './Onboarding.css';

interface Props { onDone: (u: UserProfile) => void; }

const BOY_AVATAR = `${import.meta.env.BASE_URL}avatars/boy.png`;
const GIRL_AVATAR = `${import.meta.env.BASE_URL}avatars/girl.png`;

export default function Onboarding({ onDone }: Props) {
  const [step, setStep] = useState(0);
  const [name, setName] = useState('');
  const [age, setAge] = useState(10);
  const [level, setLevel] = useState<UserProfile['level']>('debutant');
  const [readArabic, setReadArabic] = useState<UserProfile['readArabic']>('partial');
  const [avatarChoice, setAvatarChoice] = useState<'boy' | 'girl' | null>(null);

  const finish = () => {
    if (!avatarChoice) return;
    const u = createUser(name || 'Mon enfant', age, level, readArabic, avatarChoice);
    saveUser(u);
    onDone(u);
  };

  return (
    <div className={`onboard ${step === 0 ? 'onboard-welcome' : ''}`}>
      <div className="onboard-card">

        {step === 0 && (
          <div className="onboard-step onboard-step-welcome">
            <div className="onboard-brand-visual" aria-hidden="true">
              <span className="brand-star brand-star-one">✦</span>
              <span className="brand-star brand-star-two">✦</span>
              <span className="brand-moon">☾</span>
              <span className="brand-mosque">🕌</span>
            </div>
            <div className="onboard-kicker">Bienvenue dans</div>
            <h1>Sajjada</h1>
            <div className="onboard-signature">La prière pas à pas</div>
            <p>Un parcours doux et ludique pour apprendre, comprendre et aimer la prière.</p>
            <button className="btn-gold" onClick={() => setStep(1)}>Commencer ✨</button>
            <div className="onboard-dots">
              <span className="od on" /><span className="od" /><span className="od" /><span className="od" /><span className="od" />
            </div>
          </div>
        )}

        {step === 1 && (
          <div className="onboard-step">
            <div className="step-num">1 / 5</div>
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
            <div className="step-num">2 / 5</div>
            <h2>Choisis ton personnage !</h2>
            <div className="avatar-pick-row">
              <button
                type="button"
                className={`avatar-pick-card ${avatarChoice === 'boy' ? 'selected' : ''}`}
                onClick={() => setAvatarChoice('boy')}
                aria-pressed={avatarChoice === 'boy'}
              >
                <img src={BOY_AVATAR} alt="Garçon" className="avatar-pick-img" />
                <span>Garçon 👦</span>
              </button>
              <button
                type="button"
                className={`avatar-pick-card ${avatarChoice === 'girl' ? 'selected' : ''}`}
                onClick={() => setAvatarChoice('girl')}
                aria-pressed={avatarChoice === 'girl'}
              >
                <img src={GIRL_AVATAR} alt="Fille" className="avatar-pick-img" />
                <span>Fille 👧</span>
              </button>
            </div>
            <button className="btn-gold" onClick={() => setStep(3)} disabled={!avatarChoice}>Suivant →</button>
          </div>
        )}

        {step === 3 && (
          <div className="onboard-step">
            <div className="step-num">3 / 5</div>
            <h2>Quel âge as-tu ?</h2>
            <div className="age-selector">
              <button className="age-btn" onClick={() => setAge(a => Math.max(7, a - 1))}>−</button>
              <span className="age-display">{age} ans</span>
              <button className="age-btn" onClick={() => setAge(a => Math.min(13, a + 1))}>+</button>
            </div>
            <button className="btn-gold" onClick={() => setStep(4)}>Suivant →</button>
          </div>
        )}

        {step === 4 && (
          <div className="onboard-step">
            <div className="step-num">4 / 5</div>
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
            <button className="btn-gold" onClick={() => setStep(5)}>Suivant →</button>
          </div>
        )}

        {step === 5 && (
          <div className="onboard-step">
            <div className="step-num">5 / 5</div>
            <h2>Tu sais lire l'arabe ?</h2>
            <p className="onboard-hint">Cela nous aide à adapter tes exercices.</p>
            <div className="level-choices">
              {([
                { id: 'yes',     emoji: '✅', label: "Oui, je lis l'arabe",      desc: 'Je reconnais les lettres et je lis' },
                { id: 'partial', emoji: '📖', label: 'Un peu',                   desc: "J'apprends, je connais quelques lettres" },
                { id: 'no',      emoji: '🔤', label: 'Non, je lis le français',  desc: "J'utilise la translittération pour prononcer" },
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
