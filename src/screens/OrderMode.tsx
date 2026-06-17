import { useState, useMemo } from 'react';
import type { Sura } from '../data/suras';
import type { UserProfile } from '../store';
import Confetti from './Confetti';

interface Props {
  sura: Sura;
  readArabic: UserProfile['readArabic'];
  onDone: (errors: number) => void;
  onBack: () => void;
}

const MASCOT = `${import.meta.env.BASE_URL}postures/takbir_3.png`;

interface Tile { originalIdx: number; order: number | null; }

function shuffle<T>(arr: T[]): T[] {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

export default function OrderMode({ sura, readArabic, onDone, onBack }: Props) {
  const initTiles = useMemo<Tile[]>(
    () => shuffle(sura.verses.map((_, i) => ({ originalIdx: i, order: null }))),
    [sura]
  );
  const [tiles, setTiles] = useState<Tile[]>(initTiles);
  const [validated, setValidated] = useState(false);
  const [errors, setErrors] = useState(0);

  const placed = tiles.filter(t => t.order !== null).length;
  const allPlaced = placed === tiles.length;

  const handleTap = (i: number) => {
    if (validated) return;
    const t = tiles[i];
    if (t.order !== null) {
      if (t.order === placed) setTiles(prev => prev.map((x, j) => j === i ? { ...x, order: null } : x));
    } else {
      setTiles(prev => prev.map((x, j) => j === i ? { ...x, order: placed + 1 } : x));
    }
  };

  const handleValidate = () => {
    const errCount = tiles.filter(t => t.order !== t.originalIdx + 1).length;
    setErrors(errCount);
    setValidated(true);
  };

  const isFranco = readArabic === 'no';

  if (validated) {
    const perfect = errors === 0;
    const good    = errors <= 1;
    const stars   = perfect ? 3 : good ? 2 : 1;
    const xp      = perfect ? 40 : good ? 20 : 10;
    const emoji   = perfect ? '🏆' : good ? '⭐' : '📚';
    const msg     = perfect ? "Masha'Allah !" : good ? 'Presque parfait !' : "Continue à t'entraîner !";

    return (
      <div className="mode-done">
        <Confetti />
        <img className="celebrate-mascot" src={MASCOT} alt="" />
        <div className="mode-done-emoji">{emoji}</div>
        <h2>{msg}</h2>
        <p>{perfect ? 'Ordre parfait !' : `${errors} erreur${errors > 1 ? 's' : ''}`}</p>

        <div className="order-result-list">
          {tiles
            .slice()
            .sort((a, b) => (a.order ?? 99) - (b.order ?? 99))
            .map((tile, i) => {
              const ok = tile.order === tile.originalIdx + 1;
              const verse = sura.verses[tile.originalIdx];
              return (
                <div key={i} className={`order-result-row ${ok ? 'row-ok' : 'row-ko'}`}>
                  <span className="row-num">{tile.order}</span>
                  <span className="row-arabic">
                    {isFranco ? verse.transliteration : verse.arabic}
                  </span>
                  <span>{ok ? '✓' : '✗'}</span>
                </div>
              );
            })}
        </div>

        <div className="mode-done-xp">+{xp} XP · {stars} étoile{stars > 1 ? 's' : ''}</div>
        <button className="btn-gold" onClick={() => onDone(errors)}>Continuer</button>
      </div>
    );
  }

  return (
    <div className="mode-wrap">
      <div className="mode-topbar">
        <button className="mode-back" onClick={onBack}>←</button>
        <div className="mode-title">🔢 Ordre · {sura.name}</div>
        <span className="mode-count">{placed}/{tiles.length}</span>
      </div>
      <div className="mode-progress">
        <div className="mode-fill" style={{ width: `${placed / tiles.length * 100}%` }} />
      </div>

      <div className="order-body">
        <p className="order-instruction">
          {isFranco
            ? 'Tape les formules dans le bon ordre'
            : 'Tape les versets dans le bon ordre'}
        </p>

        <div className="order-grid">
          {tiles.map((tile, i) => {
            const verse = sura.verses[tile.originalIdx];
            return (
              <div
                key={i}
                className={`order-tile ${tile.order !== null ? 'tile-placed' : ''}`}
                onClick={() => handleTap(i)}
              >
                {tile.order !== null && <div className="tile-badge">{tile.order}</div>}

                {isFranco ? (
                  <>
                    <div className="tile-translit-main">{verse.transliteration}</div>
                    <div className="tile-arabic-hint">{verse.arabic}</div>
                  </>
                ) : (
                  <>
                    <div className="tile-arabic">{verse.arabic}</div>
                    <div className="tile-translit">{verse.transliteration}</div>
                  </>
                )}
              </div>
            );
          })}
        </div>

        {!allPlaced && (
          <p className="order-hint">Tape le verset numéro {placed + 1}</p>
        )}
        {allPlaced && (
          <button className="mode-next-btn" onClick={handleValidate}>Valider ✓</button>
        )}
      </div>
    </div>
  );
}
