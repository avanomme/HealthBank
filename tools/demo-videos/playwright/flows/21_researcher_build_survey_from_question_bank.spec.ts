/**
 * Researcher: Build a survey by importing questions from the Question Bank.
 *
 * Flow:
 *   Surveys → New Survey → fill title →
 *   "Add Questions" menu → "Import from Question Bank" →
 *   search/select questions in the dialog → add selected →
 *   review added questions → save as draft
 */
import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  goToAppRoute,
  loginAsResearcher,
  waitForFlutter,
} from './helpers';

test('Researcher: Build Survey From Question Bank', async ({ page }) => {
  await loginAsResearcher(page);

  await goToAppRoute(page, '/surveys', 1500);
  await page.waitForURL('**/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1200);

  await clickButton(page, 'New Survey');
  await waitForFlutter(page, 1500);

  // ── Title ──────────────────────────────────────────────────────────────
  const titleField = page.getByRole('textbox').nth(0);
  await clickLocator(page, titleField);
  await titleField.pressSequentially('Lifestyle & Wellness Survey', { delay: 40 });
  await page.waitForTimeout(300);

  // ── Open the Add Questions popup menu ──────────────────────────────────
  const addQuestionsBtn = page.getByRole('button', { name: /Add Questions/ }).first();
  await clickLocator(page, addQuestionsBtn);
  await page.waitForTimeout(800);

  // Choose "Import from Question Bank"
  await clickLocator(page, page.getByRole('menuitem', { name: 'Import from Question Bank' }).first());
  await page.waitForTimeout(1500);
  await waitForFlutter(page, 1000);

  // ── Question Bank import dialog ────────────────────────────────────────
  // Search for questions
  const searchField = page.getByRole('textbox').last();
  await clickLocator(page, searchField);
  await searchField.pressSequentially('health', { delay: 35 });
  await page.waitForTimeout(1200);

  // Select the first 3 available questions
  const checkboxes = page.getByRole('checkbox');
  const count = await checkboxes.count();
  for (let i = 0; i < Math.min(count, 3); i++) {
    const cb = checkboxes.nth(i);
    if (await cb.isVisible({ timeout: 2000 }).catch(() => false)) {
      await cb.click();
      await page.waitForTimeout(350);
    }
  }

  await page.waitForTimeout(600);

  // Clear search to show selection count across all questions
  await clickLocator(page, searchField);
  await page.keyboard.press(process.platform === 'darwin' ? 'Meta+A' : 'Control+A');
  await page.keyboard.press('Backspace');
  await page.waitForTimeout(800);

  // Confirm — "Add Selected (N)" button
  const addSelectedBtn = page.getByRole('button', { name: /Add Selected|Done/i }).first();
  if (await addSelectedBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await addSelectedBtn.click();
    await page.waitForTimeout(1500);
  } else {
    // Fallback: look for "Add (N)"
    const addBtn = page.getByRole('button', { name: /^Add \(/ }).first();
    if (await addBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
      await addBtn.click();
      await page.waitForTimeout(1500);
    }
  }

  await waitForFlutter(page, 800);

  // ── Save as Draft ──────────────────────────────────────────────────────
  await clickButton(page, 'Save Draft');
  await page.waitForTimeout(1800);
  await waitForFlutter(page, 800);
});
