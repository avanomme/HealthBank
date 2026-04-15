import { test } from '@playwright/test';
import {
  goToAppRoute,
  loginAsAdmin,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Admin: Database Viewer & Backups', async ({ page }) => {
  await loginAsAdmin(page);

  await goToAppRoute(page, '/admin/database', 1500);

  // Show the backup panel at the top
  await page.waitForTimeout(1500);
  await slowScroll(page, 250, 1, 1000);

  // Hover over Trigger Manual Backup (without clicking to avoid accidental backup)
  const backupBtn = page.getByRole('button', { name: /backup/i }).first();
  if (await backupBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await backupBtn.hover();
    await page.waitForTimeout(800);
  }

  // Scroll to existing backups list
  await slowScroll(page, 300, 1, 1000);

  // Scroll to the database tables section
  await slowScroll(page, 400, 2, 1100);

  // Expand the first table accordion to show its data
  const firstTable = page.getByRole('button').filter({ hasText: /Account|User|Survey/i }).first();
  if (await firstTable.isVisible({ timeout: 4000 }).catch(() => false)) {
    await firstTable.click();
    await page.waitForTimeout(1500);
    await waitForFlutter(page, 1000);
    await slowScroll(page, 300, 1, 1000);
    // Collapse it
    await firstTable.click();
    await page.waitForTimeout(800);
  }

  await slowScroll(page, -800, 1, 900);
  await waitForFlutter(page, 800);
});
