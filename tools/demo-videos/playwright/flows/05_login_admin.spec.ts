import { test } from '@playwright/test';
import {
  waitForFlutter,
  openLoginPage,
  fillField,
  clickButton,
  slowScroll,
  waitForHash,
} from './helpers';

test('How-To: Login as Admin', async ({ page }) => {
  test.setTimeout(120000);
  await openLoginPage(page);

  await fillField(page, 'Email', 'admin@hb.com');
  await fillField(page, 'Password', 'password');
  await clickButton(page, 'Log In');

  await waitForHash(page, '/admin', 20000);
  await waitForFlutter(page, 2500);

  await slowScroll(page, 320, 1, 1000);
  await slowScroll(page, -220, 1, 900);
});
