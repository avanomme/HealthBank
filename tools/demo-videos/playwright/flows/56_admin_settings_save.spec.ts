import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  loginAsAdmin,
  waitForFlutter,
} from './helpers';

test('Admin: Settings Save Behavior', async ({ page }) => {
  await loginAsAdmin(page);
  await clickButton(page, 'Settings');
  await page.waitForURL('**/admin/settings', { timeout: 15000 });
  await waitForFlutter(page, 1200);

  const switches = page.getByRole('switch');
  const count = await switches.count();
  if (count > 0) {
    await clickLocator(page, switches.nth(0));
    await page.waitForTimeout(600);
  }
  if (count > 1) {
    await clickLocator(page, switches.nth(1));
    await page.waitForTimeout(600);
  }

  await clickLocator(page, page.getByRole('button', { name: 'Save Changes' }).last());
  await page.waitForTimeout(1800);

  if (count > 1) {
    await clickLocator(page, switches.nth(1));
    await page.waitForTimeout(600);
  }
  if (count > 0) {
    await clickLocator(page, switches.nth(0));
    await page.waitForTimeout(600);
  }

  await clickLocator(page, page.getByRole('button', { name: 'Save Changes' }).last());
  await page.waitForTimeout(1800);
  await waitForFlutter(page, 800);
});
