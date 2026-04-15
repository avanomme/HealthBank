import { test } from '@playwright/test';
import {
  clickLocator,
  fillField,
  goToAppRoute,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Shared: Auth Support Pages', async ({ page }) => {
  // Forgot password request flow.
  await goToAppRoute(page, '/forgot-password');
  await fillField(page, 'Email', 'pw.participant@hb.com');
  await page.keyboard.press('Enter');
  await page.waitForTimeout(1600);

  // Reset password invalid-link state.
  await goToAppRoute(page, '/reset-password');
  await page.waitForTimeout(1200);

  // Reset password form state with a placeholder token.
  await goToAppRoute(page, '/reset-password?token=demo-reset-token');
  const resetInputs = page.locator('input');
  await clickLocator(page, resetInputs.nth(0));
  await page.keyboard.type('password123', { delay: 60 });
  await page.waitForTimeout(300);
  await clickLocator(page, resetInputs.nth(1));
  await page.keyboard.type('password123', { delay: 60 });
  await page.waitForTimeout(1000);

  // Two-factor support page.
  await goToAppRoute(page, '/two-factor?returnTo=/researcher/dashboard');
  await page.waitForTimeout(1200);
  await slowScroll(page, 180, 1, 800);
  await slowScroll(page, -180, 1, 700);

  // Logout confirmation page.
  await goToAppRoute(page, '/logout');
  await page.waitForTimeout(1800);

  // Deactivated account notice page.
  await goToAppRoute(page, '/deactivated-notice');
  await page.waitForTimeout(1200);

  await waitForFlutter(page, 800);
});
