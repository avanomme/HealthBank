import { test } from '@playwright/test';
import {
  goToAppRoute,
  loginAsAdmin,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Admin: User Management', async ({ page }) => {
  await loginAsAdmin(page);

  await goToAppRoute(page, '/admin/users', 1500);

  // Browse the full user table
  await page.waitForTimeout(1200);
  await slowScroll(page, 300, 2, 1000);
  await slowScroll(page, 250, 1, 900);
  await slowScroll(page, -550, 1, 800);

  // Hover over Add User button
  const addBtn = page.getByRole('button', { name: 'Add User' });
  if (await addBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await addBtn.hover();
    await page.waitForTimeout(700);
  }

  await waitForFlutter(page, 800);
});
