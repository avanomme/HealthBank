/**
 * Researcher: Assign a published survey to ALL participants.
 *
 * Flow:
 *   Surveys → filter Published → View Survey Status →
 *   click Assign → modal opens → target = All Participants →
 *   optionally set a due date → Assign Now → see result summary
 */
import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  goToAppRoute,
  loginAsResearcher,
  selectDropdownOption,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Researcher: Assign Survey — All Participants', async ({ page }) => {
  await loginAsResearcher(page);

  await goToAppRoute(page, '/surveys', 1500);
  await page.waitForURL('**/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  const clearAll = page.getByRole('button', { name: 'Clear All' }).first();
  if (await clearAll.isVisible({ timeout: 2000 }).catch(() => false)) {
    await clearAll.click();
    await page.waitForTimeout(800);
  }

  await selectDropdownOption(page, page.getByRole('button', { name: /Status/ }).first(), 2);
  await page.waitForTimeout(1200);

  const surveyCard = page.getByRole('button', { name: /Published .* questions/i }).first();
  await clickLocator(page, surveyCard);
  await page.waitForTimeout(1500);
  await waitForFlutter(page, 1800);

  // Show the analytics already on the page
  await slowScroll(page, 250, 1, 900);
  await slowScroll(page, -250, 1, 700);

  // Open Assign modal
  await clickButton(page, 'Assign');
  await page.waitForTimeout(1500);
  await waitForFlutter(page, 1000);

  // ── Assign modal ───────────────────────────────────────────────────────
  // "All Participants" is the default target — highlight it
  const allParticipants = page.getByText('All Participants', { exact: false }).first();
  if (await allParticipants.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, allParticipants);
    await page.waitForTimeout(700);
  }

  // Scroll to show current assignments list and due date field
  await slowScroll(page, 250, 1, 900);

  // Click Assign Now
  await clickButton(page, 'Assign Now');
  await page.waitForTimeout(2500);

  await waitForFlutter(page, 1000);

  // Show the updated assignment analytics
  await slowScroll(page, -400, 1, 800);
  await page.waitForTimeout(1200);
  await slowScroll(page, 300, 1, 900);
});
