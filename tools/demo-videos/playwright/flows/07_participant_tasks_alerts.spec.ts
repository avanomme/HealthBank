import { test } from '@playwright/test';
import {
  clickButton,
  loginAsParticipant,
  resetParticipantDemoState,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Participant: Tasks And Alerts', async ({ page }) => {
  resetParticipantDemoState();
  await loginAsParticipant(page);

  await clickButton(page, 'To-Do');
  await page.waitForURL('**/participant/tasks', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  await page.waitForTimeout(1200);
  await clickButton(page, 'Accept');
  await page.waitForTimeout(1800);
  await slowScroll(page, 380, 2, 1000);
  await slowScroll(page, -220, 1, 900);
});
