import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  loginAsResearcher,
  slowScroll,
  typeIntoPlaceholder,
  waitForFlutter,
} from './helpers';

test('Shared: Messaging Direct Conversation Route', async ({ page }) => {
  await loginAsResearcher(page);
  await clickButton(page, 'Messages');
  await page.waitForURL('**/messages', { timeout: 15000 });
  await waitForFlutter(page, 1200);
  await clickButton(page, 'New Message');

  await page.waitForTimeout(1200);

  const recipientOption = page.getByRole('button', { name: /open conversation with/i }).first();
  if (await recipientOption.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, recipientOption);
  } else {
    await typeIntoPlaceholder(
      page,
      'Enter email address to start a conversation',
      'part@hb.com'
    );
    await clickButton(page, 'New Message');
  }

  await waitForFlutter(page, 1200);

  await page.waitForTimeout(900);
  await slowScroll(page, 180, 1, 800);
  await typeIntoPlaceholder(page, 'Type a message...', 'Playwright direct conversation route demo message.');
  await clickButton(page, 'Send');
  await page.waitForTimeout(1200);

  await slowScroll(page, -180, 1, 700);
  await waitForFlutter(page, 800);
});
