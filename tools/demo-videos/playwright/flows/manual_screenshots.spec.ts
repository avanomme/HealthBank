/**
 * Manual screenshot capture for the Training Manual Addendum v2.
 *
 * Run with:
 *   cd tools/demo-videos/playwright
 *   npx playwright test manual_screenshots.spec.ts --project=chromium
 *
 * Output: /tmp/manual_screenshots/*.png  (16 images, consistent 1280×800)
 */

import { Page, test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  clickText,
  fillField,
  goToAppRoute,
  loginAsAdmin,
  loginAsHcp,
  loginAsParticipant,
  loginAsResearcher,
  waitForFlutter,
} from './helpers';
import * as fs from 'fs';

const OUT = '/tmp/manual_screenshots';
fs.mkdirSync(OUT, { recursive: true });

async function snap(page: Page, name: string) {
  // Hide the demo cursor overlay before snapping so it doesn't appear in shots.
  await page.evaluate(() => {
    const c = document.getElementById('pw-demo-cursor');
    const p = document.getElementById('pw-demo-cursor-pulse');
    if (c) c.style.display = 'none';
    if (p) p.style.display = 'none';
  });
  await page.screenshot({ path: `${OUT}/${name}.png`, animations: 'disabled' });
}

// ── Participant ───────────────────────────────────────────────────────────────

test('screenshot: participant dashboard', async ({ page }) => {
  await loginAsParticipant(page);
  await waitForFlutter(page, 2000);
  await snap(page, 'p01_dashboard');
});

test('screenshot: participant tasks', async ({ page }) => {
  await loginAsParticipant(page);
  await goToAppRoute(page, '/participant/tasks', 2000);
  await waitForFlutter(page, 1500);
  await snap(page, 'p02_tasks');
});

test('screenshot: participant results', async ({ page }) => {
  await loginAsParticipant(page);
  await goToAppRoute(page, '/participant/results', 2000);
  await waitForFlutter(page, 1500);
  await snap(page, 'p03_results');
});

test('screenshot: health tracking log today — overview', async ({ page }) => {
  await loginAsParticipant(page);
  await goToAppRoute(page, '/participant/health-tracking', 2000);
  await waitForFlutter(page, 2000);
  // Wait for metric cards to render
  await page.waitForTimeout(1500);
  await snap(page, 'p04_ht_logtoday');
});

test('screenshot: health tracking — metric input types', async ({ page }) => {
  await loginAsParticipant(page);
  await goToAppRoute(page, '/participant/health-tracking', 2000);
  await waitForFlutter(page, 2000);
  await page.waitForTimeout(1000);
  // Scroll down slightly to show a variety of metric card types
  await page.evaluate(() => window.scrollBy(0, 300));
  await page.waitForTimeout(800);
  await snap(page, 'p05_ht_metric_types');
});

test('screenshot: health tracking — history chart', async ({ page }) => {
  await loginAsParticipant(page);
  await goToAppRoute(page, '/participant/health-tracking', 2000);
  await waitForFlutter(page, 1500);

  // Switch to History view via the segmented button
  const historyBtn = page.getByRole('button', { name: /History/i }).first();
  if (await historyBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
    await historyBtn.click();
  } else {
    await clickText(page, 'History');
  }
  await waitForFlutter(page, 2000);
  await page.waitForTimeout(1500);
  await snap(page, 'p06_ht_history');
});

test('screenshot: health tracking — baseline prompt', async ({ page }) => {
  await loginAsParticipant(page);
  await goToAppRoute(page, '/participant/health-tracking', 2000);
  await waitForFlutter(page, 2000);
  await page.waitForTimeout(1200);
  // Baseline banner appears at top if no baseline recorded — capture the top of the page
  await snap(page, 'p07_ht_baseline');
});

// ── Researcher ────────────────────────────────────────────────────────────────

test('screenshot: researcher health tracking — filter panel', async ({ page }) => {
  await loginAsResearcher(page);
  await goToAppRoute(page, '/researcher/health-tracking', 2000);
  await waitForFlutter(page, 2000);
  await page.waitForTimeout(1500);

  // Expand the filter panel if it has a toggle
  const filtersBtn = page.getByRole('button', { name: /filters|Filter Metrics/i }).first();
  if (await filtersBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await filtersBtn.click();
    await page.waitForTimeout(1000);
  }
  await snap(page, 'r01_ht_filters');
});

test('screenshot: researcher health tracking — charts loaded', async ({ page }) => {
  await loginAsResearcher(page);
  await goToAppRoute(page, '/researcher/health-tracking', 2000);
  await waitForFlutter(page, 2000);
  await page.waitForTimeout(1000);

  // Click Load Charts — all metrics are pre-selected by default
  const loadBtn = page.getByRole('button', { name: /Load Charts/i }).first();
  if (await loadBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
    await loadBtn.click();
    await waitForFlutter(page, 3000);
    await page.waitForTimeout(1500);
  }
  await snap(page, 'r02_ht_charts');
});

