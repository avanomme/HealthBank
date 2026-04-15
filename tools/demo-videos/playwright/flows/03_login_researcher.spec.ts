import { test } from '@playwright/test';
import {
  completeConsent,
  completeFirstLoginPasswordChange,
  resetAuthDemoState,
  slowScroll,
  waitForFlutter,
  waitForHash,
} from './helpers';

test('How-To: First Login as Researcher', async ({ page }) => {
  test.setTimeout(180000);
  resetAuthDemoState('researcher');
  await completeFirstLoginPasswordChange(
    page,
    'pw.researcher@hb.com',
    'TempPass!Researcher1',
    'NewPass!Researcher1'
  );

  await completeConsent(page, 'Playwright Researcher', '/researcher/dashboard', {
    email: 'pw.researcher@hb.com',
    password: 'NewPass!Researcher1',
  });
  await waitForHash(page, '/researcher/dashboard', 20000);
  await waitForFlutter(page, 2500);

  await slowScroll(page, 320, 1, 1000);
  await slowScroll(page, -220, 1, 900);
});
