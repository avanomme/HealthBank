import { test } from '@playwright/test';
import {
  goToAppRoute,
  loginAsResearcher,
  selectDropdownOption,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Researcher: Survey List & Filters', async ({ page }) => {
  await loginAsResearcher(page);

  await goToAppRoute(page, '/surveys', 1500);
  await page.waitForURL('**/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  // Browse all surveys
  await page.waitForTimeout(1200);
  await slowScroll(page, 300, 1, 900);

  const clearAll = page.getByRole('button', { name: 'Clear All' }).first();
  if (await clearAll.isVisible({ timeout: 2000 }).catch(() => false)) {
    await clearAll.click();
    await page.waitForTimeout(800);
  }

  const statusFilter = page.getByRole('button', { name: /Status/ }).first();

  // Filter by Drafts
  await selectDropdownOption(page, statusFilter, 1);
  await page.waitForTimeout(1200);
  await slowScroll(page, 200, 1, 800);

  // Filter by Published
  await selectDropdownOption(page, statusFilter, 2);
  await page.waitForTimeout(1200);
  await slowScroll(page, 200, 1, 800);

  // Filter by Closed
  await selectDropdownOption(page, statusFilter, 3);
  await page.waitForTimeout(1000);

  // Clear filters — show all surveys
  if (await clearAll.isVisible({ timeout: 2000 }).catch(() => false)) {
    await clearAll.click();
    await page.waitForTimeout(1000);
  }

  // Scroll back to top to show New Survey button
  await slowScroll(page, -400, 1, 800);

  // Hover over New Survey to highlight it
  const newBtn = page.getByRole('button', { name: 'New Survey' });
  if (await newBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await newBtn.hover();
    await page.waitForTimeout(700);
  }
});
