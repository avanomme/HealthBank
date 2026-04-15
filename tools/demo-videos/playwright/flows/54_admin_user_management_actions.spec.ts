import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  loginAsAdmin,
  slowScroll,
  typeIntoPlaceholder,
  fillField,
  waitForFlutter,
} from './helpers';

test('Admin: User Management Actions', async ({ page }) => {
  const suffix = Date.now().toString().slice(-6);
  const email = `pw.user.${suffix}@hb.com`;

  await loginAsAdmin(page);
  await clickButton(page, 'User Management');
  await page.waitForURL('**/admin/users', { timeout: 15000 });
  await waitForFlutter(page, 1200);

  await clickLocator(page, page.getByRole('button', { name: 'Add User' }).first());
  await fillField(page, 'Email', email);
  await fillField(page, 'First Name', 'Playwright');
  await fillField(page, 'Last Name', `Coverage ${suffix}`);

  await clickLocator(page, page.getByRole('button', { name: 'Save' }).last());
  await page.waitForTimeout(2000);
  await waitForFlutter(page, 1200);

  await typeIntoPlaceholder(page, 'Search by name or email...', email);
  await page.waitForTimeout(1200);

  const editButton = page.getByRole('button', { name: 'Edit user' }).first();
  if (await editButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, editButton);
    await fillField(page, 'First Name', 'PW Updated');
    await clickLocator(page, page.getByRole('button', { name: 'Save' }).last());
    await page.waitForTimeout(1800);
  }

  const resetButton = page.getByRole('button', { name: 'Reset Password' }).first();
  if (await resetButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, resetButton);
    const sendEmail = page.getByRole('checkbox', { name: /Send email notification/i }).first();
    if (await sendEmail.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, sendEmail);
      await page.waitForTimeout(500);
    }
    await clickLocator(page, page.getByRole('button', { name: 'Reset Password' }).last());
    await page.waitForTimeout(1800);
  }

  const deactivateButton = page.getByRole('button', { name: 'Deactivate' }).first();
  if (await deactivateButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, deactivateButton);
    await page.waitForTimeout(1200);
  }

  const activateButton = page.getByRole('button', { name: 'Activate' }).first();
  if (await activateButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, activateButton);
    await page.waitForTimeout(1200);
  }

  const deleteButton = page.getByRole('button', { name: 'Delete user' }).first();
  if (await deleteButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, deleteButton);
    const confirmDelete = page.getByRole('button', { name: 'Delete' }).last();
    if (await confirmDelete.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, confirmDelete);
      await page.waitForTimeout(1800);
    }
  }

  await slowScroll(page, 220, 1, 800);
  await waitForFlutter(page, 800);
});
