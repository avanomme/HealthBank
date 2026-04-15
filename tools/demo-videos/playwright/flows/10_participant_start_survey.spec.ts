import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  goToAppRoute,
  loginAsParticipant,
  resetParticipantDemoState,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Participant: Start Survey', async ({ page }) => {
  resetParticipantDemoState();
  await loginAsParticipant(page);

  await clickButton(page, 'To-Do');
  await page.waitForURL('**/participant/tasks', { timeout: 15000 });
  await waitForFlutter(page, 1500);
  await clickButton(page, 'Start Survey');
  await page.waitForURL(/\/participant\/surveys\/\d+$/, { timeout: 15000 });
  await waitForFlutter(page, 1500);

  const yesButton = page.getByRole('button', { name: /^Yes$/i }).first();
  if (await yesButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, yesButton);
    await page.waitForTimeout(900);
  } else {
    const firstRadio = page.getByRole('radio').first();
    if (await firstRadio.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, firstRadio);
      await page.waitForTimeout(900);
    }
  }

  await slowScroll(page, 420, 1, 1100);
  const fatigueButton = page.getByRole('button', { name: /Fatigue/i }).first();
  if (await fatigueButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, fatigueButton);
  }
  await page.waitForTimeout(900);
  await goToAppRoute(page, '/participant/surveys', 1200);
  await page.waitForURL('**/participant/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1200);
});
