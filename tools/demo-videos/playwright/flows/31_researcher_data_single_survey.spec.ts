/**
 * Researcher: Research Data page — By Survey mode.
 *
 * Flow:
 *   Data page → "By Survey" mode (default) →
 *   select a survey from the dropdown →
 *   overview stat cards (total respondents, questions, etc.) →
 *   "Data Table" tab — scroll through individual anonymised responses →
 *   "Analysis" tab — charts per question →
 *   switch each chart: Bar → Line → Pie →
 *   hover Export CSV
 */
import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  loginAsResearcher,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Researcher: Research Data — Single Survey', async ({ page }) => {
  await loginAsResearcher(page);

  await clickButton(page, 'Data');
  await page.waitForURL('**/researcher/data', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  // ── "By Survey" mode is default — confirm the toggle ──────────────────
  const bySurveySegment = page.getByRole('button', { name: 'By Survey' });
  if (await bySurveySegment.isVisible({ timeout: 3000 }).catch(() => false)) {
    await bySurveySegment.hover();
    await page.waitForTimeout(600);
  }

  // ── Select a survey ────────────────────────────────────────────────────
  // The survey selector is a DropdownMenu with search
  const surveyInput = page.getByRole('textbox', { name: 'Select a survey' }).first();
  await clickLocator(page, surveyInput);
  await surveyInput.pressSequentially('Q1 2026', { delay: 35 });
  await page.waitForTimeout(900);
  await page.keyboard.press('ArrowDown');
  await page.waitForTimeout(400);
  await page.keyboard.press('Enter');
  await page.waitForTimeout(1800);

  await waitForFlutter(page, 1800);

  // ── Overview stat cards ────────────────────────────────────────────────
  await page.waitForTimeout(1200);
  await slowScroll(page, 200, 1, 900);

  // ── Data Table tab ─────────────────────────────────────────────────────
  const dataTableTab = page.getByRole('tab', { name: 'Data Table' }).first();
  if (await dataTableTab.isVisible({ timeout: 2000 }).catch(() => false)) {
    await clickLocator(page, dataTableTab);
    await page.waitForTimeout(1000);
    await waitForFlutter(page, 1200);
  }

  // Scroll horizontally if the table is wide (mouse wheel on X axis)
  await page.mouse.wheel(100, 0);
  await page.waitForTimeout(600);
  await page.mouse.wheel(-100, 0);
  await page.waitForTimeout(400);

  await slowScroll(page, 350, 2, 1000);

  // Hover Export CSV on the data table tab
  const exportBtnTable = page.getByRole('button', { name: 'Export CSV' }).first();
  if (await exportBtnTable.isVisible({ timeout: 3000 }).catch(() => false)) {
    await exportBtnTable.hover();
    await page.waitForTimeout(700);
  }

  // ── Analysis tab ───────────────────────────────────────────────────────
  await clickLocator(page, page.getByRole('tab', { name: 'Analysis' }).first());
  await page.waitForTimeout(1000);
  await waitForFlutter(page, 1800);

  // Show the first question's chart
  await page.waitForTimeout(1200);

  // ── Chart type switching ───────────────────────────────────────────────
  // The SurveyChartSwitcher renders icon buttons with tooltips:
  //   "Bar chart" | "Line chart" | "Pie chart"

  // Switch to Line chart
  const lineChartBtn = page.getByRole('button', { name: 'Line chart' }).first();
  if (await lineChartBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await clickLocator(page, lineChartBtn);
    await page.waitForTimeout(1200);
  }

  // Switch to Pie chart
  const pieChartBtn = page.getByRole('button', { name: 'Pie chart' }).first();
  if (await pieChartBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, pieChartBtn);
    await page.waitForTimeout(1200);
  }

  // Switch back to Bar chart
  const barChartBtn = page.getByRole('button', { name: 'Bar chart' }).first();
  if (await barChartBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, barChartBtn);
    await page.waitForTimeout(1000);
  }

  // Scroll to the next question's charts and switch those too
  await slowScroll(page, 400, 1, 1000);

  const lineChartBtn2 = page.getByRole('button', { name: 'Line chart' }).nth(1);
  if (await lineChartBtn2.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, lineChartBtn2);
    await page.waitForTimeout(1000);
  }

  await slowScroll(page, 400, 1, 1000);
  await slowScroll(page, -800, 1, 900);

  await waitForFlutter(page, 800);
});
