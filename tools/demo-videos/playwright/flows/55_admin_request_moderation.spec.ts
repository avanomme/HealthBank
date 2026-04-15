import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  fillField,
  goToAppRoute,
  loginAsAdmin,
  openLoginPage,
  waitForFlutter,
} from './helpers';

async function submitRequest(page: import('@playwright/test').Page, email: string, firstName: string, lastName: string) {
  await openLoginPage(page);
  await clickButton(page, 'New Here? Request An Account');
  await waitForFlutter(page, 1200);
  await fillField(page, 'First Name', firstName);
  await fillField(page, 'Last Name', lastName);
  await fillField(page, 'Email', email);
  await clickLocator(page, page.getByRole('button').nth(3));
  await page.keyboard.press('ArrowDown');
  await page.keyboard.press('Enter');
  await page.waitForTimeout(500);
  await clickButton(page, 'Submit Request');
  await page.waitForTimeout(1500);
}

test('Admin: Account Request Moderation', async ({ page }) => {
  const suffix = Date.now().toString().slice(-6);
  const approveEmail = `pw.approve.${suffix}@hb.com`;
  const rejectEmail = `pw.reject.${suffix}@hb.com`;

  await submitRequest(page, approveEmail, 'Approve', `Request ${suffix}`);
  await submitRequest(page, rejectEmail, 'Reject', `Request ${suffix}`);

  await loginAsAdmin(page);
  await goToAppRoute(page, '/admin/messages', 1500);

  const approveButton = page.getByRole('button', { name: 'Approve' }).first();
  if (await approveButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, approveButton);
    const confirmApprove = page.getByRole('button', { name: 'Approve' }).last();
    if (await confirmApprove.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, confirmApprove);
      await page.waitForTimeout(1800);
    }
  }

  const rejectButton = page.getByRole('button', { name: 'Reject' }).first();
  if (await rejectButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, rejectButton);
    await clickLocator(page, page.getByRole('button', { name: 'Reject' }).last());
    await page.waitForTimeout(1800);
  }

  await waitForFlutter(page, 800);
});
