import { test } from '@playwright/test';
import {
  waitForFlutter,
  openLoginPage,
  fillField,
  clickButton,
  clickLocator,
  resetAuthDemoState,
} from './helpers';

test('How-To: Request an Account', async ({ page }) => {
  test.setTimeout(180000);
  resetAuthDemoState('request');
  await openLoginPage(page);

  // Click "New Here? Request An Account"
  await clickButton(page, 'New Here? Request An Account');
  await waitForFlutter(page, 1500);

  // Fill form
  await fillField(page, 'First Name', 'Playwright');
  await fillField(page, 'Last Name', 'Request');
  await fillField(page, 'Email', 'pw.request@hb.com');

  // Role dropdown
  await clickLocator(page, page.getByRole('button').nth(3));
  await page.waitForTimeout(800);
  await page.keyboard.press('ArrowDown');
  await page.waitForTimeout(400);
  await page.keyboard.press('Enter');
  await page.waitForTimeout(800);

  // Submit
  await clickButton(page, 'Submit Request');
  await page.waitForTimeout(3000);
});
