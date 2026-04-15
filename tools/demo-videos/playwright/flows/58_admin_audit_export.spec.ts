import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  loginAsAdmin,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Admin: Audit Log Export', async ({ page }) => {
  await loginAsAdmin(page);
  await clickButton(page, 'Audit Log');
  await page.waitForURL('**/admin/logs', { timeout: 15000 });
  await waitForFlutter(page, 1200);

  await slowScroll(page, 220, 1, 800);

  const exportButton = page.getByRole('button', { name: 'Export as CSV' }).first();
  if (await exportButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, exportButton);
    await page.waitForTimeout(1800);
  }

  await waitForFlutter(page, 800);
});
