import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  clickText,
  ensureDemoCursor,
  goToAppRoute,
  loginAsResearcher,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Researcher: Health Tracking — Filters, Charts & Export', async ({ page }) => {
  await loginAsResearcher(page);

  await goToAppRoute(page, '/researcher/health-tracking', 1500);
  await waitForFlutter(page, 1500);
  await ensureDemoCursor(page);

  // Pause to show the page with collapsed filters
  await page.waitForTimeout(1800);

  // ── Expand filters ─────────────────────────────────────────────────────────
  const filtersPanel = page.getByRole('button', { name: /filters/i }).first();
  if (await filtersPanel.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, filtersPanel);
    await page.waitForTimeout(1200);
  }

  // ── Select a category (e.g. Mental Health) ────────────────────────────────
  const categoryDropdown = page.getByRole('combobox').first();
  if (await categoryDropdown.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, categoryDropdown);
    await page.waitForTimeout(800);
    const mentalOption = page.getByRole('option', { name: /Mental Health/i }).first();
    if (await mentalOption.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, mentalOption);
    } else {
      // Fallback: pick the second option
      const secondOption = page.getByRole('option').nth(1);
      if (await secondOption.isVisible({ timeout: 1000 }).catch(() => false)) {
        await clickLocator(page, secondOption);
      }
    }
    await page.waitForTimeout(800);
  }

  // ── Select All metrics via the checkbox or "Select All" button ────────────
  const selectAll = page.getByRole('button', { name: /Select All/i }).first();
  if (await selectAll.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, selectAll);
    await page.waitForTimeout(800);
  }

  // ── Load Charts button (always visible above filters) ─────────────────────
  const loadChartsButton = page.getByRole('button', { name: /Load Charts/i }).first();
  if (await loadChartsButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, loadChartsButton);
    await page.waitForTimeout(2500);
    await waitForFlutter(page, 1000);
  }

  // ── Scroll down to see rendered metric chart cards ────────────────────────
  await slowScroll(page, 300, 3, 900);
  await page.waitForTimeout(1000);

  // ── Toggle a chart type on the first card (e.g. Bar) ─────────────────────
  const barToggle = page.getByRole('button', { name: /Bar chart/i }).first();
  if (await barToggle.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, barToggle);
    await page.waitForTimeout(1200);
  }

  // ── Scroll back to top and use Export Filtered Data button ───────────────
  await page.keyboard.press('Home');
  await page.waitForTimeout(600);

  const exportButton = page.getByRole('button', { name: /Export Filtered Data/i }).first();
  if (await exportButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, exportButton);
    await page.waitForTimeout(2000);
  }

  await waitForFlutter(page, 800);
});
