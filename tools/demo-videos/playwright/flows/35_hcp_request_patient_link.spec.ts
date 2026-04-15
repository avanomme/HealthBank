import { test } from '@playwright/test';
import {
  clickButton,
  fillField,
  loginAsHcp,
  waitForFlutter,
} from './helpers';

test('HCP: Request Patient Link', async ({ page }) => {
  await loginAsHcp(page);

  // Navigate to My Patients
  await clickButton(page, 'Clients');
  await page.waitForURL('**/hcp/clients', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  // Open the Request Patient Link dialog
  await clickButton(page, 'Request Patient Link');
  await page.waitForTimeout(1200);
  await waitForFlutter(page, 800);

  // Fill in the patient email address
  await fillField(page, 'Patient email address', 'john.smith@email.com');
  await page.waitForTimeout(800);

  // Show the filled form — pause for the viewer
  await page.waitForTimeout(1500);

  // Cancel (so we don't actually send a duplicate request in demos)
  const cancelBtn = page.getByRole('button', { name: /cancel/i }).first();
  if (await cancelBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await cancelBtn.click();
    await page.waitForTimeout(700);
  } else {
    await page.keyboard.press('Escape');
    await page.waitForTimeout(700);
  }

  await waitForFlutter(page, 800);
});
