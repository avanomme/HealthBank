/**
 * Researcher: Survey Status page — view analytics, manage lifecycle.
 *
 * Flow:
 *   Surveys → Published → View Survey Status →
 *   see stat cards (Assigned Total, Pending, Completed, Expired) →
 *   see Assignment Status Breakdown pie chart →
 *   optionally show Close Survey action
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

test('Researcher: Survey Status — Analytics & Lifecycle', async ({ page }) => {
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
  await waitForFlutter(page, 2000);

  // ── Survey summary card ────────────────────────────────────────────────
  await page.waitForTimeout(1500);

  // ── Action buttons row ─────────────────────────────────────────────────
  // Show Edit, Assign, Close buttons
  const editBtn = page.getByRole('button', { name: 'Edit' });
  if (await editBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await editBtn.hover();
    await page.waitForTimeout(600);
  }
  const assignBtn = page.getByRole('button', { name: 'Assign' });
  if (await assignBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await assignBtn.hover();
    await page.waitForTimeout(600);
  }

  // ── Assignment Analytics section ───────────────────────────────────────
  await slowScroll(page, 300, 1, 1000);

  // Show the 4 stat cards: Assigned Total, Pending, Completed, Expired
  await page.waitForTimeout(1200);
  await slowScroll(page, 200, 1, 900);

  // Show the Assignment Status Breakdown pie chart
  await slowScroll(page, 300, 1, 1100);

  // Scroll back to top
  await slowScroll(page, -800, 1, 900);

  // ── Demonstrate Close Survey (without confirming) ──────────────────────
  const closeBtn = page.getByRole('button', { name: 'Close' });
  if (await closeBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await closeBtn.click();
    await page.waitForTimeout(1200);
    // Cancel the confirmation dialog to avoid accidentally closing
    const cancelBtn = page.getByRole('button', { name: 'Cancel' });
    if (await cancelBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
      await cancelBtn.click();
      await page.waitForTimeout(700);
    }
  }

  await waitForFlutter(page, 800);
});
