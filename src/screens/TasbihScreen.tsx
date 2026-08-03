import { useState } from 'react';
import type { UserProfile } from '../store';
import { completeTasbihSession } from '../store';
import './TasbihScreen.css';

interface Props {
  user: UserProfile;
  onDone: (u: UserProfile) => void;
  onBack: () => void;
}

const PHRASES = [
  { text: 'سُبْحَانَ اللَّهِ', trans: 'SubhanAllah', mean: 'Gloire à Allah', target: 33 },
  { text: 'الْحَمْدُ لِلَّهِ', trans: 'Alhamdulillah', mean: 'Louange à Allah', target: 33 },
  { text: 'اللَّهُ أَكْبَرُ', trans: 'Allahu Akbar', mean: 'Allah est le plus Grand', target: 33 },
];

export default function TasbihScreen({ user, onDone, onBack }: Props) {
  const [phaseIndex, setPhaseIndex] = useState(0);
  const [count, setCount] = useState(0);
  const [totalClicked, setTotalClicked] = useState(0);
  const [completed, setCompleted] = useState(false);

  const currentPhase = PHRASES[phaseIndex];

  const handleClick = () => {
    if (completed) return;
    const nextCount = count + 1;
    setCount(nextCount);
    setTotalClicked(t => t + 1);

    if (nextCount >= currentPhase.target) {
      if (phaseIndex < PHRASES.length - 1) {
        setPhaseIndex(p => p + 1);
        setCount(0);
      } else {
        setCompleted(true);
        const updated = completeTasbihSession(user, 99);
        onDone(updated);
      }
    }
  };

  return (
    <div className="tasbih-screen">
      <div className="tasbih-header">
        <button className="btn-back" onClick={onBack}>←</button>
        <h2>Compteur Tasbih 📿</h2>
        <span style={{ width: 36 }} />
      </div>

      <div className="tasbih-body">
        <div className="tasbih-progress">
          Phase {phaseIndex + 1} / 3 — Total : {totalClicked} invocations
        </div>

        <div className="tasbih-card">
          <div className="tasbih-arabic">{currentPhase.text}</div>
          <div className="tasbih-trans">{currentPhase.trans}</div>
          <div className="tasbih-mean">{currentPhase.mean}</div>

          <div className="tasbih-counter-circle" onClick={handleClick}>
            <div className="tasbih-num">{count}</div>
            <div className="tasbih-sub">/ {currentPhase.target}</div>
          </div>

          <p className="tasbih-hint">Touche le cercle pour égrener les perles 📿</p>
        </div>

        {completed && (
          <div className="tasbih-congratulation">
            🎉 Bravo ! Session Tasbih de 99 invocations complétée (+25 XP) !
          </div>
        )}
      </div>
    </div>
  );
}
