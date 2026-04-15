import { expect, test } from '@playwright/test';
import {
  clickLocator,
  loginAsParticipant,
  resetParticipantDemoState,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Participant: Results Toggle Behavior', async ({ page }) => {
  resetParticipantDemoState();
  await loginAsParticipant(page);

  await clickLocator(page, page.getByRole('button', { name: 'Results' }).first());
  await page.waitForURL('**/participant/results', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  await clickLocator(page, page.getByRole('button', { name: /Q1 2026 Health Assessment/ }).first());
  await page.waitForTimeout(1500);

  const switches = page.getByRole('switch');
  await expect(switches).toHaveCount(2);
  await expect(switches.nth(0)).not.toBeChecked();
  await expect(switches.nth(1)).not.toBeChecked();

  // Turning comparison on should only affect the comparison toggle.
  await clickLocator(page, switches.nth(1));
  await page.waitForTimeout(1200);
  await expect(switches.nth(1)).toBeChecked();
  await expect(switches.nth(0)).not.toBeChecked();

  // Turning charts on should re-enable comparison.
  await clickLocator(page, switches.nth(0));
  await page.waitForTimeout(1800);
  await expect(switches.nth(0)).toBeChecked();
  await expect(switches.nth(1)).toBeChecked();

  await slowScroll(page, 420, 1, 1100);
  await slowScroll(page, -260, 1, 900);
  await waitForFlutter(page, 800);
});
