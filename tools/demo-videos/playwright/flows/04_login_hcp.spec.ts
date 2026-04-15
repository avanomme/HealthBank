import { test } from '@playwright/test';
import {
  completeConsent,
  completeFirstLoginPasswordChange,
  resetAuthDemoState,
  slowScroll,
  waitForFlutter,
  waitForHash,
} from './helpers';

test('How-To: First Login as Healthcare Provider', async ({ page }) => {
  test.setTimeout(180000);
  resetAuthDemoState('hcp');
  await completeFirstLoginPasswordChange(
    page,
    'pw.hcp@hb.com',
    'TempPass!Hcp1',
    'NewPass!Hcp1'
  );

  await completeConsent(page, 'Playwright HCP', '/hcp/dashboard', {
    email: 'pw.hcp@hb.com',
    password: 'NewPass!Hcp1',
  });
  await waitForHash(page, '/hcp/dashboard', 20000);
  await waitForFlutter(page, 2500);

  await slowScroll(page, 320, 1, 1000);
  await slowScroll(page, -220, 1, 900);
});
