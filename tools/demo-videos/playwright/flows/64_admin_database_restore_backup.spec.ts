import { test } from '@playwright/test';
import {
  clickLocator,
  ensureDemoCursor,
  goToAppRoute,
  loginAsAdmin,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Admin: Database — Restore from Backup', async ({ page }) => {
  await loginAsAdmin(page);

  await goToAppRoute(page, '/admin/database', 1500);
  await waitForFlutter(page, 1500);
  await ensureDemoCursor(page);

  // Pause to show the page with Backup panel + Restore section visible
  await page.waitForTimeout(1800);

  // ── Scroll down to the Restore from Backup section ────────────────────────
  // The section sits below the Database Backups dropdown and above the Viewer
  await slowScroll(page, 280, 2, 900);
  await page.waitForTimeout(1200);

  // ── Open the backup selector dropdown ─────────────────────────────────────
  // The restore panel has a "Select Backup" combobox
  const restoreDropdown = page.getByRole('combobox', { name: /Select Backup/i }).first();
  const fallbackDropdown = page.getByRole('combobox').last();
  const dropdown = await restoreDropdown.isVisible({ timeout: 3000 }).catch(() => false)
    ? restoreDropdown
    : fallbackDropdown;

  if (await dropdown.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, dropdown);
    await page.waitForTimeout(1000);

    // Select the first backup in the list
    const firstOption = page.getByRole('option').first();
    if (await firstOption.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, firstOption);
      await page.waitForTimeout(800);
    }
  }

  // ── Restore Database button becomes enabled after selecting a backup ───────
  await page.waitForTimeout(600);
  const restoreButton = page.getByRole('button', { name: /Restore Database/i }).first();
  if (await restoreButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, restoreButton);
    await page.waitForTimeout(1000);

    // ── Warning dialog: shows filename + explains auto-backup ────────────────
    // Pause to let the viewer read the warning
    await page.waitForTimeout(2500);

    // Dismiss with Cancel (so the demo doesn't actually restore data)
    const cancelButton = page.getByRole('button', { name: /Cancel/i }).last();
    if (await cancelButton.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, cancelButton);
      await page.waitForTimeout(1000);
    }
  }

  // ── Scroll down to Database Viewer to confirm it still loads ──────────────
  await slowScroll(page, 400, 2, 900);
  await waitForFlutter(page, 1000);
});
