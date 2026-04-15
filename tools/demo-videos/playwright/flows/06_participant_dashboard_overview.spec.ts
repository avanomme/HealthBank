import { test } from '@playwright/test';
import {
  loginAsParticipant,
  resetParticipantDemoState,
  slowScroll,
} from './helpers';

test('Participant: Dashboard Overview', async ({ page }) => {
  resetParticipantDemoState();
  await loginAsParticipant(page);

  await page.waitForTimeout(1800);
  await slowScroll(page, 420, 2, 1100);
  await slowScroll(page, -260, 1, 1000);
  await slowScroll(page, 520, 2, 1200);
});
