import { useState } from 'react';
import { loadUser, saveUser } from './store';
import type { UserProfile } from './store';
import Onboarding from './screens/Onboarding';
import Dashboard from './screens/Dashboard';
import GuidedPrayer from './screens/GuidedPrayer';
import WuduGuide from './screens/WuduGuide';
import Learning from './screens/Learning';
import Profile from './screens/Profile';

type Screen = 'dashboard' | 'prayer' | 'wudu' | 'learning' | 'profile';

export default function App() {
  const [user, setUser] = useState<UserProfile | null>(loadUser);
  const [screen, setScreen] = useState<Screen>('dashboard');
  const [prayerId, setPrayerId] = useState('fajr');

  if (!user) return <Onboarding onDone={setUser} />;

  const handlePray = (id: string) => { setPrayerId(id); setScreen('prayer'); };
  const handleUser = (u: UserProfile) => { setUser(u); saveUser(u); };
  const handleReset = () => { localStorage.clear(); setUser(null); };

  return (
    <>
      {screen === 'dashboard' && (
        <Dashboard
          user={user}
          onUser={handleUser}
          onPray={handlePray}
          onWudu={() => setScreen('wudu')}
          onLearn={() => setScreen('learning')}
          onProfile={() => setScreen('profile')}
        />
      )}
      {screen === 'prayer' && (
        <GuidedPrayer
          prayerId={prayerId}
          user={user}
          onUser={handleUser}
          onBack={() => setScreen('dashboard')}
        />
      )}
      {screen === 'wudu' && (
        <WuduGuide user={user} onUser={handleUser} onBack={() => setScreen('dashboard')} />
      )}
      {screen === 'learning' && (
        <Learning user={user} onUser={handleUser} onBack={() => setScreen('dashboard')} />
      )}
      {screen === 'profile' && (
        <Profile
          user={user}
          onBack={() => setScreen('dashboard')}
          onReset={handleReset}
        />
      )}
    </>
  );
}
