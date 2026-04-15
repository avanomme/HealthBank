import { test } from '@playwright/test';
import { loginAsAdmin, slowScroll, waitForFlutter } from './helpers';

test('Admin: Dashboard Overview', async ({ page }) => {
  await loginAsAdmin(page);

  // Let the dashboard load fully — KPI cards, alerts, charts
  await page.waitForTimeout(2200);

  // Scroll down through KPI cards and role distribution chart
  await slowScroll(page, 400, 2, 1200);

  // Show recent activity and pending account requests sections
  await slowScroll(page, 400, 2, 1100);

  // Show Quick Links section
  await slowScroll(page, 300, 1, 1000);

  // Scroll back to top
  await slowScroll(page, -1100, 1, 900);

  await waitForFlutter(page, 800);
});
