/**
 * Researcher: Assign a published survey filtered by demographic (gender + age).
 *
 * Flow:
 *   Surveys → Published → first survey Assign button →
 *   modal → switch to "By Demographic" →
 *   set gender filter → set age range → Assign Now → see result summary
 */
import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  fillField,
  goToAppRoute,
  loginAsResearcher,
  selectDropdownOption,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Researcher: Assign Survey — By Demographic', async ({ page }) => {
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
  await page.waitForTimeout(1200);
  await clickButton(page, 'Assign');
  await page.waitForTimeout(1500);
  await waitForFlutter(page, 1000);

  // ── Assign modal ───────────────────────────────────────────────────────
  // Switch to "By Demographic" target
  const byDemographic = page.getByRole('radio', { name: 'By Demographic' }).first();
  if (await byDemographic.isVisible({ timeout: 4000 }).catch(() => false)) {
    await clickLocator(page, byDemographic);
    await page.waitForTimeout(1000);
  }

  await waitForFlutter(page, 800);

  // ── Gender filter ──────────────────────────────────────────────────────
  // The gender dropdown shows: All, Male, Female, Non-binary, Other, Unspecified
  const genderDropdown = page.getByRole('combobox').first();
  if (await genderDropdown.isVisible({ timeout: 3000 }).catch(() => false)) {
    await genderDropdown.click();
    await page.waitForTimeout(600);
    const femaleOption = page.getByRole('option', { name: /female/i }).first();
    if (await femaleOption.isVisible({ timeout: 2000 }).catch(() => false)) {
      await femaleOption.click();
      await page.waitForTimeout(700);
    }
  }

  // ── Age range filter ───────────────────────────────────────────────────
  await fillField(page, 'Age Min', '25');
  await page.waitForTimeout(400);
  await fillField(page, 'Age Max', '65');
  await page.waitForTimeout(400);

  // Show the filled form
  await slowScroll(page, 200, 1, 900);

  // Assign Now
  await clickButton(page, 'Assign Now');
  await page.waitForTimeout(2500);
  await waitForFlutter(page, 1000);
});
