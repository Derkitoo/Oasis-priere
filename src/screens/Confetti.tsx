import './Confetti.css';

const COLORS = ['#F4C24E', '#6FAE54', '#F2884B', '#4EA8DE', '#E06E30', '#8CC76A', '#9B6BDB'];

export default function Confetti({ count = 90 }: { count?: number }) {
  const pieces = Array.from({ length: count });
  return (
    <div className="confetti" aria-hidden="true">
      {pieces.map((_, i) => {
        const size = 7 + Math.random() * 8;
        const style = {
          left: `${Math.random() * 100}%`,
          width: `${size}px`,
          height: `${size * 0.55}px`,
          background: COLORS[i % COLORS.length],
          animationDelay: `${Math.random() * 0.6}s`,
          animationDuration: `${2 + Math.random() * 1.6}s`,
        };
        return <span key={i} className="confetti-piece" style={style} />;
      })}
    </div>
  );
}
