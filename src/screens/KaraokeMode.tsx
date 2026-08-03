import { useState, useEffect, useRef } from 'react';
import type { Sura } from '../data/suras';
import { RealSpeechRecognizer, compareRecitation } from '../utils/speechRecognition';
import type { SpeechComparisonResult } from '../utils/speechRecognition';
import './KaraokeMode.css';

interface Props {
  sura: Sura;
  readArabic: 'yes' | 'partial' | 'no';
  onDone: () => void;
  onBack: () => void;
}

export default function KaraokeMode({ sura, readArabic, onDone, onBack }: Props) {
  const [tab, setTab] = useState<'listen' | 'mic'>('listen');
  const [currentVerseIndex, setCurrentVerseIndex] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [repeat3x, setRepeat3x] = useState(false);
  const [repeatCount, setRepeatCount] = useState(0);

  // Reconnaissance Vocale Réelle (ASR) State
  const [isListening, setIsListening] = useState(false);
  const [liveTranscript, setLiveTranscript] = useState('');
  const [comparisonResult, setComparisonResult] = useState<SpeechComparisonResult | null>(null);
  const [asrError, setAsrError] = useState<string | null>(null);
  const [validatedVerses, setValidatedVerses] = useState<Record<number, boolean>>({});

  const audioRef = useRef<HTMLAudioElement | null>(null);
  const recognizerRef = useRef<RealSpeechRecognizer | null>(null);

  const currentVerse = sura.verses[currentVerseIndex];

  useEffect(() => {
    recognizerRef.current = new RealSpeechRecognizer();
    return () => {
      if (recognizerRef.current) recognizerRef.current.stop();
    };
  }, []);

  useEffect(() => {
    setRepeatCount(0);
    setIsPlaying(false);
    setLiveTranscript('');
    setComparisonResult(null);
    setAsrError(null);
    if (recognizerRef.current) recognizerRef.current.stop();
    setIsListening(false);
  }, [currentVerseIndex, tab]);

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

  // Démarrer la vraie reconnaissance vocale arabe
  const startRealMic = () => {
    if (!recognizerRef.current || !recognizerRef.current.isSupported) {
      setAsrError("Le micro n'est pas disponible sur ce navigateur. Utilise Chrome ou Edge.");
      return;
    }

    setAsrError(null);
    setLiveTranscript('');
    setComparisonResult(null);
    setIsListening(true);

    recognizerRef.current.start(
      (transcript, isFinal) => {
        setLiveTranscript(transcript);
        const result = compareRecitation(transcript, currentVerse.arabic);
        setComparisonResult(result);

        if (result.status === 'excellent') {
          setValidatedVerses(prev => ({ ...prev, [currentVerseIndex]: true }));
        }

        if (isFinal) {
          setIsListening(false);
        }
      },
      (err) => {
        setAsrError(`Erreur du micro : ${err}`);
        setIsListening(false);
      },
      () => {
        setIsListening(false);
      }
    );
  };

  const stopRealMic = () => {
    if (recognizerRef.current) {
      recognizerRef.current.stop();
    }
    setIsListening(false);
  };

  const allVersesValidated = sura.verses.every((_, idx) => validatedVerses[idx]);

  return (
    <div className="karaoke">
      <div className="karaoke-topbar">
        <button className="karaoke-back" onClick={onBack}>←</button>
        <div className="karaoke-title">{sura.name} — {tab === 'listen' ? 'Écoute 🎵' : 'Vraie Récitation 🎤'}</div>
        <span style={{ width: 36 }} />
      </div>

      <div className="karaoke-body">
        {/* Mode Tabs */}
        <div className="karaoke-mode-tabs">
          <button className={`tab-btn ${tab === 'listen' ? 'active' : ''}`} onClick={() => setTab('listen')}>
            🎵 Écoute & Boucle 3x
          </button>
          <button className={`tab-btn ${tab === 'mic' ? 'active' : ''}`} onClick={() => setTab('mic')}>
            🎤 Vraie Récitation Vocale
          </button>
        </div>

        <div className="karaoke-progress-bar">
          Verset {currentVerseIndex + 1} sur {sura.verses.length}
        </div>

        {tab === 'listen' ? (
          <>
            {/* Player controls */}
            <div className="karaoke-controls-card">
              <audio ref={audioRef} src={currentVerse.audioUrl} onEnded={handleAudioEnded} />

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
          </>
        ) : (
          /* Real Speech Recitation Correction Engine */
          <div className="mic-challenge-card">
            <div className="mic-header-row">
              <h3>Vraie Évaluation Vocale 🗣️</h3>
              <div className="mic-badge-engine">Moteur d'Écoute Arabe ASR</div>
            </div>

            <p className="mic-sub">
              Lis le verset à voix haute en arabe. Notre système vérifie mot par mot en temps réel !
            </p>

            <div className="mic-target-verse">
              <div className="verse-num-badge">Verset {currentVerseIndex + 1} / {sura.verses.length}</div>
              
              {/* Affichage des mots du verset avec coloration en temps réel */}
              <div className="m-ar-breakdown">
                {currentVerse.arabic.split(' ').map((word, idx) => {
                  const isMatched = comparisonResult?.matchedWords?.[idx];
                  const hasResult = comparisonResult !== null;
                  let wordClass = 'word-neutral';
                  if (hasResult) {
                    wordClass = isMatched ? 'word-correct' : 'word-incorrect';
                  }
                  return (
                    <span key={idx} className={`arabic-word-chip ${wordClass}`}>
                      {word}
                    </span>
                  );
                })}
              </div>

              <div className="m-trans">{currentVerse.transliteration}</div>
              <div className="m-fr">{currentVerse.translation}</div>
            </div>

            {/* Action Micro Réel */}
            <div className="mic-button-wrap">
              {!isListening ? (
                <button className="mic-record-btn" onClick={startRealMic}>
                  🎙️ Commencer la Récitation
                </button>
              ) : (
                <button className="mic-record-btn recording" onClick={stopRealMic}>
                  ⏹️ Arrêter l'Écoute
                </button>
              )}
            </div>

            {/* Animation Onde Vocale */}
            {isListening && (
              <div className="real-mic-status">
                <div className="recording-wave">
                  <span /><span /><span /><span /><span />
                </div>
                <div className="recording-text">Écoute active en arabe... Parle clairement devant ton micro.</div>
              </div>
            )}

            {/* Erreur navigateur */}
            {asrError && (
              <div className="asr-error-box">
                ⚠️ {asrError}
              </div>
            )}

            {/* Transcription en direct */}
            {liveTranscript && (
              <div className="live-transcript-box">
                <div className="transcript-label">Paroles captées par le micro :</div>
                <div className="transcript-text" dir="rtl">{liveTranscript}</div>
              </div>
            )}

            {/* Résultat d'évaluation réelle */}
            {comparisonResult && (
              <div className={`mic-result-card status-${comparisonResult.status}`}>
                <div className="result-top-row">
                  <span className="result-icon">
                    {comparisonResult.status === 'excellent' ? '✅' : comparisonResult.status === 'partial' ? '⚠️' : '❌'}
                  </span>
                  <span className="result-accuracy">Précision : {comparisonResult.accuracy}%</span>
                </div>
                <div className="result-feedback">{comparisonResult.feedback}</div>

                {comparisonResult.status === 'excellent' && (
                  <div className="result-valid-badge">
                    🎉 Verset {currentVerseIndex + 1} validé avec succès !
                  </div>
                )}
              </div>
            )}

            {/* Navigation des versets */}
            <div className="mic-nav-row">
              <button
                disabled={currentVerseIndex === 0}
                onClick={() => setCurrentVerseIndex(i => Math.max(0, i - 1))}
              >
                ⏮️ Verset Précédent
              </button>
              <button
                disabled={currentVerseIndex === sura.verses.length - 1}
                onClick={() => setCurrentVerseIndex(i => Math.min(sura.verses.length - 1, i + 1))}
              >
                Verset Suivant ⏭️
              </button>
            </div>
          </div>
        )}

        {(tab === 'listen' || allVersesValidated || Object.keys(validatedVerses).length >= Math.ceil(sura.verses.length / 2)) && (
          <button className="btn-finish-karaoke" onClick={onDone}>
            🎉 Valider la Récitation (+30 XP) !
          </button>
        )}
      </div>
    </div>
  );
}
