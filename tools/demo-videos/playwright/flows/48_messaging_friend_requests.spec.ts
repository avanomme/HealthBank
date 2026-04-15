import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  loginAsResearcher,
  slowScroll,
  typeIntoPlaceholder,
  waitForFlutter,
} from './helpers';

test('Shared: Messaging Friend Requests', async ({ page }) => {
  await loginAsResearcher(page);
  await clickButton(page, 'Messages');
  await page.waitForURL('**/messages', { timeout: 15000 });
  await waitForFlutter(page, 1200);
  await clickButton(page, 'Contact Requests');

  await page.waitForTimeout(1200);
  await slowScroll(page, 220, 1, 900);

  await slowScroll(page, 260, 1, 900);

  await typeIntoPlaceholder(page, 'contact@example.com', 'pw.contact@hb.com');
  await clickButton(page, 'Send Contact Request');
  await page.waitForTimeout(1200);

  const contactRequestsHeading = page.getByText('Contact Requests', { exact: true }).first();
  if (await contactRequestsHeading.isVisible({ timeout: 3000 }).catch(() => false)) {
    await slowScroll(page, 220, 1, 900);

    const acceptButton = page.getByRole('button', { name: 'Accept' }).first();
    if (await acceptButton.isVisible({ timeout: 2500 }).catch(() => false)) {
      await clickLocator(page, acceptButton);
      await page.waitForTimeout(700);
    }

    const declineButton = page.getByRole('button', { name: 'Reject' }).first();
    if (await declineButton.isVisible({ timeout: 2500 }).catch(() => false)) {
      await clickLocator(page, declineButton);
      await page.waitForTimeout(700);
    }
  }

  await waitForFlutter(page, 800);
});
