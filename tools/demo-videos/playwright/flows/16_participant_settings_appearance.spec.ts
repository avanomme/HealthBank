import { test } from '@playwright/test';
import {
  clickText,
  goToAppRoute,
  loginAsParticipant,
  resetParticipantDemoState,
  slowScroll,
  waitForHash,
  waitForFlutter,
} from './helpers';

test('Participant: Settings Appearance Themes', async ({ page }) => {
  resetParticipantDemoState();
  await loginAsParticipant(page);

  await goToAppRoute(page, '/settings', 1500);
  await waitForHash(page, '/settings');
  await waitForFlutter(page, 1500);

  await clickText(page, 'Modern');
  await page.waitForTimeout(1200);
  await clickText(page, 'Dark');
  await page.waitForTimeout(1200);
  await clickText(page, 'Apply');
  await page.waitForTimeout(2200);
  await slowScroll(page, 220, 1, 900);
});
