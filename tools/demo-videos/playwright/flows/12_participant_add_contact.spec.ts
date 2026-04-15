import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  loginAsParticipant,
  resetParticipantDemoState,
  waitForHash,
  waitForFlutter,
} from './helpers';

test('Participant: Add A Contact', async ({ page }) => {
  resetParticipantDemoState();
  await loginAsParticipant(page);

  await clickLocator(page, page.getByRole('button', { name: 'Messages' }).first());
  await waitForHash(page, '/messages');
  await waitForFlutter(page, 1500);

  await clickButton(page, 'Contact Requests');
  await waitForFlutter(page, 1200);

  await clickButton(page, 'Accept');
  await page.waitForTimeout(2200);
});
