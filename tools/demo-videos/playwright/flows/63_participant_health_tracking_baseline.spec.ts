import { test } from '@playwright/test';
import {
  clickLocator,
  clickText,
  ensureDemoCursor,
  goToAppRoute,
  loginAsParticipant,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Participant: Health Tracking — Baseline Entry', async ({ page }) => {
  await loginAsParticipant(page);

  await goToAppRoute(page, '/participant/health-tracking', 1500);
  await waitForFlutter(page, 1500);
  await ensureDemoCursor(page);

  // Pause to show the page — baseline banner should appear if no baseline exists
  await page.waitForTimeout(1800);

  // ── Tap the baseline banner CTA if visible ─────────────────────────────────
  const baselineBanner = page.getByRole('button', { name: /record.*baseline|baseline.*snapshot/i }).first();
  if (await baselineBanner.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, baselineBanner);
    await page.waitForTimeout(1500);
    await waitForFlutter(page, 1000);
  }

  // Baseline mode shows a "Baseline" indicator in the header — scroll to show it
  await slowScroll(page, 150, 1, 900);
  await page.waitForTimeout(1200);

  // ── Fill in a scale metric (first slider visible) ─────────────────────────
  const firstScale = page.getByRole('slider').first();
  if (await firstScale.isVisible({ timeout: 3000 }).catch(() => false)) {
    const box = await firstScale.boundingBox();
    if (box) {
      // Click at 70% along the slider to set a value of roughly 7/10
      await page.mouse.click(box.x + box.width * 0.7, box.y + box.height / 2);
      await page.waitForTimeout(600);
    }
  }

  // ── Fill in a yes/no metric ────────────────────────────────────────────────
  const yesChip = page.getByRole('button', { name: /^Yes$/i }).first();
  if (await yesChip.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, yesChip);
    await page.waitForTimeout(800);
  }

  // ── Scroll to show more metrics ────────────────────────────────────────────
  await slowScroll(page, 250, 2, 900);
  await page.waitForTimeout(1000);

  // ── Save the baseline entries ──────────────────────────────────────────────
  const saveButton = page.getByRole('button', { name: /save/i }).first();
  if (await saveButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, saveButton);
    await page.waitForTimeout(2500);
  }

  // ── Navigate to History and confirm baseline entries appear ───────────────
  const historyTab = page.getByRole('button', { name: /History/i }).first();
  if (await historyTab.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, historyTab);
    await page.waitForTimeout(1800);
    await waitForFlutter(page, 1000);
  } else if (await page.getByText('History', { exact: false }).first().isVisible({ timeout: 1000 }).catch(() => false)) {
    await clickText(page, 'History');
    await page.waitForTimeout(1800);
    await waitForFlutter(page, 1000);
  }

  // Switch to By Category or By Metric view to see the saved data
  const byMetric = page.getByRole('button', { name: /By Metric/i }).first();
  if (await byMetric.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, byMetric);
    await page.waitForTimeout(1500);
  }

  await slowScroll(page, 300, 2, 900);
  await waitForFlutter(page, 800);
});
