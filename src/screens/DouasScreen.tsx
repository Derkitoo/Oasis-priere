import { useState } from 'react';
import { DOUAS } from '../data/douas';
import './DouasScreen.css';

interface Props {
  onBack: () => void;
}

export default function DouasScreen({ onBack }: Props) {
  const [selectedCategory, setSelectedCategory] = useState<string>('all');

  const filtered = selectedCategory === 'all'
    ? DOUAS
    : DOUAS.filter(d => d.category === selectedCategory);

  return (
    <div className="douas-screen">
      <div className="douas-header">
        <button className="btn-back" onClick={onBack}>←</button>
        <h2>Invocations (Douas) 🤲</h2>
        <span style={{ width: 36 }} />
      </div>

      <div className="douas-body">
        <div className="douas-filter-chips">
          {([
            { id: 'all', label: 'Toutes 🌟' },
            { id: 'matin', label: 'Matin 🌅' },
            { id: 'repas', label: 'Repas 🍎' },
            { id: 'sommeil', label: 'Nuit 🌙' },
            { id: 'savoir', label: 'Études 📚' },
          ] as const).map(c => (
            <button
              key={c.id}
              className={`chip ${selectedCategory === c.id ? 'active' : ''}`}
              onClick={() => setSelectedCategory(c.id)}
            >
              {c.label}
            </button>
          ))}
        </div>

        <div className="douas-list">
          {filtered.map(d => (
            <div key={d.id} className="doua-card">
              <div className="doua-title">{d.title}</div>
              <div className="doua-arabic">{d.arabic}</div>
              <div className="doua-trans">{d.transliteration}</div>
              <div className="doua-translation">{d.translation}</div>
              <div className="doua-benefit">💡 {d.benefit}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
