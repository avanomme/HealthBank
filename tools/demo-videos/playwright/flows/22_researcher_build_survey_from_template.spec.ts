/**
 * Researcher: Build a survey by loading questions from a Template.
 *
 * Flow:
 *   Surveys → New Survey → fill title →
 *   "Add Questions" menu → "Start from Template" →
 *   template list opens in selection mode → pick first template →
 *   questions load into builder → optionally add more questions →
 *   save as draft
 */
import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  goToAppRoute,
  loginAsResearcher,
  waitForFlutter,
} from './helpers';

test('Researcher: Build Survey From Template', async ({ page }) => {
  await loginAsResearcher(page);

  await goToAppRoute(page, '/surveys', 1500);
  await page.waitForURL('**/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1200);

  await clickButton(page, 'New Survey');
  await waitForFlutter(page, 1500);

  // ── Title ──────────────────────────────────────────────────────────────
  const titleField = page.getByRole('textbox').nth(0);
  await clickLocator(page, titleField);
  await titleField.pressSequentially('Annual Wellness Screening 2026', { delay: 40 });
  await page.waitForTimeout(300);

  // ── Open the Add Questions popup menu ──────────────────────────────────
  const addQuestionsBtn = page.getByRole('button', { name: /Add Questions/ }).first();
  await clickLocator(page, addQuestionsBtn);
  await page.waitForTimeout(800);

  // Choose "Start from Template"
  await clickLocator(page, page.getByRole('menuitem', { name: 'Start from Template' }).first());
  await page.waitForTimeout(1800);
  await waitForFlutter(page, 1200);

  // ── Template selection page ────────────────────────────────────────────
  // Browse available templates
  await page.waitForTimeout(700);

  // Click "Create Survey" on the first template card to load its questions
  const createSurveyBtn = page.getByRole('button', { name: /Create Survey|Use Template|Select Template/ }).first();
  if (await createSurveyBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
    await createSurveyBtn.click();
    await page.waitForTimeout(1800);
  } else {
    // Fallback: click the first template card body
    const firstCard = page.getByRole('button').filter({ hasText: /question/i }).first();
    if (await firstCard.isVisible({ timeout: 3000 }).catch(() => false)) {
      await firstCard.click();
      await page.waitForTimeout(1800);
    }
  }

  await waitForFlutter(page, 1000);

  // ── Save as Draft ──────────────────────────────────────────────────────
  await clickButton(page, 'Save Draft');
  await page.waitForTimeout(1800);
  await waitForFlutter(page, 800);
});
