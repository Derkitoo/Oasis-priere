// Web Speech Recognition & Normalisation Arabe Réelle

export interface SpeechComparisonResult {
  accuracy: number; // 0 à 100%
  transcript: string;
  normalizedTranscript: string;
  normalizedExpected: string;
  matchedWords: boolean[]; // par mot du verset attendu
  status: 'excellent' | 'partial' | 'wrong';
  feedback: string;
}

// Supprime les diacritiques (Tashkeel) et normalise l'arabe
export const normalizeArabic = (text: string): string => {
  return text
    .replace(/[\u064B-\u065F\u0670]/g, '') // Enlève Fatha, Damma, Kasra, Sukun, Tanween, Shadda
    .replace(/[أإآ]/g, 'ا')                 // Unifie Alif
    .replace(/ة/g, 'ه')                      // Unifie Ta Marbuta
    .replace(/ى/g, 'ي')                      // Unifie Alif Maqsura
    .replace(/[^\u0621-\u064A\s]/g, '')     // Garde uniquement lettres arabes et espaces
    .trim()
    .replace(/\s+/g, ' ');
};

// Compare la récitation vocale réelle avec le verset coranique attendu
export const compareRecitation = (
  spokenTranscript: string,
  expectedVerseArabic: string
): SpeechComparisonResult => {
  const normSpoken = normalizeArabic(spokenTranscript);
  const normExpected = normalizeArabic(expectedVerseArabic);

  if (!normSpoken) {
    return {
      accuracy: 0,
      transcript: spokenTranscript,
      normalizedTranscript: '',
      normalizedExpected: normExpected,
      matchedWords: normExpected.split(' ').map(() => false),
      status: 'wrong',
      feedback: 'Aucune parole arabe détectée. Parle bien en face du micro !',
    };
  }

  const expectedWords = normExpected.split(' ');
  const spokenWords = normSpoken.split(' ');

  let matchCount = 0;
  const matchedWords = expectedWords.map((word) => {
    // Vérifier si le mot attendu est présent dans les mots prononcés (tolérance de position)
    const isMatched = spokenWords.some((sw) => {
      if (sw === word) return true;
      // Tolérance pour les légères erreurs de prononciation / phonème (Levenshtein 1)
      if (Math.abs(sw.length - word.length) <= 1 && sw.length > 2) {
        let diffs = 0;
        for (let i = 0; i < Math.min(sw.length, word.length); i++) {
          if (sw[i] !== word[i]) diffs++;
        }
        return diffs <= 1;
      }
      return false;
    });

    if (isMatched) matchCount++;
    return isMatched;
  });

  const accuracy = Math.round((matchCount / expectedWords.length) * 100);

  let status: 'excellent' | 'partial' | 'wrong' = 'wrong';
  let feedback = '';

  if (accuracy >= 75) {
    status = 'excellent';
    feedback = '✨ Récitation exacte et impressionnante ! Bravo !';
  } else if (accuracy >= 45) {
    status = 'partial';
    feedback = '⚠️ Récitation partielle. Certains mots sont manquants ou mal prononcés.';
  } else {
    status = 'wrong';
    feedback = '❌ Récitation incorrecte. Ce n\'est pas la récitation de cette sourate. Réécoute l\'audio et réessaie !';
  }

  return {
    accuracy,
    transcript: spokenTranscript,
    normalizedTranscript: normSpoken,
    normalizedExpected: normExpected,
    matchedWords,
    status,
    feedback,
  };
};

// Interface Web Speech Recognition
export class RealSpeechRecognizer {
  private recognition: any = null;
  public isSupported: boolean = false;

  constructor() {
    const SpeechRecognition =
      (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;
    if (SpeechRecognition) {
      this.isSupported = true;
      this.recognition = new SpeechRecognition();
      this.recognition.continuous = false;
      this.recognition.interimResults = true;
      this.recognition.lang = 'ar-SA'; // Langue arabe
    }
  }

  public start(
    onResult: (transcript: string, isFinal: boolean) => void,
    onError: (err: string) => void,
    onEnd: () => void
  ) {
    if (!this.isSupported || !this.recognition) {
      onError('Reconnaissance vocale non supportée sur ce navigateur.');
      return;
    }

    this.recognition.onresult = (event: any) => {
      let transcript = '';
      let isFinal = false;
      for (let i = event.resultIndex; i < event.results.length; i++) {
        transcript += event.results[i][0].transcript;
        if (event.results[i].isFinal) isFinal = true;
      }
      onResult(transcript, isFinal);
    };

    this.recognition.onerror = (event: any) => {
      onError(event.error || 'Erreur de micro');
    };

    this.recognition.onend = () => {
      onEnd();
    };

    try {
      this.recognition.start();
    } catch (e) {
      onError('Impossible de démarrer le micro');
    }
  }

  public stop() {
    if (this.recognition) {
      try {
        this.recognition.stop();
      } catch (_) {}
    }
  }
}
