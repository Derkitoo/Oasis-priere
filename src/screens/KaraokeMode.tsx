import { useState, useEffect, useRef } from 'react';
import type { Sura } from '../data/suras';
import './KaraokeMode.css';

interface Props {
  sura: Sura;
  readArabic: 'yes' | 'partial' | 'no';
  onDone: () => void;
  onBack: () => void;
}

export default function KaraokeMode({ sura, readArabic, onDone, onBack }: Props) {
  const [currentVerseIndex, setCurrentVerseIndex] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [repeat3x, setRepeat3x] = useState(false);
  const [repeatCount, setRepeatCount] = useState(0);

  const audioRef = useRef<HTMLAudioElement | null>(null);

  const currentVerse = sura.verses[currentVerseIndex];

  useEffect(() => {
    // Réinitialiser au changement de verset
    setRepeatCount(0);
    setIsPlaying(false);
  }, [currentVerseIndex]);

  const handlePlay = () => {
    if (audioRef.current) {
      audioRef.current.play();
      setIsPlaying(true);
    }
  };

  const handlePause = () => {
    if (audioRef.current) {
      audioRef.current.pause();
      setIsPlaying(false);
    }
  };

  const handleAudioEnded = () => {
    if (repeat3x && repeatCount < 2) {
      setRepeatCount(c => c + 1);
      if (audioRef.current) {
        audioRef.current.currentTime = 0;
        audioRef.current.play();
      }
    } else {
      setIsPlaying(false);
      if (currentVerseIndex < sura.verses.length - 1) {
        setCurrentVerseIndex(i => i + 1);
      }
    }
  };

  return (
    <div className="karaoke">
      <div className="karaoke-topbar">
        <button className="karaoke-back" onClick={onBack}>←</button>
        <div className="karaoke-title">{sura.name} — Karaoké 🎤</div>
        <span style={{ width: 36 }} />
      </div>

      <div className="karaoke-body">
        <div className="karaoke-progress-bar">
          Verset {currentVerseIndex + 1} sur {sura.verses.length}
        </div>

        {/* Player controls */}
        <div className="karaoke-controls-card">
          <audio
            ref={audioRef}
            src={currentVerse.audioUrl}
            onEnded={handleAudioEnded}
          />

          <button
            className={`repeat-toggle ${repeat3x ? 'active' : ''}`}
            onClick={() => setRepeat3x(!repeat3x)}
          >
            🔄 Boucle 3x {repeat3x ? `(${repeatCount + 1}/3)` : ''}
          </button>

          <div className="main-play-btn" onClick={isPlaying ? handlePause : handlePlay}>
            {isPlaying ? '⏸️' : '▶️'}
          </div>

          <div className="nav-buttons">
            <button
              disabled={currentVerseIndex === 0}
              onClick={() => setCurrentVerseIndex(i => Math.max(0, i - 1))}
            >
              ⏮️ Précédent
            </button>
            <button
              disabled={currentVerseIndex === sura.verses.length - 1}
              onClick={() => setCurrentVerseIndex(i => Math.min(sura.verses.length - 1, i + 1))}
            >
              Suivant ⏭️
            </button>
          </div>
        </div>

        {/* Versets list */}
        <div className="verses-karaoke-list">
          {sura.verses.map((v, i) => {
            const isCurrent = i === currentVerseIndex;
            return (
              <div
                key={i}
                className={`karaoke-verse-card ${isCurrent ? 'active' : ''}`}
                onClick={() => setCurrentVerseIndex(i)}
              >
                <div className="verse-num">Verset {i + 1}</div>
                {(readArabic === 'yes' || readArabic === 'partial') && (
                  <div className="verse-ar">{v.arabic}</div>
                )}
                {(readArabic === 'no' || readArabic === 'partial') && (
                  <div className="verse-trans">{v.transliteration}</div>
                )}
                <div className="verse-fr">{v.translation}</div>
              </div>
            );
          })}
        </div>

        {currentVerseIndex === sura.verses.length - 1 && (
          <button className="btn-finish-karaoke" onClick={onDone}>
            🎉 Validation Récitation (+20 XP) !
          </button>
        )}
      </div>
    </div>
  );
}
