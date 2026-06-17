export interface UserProfile {
  name: string;
  age: number;
  level: 'debutant' | 'intermediaire' | 'avance';
  xp: number;
  streak: number;
  lastPrayerDate: string;
  completedPrayers: string[];
  masteredPostures: string[];
  memorizedSuras: string[];
  suraStars?: Record<string, number>; // suraId → 0-3 étoiles
  readArabic?: 'yes' | 'partial' | 'no';
}

const KEY = 'oasis_user';

export const loadUser = (): UserProfile | null => {
  try {
    const s = localStorage.getItem(KEY);
    return s ? JSON.parse(s) : null;
  } catch { return null; }
};

export const saveUser = (u: UserProfile) => {
  localStorage.setItem(KEY, JSON.stringify(u));
};

export const createUser = (
  name: string,
  age: number,
  level: UserProfile['level'],
  readArabic: UserProfile['readArabic'] = 'partial'
): UserProfile => ({
  name,
  age,
  level,
  xp: 0,
  streak: 1,
  lastPrayerDate: new Date().toDateString(),
  completedPrayers: [],
  masteredPostures: [],
  memorizedSuras: [],
  readArabic,
});

export const addXP = (user: UserProfile, amount: number): UserProfile => {
  const updated = { ...user, xp: user.xp + amount };
  saveUser(updated);
  return updated;
};

export const completeSuraMode = (
  user: UserProfile,
  suraId: string,
  stars: number,
  xpGain: number
): UserProfile => {
  const current = user.suraStars?.[suraId] ?? 0;
  const updated: UserProfile = {
    ...user,
    xp: user.xp + xpGain,
    suraStars: { ...(user.suraStars ?? {}), [suraId]: Math.max(current, stars) },
  };
  saveUser(updated);
  return updated;
};

export const completePrayer = (user: UserProfile, prayerId: string): UserProfile => {
  const today = new Date().toDateString();
  const streak = user.lastPrayerDate === today ? user.streak : user.streak + 1;
  const updated = {
    ...user,
    xp: user.xp + 50,
    streak,
    lastPrayerDate: today,
    completedPrayers: [...new Set([...user.completedPrayers, `${prayerId}_${today}`])],
  };
  saveUser(updated);
  return updated;
};
