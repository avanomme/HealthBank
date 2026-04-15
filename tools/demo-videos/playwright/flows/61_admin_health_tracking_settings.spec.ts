import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  clickText,
  ensureDemoCursor,
  fillField,
  goToAppRoute,
  loginAsAdmin,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Admin: Health Tracking Settings', async ({ page }) => {
  await loginAsAdmin(page);

  await goToAppRoute(page, '/admin/health-tracking', 1500);
  await waitForFlutter(page, 1500);
  await ensureDemoCursor(page);

  // Pause to show the categories list
  await page.waitForTimeout(1800);

  // Expand the Physical Health category row
  const physicalRow = page.getByRole('button', { name: /Physical Health/i }).first();
  if (await physicalRow.isVisible({ timeout: 5000 }).catch(() => false)) {
    await clickLocator(page, physicalRow);
  } else {
    // Fall back to clicking the expand/chevron icon next to Physical Health text
    await clickText(page, 'Physical Health');
  }
  await page.waitForTimeout(1400);

  // Wait for the metrics list to appear inside the expanded category
  await waitForFlutter(page, 800);

  // Slow scroll to reveal all metrics in the expanded category
  await slowScroll(page, 260, 2, 900);
  await page.waitForTimeout(1200);

  // Click Add Category button (typically top-right of the page)
  const addCategoryButton = page.getByRole('button', { name: /Add Category/i }).first();
  if (await addCategoryButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, addCategoryButton);
  } else {
    await clickButton(page, 'Add Category');
  }
  await page.waitForTimeout(1400);

  // Fill in the category name field
  const nameField = page.getByLabel('Category Name').first();
  if (await nameField.isVisible({ timeout: 3000 }).catch(() => false)) {
    await fillField(page, 'Category Name', 'Demo Category');
  } else {
    await fillField(page, 'Name', 'Demo Category');
  }
  await page.waitForTimeout(1000);

  // Click Cancel to dismiss without saving
  const cancelNewCategory = page.getByRole('button', { name: /Cancel/i }).first();
  if (await cancelNewCategory.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, cancelNewCategory);
    await page.waitForTimeout(1200);
  }

  // Click the edit (pencil) icon on the first visible metric
  const editMetricButton = page
    .getByRole('button', { name: /Edit metric|Edit|pencil/i })
    .first();
  if (await editMetricButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, editMetricButton);
  } else {
    // Fallback: look for any tooltip-labelled edit button
    const genericEdit = page.getByRole('button', { name: /edit/i }).first();
    if (await genericEdit.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, genericEdit);
    }
  }
  await page.waitForTimeout(1400);

  // Wait for the edit metric dialog to appear
  await waitForFlutter(page, 800);

  // Click Cancel to dismiss the dialog
  const cancelEditDialog = page.getByRole('button', { name: /Cancel/i }).last();
  if (await cancelEditDialog.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, cancelEditDialog);
    await page.waitForTimeout(1200);
  }
});
