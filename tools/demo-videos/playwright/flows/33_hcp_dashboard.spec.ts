import { test } from '@playwright/test';
import { loginAsHcp, slowScroll, waitForFlutter } from './helpers';

test('HCP: Dashboard Overview', async ({ page }) => {
  await loginAsHcp(page);

  // Dashboard loads — show the welcome message and stat cards
  await page.waitForTimeout(2000);
  await slowScroll(page, 300, 1, 1100);

  // Scroll back to reveal action buttons (View All / Reports)
  await slowScroll(page, 300, 1, 1000);
  await slowScroll(page, -600, 1, 900);

  await waitForFlutter(page, 800);
});
