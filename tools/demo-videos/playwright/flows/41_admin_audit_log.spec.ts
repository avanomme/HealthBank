import { test } from '@playwright/test';
import {
  clickButton,
  fillField,
  loginAsAdmin,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Admin: Audit Log', async ({ page }) => {
  await loginAsAdmin(page);

  // Navigate to Audit Log
  await clickButton(page, 'Audit Log');
  await page.waitForURL('**/admin/logs', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  // Browse the log entries
  await page.waitForTimeout(1500);
  await slowScroll(page, 350, 2, 1100);

  // Expand the first row to show full details
  const firstRow = page.getByRole('row').nth(1);
  if (await firstRow.isVisible({ timeout: 3000 }).catch(() => false)) {
    await firstRow.click();
    await page.waitForTimeout(1500);
    await slowScroll(page, 200, 1, 900);
    // Collapse it
    await firstRow.click();
    await page.waitForTimeout(800);
  }

  // Search the audit log
  await fillField(page, 'Search', 'login');
  await page.waitForTimeout(1500);
  await slowScroll(page, 200, 1, 800);

  // Clear search
  await fillField(page, 'Search', '');
  await page.waitForTimeout(800);

  // Hover over Export as CSV button
  const exportBtn = page.getByRole('button', { name: /export/i }).first();
  if (await exportBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await exportBtn.hover();
    await page.waitForTimeout(700);
  }

  await slowScroll(page, -400, 1, 800);
  await waitForFlutter(page, 800);
});
