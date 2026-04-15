import { expect, test } from '@playwright/test';
import {
  clickText,
  goToAppRoute,
  loginAsAdmin,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Admin: Deletion Queue Redirect', async ({ page }) => {
  await loginAsAdmin(page);
  await goToAppRoute(page, '/admin/deletion-queue', 1500);

  await page.waitForTimeout(1800);
  const currentPath = new URL(page.url()).pathname;
  if (!currentPath.endsWith('/admin/messages')) {
    await clickText(page, 'Account Requests');
    await page.waitForURL('**/admin/messages', { timeout: 15000 });
  }

  await waitForFlutter(page, 1200);
  await expect(page).toHaveURL(/\/admin\/messages$/);

  await page.waitForTimeout(1000);
  await clickText(page, 'Deletion Requests');
  await page.waitForTimeout(1000);
  await slowScroll(page, 240, 1, 900);
  await slowScroll(page, -220, 1, 700);

  await waitForFlutter(page, 800);
});
