import { test } from '@playwright/test';
import {
  completeConsent,
  completeFirstLoginPasswordChange,
  completeParticipantProfile,
  resetAuthDemoState,
  slowScroll,
  waitForFlutter,
  waitForHash,
} from './helpers';

test('How-To: First Login as Participant', async ({ page }) => {
  test.setTimeout(180000);
  resetAuthDemoState('participant');
  await completeFirstLoginPasswordChange(
    page,
    'pw.participant@hb.com',
    'TempPass!Participant1',
    'NewPass!Participant1'
  );

  await completeParticipantProfile(page);
  await completeConsent(page, 'Playwright Participant', '/participant/dashboard', {
    email: 'pw.participant@hb.com',
    password: 'NewPass!Participant1',
  });
  await waitForHash(page, '/participant/dashboard', 20000);
  await waitForFlutter(page, 2000);

  await slowScroll(page, 380, 1, 1000);
  await slowScroll(page, -260, 1, 1000);
});
