import { Page, test } from '@playwright/test';
import {
  clickLocator, goToAppRoute,
  loginAsAdmin, loginAsResearcher, waitForFlutter,
} from './helpers';
import * as fs from 'fs';

const OUT = '/tmp/manual_screenshots';

async function snap(page: Page, name: string) {
  await page.evaluate(() => {
    const c = document.getElementById('pw-demo-cursor');
    const p = document.getElementById('pw-demo-cursor-pulse');
    if (c) c.style.display = 'none';
    if (p) p.style.display = 'none';
  });
  await page.screenshot({ path: `${OUT}/${name}.png`, animations: 'disabled' });
}

test('retake: researcher charts loaded', async ({ page }) => {
  await loginAsResearcher(page);
  await goToAppRoute(page, '/researcher/health-tracking', 2000);
  await waitForFlutter(page, 2000);
  await page.waitForTimeout(1000);
  const loadBtn = page.getByRole('button', { name: /Load Chart/i }).first();
  if (await loadBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
    await loadBtn.click();
    await waitForFlutter(page, 4000);
    await page.waitForTimeout(2000);
  }
  await snap(page, 'r02_ht_charts');
});

test('retake: admin edit metric dialog', async ({ page }) => {
  await loginAsAdmin(page);
  await goToAppRoute(page, '/admin/health-tracking', 2000);
  await waitForFlutter(page, 2000);
  await page.waitForTimeout(1000);
  // Expand Physical Health
  const physicalRow = page.getByRole('button', { name: /Physical Health/i }).first();
  if (await physicalRow.isVisible({ timeout: 5000 }).catch(() => false)) {
    await physicalRow.click();
    await page.waitForTimeout(1500);
    await waitForFlutter(page, 800);
  }
  await page.evaluate(() => window.scrollBy(0, 200));
  await page.waitForTimeout(500);
  // Click first edit-labelled button visible
  const editBtns = page.getByRole('button', { name: /edit/i });
  if (await editBtns.first().isVisible({ timeout: 3000 }).catch(() => false)) {
    await editBtns.first().click();
    await page.waitForTimeout(1800);
    await waitForFlutter(page, 800);
  }
  await snap(page, 'a02_ht_edit_dialog');
});
