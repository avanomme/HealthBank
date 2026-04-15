import { test } from '@playwright/test';
import {
  clickButton,
  clickText,
  loginAsAdmin,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Admin: Account Requests & Deletion Requests', async ({ page }) => {
  await loginAsAdmin(page);

  // Navigate to Account Requests
  await clickButton(page, 'Account Requests');
  await page.waitForURL('**/admin/messages', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  // New Account Requests tab is default — browse it
  await page.waitForTimeout(1200);
  await slowScroll(page, 300, 1, 1000);

  // If there are pending requests, show the Approve/Reject buttons
  const approveBtn = page.getByRole('button', { name: 'Approve' }).first();
  if (await approveBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await approveBtn.hover();
    await page.waitForTimeout(800);
    const rejectBtn = page.getByRole('button', { name: 'Reject' }).first();
    if (await rejectBtn.isVisible({ timeout: 2000 }).catch(() => false)) {
      await rejectBtn.hover();
      await page.waitForTimeout(700);
    }
  }

  // Switch to Deletion Requests tab
  await clickText(page, 'Deletion Requests');
  await page.waitForTimeout(1200);
  await waitForFlutter(page, 1000);
  await slowScroll(page, 200, 1, 900);

  // Switch back to New Account Requests tab
  await clickText(page, 'New Account Requests');
  await page.waitForTimeout(1000);

  await waitForFlutter(page, 800);
});
