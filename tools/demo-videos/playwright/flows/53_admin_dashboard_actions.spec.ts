import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  loginAsAdmin,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Admin: Dashboard Actions And Quick Links', async ({ page }) => {
  await loginAsAdmin(page);

  await page.waitForTimeout(1800);

  const totalUsersCard = page.getByRole('button', { name: /Total Users/i }).first();
  if (await totalUsersCard.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, totalUsersCard);
    await page.waitForURL('**/admin/users', { timeout: 15000 });
    await waitForFlutter(page, 1200);
    await page.goBack();
    await waitForFlutter(page, 1200);
  }

  await slowScroll(page, 620, 1, 1000);

  const quickLinks = [
    'Manage Users',
    'Audit Log',
    'Database Viewer',
    'Account Requests',
    'UI Test Page',
  ];

  for (const linkName of quickLinks) {
    const chip = page.getByRole('button', { name: linkName }).first();
    if (await chip.isVisible({ timeout: 1500 }).catch(() => false)) {
      await clickLocator(page, chip);
      await page.waitForTimeout(1200);
      await waitForFlutter(page, 1000);
      await page.goBack();
      await waitForFlutter(page, 1000);
      await slowScroll(page, 620, 1, 900);
    }
  }

  await clickButton(page, 'HealthBank logo, navigate to dashboard Health Bank');
  await waitForFlutter(page, 800);
});
