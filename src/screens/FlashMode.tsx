import { useState } from 'react';
import type { Sura } from '../data/suras';
import type { UserProfile } from '../store';
import Confetti from './Confetti';

interface Props {
  sura: Sura;
  readArabic: UserProfile['readArabic'];
  onDone: () => void;
  onBack: () => void;
}

const MASCOT = `${import.meta.env.BASE_URL}postures/takbir_3.png`;

export default function FlashMode({ sura, readArabic, onDone, onBack }: Props) {
  const [idx, setIdx] = useState(0);
  const [revealed, setRevealed] = useState(false);
  const [done, setDone] = useState(false);

  const verse = sura.verses[idx];
  const total = sura.verses.length;

  const handleTap = () => {
    if (!revealed) { setRevealed(true); return; }
    if (idx < total - 1) { setIdx(i => i + 1); setRevealed(false); }
    else setDone(true);
  };

  if (done) return (
    <div className="mode-done">
      <Confetti />
      <img className="celebrate-mascot" src={MASCOT} alt="" />
      <div className="mode-done-emoji">⭐</div>
      <h2>Bravo !</h2>
      <p>Tu as revu tous les versets de {sura.name}</p>
      <div className="mode-done-xp">+10 XP · 1 étoile débloquée</div>
      <button className="btn-gold" onClick={onDone}>Continuer</button>
    </div>
  );

  const isArabophone = readArabic === 'yes';
  const isFrancophone = readArabic === 'no';

  return (
    <div className="mode-wrap">
      <div className="mode-topbar">
        <button className="mode-back" onClick={onBack}>←</button>
        <div className="mode-title">⚡ Flash · {sura.name}</div>
        <span className="mode-count">{idx + 1}/{total}</span>
      </div>
      <div className="mode-progress">
        <div className="mode-fill" style={{ width: `${((idx + (revealed ? 1 : 0.5)) / total) * 100}%` }} />
      </div>

      <div className={`flash-card ${revealed ? 'revealed' : ''}`} onClick={handleTap}>

        {/* ── Arabophone : arabe en premier, grand ── */}
        {isArabophone && (
          <>
            <div className="flash-arabic flash-arabic-xl">{verse.arabic}</div>
            {revealed && (
              <>
                <div className="flash-separator" />
                <div className="flash-translation flash-translation-lg">{verse.translation}</div>
                <div className="flash-translit flash-translit-sm">{verse.transliteration}</div>
                <div className="flash-hint">Tape pour continuer →</div>
              </>
            )}
            {!revealed && <div className="flash-hint flash-hint-reveal">Tape pour voir la signification ✨</div>}
          </>
        )}

        {/* ── Partiel : arabe + translittération ensemble ── */}
        {!isArabophone && !isFrancophone && (
          <>
            <div className="flash-arabic">{verse.arabic}</div>
            <div className="flash-translit">{verse.transliteration}</div>
            {revealed && (
              <>
                <div className="flash-separator" />
                <div className="flash-translation">{verse.translation}</div>
                <div className="flash-hint">Tape pour continuer →</div>
              </>
            )}
            {!revealed && <div className="flash-hint flash-hint-reveal">Tape pour voir la traduction ✨</div>}
          </>
        )}

        {/* ── Francophone : translittération en premier, grande ── */}
        {isFrancophone && (
          <>
            <div className="flash-translit flash-translit-xl">{verse.transliteration}</div>
            {revealed && (
              <>
                <div className="flash-separator" />
                <div className="flash-translation flash-translation-lg">{verse.translation}</div>
                <div className="flash-arabic flash-arabic-sm">{verse.arabic}</div>
                <div className="flash-hint">Tape pour continuer →</div>
              </>
            )}
            {!revealed && <div className="flash-hint flash-hint-reveal">Tape pour voir la signification ✨</div>}
          </>
        )}

      </div>

      <div className="mode-dots">
        {sura.verses.map((_, i) => (
          <div key={i} className={`mode-dot ${i === idx ? 'active' : i < idx ? 'past' : ''}`} />
        ))}
      </div>
    </div>
  );
}
