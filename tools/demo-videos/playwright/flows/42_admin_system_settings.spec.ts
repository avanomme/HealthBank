import { test } from '@playwright/test';
import {
  goToAppRoute,
  loginAsAdmin,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Admin: System Settings', async ({ page }) => {
  await loginAsAdmin(page);

  await goToAppRoute(page, '/admin/settings', 1500);

  // Show the full settings form
  await page.waitForTimeout(1200);

  // Data Privacy section — show K-Anonymity field
  await slowScroll(page, 250, 1, 1000);

  // Show the Registration Open toggle
  await slowScroll(page, 200, 1, 900);

  // Show Maintenance Mode toggle and message fields
  await slowScroll(page, 300, 1, 1000);

  // Login Security section
  await slowScroll(page, 300, 1, 1000);

  // Hover over Save Changes button
  const saveBtn = page.getByRole('button', { name: 'Save Changes' });
  if (await saveBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await saveBtn.hover();
    await page.waitForTimeout(800);
  }

  await slowScroll(page, -1300, 1, 900);
  await waitForFlutter(page, 800);
});
