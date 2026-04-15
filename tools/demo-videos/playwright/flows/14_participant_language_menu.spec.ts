import { test } from '@playwright/test';
import {
  loginAsParticipant,
  resetParticipantDemoState,
  selectAccountMenuItem,
} from './helpers';

test('Participant: Language Options In Avatar Menu', async ({ page }) => {
  resetParticipantDemoState();
  await loginAsParticipant(page);

  await selectAccountMenuItem(page, 'Français');
  await page.waitForTimeout(2200);

  await selectAccountMenuItem(page, 'English');
  await page.waitForTimeout(2200);
});