// ── HCP ───────────────────────────────────────────────────────────────────────

test('screenshot: hcp reports — health tracking tab', async ({ page }) => {
  await loginAsHcp(page);
  await goToAppRoute(page, '/hcp/reports', 2000);
  await waitForFlutter(page, 2000);
  await page.waitForTimeout(1000);

  // Click the Health Tracking tab
  const htTab = page.getByRole('tab', { name: /Health Tracking/i }).first();
  if (await htTab.isVisible({ timeout: 5000 }).catch(() => false)) {
    await htTab.click();
    await page.waitForTimeout(1200);
  } else {
    await clickText(page, 'Health Tracking');
    await page.waitForTimeout(1200);
  }
  await snap(page, 'h01_reports_ht_tab');
});

test('screenshot: hcp reports — health tracking chart', async ({ page }) => {
  await loginAsHcp(page);
  await goToAppRoute(page, '/hcp/reports', 2000);
  await waitForFlutter(page, 2000);

  // Switch to Health Tracking tab
  const htTab = page.getByRole('tab', { name: /Health Tracking/i }).first();
  if (await htTab.isVisible({ timeout: 5000 }).catch(() => false)) {
    await htTab.click();
  } else {
    await clickText(page, 'Health Tracking');
  }
  await page.waitForTimeout(1000);

  // Select the first patient
  const patientDropdown = page.getByRole('combobox').first();
  if (await patientDropdown.isVisible({ timeout: 5000 }).catch(() => false)) {
    await patientDropdown.click();
    await page.waitForTimeout(600);
    const firstOption = page.getByRole('option').first();
    if (await firstOption.isVisible({ timeout: 3000 }).catch(() => false)) {
      await firstOption.click();
      await page.waitForTimeout(1200);
    }
  }

  // Load charts
  const loadBtn = page.getByRole('button', { name: /Load Charts/i }).first();
  if (await loadBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
    await loadBtn.click();
    await waitForFlutter(page, 3000);
    await page.waitForTimeout(1500);
  }
  await snap(page, 'h02_reports_ht_chart');
});

// ── Admin ─────────────────────────────────────────────────────────────────────

test('screenshot: admin health tracking — category list', async ({ page }) => {
  await loginAsAdmin(page);
  await goToAppRoute(page, '/admin/health-tracking', 2000);
  await waitForFlutter(page, 2000);
  await page.waitForTimeout(1500);
  await snap(page, 'a01_ht_settings');
});

test('screenshot: admin health tracking — edit metric dialog', async ({ page }) => {
  await loginAsAdmin(page);
  await goToAppRoute(page, '/admin/health-tracking', 2000);
  await waitForFlutter(page, 2000);
  await page.waitForTimeout(1000);

  // Expand Physical Health category
  const physicalRow = page.getByRole('button', { name: /Physical Health/i }).first();
  if (await physicalRow.isVisible({ timeout: 5000 }).catch(() => false)) {
    await physicalRow.click();
    await page.waitForTimeout(1200);
  }

  // Click edit on first metric (tooltip "Edit metric" or pencil icon)
  const editBtn = page.getByRole('button', { name: /edit/i }).first();
  if (await editBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await editBtn.click();
    await page.waitForTimeout(1500);
    await waitForFlutter(page, 800);
    await snap(page, 'a02_ht_edit_dialog');
  }
});

test('screenshot: admin database — backup panel', async ({ page }) => {
  await loginAsAdmin(page);
  await goToAppRoute(page, '/admin/database', 2000);
  await waitForFlutter(page, 2000);
  await page.waitForTimeout(1500);
  // Database Utilities panel is at the top — no scroll needed
  await snap(page, 'a03_db_backup');
});

test('screenshot: admin settings — full page', async ({ page }) => {
  await loginAsAdmin(page);
  await goToAppRoute(page, '/admin/settings', 2000);
  await waitForFlutter(page, 2000);
  await page.waitForTimeout(1500);
  await snap(page, 'a04_settings');
});

test('screenshot: admin settings — save confirmation', async ({ page }) => {
  await loginAsAdmin(page);
  await goToAppRoute(page, '/admin/settings', 2000);
  await waitForFlutter(page, 2000);
  await page.waitForTimeout(1000);

  // Scroll to the Save button at the bottom
  const saveBtn = page.getByRole('button', { name: /Save Settings/i }).first();
  if (await saveBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
    await saveBtn.scrollIntoViewIfNeeded();
    await page.waitForTimeout(600);
    await saveBtn.click();
    await page.waitForTimeout(1500);
    await waitForFlutter(page, 800);
  }
  await snap(page, 'a05_settings_save');
});
