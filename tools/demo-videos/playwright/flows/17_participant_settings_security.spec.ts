import { test } from '@playwright/test';
import {
  clickButton,
  goToAppRoute,
  loginAsParticipant,
  resetParticipantDemoState,
  waitForHash,
  waitForFlutter,
} from './helpers';

test('Participant: Settings Security Options', async ({ page }) => {
  resetParticipantDemoState();
  await loginAsParticipant(page);

  await goToAppRoute(page, '/settings', 1500);
  await waitForHash(page, '/settings');
  await waitForFlutter(page, 1500);

  await goToAppRoute(page, '/change-password', 1200);
  await waitForHash(page, '/change-password');
  await waitForFlutter(page, 1200);
  await page.waitForTimeout(1800);

  await goToAppRoute(page, '/settings', 1200);
  await waitForHash(page, '/settings');
  await waitForFlutter(page, 1200);

  const disable2faButton = page.getByRole('button', { name: /Disable 2FA/i }).first();
  if (await disable2faButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await disable2faButton.click();
    await page.waitForTimeout(1000);
    const cancelDisable = page.getByRole('button', { name: /Cancel/i }).first();
    if (await cancelDisable.isVisible({ timeout: 2000 }).catch(() => false)) {
      await cancelDisable.click();
      await page.waitForTimeout(1000);
    }
  }

  const deleteAccountButton = page.getByRole('button', { name: /Delete Account/i }).first();
  if (await deleteAccountButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await deleteAccountButton.click();
    await page.waitForTimeout(1000);
    const cancelDelete = page.getByRole('button', { name: /Cancel/i }).last();
    if (await cancelDelete.isVisible({ timeout: 2000 }).catch(() => false)) {
      await cancelDelete.click();
      await page.waitForTimeout(1200);
    }
  }
});
