import { test } from '@playwright/test';
import {
  clickButton,
  fillField,
  goToAppRoute,
  loginAsParticipant,
  resetParticipantDemoState,
  waitForHash,
  waitForFlutter,
} from './helpers';

test('Participant: Edit Profile Information', async ({ page }) => {
  resetParticipantDemoState();
  await loginAsParticipant(page);

  await goToAppRoute(page, '/profile', 1500);
  await waitForHash(page, '/profile');
  await waitForFlutter(page, 1500);

  await clickButton(page, 'Edit');
  await page.waitForTimeout(1000);

  await fillField(page, 'First Name', 'Participant Demo');
  const genderField = page
    .locator('input:not([type="hidden"]):not([disabled]), textarea:not([disabled])')
    .nth(1);
  if (await genderField.isVisible({ timeout: 1500 }).catch(() => false)) {
    await genderField.click();
    await page.keyboard.press(process.platform === 'darwin' ? 'Meta+A' : 'Control+A');
    await page.keyboard.press('Backspace');
    await genderField.pressSequentially('Male Participant', { delay: 60 });
    await page.waitForTimeout(500);
  }

  const saveButton = page.getByRole('button', { name: /Save changes/i }).first();
  if (await saveButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await saveButton.click();
    await page.waitForTimeout(2400);
  }
});
