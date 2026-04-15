import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  clickText,
  loginAsAdmin,
  waitForFlutter,
  slowScroll,
} from './helpers';

test('Admin: View As (Impersonate User)', async ({ page }) => {
  await loginAsAdmin(page);

  // The "View As" control lives in the admin header/sidebar
  // Look for a "View As" button or dropdown
  const viewAsBtn = page.getByRole('button', { name: /view as/i }).first();
  if (await viewAsBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await viewAsBtn.click();
    await page.waitForTimeout(1000);
  } else {
    // Try the label text
    const viewAsLabel = page.getByText('View As', { exact: false }).first();
    if (await viewAsLabel.isVisible({ timeout: 4000 }).catch(() => false)) {
      await clickLocator(page, viewAsLabel);
      await page.waitForTimeout(1000);
    }
  }

  await waitForFlutter(page, 800);

  // Select a participant from the dropdown
  const dropdown = page.getByRole('combobox').first();
  if (await dropdown.isVisible({ timeout: 4000 }).catch(() => false)) {
    await dropdown.click();
    await page.waitForTimeout(700);
    // Choose first option (a participant)
    const firstOption = page.getByRole('option').first();
    if (await firstOption.isVisible({ timeout: 3000 }).catch(() => false)) {
      await firstOption.click();
      await page.waitForTimeout(1500);
    }
  } else {
    // Try clicking any "Participant" user name visible on dashboard
    const participantLink = page.getByText('Participant', { exact: false }).first();
    if (await participantLink.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, participantLink);
      await page.waitForTimeout(1500);
    }
  }

  await waitForFlutter(page, 1500);

  // We are now viewing as participant — show their dashboard
  await page.waitForTimeout(1800);
  await slowScroll(page, 300, 1, 1000);

  // Return to admin using "Back to Admin" button
  const backBtn = page.getByRole('button', { name: /back to admin/i }).first();
  if (await backBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
    await backBtn.click();
    await page.waitForURL('**/admin**', { timeout: 15000 });
    await waitForFlutter(page, 1500);
  }

  await waitForFlutter(page, 800);
});
