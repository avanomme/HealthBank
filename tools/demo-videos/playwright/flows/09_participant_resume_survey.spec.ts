import { test } from '@playwright/test';
import {
  clickLocator,
  clickButton,
  loginAsParticipant,
  resetParticipantDemoState,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Participant: Resume Survey', async ({ page }) => {
  resetParticipantDemoState();
  await loginAsParticipant(page);

  await clickButton(page, 'Surveys');
  await page.waitForURL('**/participant/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1500);
  await clickButton(page, 'Resume Survey');
  await page.waitForURL(/\/participant\/surveys\/\d+$/, { timeout: 15000 });
  await waitForFlutter(page, 1500);

  const numericInputs = page.locator('input[data-semantics-role="text-field"], textarea');
  await clickLocator(page, numericInputs.first());
  await page.keyboard.press(process.platform === 'darwin' ? 'Meta+A' : 'Control+A');
  await page.keyboard.press('Backspace');
  await numericInputs.first().pressSequentially('5', { delay: 80 });
  await page.waitForTimeout(700);

  await clickButton(page, 'Monthly');
  await page.waitForTimeout(900);
  await slowScroll(page, 320, 1, 1000);
  await clickButton(page, 'Surveys');
  await page.waitForURL('**/participant/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1500);
});
