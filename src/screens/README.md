# Intégration — redesign complet (mélange A + B + C)

Style : doux/crème (A) + bandeaux & badges (B) + parcours (C).
Police : **Baloo 2** (titres) + **Quicksand** (texte).

## Corrections récentes ✅
- **Badge de sourate** : le nom arabe tient maintenant dans la pastille → re-copie `Learning.css`.
- **Fond noir des postures (Ruku / I'tidâl)** : images détourées en transparent.
  1. Copie `postures-corrigees/ruku_0.png` et `ruku_2.png` dans `public/postures/`.
  2. Remplace l'extension dans **2 fichiers** :
     - `src/data/prayers.ts` : `ruku_0.jpg` → `ruku_0.png` et `ruku_2.jpg` → `ruku_2.png`
     - `src/screens/Learning.tsx` : `ruku_0.jpg` → `ruku_0.png` et `ruku_2.jpg` → `ruku_2.png`

  (Je ne peux pas redessiner ces illustrations stock, mais le fond noir est nettoyé
  et le cadrage amélioré. Pour de nouvelles illustrations, il faudrait les fournir.)

## Nouveautés : animations & vie ✨
Quatre ajouts (1 = transitions, 2 = récompenses, 3 = mascotte-coach, 4 = compteurs animés) :

- **Transitions entre écrans** — chaque écran apparaît en fondu/glissé.
  → Nouveau fichier `transitions.css` dans `src/screens/`, + il est importé dans `App.tsx` (ligne `import './screens/transitions.css';`).
- **Récompenses (confettis + mascotte)** — sur chaque écran de fin (prière, wudu, flash, quiz, ordre).
  → Nouveaux fichiers `Confetti.tsx` + `Confetti.css` dans `src/screens/`.
- **Mascotte-coach** — un petit guide qui encourage pendant la prière et le wudu (bulle qui change selon la progression).
- **Compteurs animés** — l'XP monte en douceur et la barre de niveau se remplit à l'ouverture du Dashboard.

Fichiers **modifiés** par ces ajouts (à re-copier) :
`App.tsx`, `Dashboard.tsx`, `GuidedPrayer.tsx` + `.css`, `WuduGuide.tsx` + `.css`,
`FlashMode.tsx`, `QuizMode.tsx`, `OrderMode.tsx`.
Fichiers **nouveaux** : `Confetti.tsx`, `Confetti.css`, `transitions.css`.

> Tout respecte « réduire les animations » (accessibilité) : si l'appareil le demande, les effets se désactivent.

## 1. Ajouter les polices (à faire une seule fois)
Dans `oasis-priere/index.html`, dans le `<head>` :

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Baloo+2:wght@500;600;700;800&family=Quicksand:wght@400;500;600;700&display=swap" rel="stylesheet" />

## 2. Copier les fichiers dans `oasis-priere/src/screens/` (écraser les anciens)

| Fichier livré            | Destination                          | Ce qui change |
|--------------------------|--------------------------------------|---------------|
| `Dashboard.tsx` + `.css` | `src/screens/Dashboard.tsx` / `.css` | accueil redessiné |
| `GuidedPrayer.css`       | `src/screens/GuidedPrayer.css`       | **CSS seul** (logique intacte) |
| `WuduGuide.css`          | `src/screens/WuduGuide.css`          | **CSS seul** (logique intacte) |
| `Learning.css`           | `src/screens/Learning.css`           | **CSS seul** (logique intacte) |
| `Profile.tsx` + `.css`   | `src/screens/Profile.tsx` / `.css`   | + grille de badges réels |
| `Onboarding.tsx` + `.css`| `src/screens/Onboarding.tsx` / `.css`| + mascotte sur l'accueil |

Aucune prop ni logique modifiée : XP, streak, navigation, getCurrentPrayer,
completeSuraMode, etc. fonctionnent exactement comme avant. Les fichiers `.css`
qui remplacent l'ancien ne touchent pas au `.tsx` correspondant.

## 3. Mascotte & images
Tout utilise tes images existantes de `public/postures/` et `public/wudu/`,
chargées via `import.meta.env.BASE_URL` comme dans ton code d'origine. Rien à copier.

## Barre de navigation du bas 🧭 (nouveau)
Ton code d'origine n'avait pas de barre partagée. J'ai ajouté un composant
`BottomNav` branché dans `App.tsx`. Il apparaît sur **Accueil / Apprendre / Profil**
(masqué pendant la prière et le wudu, qui sont des parcours plein écran).

À copier :
- `BottomNav.tsx` + `BottomNav.css`  →  `src/screens/`
- `App.tsx`                          →  `src/App.tsx` (remplace l'ancien)

Et re-copie ces 3 CSS (j'y ai ajouté l'espace bas pour ne pas masquer le contenu
sous la barre) : `Dashboard.css`, `Learning.css`, `Profile.css`.

> Si tu as personnalisé ton `App.tsx`, ajoute simplement : l'import de `BottomNav`
> et `getCurrentPrayer`, la constante `showNav`, et le bloc `{showNav && <BottomNav … />}`.

## Mini-jeux (Flash / Quiz / Ordre) — inclus ✅
Ces 3 composants n'importent aucun CSS : leurs styles vivaient dans l'ancien
`Learning.css`. Le **nouveau `Learning.css`** contient maintenant le menu
Apprentissage **+ les 3 mini-jeux restylés**. Aucun `.tsx` de mini-jeu à toucher.

> ⚠️ Si tu as déjà intégré la version précédente : il suffit de **re-copier
> `Learning.css`** (c'est le seul fichier qui change pour les mini-jeux).
