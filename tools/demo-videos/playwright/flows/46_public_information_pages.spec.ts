import { test } from '@playwright/test';
import {
  goToAppRoute,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Shared: Public Information Pages', async ({ page }) => {
  await goToAppRoute(page, '/');

  // Show the public home page.
  await page.waitForTimeout(1200);
  await slowScroll(page, 220, 1, 900);
  await slowScroll(page, -220, 1, 700);

  // About page.
  await goToAppRoute(page, '/about');
  await page.waitForTimeout(900);
  await slowScroll(page, 260, 1, 900);

  // Contact page.
  await goToAppRoute(page, '/contact');
  await page.waitForTimeout(900);
  await slowScroll(page, 260, 1, 900);

  // Help / FAQ page.
  await goToAppRoute(page, '/help');
  await page.waitForTimeout(900);
  await slowScroll(page, 200, 1, 900);

  // Privacy Policy.
  await goToAppRoute(page, '/privacy-policy');
  await page.waitForTimeout(900);
  await slowScroll(page, 420, 1, 1000);

  // Terms of Service.
  await goToAppRoute(page, '/terms-of-service');
  await page.waitForTimeout(900);
  await slowScroll(page, 420, 1, 1000);
  await slowScroll(page, -420, 1, 700);

  await waitForFlutter(page, 800);
});
