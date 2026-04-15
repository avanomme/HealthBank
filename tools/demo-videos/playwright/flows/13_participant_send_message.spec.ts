import { test } from '@playwright/test';
import {
  clickLocator,
  loginAsParticipant,
  resetParticipantDemoState,
  waitForHash,
  waitForFlutter,
} from './helpers';

test('Participant: Send A Message', async ({ page }) => {
  resetParticipantDemoState();
  await loginAsParticipant(page);

  await clickLocator(page, page.getByRole('button', { name: 'Messages' }).first());
  await waitForHash(page, '/messages');
  await waitForFlutter(page, 1500);

  const hcpThread = page.getByRole('button', { name: /HCP User/i }).first();
  if (await hcpThread.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, hcpThread);
  } else {
    await clickLocator(page, page.getByText('HCP User').first());
  }
  await page.waitForTimeout(1200);

  const composer = page.getByRole('textbox', { name: /Type a message/i }).first();
  await composer.click();
  await composer.fill('Hello, I just wanted to confirm I completed my latest survey.');
  await page.waitForTimeout(500);

  const sendButton = page.getByRole('button', { name: /^Send(?:\s+Send)?$/i }).first();
  if (await sendButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, sendButton);
  }
  await page.waitForTimeout(2200);
});
