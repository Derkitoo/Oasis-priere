import { useState } from 'react';
import { SURAS } from '../data/suras';
import type { Sura } from '../data/suras';
import type { UserProfile } from '../store';
import { completeSuraMode } from '../store';
import FlashMode from './FlashMode';
import QuizMode from './QuizMode';
import OrderMode from './OrderMode';
import './Learning.css';

interface Props {
  user: UserProfile;
  onUser: (u: UserProfile) => void;
  onBack: () => void;
}

type Mode = 'flash' | 'quiz' | 'order';

function StarRow({ count }: { count: number }) {
  return (
    <div className="star-row">
      {[1, 2, 3].map(n => (
        <span key={n} className={`star ${n <= count ? 'star-lit' : 'star-dim'}`}>★</span>
      ))}
    </div>
  );
}

export default function Learning({ user, onUser, onBack }: Props) {
  const [activeSura, setActiveSura] = useState<Sura | null>(null);
  const [mode, setMode] = useState<Mode | null>(null);

  const launch = (sura: Sura, m: Mode) => { setActiveSura(sura); setMode(m); };
  const backToMenu = () => { setActiveSura(null); setMode(null); };

  const handleFlashDone = () => {
    const updated = completeSuraMode(user, activeSura!.id, 1, 10);
    onUser(updated); backToMenu();
  };

  const handleQuizDone = (score: number, total: number) => {
    const stars = score >= total ? 2 : score >= Math.ceil(total * 0.6) ? 2 : 1;
    const xp = score === total ? 30 : score >= Math.ceil(total * 0.6) ? 20 : 10;
    const updated = completeSuraMode(user, activeSura!.id, stars, xp);
    onUser(updated); backToMenu();
  };

  const handleOrderDone = (errors: number) => {
    const stars = errors === 0 ? 3 : errors <= 1 ? 2 : 1;
    const xp = errors === 0 ? 40 : errors <= 1 ? 20 : 10;
    const updated = completeSuraMode(user, activeSura!.id, stars, xp);
    onUser(updated); backToMenu();
  };

  const ra = user.readArabic ?? 'partial';

  if (activeSura && mode === 'flash') return <FlashMode sura={activeSura} readArabic={ra} onDone={handleFlashDone} onBack={backToMenu} />;
  if (activeSura && mode === 'quiz')  return <QuizMode  sura={activeSura} readArabic={ra} onDone={handleQuizDone}  onBack={backToMenu} />;
  if (activeSura && mode === 'order') return <OrderMode  sura={activeSura} readArabic={ra} onDone={handleOrderDone} onBack={backToMenu} />;

  // ── Menu ──────────────────────────────────────────────────────────
  return (
    <div className="learn">
      <div className="learn-topbar">
        <button className="learn-back" onClick={onBack}>←</button>
        <div className="learn-title">Apprentissage</div>
        <span />
      </div>

      <div className="learn-body">
        <h3 className="section-title">📖 Sourates</h3>
        <div className="sura-list">
          {SURAS.map(sura => {
            const stars = user.suraStars?.[sura.id] ?? 0;
            return (
              <div key={sura.id} className="sura-block">
                <div className="sura-block-header">
                  <div className="sura-arabic-sm">{sura.arabicName}</div>
                  <div className="sura-block-info">
                    <div className="sura-name">{sura.name}</div>
                    <div className="sura-count">{sura.verses.length} versets</div>
                  </div>
                  <StarRow count={stars} />
                </div>
                <div className="sura-modes">
                  <button className={`mode-btn mode-flash ${stars >= 1 ? 'mode-done' : ''}`} onClick={() => launch(sura, 'flash')}>
                    ⚡ Flash
                  </button>
                  <button className={`mode-btn mode-quiz ${stars >= 2 ? 'mode-done' : ''}`} onClick={() => launch(sura, 'quiz')}>
                    ❓ Quiz
                  </button>
                  <button className={`mode-btn mode-order ${stars >= 3 ? 'mode-done' : ''}`} onClick={() => launch(sura, 'order')}>
                    🔢 Ordre
                  </button>
                </div>
              </div>
            );
          })}
        </div>

        <h3 className="section-title" style={{ marginTop: 32 }}>🕌 Postures de prière</h3>
        <div className="posture-list">
          {[
            { id: 'takbir',          img: 'takbir_3.png',  label: 'Takbîrat al-Ihrâm',      desc: 'Debout, bras levés aux épaules — « Allâhou Akbar »' },
            { id: 'qiyam',           img: 'takbir_4.png',  label: 'Qiyam (Debout)',          desc: 'Main droite sur main gauche, au-dessus de la poitrine' },
            { id: 'ruku',            img: 'ruku_0.jpg',    label: "Ruku' (Inclinaison)",     desc: "Incliné, mains sur les genoux, dos droit — × 3" },
            { id: 'itidal',          img: 'ruku_2.jpg',    label: "I'tidâl (Redressement)",  desc: "Debout après le ruku' — « Sami'aLlâhou liman Hamidah »" },
            { id: 'sujud',           img: 'sujud_0.png',   label: 'Soujoud (Prosternation)', desc: '7 parties sur le sol — × 3' },
            { id: 'julus',           img: 'sujud_2.png',   label: 'Joulous (Assis)',         desc: 'Entre les deux prosternations — « Rabbighfir lî » × 3' },
            { id: 'tashahhud',       img: 'tashahhud_3.png', label: 'Tachahhoud',            desc: 'Assis, index levé vers la Qibla' },
            { id: 'tashahhud_final', img: 'sujud_2.png',   label: 'Tawarruk (final)',        desc: 'Jambe gauche sortie à droite — + Salât Ibrahimiyya' },
            { id: 'taslim_r',        img: 'taslim_1.png',  label: 'Salâm à droite',          desc: "« Assalêmou 'alaykum warahmatuLlah »" },
            { id: 'taslim_l',        img: 'taslim_2.png',  label: 'Salâm à gauche',          desc: "« Assalêmou 'alaykum warahmatuLlah » — terminé !" },
          ].map(p => (
            <div key={p.id} className="posture-card">
              <div className="posture-img-wrap">
                <img src={`/postures/${p.img}`} alt={p.label} className="posture-img" />
              </div>
              <div className="posture-info">
                <div className="posture-name">{p.label}</div>
                <div className="posture-desc">{p.desc}</div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
