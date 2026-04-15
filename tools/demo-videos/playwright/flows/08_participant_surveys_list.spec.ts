import { test } from '@playwright/test';
import {
  clickButton,
  loginAsParticipant,
  resetParticipantDemoState,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Participant: Surveys List', async ({ page }) => {
  resetParticipantDemoState();
  await loginAsParticipant(page);

  await clickButton(page, 'Surveys');
  await page.waitForURL('**/participant/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  await page.waitForTimeout(1200);
  await slowScroll(page, 260, 1, 900);
  await clickButton(page, 'Resume Survey');
  await page.waitForTimeout(2200);
  await clickButton(page, 'Back to surveys');
  await page.waitForURL('**/participant/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1200);
  await clickButton(page, 'Start Survey');
  await page.waitForTimeout(2200);
});
