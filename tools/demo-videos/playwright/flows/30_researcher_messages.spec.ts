import { test } from '@playwright/test';
import {
  clickButton,
  fillField,
  loginAsResearcher,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Researcher: Messaging Inbox', async ({ page }) => {
  await loginAsResearcher(page);

  // Navigate to Messages via header
  await clickButton(page, 'Messages');
  await page.waitForURL('**/messages', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  // Browse the inbox
  await page.waitForTimeout(1200);
  await slowScroll(page, 250, 1, 900);

  // Open the first conversation if one exists
  const firstConversation = page.getByRole('button').filter({ hasText: /^(?!New Message|Contacts).+/ }).first();
  if (await firstConversation.isVisible({ timeout: 3000 }).catch(() => false)) {
    await firstConversation.click();
    await page.waitForTimeout(1500);
    await waitForFlutter(page, 1000);
    await slowScroll(page, 200, 1, 800);
  }

  // Show New Message button
  const newMsgBtn = page.getByRole('button', { name: 'New Message' });
  if (await newMsgBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await newMsgBtn.click();
    await page.waitForTimeout(1200);
    await waitForFlutter(page, 1000);

    // Show the new conversation form
    await slowScroll(page, 200, 1, 800);

    // Dismiss it
    const cancelBtn = page.getByRole('button', { name: /cancel|close/i }).first();
    if (await cancelBtn.isVisible({ timeout: 2000 }).catch(() => false)) {
      await cancelBtn.click();
      await page.waitForTimeout(700);
    } else {
      await page.keyboard.press('Escape');
      await page.waitForTimeout(700);
    }
  }

  await waitForFlutter(page, 800);
});
