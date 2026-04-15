import { test } from '@playwright/test';
import {
  clickText,
  goToAppRoute,
  loginAsAdmin,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Admin: UI Test Page', async ({ page }) => {
  await loginAsAdmin(page);
  await goToAppRoute(page, '/admin/ui-test', 1500);

  await page.waitForTimeout(1200);
  await slowScroll(page, 360, 1, 1000);

  const buttonsSection = page.getByText('Buttons', { exact: true }).first();
  if (await buttonsSection.isVisible({ timeout: 2500 }).catch(() => false)) {
    await clickText(page, 'Buttons');
    await page.waitForTimeout(700);
  }

  await slowScroll(page, 520, 1, 1000);

  const formsSection = page.getByText('Forms and Input', { exact: true }).first();
  if (await formsSection.isVisible({ timeout: 2500 }).catch(() => false)) {
    await clickText(page, 'Forms and Input');
    await page.waitForTimeout(700);
  }

  await slowScroll(page, 760, 1, 1100);

  const dataDisplaySection = page.getByText('Data Display', { exact: true }).first();
  if (await dataDisplaySection.isVisible({ timeout: 2500 }).catch(() => false)) {
    await clickText(page, 'Data Display');
    await page.waitForTimeout(700);
  }

  await slowScroll(page, 820, 1, 1100);
  await slowScroll(page, -1800, 1, 900);

  await waitForFlutter(page, 800);
});
