import { test } from '@playwright/test';
import {
  clickButton,
  loginAsResearcher,
  selectDropdownOption,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Researcher: Template Library', async ({ page }) => {
  await loginAsResearcher(page);

  // Navigate to Templates via header
  await clickButton(page, 'Templates');
  await page.waitForURL('**/templates', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  const backBtn = page.getByRole('button', { name: 'Back' }).first();
  if (await backBtn.isVisible({ timeout: 2000 }).catch(() => false)) {
    await backBtn.click();
    await page.waitForTimeout(1200);
    await waitForFlutter(page, 1200);
  }

  // Browse all templates
  await page.waitForTimeout(1200);
  await slowScroll(page, 320, 1, 1000);

  const clearAll = page.getByRole('button', { name: 'Clear All' }).first();
  if (await clearAll.isVisible({ timeout: 2000 }).catch(() => false)) {
    await clearAll.click();
    await page.waitForTimeout(800);
  }

  const visibilityFilter = page.getByRole('button', { name: /Visibility/ }).first();

  // Filter by Public templates
  await selectDropdownOption(page, visibilityFilter, 1);
  await page.waitForTimeout(1100);
  await slowScroll(page, 200, 1, 800);

  // Filter by Private templates
  await selectDropdownOption(page, visibilityFilter, 2);
  await page.waitForTimeout(1000);

  // Clear filters
  if (await clearAll.isVisible({ timeout: 2000 }).catch(() => false)) {
    await clearAll.click();
    await page.waitForTimeout(900);
  }
  await slowScroll(page, -300, 1, 700);

  // Preview the first template
  const previewBtn = page.getByRole('button', { name: 'Preview' }).first();
  if (await previewBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await previewBtn.click();
    await page.waitForTimeout(1500);
    // Dismiss the preview dialog if one appeared
    const closeBtn = page.getByRole('button', { name: /close|dismiss|cancel/i }).first();
    if (await closeBtn.isVisible({ timeout: 2000 }).catch(() => false)) {
      await closeBtn.click();
      await page.waitForTimeout(700);
    }
  }

  // Show "New Template" button
  const newTemplateBtn = page.getByRole('button', { name: 'New Template' });
  if (await newTemplateBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await newTemplateBtn.hover();
    await page.waitForTimeout(700);
  }

  await waitForFlutter(page, 800);
});
