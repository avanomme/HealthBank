/**
 * Researcher: Research Data page — Data Bank (cross-survey) mode.
 *
 * Flow:
 *   Data page → toggle to "Data Bank" mode →
 *   "+ Add Fields" → select surveys/questions →
 *   optional date range filter →
 *   overview stat cards (Total Respondents, Surveys, Questions, Avg Completion) →
 *   "Data Table" tab → scroll through merged data →
 *   "Analysis" tab → charts → switch chart types → Export CSV
 */
import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  loginAsResearcher,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Researcher: Research Data — Data Bank Mode', async ({ page }) => {
  await loginAsResearcher(page);

  await clickButton(page, 'Data');
  await page.waitForURL('**/researcher/data', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  // ── Switch to Data Bank mode ───────────────────────────────────────────
  const dataBankSegment = page.getByRole('button', { name: 'Data Bank' });
  if (await dataBankSegment.isVisible({ timeout: 4000 }).catch(() => false)) {
    await clickLocator(page, dataBankSegment);
    await page.waitForTimeout(1200);
    await waitForFlutter(page, 1000);
  }

  // ── Add Fields ─────────────────────────────────────────────────────────
  const addFieldsBtn = page.getByRole('button', { name: 'Add Fields' });
  if (await addFieldsBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
    await addFieldsBtn.click();
    await page.waitForTimeout(1500);
    await waitForFlutter(page, 1000);
  }

  // ── Select fields dialog / panel ───────────────────────────────────────
  // Select all available questions/fields
  const selectAllBtn = page.getByRole('button', { name: 'Select All' }).first();
  if (await selectAllBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await selectAllBtn.click();
    await page.waitForTimeout(800);
  } else {
    // Fallback: tick individual checkboxes
    const checkboxes = page.getByRole('checkbox');
    const total = await checkboxes.count();
    for (let i = 0; i < Math.min(total, 5); i++) {
      const cb = checkboxes.nth(i);
      if (await cb.isVisible({ timeout: 2000 }).catch(() => false)) {
        await cb.click();
        await page.waitForTimeout(300);
      }
    }
  }

  await slowScroll(page, 200, 1, 800);

  // Confirm the selection
  const doneBtn = page.getByRole('button', { name: 'Done' }).first();
  if (await doneBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await doneBtn.click();
    await page.waitForTimeout(1500);
  } else {
    const addSelectedBtn = page.getByRole('button', { name: /Add Selected|Add \(/ }).first();
    if (await addSelectedBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
      await addSelectedBtn.click();
      await page.waitForTimeout(1500);
    }
  }

  await waitForFlutter(page, 1800);

  // ── Overview stat cards ────────────────────────────────────────────────
  // Shows: Total Respondents, Surveys, Total Questions, Avg Completion
  await page.waitForTimeout(1200);
  await slowScroll(page, 200, 1, 900);

  // ── Data Table tab ─────────────────────────────────────────────────────
  const dataTableTab = page.getByRole('tab', { name: 'Data Table' }).first();
  if (await dataTableTab.isVisible({ timeout: 2000 }).catch(() => false)) {
    await clickLocator(page, dataTableTab);
    await page.waitForTimeout(1000);
    await waitForFlutter(page, 1200);
  }

  await slowScroll(page, 350, 2, 1000);

  // Hover Export CSV
  const exportBtnTable = page.getByRole('button', { name: 'Export CSV' }).first();
  if (await exportBtnTable.isVisible({ timeout: 3000 }).catch(() => false)) {
    await exportBtnTable.hover();
    await page.waitForTimeout(700);
  }

  // ── Analysis tab ───────────────────────────────────────────────────────
  await clickLocator(page, page.getByRole('tab', { name: 'Analysis' }).first());
  await page.waitForTimeout(1000);
  await waitForFlutter(page, 1800);

  await page.waitForTimeout(1200);

  // Switch chart types for the first chart
  const lineChartBtn = page.getByRole('button', { name: 'Line chart' }).first();
  if (await lineChartBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await clickLocator(page, lineChartBtn);
    await page.waitForTimeout(1100);
  }

  const pieChartBtn = page.getByRole('button', { name: 'Pie chart' }).first();
  if (await pieChartBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, pieChartBtn);
    await page.waitForTimeout(1100);
  }

  const barChartBtn = page.getByRole('button', { name: 'Bar chart' }).first();
  if (await barChartBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, barChartBtn);
    await page.waitForTimeout(1000);
  }

  await slowScroll(page, 400, 2, 1000);

  // Hover Export CSV on analysis tab
  const exportBtnAnalysis = page.getByRole('button', { name: 'Export CSV' }).first();
  if (await exportBtnAnalysis.isVisible({ timeout: 3000 }).catch(() => false)) {
    await exportBtnAnalysis.hover();
    await page.waitForTimeout(700);
  }

  await slowScroll(page, -600, 1, 900);
  await waitForFlutter(page, 800);
});
