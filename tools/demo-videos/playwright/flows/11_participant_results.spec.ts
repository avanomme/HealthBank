import { test } from '@playwright/test';
import {
  clickLocator,
  loginAsParticipant,
  resetParticipantDemoState,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Participant: Results And Comparison', async ({ page }) => {
  resetParticipantDemoState();
  await loginAsParticipant(page);

  await clickLocator(page, page.getByRole('button', { name: 'Results' }).first());
  await page.waitForURL('**/participant/results', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  await clickLocator(page, page.getByRole('button', { name: /Q1 2026 Health Assessment/ }));
  await page.waitForTimeout(1500);

  const switches = page.getByRole('switch');
  if (await switches.count()) {
    await clickLocator(page, switches.nth(0));
    await page.waitForTimeout(1800);
  }
  if ((await switches.count()) > 1) {
    await clickLocator(page, switches.nth(1));
    await page.waitForTimeout(1800);
  }

  await slowScroll(page, 420, 2, 1100);
});
