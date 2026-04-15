/**
 * Researcher: Build a survey from scratch using the inline question editor.
 *
 * Flow:
 *   Surveys → New Survey → fill title/description/dates →
 *   "Add Questions" menu → "Add New Question" → fill question inline →
 *   confirm → save as draft
 */
import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  goToAppRoute,
  loginAsResearcher,
  waitForFlutter,
} from './helpers';

test('Researcher: Build Survey From Scratch', async ({ page }) => {
  await loginAsResearcher(page);

  await goToAppRoute(page, '/surveys', 1500);
  await page.waitForURL('**/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1200);

  await clickButton(page, 'New Survey');
  await waitForFlutter(page, 1500);

  // ── Title and description ──────────────────────────────────────────────
  const titleField = page.getByRole('textbox').nth(0);
  await clickLocator(page, titleField);
  await titleField.pressSequentially('Q3 2026 Health Assessment', { delay: 40 });
  await page.waitForTimeout(300);

  const descriptionField = page.getByRole('textbox').nth(1);
  await clickLocator(page, descriptionField);
  await descriptionField.pressSequentially('Third-quarter health check for enrolled participants.', { delay: 35 });
  await page.waitForTimeout(300);

  // ── Date range ─────────────────────────────────────────────────────────
  // Click the Start Date field to open the date picker
  const startDate = page.getByText('Start Date').first();
  await clickLocator(page, startDate);
  await page.waitForTimeout(1000);
  // Accept whatever the picker defaults to
  const okBtn = page.getByRole('button', { name: 'OK' });
  if (await okBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await okBtn.click();
    await page.waitForTimeout(700);
  } else {
    await page.keyboard.press('Escape');
    await page.waitForTimeout(500);
  }

  // Click the End Date field
  const endDate = page.getByText('End Date').first();
  await clickLocator(page, endDate);
  await page.waitForTimeout(1000);
  if (await okBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await okBtn.click();
    await page.waitForTimeout(700);
  } else {
    await page.keyboard.press('Escape');
    await page.waitForTimeout(500);
  }

  // ── Add New Question inline ────────────────────────────────────────────
  // "Add Questions" is a PopupMenuButton — clicking opens a menu
  const addQuestionsBtn = page.getByRole('button', { name: /Add Questions/ }).first();
  await clickLocator(page, addQuestionsBtn);
  await page.waitForTimeout(800);

  // Choose "Add New Question" from the popup menu
  await clickLocator(page, page.getByRole('menuitem', { name: 'Add New Question' }).first());
  await page.waitForTimeout(1200);

  // The inline draft question card appears — fill the question text
  const questionInput = page.getByRole('textbox').last();
  if (await questionInput.isVisible({ timeout: 4000 }).catch(() => false)) {
    await questionInput.click();
    await page.waitForTimeout(400);
    await questionInput.pressSequentially('How would you rate your overall health this week?', { delay: 40 });
    await page.waitForTimeout(500);
  }

  // Confirm the question (saves it via API)
  const confirmBtn = page.getByRole('button', { name: /confirm/i }).first();
  if (await confirmBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await confirmBtn.click();
    await page.waitForTimeout(1500);
  }

  await waitForFlutter(page, 800);

  // ── Save as Draft ──────────────────────────────────────────────────────
  await clickButton(page, 'Save Draft');
  await page.waitForTimeout(1800);
  await waitForFlutter(page, 800);
});
