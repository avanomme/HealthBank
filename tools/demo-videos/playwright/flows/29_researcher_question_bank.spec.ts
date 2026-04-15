import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  fillField,
  loginAsResearcher,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Researcher: Question Bank', async ({ page }) => {
  await loginAsResearcher(page);

  // Navigate to Question Bank via header
  await clickButton(page, 'Question Bank');
  await page.waitForURL('**/questions', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  // Browse questions
  await page.waitForTimeout(1200);
  await slowScroll(page, 300, 1, 1000);

  // Search for a question
  await fillField(page, 'Search', 'health');
  await page.waitForTimeout(1500);
  await slowScroll(page, 200, 1, 800);

  // Clear search and filter by category
  await fillField(page, 'Search', '');
  await page.waitForTimeout(800);

  // Filter by Mental Health category
  const categoryFilter = page.getByRole('button', { name: /Category/ }).first();
  if (await categoryFilter.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, categoryFilter);
    await page.waitForTimeout(800);
    await clickLocator(page, page.getByRole('menuitem', { name: 'Mental Health' }).first());
    await page.waitForTimeout(1200);
    await slowScroll(page, 200, 1, 800);
  }

  // Clear filters
  const clearAll = page.getByRole('button', { name: 'Clear All' }).first();
  if (await clearAll.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clearAll.click();
    await page.waitForTimeout(800);
  }

  await slowScroll(page, -300, 1, 700);

  // Show the New Question button
  const newQuestionBtn = page.getByRole('button', { name: 'New Question' });
  if (await newQuestionBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await newQuestionBtn.hover();
    await page.waitForTimeout(700);
  }

  await waitForFlutter(page, 800);
});
