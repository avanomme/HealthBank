import { test } from '@playwright/test';
import {
  clickLocator,
  goToAppRoute,
  loginAsAdmin,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Admin: Database Backup Lifecycle', async ({ page }) => {
  await loginAsAdmin(page);
  await goToAppRoute(page, '/admin/database', 1500);

  // ── Create a manual backup ─────────────────────────────────────────────────
  const createBackup = page.getByRole('button', { name: 'Create Backup Now' }).first();
  if (await createBackup.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, createBackup);
    await page.waitForTimeout(3000);
  }

  // ── Download the first available backup ───────────────────────────────────
  const downloadButton = page.getByRole('button', { name: 'Download backup file' }).first();
  if (await downloadButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, downloadButton);
    await page.waitForTimeout(1500);
  }

  // ── Delete the manual backup ──────────────────────────────────────────────
  const deleteButton = page.getByRole('button', { name: 'Delete this backup' }).first();
  if (await deleteButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, deleteButton);
    const confirmDelete = page.getByRole('button', { name: 'Delete' }).last();
    if (await confirmDelete.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, confirmDelete);
      await page.waitForTimeout(1800);
    }
  }

  // ── Restore from Backup section ────────────────────────────────────────────
  // Scroll down to the Restore from Backup panel (between Utilities and Viewer)
  await slowScroll(page, 300, 2, 900);
  await waitForFlutter(page, 800);

  // Open the backup selector dropdown
  const restoreDropdown = page.getByRole('combobox').last();
  if (await restoreDropdown.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, restoreDropdown);
    await page.waitForTimeout(1000);

    // Select the first option available
    const firstOption = page.getByRole('option').first();
    if (await firstOption.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, firstOption);
      await page.waitForTimeout(800);
    }
  }

  // Click the Restore Database button (visible once a backup is selected)
  const restoreButton = page.getByRole('button', { name: 'Restore Database' }).first();
  if (await restoreButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, restoreButton);
    await page.waitForTimeout(800);

    // Dismiss the confirmation dialog — Cancel so we don't actually restore in demo
    const cancelButton = page.getByRole('button', { name: 'Cancel' }).last();
    if (await cancelButton.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, cancelButton);
      await page.waitForTimeout(800);
    }
  }

  await slowScroll(page, 400, 1, 900);
  await waitForFlutter(page, 800);
});
