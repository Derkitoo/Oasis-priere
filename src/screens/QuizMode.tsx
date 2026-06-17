import { useState, useMemo } from 'react';
import type { Sura } from '../data/suras';
import { SURAS } from '../data/suras';
import type { UserProfile } from '../store';

interface Props {
  sura: Sura;
  readArabic: UserProfile['readArabic'];
  onDone: (score: number, total: number) => void;
  onBack: () => void;
}

// 'ar_to_fr'  : montre arabe   → choisir traduction FR  (arabophone)
// 'tr_to_fr'  : montre translit → choisir traduction FR  (francophone)
// 'fr_to_tr'  : montre FR      → choisir translittération (francophone)
type QType = 'ar_to_fr' | 'tr_to_fr' | 'fr_to_tr';

interface Question {
  verseIdx: number;
  type: QType;
  prompt: string;    // ce qu'on montre
  options: string[]; // 3 choix
  correctIdx: number;
}

function shuffle<T>(arr: T[]): T[] {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

function buildQuestions(sura: Sura, readArabic: UserProfile['readArabic']): Question[] {
  const allVerses = SURAS.flatMap(s => s.verses);
  const otherVerses = allVerses.filter(v => !sura.verses.some(sv => sv.arabic === v.arabic));

  const indices = shuffle([...Array(sura.verses.length).keys()]).slice(0, Math.min(5, sura.verses.length));
  const isFranco = readArabic === 'no';

  return indices.map((vIdx, i) => {
    const verse = sura.verses[vIdx];

    // Francophones alternent tr_to_fr et fr_to_tr
    const type: QType = isFranco
      ? (i % 2 === 0 ? 'tr_to_fr' : 'fr_to_tr')
      : 'ar_to_fr';

    if (type === 'ar_to_fr') {
      const wrongs = shuffle(otherVerses.map(v => v.translation)).slice(0, 2);
      const options = shuffle([verse.translation, ...wrongs]);
      return { verseIdx: vIdx, type, prompt: verse.arabic, options, correctIdx: options.indexOf(verse.translation) };
    }
    if (type === 'tr_to_fr') {
      const wrongs = shuffle(otherVerses.map(v => v.translation)).slice(0, 2);
      const options = shuffle([verse.translation, ...wrongs]);
      return { verseIdx: vIdx, type, prompt: verse.transliteration, options, correctIdx: options.indexOf(verse.translation) };
    }
    // fr_to_tr
    const wrongs = shuffle(otherVerses.map(v => v.transliteration)).slice(0, 2);
    const options = shuffle([verse.transliteration, ...wrongs]);
    return { verseIdx: vIdx, type, prompt: verse.translation, options, correctIdx: options.indexOf(verse.transliteration) };
  });
}

const XP_BY_SCORE  = [10, 10, 20, 20, 30];
const STAR_BY_SCORE = [1,  1,  2,  2,  2];

const QUESTION_LABEL: Record<QType, string> = {
  ar_to_fr: 'Que signifie ce verset ?',
  tr_to_fr: 'Que signifie cette formule ?',
  fr_to_tr: 'Comment se prononce ce verset ?',
};

export default function QuizMode({ sura, readArabic, onDone, onBack }: Props) {
  const questions = useMemo(() => buildQuestions(sura, readArabic), [sura, readArabic]);
  const [qIdx, setQIdx] = useState(0);
  const [chosen, setChosen] = useState<number | null>(null);
  const [score, setScore] = useState(0);
  const [done, setDone] = useState(false);

  const q = questions[qIdx];
  const total = questions.length;
  const verse = sura.verses[q.verseIdx];

  const handleAnswer = (i: number) => {
    if (chosen !== null) return;
    setChosen(i);
    if (i === q.correctIdx) setScore(s => s + 1);
  };

  const handleNext = () => {
    if (qIdx < total - 1) { setQIdx(i => i + 1); setChosen(null); }
    else setDone(true);
  };

  if (done) {
    const xp    = XP_BY_SCORE[score]   ?? 10;
    const stars = STAR_BY_SCORE[score] ?? 1;
    const emoji = score === total ? '🌟' : score >= 3 ? '⭐' : '📚';
    const msg   = score === total ? 'Parfait !' : score >= 3 ? 'Très bien !' : "Continue à t'entraîner !";
    return (
      <div className="mode-done">
        <div className="mode-done-emoji">{emoji}</div>
        <h2>{msg}</h2>
        <div className="quiz-final-score">{score}<span>/{total}</span></div>
        <div className="mode-done-xp">+{xp} XP · {stars} étoile{stars > 1 ? 's' : ''} débloquée{stars > 1 ? 's' : ''}</div>
        <button className="btn-gold" onClick={() => onDone(score, total)}>Continuer</button>
      </div>
    );
  }

  // Prompt styling: arabe = direction rtl, translit/fr = normal
  const promptIsArabic = q.type === 'ar_to_fr';
  const promptIsFr     = q.type === 'fr_to_tr';

  return (
    <div className="mode-wrap">
      <div className="mode-topbar">
        <button className="mode-back" onClick={onBack}>←</button>
        <div className="mode-title">❓ Quiz · {sura.name}</div>
        <span className="mode-count">{qIdx + 1}/{total}</span>
      </div>
      <div className="mode-progress">
        <div className="mode-fill" style={{ width: `${(qIdx + 1) / total * 100}%` }} />
      </div>

      <div className="quiz-body">
        <p className="quiz-question">{QUESTION_LABEL[q.type]}</p>

        {/* Prompt principal */}
        {promptIsArabic && <div className="quiz-arabic">{q.prompt}</div>}
        {promptIsFr     && <div className="quiz-prompt-fr">{q.prompt}</div>}
        {!promptIsArabic && !promptIsFr && <div className="quiz-translit-prompt">{q.prompt}</div>}

        {/* Aide contextuelle : francophone voit toujours l'arabe en petit */}
        {readArabic === 'no' && q.type !== 'ar_to_fr' && (
          <div className="quiz-arabic-hint">{verse.arabic}</div>
        )}
        {/* Arabophone : rappel translittération sous l'arabe */}
        {readArabic === 'yes' && (
          <div className="quiz-translit-hint">{verse.transliteration}</div>
        )}

        <div className="quiz-options">
          {q.options.map((opt, i) => {
            let cls = 'quiz-opt';
            if (chosen !== null) {
              if (i === q.correctIdx) cls += ' opt-correct';
              else if (i === chosen)  cls += ' opt-wrong';
              else                    cls += ' opt-dim';
            }
            return (
              <button key={i} className={cls} onClick={() => handleAnswer(i)}>
                <span className="opt-letter">{['A', 'B', 'C'][i]}</span>
                <span className="opt-text">{opt}</span>
              </button>
            );
          })}
        </div>

        {chosen !== null && (
          <div className={`quiz-feedback ${chosen === q.correctIdx ? 'fb-ok' : 'fb-ko'}`}>
            {chosen === q.correctIdx ? '✅ Exact !' : `❌ C'était : ${q.options[q.correctIdx]}`}
          </div>
        )}
        {chosen !== null && (
          <button className="mode-next-btn" onClick={handleNext}>
            {qIdx < total - 1 ? 'Question suivante →' : 'Voir les résultats'}
          </button>
        )}
      </div>
    </div>
  );
}
