export interface Doua {
  id: string;
  title: string;
  category: 'matin' | 'soir' | 'repas' | 'sommeil' | 'savoir';
  arabic: string;
  transliteration: string;
  translation: string;
  benefit: string;
}

export const DOUAS: Doua[] = [
  {
    id: 'waking_up',
    title: 'Au réveil',
    category: 'matin',
    arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
    transliteration: 'Al-ḥamdu lillāhi llaḏī aḥyānā baʿda mā amātanā wa-ilayhi n-nušūr',
    translation: 'Louange à Allah qui nous a rendu la vie après nous avoir fait mourir, et c\'est vers Lui qu\'est le retour.',
    benefit: 'À dire en ouvrant les yeux le matin pour remercier Allah du souffle de la vie.',
  },
  {
    id: 'before_eating',
    title: 'Avant de manger',
    category: 'repas',
    arabic: 'بِسْمِ اللَّهِ',
    transliteration: 'Bismillāh',
    translation: 'Au nom d\'Allah.',
    benefit: 'Attire la bénédiction dans ton repas et éloigne les mauvaises pensées.',
  },
  {
    id: 'after_eating',
    title: 'Après le repas',
    category: 'repas',
    arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
    transliteration: 'Al-ḥamdu lillāhi llaḏī aṭʿamanā wa-saqānā wa-jaʿalanā muslimīn',
    translation: 'Louange à Allah qui nous a nourris, nous a abreuvés et a fait de nous des musulmans.',
    benefit: 'Remercie Allah pour la nourriture et la boisson reçues.',
  },
  {
    id: 'before_sleeping',
    title: 'Avant de dormir',
    category: 'sommeil',
    arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    transliteration: 'Bismika-llāhumma amūtu wa-aḥyā',
    translation: 'En Ton nom, ô Allah, je meurs et je vis.',
    benefit: 'Place ton sommeil sous la protection d\'Allah pour passer une nuit paisible.',
  },
  {
    id: 'knowledge',
    title: 'Pour réussir ses études',
    category: 'savoir',
    arabic: 'رَبِّ زِدْنِي عِلْمًا',
    transliteration: 'Rabbi zidnī ʿilmā',
    translation: 'Ô mon Seigneur, augmente mes connaissances et ma sagesse !',
    benefit: 'Invocation du Prophète pour demander la mémoire et l\'intelligence.',
  },
];
