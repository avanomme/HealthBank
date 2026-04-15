import { test } from '@playwright/test';
import {
  clickButton,
  loginAsAdmin,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Admin: Page Navigator Hub', async ({ page }) => {
  await loginAsAdmin(page);

  // Navigate to Page Navigator
  await clickButton(page, 'Page Navigator');
  await page.waitForURL('**/admin/nav-hub', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  // Show the navigator — scroll through all role groups
  await page.waitForTimeout(1200);

  // Admin group
  await slowScroll(page, 280, 1, 1000);

  // Participant group
  await slowScroll(page, 280, 1, 1000);

  // Researcher group
  await slowScroll(page, 280, 1, 1000);

  // HCP group
  await slowScroll(page, 280, 1, 1000);

  // Shared + Public/Auth groups
  await slowScroll(page, 280, 1, 1000);

  // Scroll back to top
  await slowScroll(page, -1400, 1, 900);

  await waitForFlutter(page, 800);
});
