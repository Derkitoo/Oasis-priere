let _audio: HTMLAudioElement | null = null;

// Joue un fichier audio hébergé (MP3) — pour les versets coraniques
export const playAudio = (url: string) => {
  if (_audio) { _audio.pause(); _audio.currentTime = 0; }
  _audio = new Audio(url);
  _audio.play().catch(() => {});
};

// TTS de secours pour les textes non-coraniques (fonctionne sur Android/iOS)
export const speak = (text: string, lang = 'ar-SA') => {
  if (!('speechSynthesis' in window)) return;
  window.speechSynthesis.cancel();
  const u = new SpeechSynthesisUtterance(text);
  u.lang = lang;
  u.rate = 0.7;
  window.speechSynthesis.speak(u);
};

// Détecte si un texte contient des caractères arabes réels (pas juste des chiffres)
export const hasArabic = (text: string) => /[؀-ۿ]/.test(text);
